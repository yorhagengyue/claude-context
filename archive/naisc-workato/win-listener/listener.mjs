// Ripple · ActivityWatch device presence listener
//
// Long-running process. Every POLL_MS, reads the latest AFK + window events
// from local ActivityWatch (http://localhost:5600) and upserts a single row
// per (user_id, device_id) into the Supabase `device_activity` table.
//
// Run:
//   cd "/Users/gengyue/Desktop/Toffeemoon Design System"
//   node scripts/aw-listener/listener.mjs
//
// Schema:
//   create table public.device_activity (
//     user_id text not null,
//     device_id text not null,
//     hostname text,
//     platform text,
//     display_name text,
//     current_app text,
//     current_window_title text,
//     afk_status text,
//     last_seen timestamptz,
//     updated_at timestamptz default now(),
//     primary key (user_id, device_id)
//   );

import {appendFileSync, mkdirSync, existsSync, readFileSync} from 'fs';
import {fileURLToPath} from 'url';
import {dirname, join} from 'path';
import os from 'os';

// ──────────────── env loader ────────────────
const __dirname = dirname(fileURLToPath(import.meta.url));
const envPath = join(__dirname, '..', '..', '.env');
if (existsSync(envPath)) {
  for (const line of readFileSync(envPath, 'utf8').split('\n')) {
    const m = line.match(/^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*?)\s*$/);
    if (m && !process.env[m[1]]) process.env[m[1]] = m[2].replace(/^["']|["']$/g, '');
  }
}

const SUPA_URL = process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL;
const SUPA_KEY = process.env.SUPABASE_SECRET_KEY;
const RIPPLE_USER_ID = process.env.RIPPLE_USER_ID || 'tommychen030607';
const POLL_MS = parseInt(process.env.AW_POLL_MS || '30000', 10);
const AW_HOST = process.env.AW_HOST || 'http://localhost:5600';
const HOSTNAME = os.hostname();
const PLATFORM = (() => {
  const p = process.platform;
  if (p === 'darwin') return 'darwin';
  if (p === 'win32') return 'windows';
  return 'linux';
})();
// Per-platform sensible defaults so the same script works on Mac/Win/Linux
// without forcing the user to set every env var. Override via .env when needed.
const PLATFORM_DEFAULTS = {
  darwin:  { idPrefix: 'macmini', display: 'Mac mini · gengyue' },
  windows: { idPrefix: 'win',     display: `Windows PC · ${HOSTNAME}` },
  linux:   { idPrefix: 'linux',   display: `Linux · ${HOSTNAME}` },
};
const PLATFORM_DEF = PLATFORM_DEFAULTS[PLATFORM] || PLATFORM_DEFAULTS.linux;
const DEVICE_ID = process.env.AW_DEVICE_ID || `${PLATFORM_DEF.idPrefix}-${HOSTNAME}`;
const DISPLAY_NAME = process.env.AW_DISPLAY_NAME || PLATFORM_DEF.display;

if (!SUPA_URL || !SUPA_KEY) {
  console.error('Missing VITE_SUPABASE_URL or SUPABASE_SECRET_KEY in .env');
  process.exit(1);
}

// ──────────────── logging ────────────────
const LOG_DIR = join(__dirname, 'data');
mkdirSync(LOG_DIR, {recursive: true});
const LOG_FILE = join(LOG_DIR, 'listener.log');
const ts = () => new Date().toISOString();
function log(msg) {
  const line = `[${ts()}] ${msg}`;
  console.log(line);
  try { appendFileSync(LOG_FILE, line + '\n'); } catch {}
}

// ──────────────── supabase rest ────────────────
async function sbUpsert(table, row, onConflict) {
  const url = `${SUPA_URL}/rest/v1/${table}?on_conflict=${onConflict}`;
  const r = await fetch(url, {
    method: 'POST',
    headers: {
      apikey: SUPA_KEY,
      authorization: `Bearer ${SUPA_KEY}`,
      'content-type': 'application/json',
      prefer: 'resolution=merge-duplicates,return=minimal',
    },
    body: JSON.stringify(row),
  });
  if (!r.ok) {
    log(`  ⚠ upsert ${table} ${r.status}: ${(await r.text()).slice(0, 200)}`);
    return false;
  }
  return true;
}

// ──────────────── AW polling ────────────────
async function awLatestEvent(bucketType) {
  const bucket = `${bucketType}_${HOSTNAME}`;
  const url = `${AW_HOST}/api/0/buckets/${encodeURIComponent(bucket)}/events?limit=1`;
  const r = await fetch(url);
  if (!r.ok) throw new Error(`AW ${bucket} ${r.status}`);
  const arr = await r.json();
  return arr[0] || null;
}

function eventEndMs(ev) {
  if (!ev) return null;
  const start = new Date(ev.timestamp).getTime();
  return start + ev.duration * 1000;
}

function eventAgeSec(ev) {
  const end = eventEndMs(ev);
  if (end === null) return Infinity;
  return (Date.now() - end) / 1000;
}

// AFK fallback heuristic: if newest afk event ended > AFK_STALE_S ago, treat as afk.
const AFK_STALE_S = 120;

async function tick() {
  try {
    const [afk, win] = await Promise.all([
      awLatestEvent('aw-watcher-afk'),
      awLatestEvent('aw-watcher-window'),
    ]);

    const afkStatus = afk?.data?.status || 'unknown';
    const afkAge = eventAgeSec(afk);
    const winAge = eventAgeSec(win);

    const isActive = afkStatus === 'not-afk' && afkAge < AFK_STALE_S;

    const currentApp = (isActive && win?.data?.app) || null;
    const currentWindowTitle = (isActive && win?.data?.title) || null;

    // last_seen = newest signal end-time from either bucket (so the frontend
    // can compute "is online iff now - last_seen < 60s")
    const winEnd = eventEndMs(win);
    const afkEnd = eventEndMs(afk);
    const newest = Math.max(winEnd || 0, afkEnd || 0);
    const lastSeen = newest > 0 ? new Date(newest).toISOString() : new Date().toISOString();

    const row = {
      user_id: RIPPLE_USER_ID,
      device_id: DEVICE_ID,
      hostname: HOSTNAME,
      platform: PLATFORM,
      display_name: DISPLAY_NAME,
      current_app: currentApp,
      current_window_title: currentWindowTitle,
      afk_status: afkStatus,
      last_seen: lastSeen,
      updated_at: new Date().toISOString(),
    };

    const ok = await sbUpsert('device_activity', row, 'user_id,device_id');
    log(`tick: active=${isActive} afk=${afkStatus} app=${currentApp || '-'} winAge=${winAge.toFixed(0)}s upsert=${ok ? 'ok' : 'FAIL'}`);
  } catch (e) {
    log(`  ⚠ tick error: ${e.message}`);
  }
}

log(`AW listener starting · user=${RIPPLE_USER_ID} device=${DEVICE_ID} host=${HOSTNAME} platform=${PLATFORM} poll=${POLL_MS}ms`);
tick();
setInterval(tick, POLL_MS);

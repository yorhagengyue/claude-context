# Ripple · Windows ActivityWatch listener

Run on a Windows PC to stream the machine's presence (active app + AFK state)
into Ripple's Supabase `device_activity` table. The Ripple dashboard at
[ripple-wellness.vercel.app/demo?thread=dashboard](https://ripple-wellness.vercel.app/demo?thread=dashboard)
shows the device live within ~30 s and the agent's
`activitywatch.device_status` tool card picks it up automatically.

## What this enables

- Windows row in the Dashboard's **Devices** card flips from
  `● Off · 34d ago` → `● Connected · Xs ago`
- Heart-rate anomaly agent's `activitywatch.device_status` tool shows the
  Windows device as Active with the current app name (e.g. `Active · in Code`)
- Cross-device wellness reasoning (e.g. "user is on the Windows desktop, not
  the Mac")

No Workato, no MCP, no API server runs on the Win machine — pure 30 s poll
from local ActivityWatch HTTP API → Supabase REST upsert. Single Node script.

## Prerequisites

- Windows 10 or 11
- Node.js LTS already installed (verify: `node --version` in cmd)
- Local admin to install ActivityWatch
- Internet (the script writes to Supabase)

## One-time setup

### 1. Install ActivityWatch

Download the Windows installer (pinned to v0.13.2 to match the Mac mini):

> https://github.com/ActivityWatch/activitywatch/releases/download/v0.13.2/activitywatch-v0.13.2-windows-x86_64-setup.exe

Run installer with defaults. After install, ActivityWatch starts automatically
and shows a clock icon in the system tray. The local server runs on
`http://localhost:5600`.

Sanity check in browser: open `http://localhost:5600` — you should see the
ActivityWatch web UI with two buckets (`aw-watcher-afk_<hostname>` and
`aw-watcher-window_<hostname>`).

### 2. Get this folder onto the Win machine

You've been granted access to the `claude-context` repo. From PowerShell:

```powershell
cd "$HOME\Documents"
git clone https://github.com/yorhagengyue/claude-context.git
cd "claude-context\shared\projects\naisc-workato\win-listener"
```

You'll see `listener.mjs`, `.env.example`, `start.bat`, `README.md`.
The `.env` file is NOT in the repo (GitHub blocks committing the secret) —
you'll create it in step 3.

### 3. Create `.env` with the Supabase credentials

Copy the template:

```powershell
copy .env.example .env
```

Open `.env` in Notepad and replace the placeholder `SUPABASE_SECRET_KEY=...`
line with the real value Geng Yue sent you via WeChat / chat. The line should
look like:

```
SUPABASE_SECRET_KEY=sb_secret_xxxxxxxxxxxxxxxxxxxx
```

Save the file. `VITE_SUPABASE_URL` already has the right value baked in.

### 4. (Optional) Customize device display name

Open `.env` in Notepad and uncomment / set `AW_DISPLAY_NAME` if you want
something custom on the dashboard:

```
AW_DISPLAY_NAME=YorHa Desktop
```

Save. If you leave it commented, the dashboard will show
`Windows PC · <your-hostname>` automatically.

## Run

### Easy path (recommended)

Double-click `start.bat` in File Explorer. A console window opens, shows the
startup banner, and starts polling every 30 s. Close the window to stop.

### CLI path

```cmd
cd path\to\win-listener
node listener.mjs
```

## Verify it's working

Within 30 s of launching the script:

1. Console should print lines like:
   ```
   [2026-05-18T03:21:50.123Z] AW listener starting · user=tommychen030607 device=win-DESKTOP-XYZ host=DESKTOP-XYZ platform=windows poll=30000ms
   [2026-05-18T03:21:50.456Z] tick: active=true afk=not-afk app=Code winAge=2s upsert=ok
   ```

2. A row appears in Supabase. From any browser hit:
   ```
   https://ubuamehrsvyrbnoxtavk.supabase.co/rest/v1/device_activity?user_id=eq.tommychen030607&platform=eq.windows&select=device_id,display_name,current_app,last_seen
   ```
   with header `apikey: sb_publishable_6sOMp-mMZStZP-lrDMtRqA_QjZ7N3Ev`
   (Supabase's anon publishable key — safe to share).
   Or just open the Ripple dashboard.

3. Open https://ripple-wellness.vercel.app/demo?thread=dashboard — the
   **Devices** card should show the Win row flip to green `● Connected`
   within a few seconds.

## Stop

- Easy path: close the cmd window opened by `start.bat`
- CLI path: `Ctrl+C` in the terminal

The dashboard will show the Win row drift to `● Off` after `last_seen` ages
past 60 s. No cleanup needed.

## How it works (one-paragraph)

Every 30 s, the script reads the latest event from each of two ActivityWatch
buckets via `http://localhost:5600/api/0/buckets/{bucket}/events?limit=1`:

- `aw-watcher-afk_<hostname>` → tells us if the user is AFK or active
- `aw-watcher-window_<hostname>` → tells us which app + window title is in focus

It computes `is_active = afk_status === 'not-afk' AND afk_event_age < 120s`,
then sends a single Supabase upsert keyed on `(user_id, device_id)`:

```json
{
  "user_id": "tommychen030607",
  "device_id": "win-DESKTOP-XYZ",
  "hostname": "DESKTOP-XYZ",
  "platform": "windows",
  "display_name": "Windows PC · DESKTOP-XYZ",
  "current_app": "Code",
  "current_window_title": "listener.mjs — win-listener",
  "afk_status": "not-afk",
  "last_seen": "2026-05-18T03:21:48.000Z",
  "updated_at": "2026-05-18T03:21:50.456Z"
}
```

The Ripple frontend treats any row with `now - last_seen < 60s` as **online**
and renders the green pulsing pip in both the Dashboard's Devices card and
the Heart-rate anomaly thread's `activitywatch.device_status` tool card.

## Troubleshooting

### `AW <bucket> 404`
ActivityWatch isn't running, or your watchers haven't started yet. Open the
AW system tray icon → "Open ActivityWatch" → verify both `aw-watcher-afk` and
`aw-watcher-window` are listed in the Modules tab. If not, re-install AW.

### `upsert device_activity 401/403`
Wrong or stale `SUPABASE_SECRET_KEY`. Verify the value in `.env` matches what's
shipped (see below). If it does and you still get 401, ping Geng Yue — the key
may have been rotated post-demo.

### `Node.js not found on PATH`
Install Node.js LTS from https://nodejs.org, restart PowerShell / cmd,
re-run.

### Dashboard still shows "Off" after running
Hit refresh on the dashboard tab. If still off after 30 s and the console is
upserting `ok`, check the row directly in Supabase REST (see Verify step 2).
If the row is fresh in Supabase but the UI shows Off, hard-refresh the demo
page (Cmd/Ctrl+Shift+R) — the cache might be stale.

### Console stops printing tick lines
The watch loop runs as `setInterval`. If it stalls, Ctrl+C, then `node listener.mjs`
again. The logfile at `data/listener.log` records every tick — tail it to
see what happened before the freeze.

## What's in this folder

| File | Purpose |
|---|---|
| `listener.mjs` | The Node poller. Cross-platform — same script runs on Mac/Linux. |
| `.env.example` | Template for `.env`. Copy to `.env` and paste the real secret. |
| `.env` | Created by you in step 3. NOT in the repo. |
| `start.bat` | Windows launcher with pre-flight checks (Node + AW reachable). |
| `README.md` | This file. |

## Security note

The `SUPABASE_SECRET_KEY` shipped in `.env` is the service-role key for the
Ripple Supabase project. It can write to ANY public table in the project,
not just `device_activity`. For the 5/22 demo we accept this trade-off
because the listener runs on trusted Win machines only and the demo
horizon is short. Post-demo, we'll create a scoped Postgres role with
write-only access to `device_activity` and rotate this key.

If you're handing this folder to someone outside the team, strip `.env` first
and have them paste the key manually.

## Cross-reference

- Mac mini listener (same script, daemonized): `~/Desktop/Toffeemoon Design System/scripts/aw-listener/listener.mjs`
- Dashboard rendering of `device_activity`: `ripple/demo.jsx` → search `DeviceCard`
- Heart-rate thread agent tool card: `ripple/demo.jsx` → search `ActivityWatchTool`
- Supabase schema: see top of `listener.mjs` for the CREATE TABLE statement

---
title: NAISC 5/22 Demo Flow — Locked Scope
status: in_progress
locked_at: 2026-05-12
deadline: 2026-05-22
source: claude
---

# 5/22 Demo End-to-End Flow

**Scope locked 2026-05-12.** Everything in this doc is the demo path. Anything not listed is dropped for 5/22.

## The flow user wants to execute live

1. HR/step spike detected (Apple Watch → HAE → Supabase) ← **already shipped**
2. Ripple agent gets the alert
3. Agent reasons: "why did HR jump?"
4. Agent fetches multi-signal context:
   - `get_current_vitals` — Supabase (shipped)
   - `get_baseline_deviation` × N — Workato recipe (shipped)
   - `get_user_presence` — local AW stdio MCP (shipped 5/12)
   - **`get_recent_location` — TO BUILD** (browser beacon → Supabase → MCP)
5. Agent decides: based on HR + step rate + speed + displacement, is user really exercising?
   - HR↑ + step rate↑ + speed > 1 m/s → real workout
   - HR↑ + speed ≈ 0 + displacement ≈ 0 → "static but elevated — doing calisthenics / HIIT in place / stressed?"
   - HR↑ + speed > 1 m/s but displacement ≈ 0 (treadmill / circling) → "moving but staying put — treadmill?"
6. Agent asks user via WhatsApp (text). User shown both in WA and Claude window.
7. **User replies via WA voice note (deliberate demo highlight)**.
8. Twilio inbound webhook fires → media URL → download → Whisper STT → text back to agent
9. Agent reads the answer, generates reply, sends to WA. User sees same reply both in WA and the Claude conversation window.

## What's already built

- Apple Watch → HAE → Supabase (HR/HRV/RHR/sleep/steps/spo2/active_energy/respiratory)
- Workato recipes: spike detection, baseline deviation, anomaly log
- 4 MCP tools via Workato Genie: `get_current_vitals`, `get_baseline_deviation`, `get_recent_anomaly_log`, `send_contextual_nudge`
- Local `aw-presence` stdio MCP server (Mac mini, reads ActivityWatch live)
- WhatsApp 2-way chat (Twilio outbound + Workato inbound recipe; gets/asks/acks text)
- Whisper STT toolchain on Mac mini (Hermes infrastructure)

## What's left to build for this flow

| # | Component | Where | Owner | Effort |
|---|---|---|---|---|
| 1 | Location beacon HTML page (`navigator.geolocation.watchPosition`) | Static page hosted at public URL (Cloudflare Pages / Vercel / Supabase Storage) | Claude | 1.5h |
| 2 | Supabase `location_log` table + RLS policy | Supabase Management API | Claude | 0.3h |
| 3 | MCP tool `get_recent_location(user_id, seconds)` → returns last N points + computed `is_stationary`, `avg_speed_m_s`, `displacement_m` | Local stdio MCP server (sibling to aw-presence) OR extend Workato | Claude — go local, same pattern as aw-presence | 1.5h |
| 4 | WA voice note path: Twilio inbound webhook → download media → Whisper STT → relay back to Workato chat bot | Mac mini local listener exposed via cloudflared tunnel | Claude + user (Twilio webhook URL update) | 2.5h |
| 5 | Dual-channel display: agent text appears in WA + Claude window simultaneously | Simplest: agent always sends to WA, Claude window naturally shows since Claude IS what's speaking | Claude | 0.5h |
| 6 | Demo rehearsal — full flow on real data, 90s max | — | User + Claude | 1h |

**Total: ~7h work.** Within 5/22 budget.

## What's NOT in scope for 5/22

- iOS Shortcuts Motion API integration (CMMotionActivity)
- HAE Workouts session export
- Workout type classification beyond "moving / static" heuristic
- Multi-user (single user `tommychen030607` for demo)
- Production deployment of WA listener (cloudflared tunnel is fine for demo)
- LLM-as-judge multi-agent reasoning layer (Q&A talk track, not code)
- ML model training (decision per ml-strategy-v1.md)

## Architecture for browser GPS beacon

- iPhone Safari opens public URL pre-demo
- Page: `navigator.geolocation.watchPosition({enableHighAccuracy: true, maximumAge: 0})` — gets ~1 fix/sec when moving
- Each fix POST to Supabase REST insert with anon key
- Supabase row: `{user_id, ts, lat, lng, accuracy_m, speed_m_s, heading_deg, source}`
- `speed_m_s` is `position.coords.speed` from GeolocationCoordinates — iOS Safari fills this from CoreLocation when GPS lock is good
- Page UI shows last fix + upload status so user can see it's live during demo
- No persistence beyond the table — query it via MCP tool

## Hosting decision

Cloudflare Pages — user has experience (CLAUDE.md §4), free, custom domain optional. Static HTML with inlined anon key.
Fallback: cloudflared quick tunnel pointing at Mac mini `python3 -m http.server`.

## Sequence

1. Create Supabase `location_log` table (Claude, 5 min)
2. Build HTML page locally + test in desktop browser (Claude, 1h)
3. Deploy to Cloudflare Pages (Claude/User, 30 min)
4. iPhone Safari authorization test, verify rows land in Supabase (User, 5 min)
5. Build local MCP server `wa-location` with `get_recent_location` (Claude, 1.5h)
6. Register in Claude Desktop config (Claude, 1 min)
7. Build WA voice note ingestion (Claude, 2.5h)
8. Rehearse the full flow end-to-end (User+Claude, 1h)

Step 1 starts immediately after this doc is saved.

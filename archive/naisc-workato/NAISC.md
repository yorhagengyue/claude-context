---
project: NAISC 2026 Workato Track · Ripple
status: FINALIST · 5/22 pitch · 14 days remaining
last-updated: 2026-05-08
---

# Ripple — NAISC 2026 Workato Track

> **Upstream**: [CLAUDE.md](../../shared/CLAUDE.md) §5 project index
> **Heavy notes / timeline / transcripts**: Obsidian Vault `01 - Projects/Workato NAISC/`
> **Pre-finals state** (4/19-4/24, demo recording + submission): see `archive/NAISC_pre-finals.md` + `archive/morning_handoff_2026-04-20/`

---

## TL;DR (30-second read)

Ripple is **Team YoRHa**'s submission to **NAISC 2026 Workato Track**. We are **1 of 7 finalists**. Final pitch is **2026-05-22 (Fri)**, 14 days from today. The 5/8 mentorship sessions (TP7 with Colin + TP8 with the Workato/business mentor) happened today and the takeaways are distilled in `mentor-takeaways-tp7-tp8.md`. The 8-recipe Workato pipeline + 4 MCP tools + Discord context source + 53-rule evidence library are shipped. The deck and live-demo rehearsal are the open work. **5/22 ML training is locked OFF** — Pattern D (RAG/MCP) only.

---

## Current state

| Item | Value |
|---|---|
| Stage | **Finalist · 5/22 pitch** (Sarah Loke confirmation 4/24) |
| Team (official roster) | **Geng Yue · Liu Zicheng · Chen Yufei** |
| Mentorship | TP7 + TP8 done **2026-05-08** — see `mentor-takeaways-tp7-tp8.md` |
| Trailer | https://youtu.be/NbFPHHf_jz8 |
| Website | https://ripple-wellness.vercel.app/ |
| Workato MCP server | `https://1720.apim.mcp.trial.workato.com/` (4 tools live) |
| Recipes | 8 active (bulk ingest / live spike / 24h watchdog / 4 MCP / two-way chat) |
| Discord listener | Running on Mac Mini, PID 48771 (verified 2026-05-08) — see `discord-integration-v1.md` |
| Rule library | v2: 53 rules / 11 categories / citations — see `rule-library/README.md` |
| ML strategy | **Locked: no training before 5/22, Pattern D only** — see `ml-strategy-v1.md` |

### Pending decisions (open at 5/8)

- [ ] **`vercel deploy --prod`** of 3 new Discord API endpoints (P0 — Workato MCP can't call them until prod)
- [ ] **launchd plist** for listener (P1 — survives Mac restart). Decision: **drop until post-5/22** per 14-day budget
- [ ] **Tommy Chen → Chen Yufei** in trailer/site/submission email (P2 — user has not committed; mentors did not comment)
- [ ] **Live demo vs pre-recorded fallback** for 5/22 — TP8 mentor said live wins but plan a fallback

---

## Read order for full context

When picking up this project:

1. **This file** — orientation
2. **`mentor-takeaways-tp7-tp8.md`** — what changed at 5/8 and the action implications driving the next 14 days
3. **`forward-plan-v1.md`** — the pre-mentor strategy doc (5/8 mentor questions section is now answered, but the architecture-options section is still the canvas for the next 14 days)
4. **`discord-integration-v1.md`** — full record of the Discord listener (the differentiator demo asset)
5. **`ml-strategy-v1.md`** — why no ML training before 5/22, why MCP/RAG instead, the "We don't train models today" pitch line
6. **`rule-library/README.md`** — the 53-rule evidence asset and how it maps to the deck
7. **`submission-email.md`** — what was sent to organizers (final v4)
8. **`implementation-log.md`** — engineering log up through 4/19 (recipe-by-recipe build trail and known gotchas)
9. **Obsidian only** (heavy / not mirrored): TP7 + TP8 raw transcripts, trailer/demo scripts, design docs

---

## Architecture (current shipped state)

```
[Apple Watch / curl simulator]
  ├─ bulk push → Recipe 1 v1 → Supabase healthlog
  └─ live spike → Recipe 7 live_hr_alert_demo → IF >150 → Twilio → WhatsApp (~3s)

[Daily 24h schedule]
  Recipe 6 Ripple Anomaly Watchdog → Supabase baseline_view → Twilio

[Two-way chat]
  User WA reply → Twilio sandbox webhook (form-encoded)
                → Recipe 8 ripple_chat_bot → Moonshot/Kimi LLM → Twilio echo

[Agent MCP tools]  (Claude Desktop / Cursor → Ripple MCP server)
  Recipe 2 get_current_vitals
  Recipe 3 get_baseline_deviation
  Recipe 4 get_recent_anomaly_log
  Recipe 5 send_contextual_nudge

[Discord context source]  ← shipped 5/3-5/4, NOT YET prod-deployed
  Lanyard WS → Node listener → Supabase (3 tables + 1 view)
                            → Vercel API /api/discord/{current,today,sessions}
                            → (waiting) Workato MCP tool get_discord_activity
```

### TP8 mentor's 3-layer reframe (NEW, drives deck rebuild)

The same architecture, viewed as judges should see it:

| Layer | What it is | Ripple components |
|---|---|---|
| **1 · Ingestion** | Sensor → connector → spine | Apple Watch + HAE + Discord listener + future Garmin/Calendar |
| **2 · Processing** | Pre-processor → rule library → ML signals → LLM | Supabase + 53-rule library v2 + Workato recipes + Moonshot LLM |
| **3 · Communication** | Multi-channel agent surface | WhatsApp + WeChat + Telegram + family-circle + MCP for agents |
| **Governance overlay** | Per-layer security/privacy/consent | (currently implicit — needs to be explicit in deck) |

**Pitch line (TP8 framing)**: "Ripple is not another AI agent. It's the **pre-processed data pipeline** that any agent — Hermes, Cursor, future GPT-N — can plug into. Agents are what everyone's building. The data spine is what's missing."

---

## 14-day ship list to 5/22

**Total budget**: ~45 hours / 14 days = ~3 h/day. Realistic if no scope creep.

### MUST (blocking the pitch)

| # | Task | Hours | Notes |
|---|---|---|---|
| 1 | Wire **R006** (sleep+HRV+RHR composite recovery) into Workato as new MCP tool / recipe | ~8 | Easy — signals already flowing |
| 2 | Wire **R043** (late-night phone use → sleep degradation) joining Discord activity + sleep data | ~12 | Differentiator. Ties Discord listener to rule library. |
| 3 | Deck rebuild: 3-layer architecture overview + ingestion connectors + processing/rule-library + communication channels + Cursor "why now" + thin business layer | ~10-12 | Per TP8 mentor advice |
| 4 | Record **R043 + Discord live demo video** (~90s, real data) | ~8 | TP8: "live demo wins, plan fallback" |
| 5 | **Q&A defense prep** — LLM-as-judge multi-agent diagram + RLHF flywheel + data flywheel moat answer + evidence-base citations | ~5 | Per TP7 + TP8 |

### STRETCH

- [ ] Wire **R048** (6-signal whole-body shift) — only if wrist temperature data flows end-to-end. Verify before committing.
- [ ] `vercel deploy --prod` of Discord API endpoints (~30 min if no surprise; could go MUST if needed for live demo)

### EXPLICITLY DROPPED (post-5/22)

- [ ] launchd plist for listener
- [ ] Calendar / Obsidian context sources (clone the Discord pattern after 5/22)
- [ ] ML training (locked off — see `ml-strategy-v1.md`)

---

## Critical caveats / corrections

### Team naming

- **Sarah Loke 4/24 official finalist email roster**: Geng Yue · Liu Zicheng · **Chen Yufei**
- Trailer / website / submission email currently list **"Tommy Chen"** as the third member
- Tommy Chen is **Geng Yue's English name** (CLAUDE.md §1), NOT a separate teammate
- **Public-facing artifacts are currently inconsistent with the official roster.** User has not decided whether to fix before 5/22.

### iOS HAE background scheduling unreliable

- Recipe 1 `live_hr_alert_demo` ingest only triggered ~24 times in 30 days; zero after 4/18
- HealthyApps docs: "Apps are not allowed to access health data while iPhone is locked"
- iOS background scheduler decides actual run frequency, not the app's UI setting
- Implication for 5/22 demo: **don't rely on live HAE during the pitch**. Use curl simulator with pre-canned data, or live demo with phone unlocked + charging.

### Workato CodeMirror not standard CM

- JS `setValue` writes to preview, but Angular form binding doesn't pick it up — values revert on blur
- Only reliable path: focus → user paste (Cmd+V) → Tab
- Implication: don't try to script Workato form changes; do them by hand

### Workato trial account quota

- Endpoint URLs include `.trial.` — month task limit unknown
- Agent-loop architecture (if pursued) could burn ~30 tasks per trigger × 50/day = 1500/day → maybe 3 days to exhaust monthly quota
- **Mentor question for any post-5/22 Option A pursuit**: get the actual cap and the upgrade path

### ActivityWatch Mac Mini · device name leaks PII in window titles

- Mac mini hostname is currently `gengyuedeMac-mini-3.local` (literal "耿越的Mac mini" device name)
- AW bucket key embeds hostname: `aw-watcher-window_gengyuedeMac-mini-3.local`
- Any window title from a network-aware Windows app pointing back at the Mac (e.g. `GameViewer.exe`, remote desktop tools, AirPlay receivers) **will surface the Chinese device name in screen activity data**
- **For 5/22 deck**: when screenshotting AW dashboard, hide the "Window Titles" panel and show only app + duration columns — title column can leak the device name
- **For post-5/22 cross-device sync**: rename Mac to a neutral label (e.g. `mac-mini-ripple`). NOT now — the bucket key is referenced in any existing screen-events ingest code path, and the Discord listener may have implicit dependencies on the `.local` hostname
- Logical `source_host` field in the (future) `screen_sessions` table should be a stable label (`mac-mini` / `gengyue-pc`), decoupled from the OS hostname, so renaming the Mac later doesn't break cross-device aggregation

### Hackathon ≠ VC pitch

- 5/22 is a hackathon. Don't dwell on FDA liability / actuarial-grade evidence / long-term moat / copycat risk.
- Those are post-5/22 questions if Ripple continues.
- Mentors confirmed: judges grade idea > tech depth, end-to-end live demo > slides, thin business layer (small evaluation weight).

---

## Behavioral hints for next Claude session

Per CLAUDE.md §3 (architecture-advisor framing):

- Don't generate code unless explicitly asked
- Don't propose "spike a quick test" — user has explicitly opposed (CLAUDE.md §8 [2026-05-04])
- Don't propose ML training before 5/22 (locked off)
- Be honest, not flattering — if the deck/architecture has a real problem, say so
- TP7's "one scenario, you fighting in time" applies to Claude too: don't try to fix everything; help the user pick the strongest demo and own it
- The architecture is **shipped and stable**. The work in the next 14 days is **deck + demo rehearsal + Q&A prep**, not building new infrastructure.

---

## Open infra (running)

| Service | Where | Status |
|---|---|---|
| Discord listener | Mac Mini, `~/Desktop/Toffeemoon Design System/scripts/discord-listener/listener.mjs` | PID 48771 (+ child 98047) — verified 2026-05-08 |
| Listener log | `~/Desktop/Toffeemoon Design System/scripts/discord-listener/data/listener.log` | Heartbeat every 10 min |
| Vite dev | localhost:5173 | Provides 3 Discord API endpoints (not yet prod) |
| Workato MCP | `https://1720.apim.mcp.trial.workato.com/` | 4 tools live |
| Supabase | hosted | Persistent state for healthlog + Discord tables |
| Cloudflare tunnel | maybe started earlier | Status unknown — check before assuming dead |

**Listener restart commands**:

```bash
pgrep -af discord-listener                       # check
pkill -f discord-listener                        # stop
cd "/Users/gengyue/Desktop/Toffeemoon Design System" \
  && (nohup node scripts/discord-listener/listener.mjs > /dev/null 2>&1 &)
tail -f "/Users/gengyue/Desktop/Toffeemoon Design System/scripts/discord-listener/data/listener.log"
```

Mac restart loses the listener (no launchd plist yet — by-design dropped from 14-day budget).

---

## Key dates

| Date | Event |
|---|---|
| 2026-04-25 | Finalist email |
| 2026-05-08 (Fri) | TP7 (Colin) + TP8 (Workato/business) mentorship — **DONE** |
| 2026-05-09 → 2026-05-21 | 14-day build / rehearse |
| **2026-05-22 (Fri)** | **NAISC Workato Track final pitch** |

---

## Related project memories in CLAUDE.md §8

- `[2026-05-08] mentorship: TP7 + TP8 综合`
- `[2026-05-08] decision: 14-day ship list locked`
- `[2026-05-08] asset: Ripple rule library v2`
- `[2026-05-08] project: NAISC mentor 录音转录入库` (transcripts in Obsidian)
- `[2026-05-04]` cluster: MCP-as-decoupling, Lanyard, Discord history, hackathon-vs-funding correction, NAISC team naming, Discord listener PID
- `[2026-04-19/20]` cluster: Plan B Kimi attempt, Workato CodeMirror reality, two-way chat shipped

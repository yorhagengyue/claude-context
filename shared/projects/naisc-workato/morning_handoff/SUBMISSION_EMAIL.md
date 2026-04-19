# NAISC 2026 Submission Email — Draft

**发送日期**：2026-04-23 前任意时间  
**收件人**：（从官网获取 — 填正确 submission 邮箱）  
**抄送**：（如官网要求）

---

## Subject

```
NAISC 2026 Workato Track Submission — Ripple (Geng Yue / Tommy Chen)
```

## Body

```
Dear NAISC 2026 Review Team,

I am pleased to submit my entry to the Workato track of NAISC 2026.

Project: Ripple — Real-time Wellness Agent
Category: Workato Orchestration / AI Agent
Participant: Geng Yue (Tommy Chen)
Email: tommychen030607@gmail.com
Institution: Temasek Polytechnic, Singapore
GitHub: https://github.com/yorhagengyue

SUMMARY

Ripple is a real-time wellness monitoring agent built entirely on a single Workato trial account in one development cycle. It orchestrates Apple Watch (via Health Auto Export), Supabase PostgreSQL, Twilio WhatsApp, and the Kimi LLM (moonshot-v1-8k) into a complete sense-think-act-converse pipeline. Eight recipes and four MCP tools cooperate to ingest vitals, detect anomalies against a personal baseline, alert the user on WhatsApp, carry out a short empathetic conversation, and persist the interaction to Supabase for daily review.

WHY WORKATO

Building the same product from scratch would normally require a backend framework (Next.js or FastAPI), a queue, a scheduler, a webhook broker, and glue code between five SaaS vendors. Workato's Genie MCP, HTTP connector, recipe branching, and native Twilio/PostgreSQL connectors reduced that to eight recipes with zero custom server code. The trial tier was sufficient end-to-end; no paid add-ons were required.

KEY TECHNICAL DECISIONS

1. Trigger topology — separate webhooks for ingest (v1) and real-time alerts (live_hr_alert_demo), with a 24-hour Watchdog scheduled scan as the daily baseline refresher. Independence prevents a failure in one path from silencing the other.
2. Two-way chat — Recipe 8 receives the inbound Twilio sandbox webhook (form-urlencoded), routes the user message to Kimi with a structured JSON response prompt, parses the reply and context_tag, then echoes Kimi's recommendation back to WhatsApp.
3. MCP surface — four tools (get_current_vitals, get_baseline_deviation, get_recent_anomaly_log, send_contextual_nudge) exposed via Workato Genie so any MCP client (Claude Desktop, Cursor) can query the same data the agent uses.
4. Storage boundary — Supabase as the source of truth; healthlog (vitals) is append-only, alert_sessions (chats) is jsonb with turn history and a resolution tag for analytics.

DELIVERABLES (attached or linked)

- Demo video (4 min): [YouTube / Drive link]
- Architecture diagram: architecture.png
- Recipe exports: recipe_exports/ (all eight .json assets)
- Source documentation: https://github.com/yorhagengyue/claude-context/tree/main/shared/projects/naisc-workato
- Live environment snapshot: Supabase schema + seed data file

REPRODUCIBILITY

Anyone with a Workato trial account, a Supabase project, a Twilio sandbox, and a Kimi API key can reproduce this in roughly four hours by importing the recipe JSON exports and substituting credentials.

Thank you for reviewing Ripple. Happy to answer any questions at tommychen030607@gmail.com.

Regards,
Geng Yue (Tommy Chen)
Singapore, Apr 2026
```

---

## 附件清单

- [ ] video.mp4 (4 min)
- [ ] architecture.png (或 .pdf)
- [ ] recipe_exports/v1.json
- [ ] recipe_exports/live_hr_alert_demo.json
- [ ] recipe_exports/ripple_chat_bot.json
- [ ] recipe_exports/ripple_anomaly_watchdog.json
- [ ] recipe_exports/get_current_vitals.json
- [ ] recipe_exports/get_baseline_deviation.json
- [ ] recipe_exports/get_recent_anomaly_log.json
- [ ] recipe_exports/send_contextual_nudge.json

## 录完 demo 后要做的（发送前 checklist）

- [ ] Video 上传 YouTube（私有链接 / 任何人可看）
- [ ] README.md 写好放 GitHub（含可复现步骤）
- [ ] Architecture diagram 确保 8 个 recipe 全显示，连线清楚
- [ ] Recipe exports 在 Workato 每个 recipe 的 Settings → Export JSON，一个一个下载
- [ ] 发送前自己通读一遍，改 email tone（比赛官方更正式？更 casual？看他们页面）

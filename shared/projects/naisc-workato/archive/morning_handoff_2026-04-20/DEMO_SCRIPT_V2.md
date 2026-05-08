# DEMO_SCRIPT_V2 — Ripple NAISC 2026

**目标**：3-4 min 视频，展示 Workato orchestrated real-time wellness agent 端到端工作  
**核心叙事**："Sense → Think → Act → Converse" — Workato 连接 Apple Watch / Supabase / Twilio / Kimi LLM / MCP，一个普通账号一天搭出完整 agent 产品

---

## 录制前准备（5 min）

### 屏幕与窗口布局

```
┌─────────────────────┬──────────────────┐
│ Workato Recipe list │ iPhone Mirror    │
│  (project Ripple)   │   (WhatsApp)     │
├─────────────────────┼──────────────────┤
│ Terminal (curl)     │ Supabase Table   │
│                     │  (healthlog)     │
└─────────────────────┴──────────────────┘
```

- 用 macOS iPhone Mirroring 把手机 WA 投到屏幕上（否则录不到通知）
- Terminal 字号放大到 16-18 pt
- Workato Recipe list 过滤到 Ripple project

### 打开的 tabs
1. Workato → Ripple project (recipe list showing all 8 recipes Active)
2. Workato → Recipe 1 (v1) Jobs history
3. Twilio → Messaging Logs
4. Supabase → SQL editor with pre-typed query on healthlog
5. iPhone Mirror → WhatsApp Twilio chat

### 预录制 curl（贴在 Terminal 里，一键回车）

**Curl A：模拟手表 HR spike（触发 Recipe 7 alert）**
```bash
curl -s -X POST -H 'Content-Type: application/json' \
  -d '{"metric":"heart_rate","value":178,"unit":"bpm","source":"apple_watch","ts":"'$(date -u +%FT%TZ)'"}' \
  'https://webhooks.trial.workato.com/webhooks/rest/75c7e434-bc99-44b9-99e7-705948d0a35d/ripple-live-alert'
```

**Curl B：模拟手表常规 vitals（触发 Recipe 1 ingest → Supabase healthlog）**
```bash
curl -s -X POST -H 'Content-Type: application/json' \
  -d '{"metric":"heart_rate","value":72,"unit":"bpm","source":"apple_watch","ts":"'$(date -u +%FT%TZ)'"}' \
  'https://webhooks.trial.workato.com/webhooks/rest/75c7e434-bc99-44b9-99e7-705948d0a35d/ripple-health-data'
```

---

## 分镜脚本（4 min 版）

### 镜头 1 — 开场 (0:00-0:15)

**画面**：Workato Ripple project recipe list 全部 Active

**旁白**：
> "This is Ripple, a real-time wellness agent I built in a day on Workato Trial. It orchestrates my Apple Watch, Supabase, Twilio WhatsApp, and Kimi LLM — no backend code, eight recipes."

### 镜头 2 — Sense: 手表数据入库 (0:15-0:45)

**画面**：Terminal 跑 Curl B → 立刻切 Workato Recipe 1 Jobs → Supabase healthlog 最新行

**旁白**：
> "Every minute Apple Watch pushes vitals through Health Auto Export to a Workato webhook. Recipe 1 validates and writes to Supabase. Here's a simulated push — job completes in under a second, row appears in healthlog."

**强调**：指向 healthlog 表最新行的 created_at 时间戳

### 镜头 3 — Think: 异常检测 + alert (0:45-1:30)

**画面**：Terminal 跑 Curl A（HR=178）→ 切到 iPhone Mirror WA → 收到 alert

**旁白**：
> "When HR exceeds baseline by 2 sigma, Recipe 7 fires a real-time alert. Watch this — I simulate a spike to 178."

**等 3 秒** → iPhone WA 弹通知 `Ripple live alert: heart rate spike detected 178 bpm. Are you OK?`

**强调**：看 Twilio logs tab → outbound 消息 SID 刚出现

### 镜头 4 — Converse: AI 多轮对话 (1:30-2:45)

**画面**：iPhone 上在 WA 对话里打 `gaming` → 等 Kimi 回复

**旁白**：
> "I reply 'gaming' on WhatsApp. Recipe 8 takes my message, calls Kimi moonshot-v1-8k with a structured prompt that classifies the reason and decides if escalation is needed."

**Kimi 回复出现**：  
`Glad to hear it's just the excitement of gaming. Remember to take breaks to relax your mind and body.`

**继续**：发 `idk` → Kimi 追问 `Do you feel any chest tightness, dizziness, or pain?`
**再发**：`chest pain` → Kimi 升级 → `I'm really concerned. Please seek medical help immediately.`

**旁白**：
> "Vague answers get probed. Medical red flags trigger escalation. All decided by one structured LLM call."

### 镜头 5 — Record: 持久化到 Supabase (2:45-3:15)

**画面**：Supabase 切到 alert_sessions 表 → 展示最近 3 条 session，点开一条看 turns jsonb

**旁白**：
> "Every conversation is stored in Supabase alert_sessions with the reply, context tag, and full turn history. This becomes training data for context-aware future alerts."

### 镜头 6 — MCP: Claude Desktop 访问 (3:15-3:45)

**画面**：Claude Desktop → 调用 Ripple Genie MCP → ask `What was my HR anomaly today?`

**Claude 回复**：通过 Workato MCP Recipe 3 (get_baseline_deviation) 和 Recipe 4 (get_recent_anomaly_log) 拿到数据 → 解释

**旁白**：
> "Workato Genie exposes four tools to any MCP client. Claude Desktop can now query my vitals, check baseline deviation, read the anomaly log, or even send me a contextual nudge back through Twilio."

### 镜头 7 — 收尾 (3:45-4:00)

**画面**：回到 Workato recipe list

**旁白**：
> "Eight recipes, four MCP tools, two-way WhatsApp chat, real-time anomaly detection. Built in one day on Workato, using only a regular account. That's Ripple."

---

## 关键断点/安全阀

| 出问题 | Fallback |
|---|---|
| Kimi 返 500 / 字数超标 | 切到 echo 版本（Recipe 8 回退 git 操作即可） |
| WA 延迟 >10s | Retake，Twilio sandbox 偶尔抖 |
| Curl 404 | 检查 Recipe 7/1 是否 Active，Start 一下 |
| iPhone mirroring 断 | 用 QuickTime 录手机屏幕备份 |

---

## 交付包（视频 + 附件）

- **video.mp4** 4 min，1080p
- **architecture.png** — 架构图（附件）
- **recipe_exports/** — 8 个 recipe 的 .json export（证明原生 Workato 资产）
- **README.md** — 5 段话：story / architecture / how to reproduce / trade-offs / future

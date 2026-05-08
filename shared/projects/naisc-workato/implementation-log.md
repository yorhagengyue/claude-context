---
source: hermes
date: 2026-04-17
generated: 2026-04-17T03:53:20+08:00
type: log
---

# Ripple — 实施日志

## 2026-04-16：数据管道搭建（已完成 ✅）

### 时间线

1. **Workato Recipe 创建**
   - 新建 Recipe，选择 HTTP Webhook trigger
   - 配置 webhook event name: `ripple-health-data`
   - 用 sample JSON 生成 schema（6 项核心指标）
   - Recipe 启动后获得 webhook URL

2. **Webhook 端到端测试**
   - curl 发送测试 payload → 首次 404（Recipe 未启动）
   - 启动 Recipe 后重试 → 200 `{"status":"ok"}`
   - Workato Job History 确认 6 项指标全部正确解析

3. **Health Auto Export 配置**
   - iOS app 内新建 REST API automation，命名 `ripple`
   - 填入 webhook URL
   - 导出格式：JSON v2
   - Aggregated data: ON
   - Batch requests: OFF
   - 指标选择：全部已选（后续建议精简为 6 项）

4. **真实数据验证**
   - 手动触发一次推送 → Workato 成功接收
   - 确认收到的指标：step_count, walking 相关, headphone_audio_exposure, physical_effort
   - 日期格式含时区 `+0800`，source name 含中文 — 与 schema 样本有差异，需后续适配

### 已知差异（schema vs 真实数据）

| 项目 | Schema 样本 | 真实数据 |
|------|------------|---------|
| 日期格式 | `2026-04-16 08:00:00` | `2026-04-16 20:26:00 +0800` |
| Source name | `Apple Watch` | `耿越的Apple Watch` / `YoRHa` |
| 指标范围 | 6 项核心 | 全部 HealthKit 授权指标 |

---

## 下一步（优先级排序）

1. **等过夜数据**：确认 HRV、静息心率、睡眠、SpO2、活跃能量是否正常推送
2. **精简推送指标**：Health Auto Export 改为只推 6 项核心（减少噪音）
3. **更新 Workato schema**：适配真实数据格式（时区、中文 source name）
4. **建 Data Tables**：user_health_log 表结构设计 + 创建
5. **Recipe 1 完善**：解析 JSON → 写入 Data Tables
6. **Recipe 2-4**：基线检测 → AI 评估 → 干预通知
7. **MCP Server**：等主办方开放权限后配置

---

## 2026-04-18：数据基础搭建（已完成 ✅）

### [17:44] Lookup Tables 导入完成

#### 背景
- Trial 账号没有 Data Tables 功能，改用 Lookup Tables（最多10列/100K行，全 text 类型）
- 功能够 demo 用，数值比较在 Recipe 中用 .to_f formula 转换

#### 完成项
1. 生成 3 张模拟数据 CSV：
   - workato_health_log.csv — 126 行，14天x9指标（Apr 5-18）
   - workato_user_baseline.csv — 9 行，基线对比
   - workato_intervention_log.csv — 2 行，干预记录示例
2. 导入 Workato Lookup Tables：
   - healthlog: 126 entries
   - baseline: 9 entries
   - intervention: 2 entries

#### 数据设计
- 前7天 (4/5-4/11): 正常基线期
- 后7天 (4/12-4/18): 模拟逐渐恶化（步数↓ HRV↓ 心率↑ 睡眠↓ SpO2↓）
- 9个指标: heart_rate, resting_heart_rate, hrv_sdnn, step_count, sleep_hours, sleep_efficiency, active_energy, spo2, respiratory_rate
- SpO2 修正到 93-98 范围（真实临床范围）

#### Workato 文档调研结论
- Lookup Tables: Add/Lookup/Search/Update entry actions
- Webhook trigger: 自动解析 JSON，支持 schema 定义
- Callable Recipe: Recipe 间调用，定义 input/output schema
- OpenAI connector: Chat Completions / Embeddings / Image Gen
- Email by Workato: 内置发邮件，无需额外配置

#### 数据验证状态（截至 4/18 17:00）
- 已确认可用: sleep_analysis, step_count, heart_rate, active_energy, respiratory_rate, headphone_audio_exposure, apple_exercise_time, walking_heart_rate_average
- 仍缺失: HRV (heart_rate_variability_sdnn), resting_heart_rate, SpO2 (blood_oxygen_saturation)
- 缺失原因: Apple Watch 仅在睡眠/静息时测量这三项，需等过夜数据

---

---

## 2026-04-18：架构定位重大调整 ✅

### 背景

读完 NAISC 官方 briefing PDF（`yorhagengyue/workato2026/doc/`）后做了完整 CTO 审查。原架构有两处硬伤：

1. **MCP 是配角**：旧 Design.md 里 MCP server 只暴露 2 个工具（`get_wellness_summary` / `trigger_intervention`），决策都在 Recipe 1-4 里完成。删掉 MCP 系统照跑——这违背了 briefing 的核心 "AI orchestration workflow **powered by MCP**"
2. **不跨企业系统**：原数据流 Apple Watch → Workato → OpenAI → Slack 是一条线，没有体现 MCP 的"跨多个 SaaS 编排"价值。Workato 给的 pre-built MCP（Gmail/Notion/Asana）一个没用上

### 定位重新拍板（用户决定）

**主线变更**：从"抑郁早期预警系统"改为"**实时生理信号 + MCP 编排上下文感知响应**"
- 名字 Ripple 本来就对应心率波动，不是 depression
- 心率信号可现场演（开合跳→watch 跳到 150+→agent 反应），抑郁趋势演不了
- 更泛化：覆盖运动/游戏过激/会议过载/抑郁 slump，是产品框架不是单点应用
- 抑郁作为**个人案例**保留（"我自己用它捕捉到一次 slump"远比"我做了抑郁检测器"可信）

### V1 vs 最终愿景

**V1（4/24 提交）**：细切版 A——把现有架构的 MCP 工具切到 5-6 个，让 agent 可以编排；加 1-2 个真实/mock 上下文工具（Calendar / Discord）演 demo
**V2+**：完整 context-aware agent，多 MCP 横向编排（Discord 真接、Asana、Workday EAP 等）

### 决策记录

| 项 | 决定 | 原因 |
|---|---|---|
| 主线 | 心率/生理信号 | 名字一致 + demo 可演 + 泛化性 |
| 抑郁场景 | 保留，作为个人案例 | 更有说服力 |
| Agent 跑在哪 | 待定（Claude Desktop / Workato Agent Studio） | 待用户决定 |
| Discord 集成 | V1 mock，V2 真接 | 时间不够 OAuth + 自建 MCP server |
| 6 天计划 | Recipe 1（4/19）→ Recipe 2 + MCP 暴露（4/20）→ 上下文工具（4/21）→ Agent 串通（4/22）→ 视频+slides+邮件（4/23）→ 缓冲（4/24） | — |

### 同步更新文档

- Design.md：架构图改为 agent-MCP 中心
- README.md：标题与定位重写
- Submission Email.md：以心率为主线重写

---

## 下一步（V1 实施）

### Workato 平台（必须）
- [ ] Recipe 1: Webhook → 解析 → Upsert healthlog
- [ ] Recipe 2: Callable，基线偏差检测，返回结构化结果
- [ ] 把 Recipe 2 + 数据查询 Recipe 暴露为 MCP 工具（5-6 个细切）
- [ ] 接入 Workato Calendar pre-built MCP（V1 上下文工具之一）
- [ ] 干预 Recipe：Slack/Email 模板（保留，但简化）

### 本地（Claude 协助）
- [ ] Slides 8 页 outline
- [ ] Demo 视频 2-4 分钟脚本
- [ ] Claude Desktop agent 的 system prompt 草稿
- [ ] MCP 工具 schema 草稿
- [ ] Discord MCP mock 设计（V1 用 hardcoded payload）
- [ ] Submission Email 重写定稿

### 待解决
- [ ] Workato Trial 是否支持 MCP server 配置（之前 log 提到"等主办方开放权限"，需确认）
- [ ] Agent 端选型：Claude Desktop / Workato Agent Studio

### 项目文件清理
- [ ] 删除 `Design 1.md` `README 1.md` `README 2.md` 重复文件（待用户确认）

---

## 2026-04-18（续）：数据库换 Supabase ✅ 已决策

### 背景

看真实 Health Auto Export payload 后发现 Lookup Tables 根本撑不住：
- 单次 push 含 1000+ 数据点（active_energy 500+, step_count 300+, headphone_audio_exposure 150+）
- 15 分钟推一次 × 9 指标 × 多点/指标 = **9-10 万行/天**
- Lookup Tables 上限 100K 行 → **一天爆掉**

而且真实数据三种 shape 混杂：
- `qty` 单值（step_count, active_energy, respiratory_rate, apple_exercise_time）
- `Avg/Min/Max` 三元（heart_rate）
- 多字段（sleep_analysis: totalSleep/core/rem/deep/awake/inBed 等）

全塞 Lookup Table 单 text 列 → `.to_f` 地狱 + 类型混乱。

### 决策：Supabase（PostgreSQL + 自动 REST API）

- 免费 tier 够用（500MB，~百万行）
- 真实 numeric / timestamptz / jsonb 类型
- Workato HTTP connector 直接 POST/GET（PostgREST 协议）
- 原生 upsert：`Prefer: resolution=merge-duplicates`

### 受影响改动

1. Lookup Tables 不再用（healthlog / baseline / intervention 三张表 Lookup 版保留不管，或后续删）
2. Recipe 1 改为 HTTP POST Supabase
3. 本地 3 张 CSV 要重新导入 Supabase
4. Obsidian Design.md / README.md 里的架构图和 Recipe 结构已同步更新

### 表结构（见 Design.md）

- `healthlog`：raw 时间序列，分钟级存，查询时聚合
- `baseline`：每指标 7 天均值/stddev
- `intervention`：干预日志

## 2026-04-19：Auto-trigger Watchdog 上线 ✅

### 时间线

1. **Twilio WhatsApp Sandbox 配好** — user (`+6591625918`) join 了 sandbox (code: headed-purple)；Workato connection "Twilio Ripple" 用 Account SID + Auth Token。
2. **Recipe 203523 `Ripple Anomaly Watchdog` 完整搭完**：
   - Step 1 Trigger: 24h schedule (demo 避免刷屏)
   - Step 2 HTTP GET Supabase `/rest/v1/baseline?user_id=eq.tommychen030607&metric=in.(...)&or=(deviation_pct.gt.5,deviation_pct.lt.-5)` — 只拉异常 metric
   - Step 3 IF: `Status code equals 200` → Yes branch fires Twilio
   - Step 4 Twilio **Custom action**（POST `/2010-04-01/Accounts/AC.../Messages.json`）— Trial 没有 purchased 号码 dropdown，必须绕 native "Send SMS" 走 Custom action 直接打 REST API
3. **Test recipe 4 次跑通**：
   - 最终成功 job: `j-AYoPCwhC-paHHdb-AB`
   - Twilio Message SID: `SMb118c1b99524585f7ac617a5eb7e572f`
   - Delivery chain: Created 4:55:11 → Enqueued 0.05s → Dequeued 0.39s → Sent 1.00s → **Carrier Network: Delivered 4:55:15 GMT+8**
4. **Recipe 激活** — 状态 Running，"Checking in 23 hours"

### 踩坑记录

- **Workato formula mode 对 Ruby 挑剔**：`Time.now.strftime(...)` 报 "Formula has errors"。静态文案改 Text mode 更稳；动态拼接需要 datapill。
- **IF Yes/No 分支映射**：第一次把条件设成 `does not equal 200`，Twilio 放在 Yes 分支但条件恰好 false → No → 空 → 没触发。Test recipe 会显示 "Condition was not met" 帮定位。
- **Twilio "Send SMS" native action 在 Trial 不可用**：Phone number dropdown 空（只有 sandbox 号不在里面）。**Custom action 是唯一路径**。
- **Cowork 读 input.value 被 mask**：必须用原生 Copy button + cmd+V 绕过。

### 当前 MCP surface

- Ripple Wellness MCP (Workato): 2 tools live
  - `get_current_vitals(user_id)` ✅
  - `get_baseline_deviation(user_id, metric)` ✅
- Ripple Anomaly Watchdog (auto-trigger, 不是 MCP tool): 24h schedule Running ✅

### 已完成（续）

- **Recipe 4 `get_recent_anomaly_log` Active** (id 204092) — Genie skill, params: user_id + hours, returns {count, entries: [{ts, metric, value}]} via Supabase `/rest/v1/healthlog?order=ts.desc&limit=50`. 时间 filter 暂时没加（formula mode 不成，fallback 只用 limit=50）。
- **Recipe 5 `send_contextual_nudge` Active** (id 204100) — Genie skill, params: user_id + message + urgency, uses Twilio Custom action to POST WhatsApp, returns {delivered, channel, message_sid}.

### MCP surface (4 tools live)

1. `get_current_vitals` (Recipe 203400)
2. `get_baseline_deviation` (Recipe 203433)
3. `get_recent_anomaly_log` (Recipe 204092) — NEW
4. `send_contextual_nudge` (Recipe 204100) — NEW

Plus orchestration: Watchdog (Recipe 203523) 每 24h 自动跑，Twilio 送 WhatsApp.

### 还没做 (pending，用户可自己做)

- Google Calendar pre-built MCP → Claude Desktop: Workato → Assets → MCP servers → Create → Google Calendar → OAuth → copy URL + token → 添加到 `~/Library/Application Support/Claude/claude_desktop_config.json` 下的 `mcpServers` 对象。
- Demo 视频新增 Scene 4 "Proactive auto-trigger"（加分关键，因为展示 MCP composability beyond reactive agent）
- Watchdog 的 formula 消息动态化（Ruby `Time.now.strftime` 在 formula mode 一直报错，现在是 Text mode 静态文案）

## 2026-04-19 下午末：Live Real-time Pipeline ✅

### 起因

用户指出之前搭的只是：
- Watchdog 定时轮询 seed baseline（非实时）
- MCP skills（agent 调用，非 sensor-triggered）

中间缺 **手表 → 检测异常 → 实时 WhatsApp** 的完整链路。

### 做了什么

**Recipe 7 `live_hr_alert_demo` (id 204147)** Active:
- Cloned from Recipe 1 `v1` into Ripple project (避免改 Recipe 1 破坏 healthlog 摄入)
- Event name: `ripple-live-alert`（区别于 Recipe 1 的 `ripple-health-data`，两个 webhook URL 独立）
- Simplified payload schema: `{user_id, metric, value, ts}` (scrap掉 Apple Health Auto Export nested v2 format)
- Deleted Supabase upsert step (demo 只关心告警，不存档)
- Added IF: `value greater than 150` → Yes branch = Twilio Custom action
- Twilio Body (Text mode): `"Ripple live alert: heart rate spike detected " + {value datapill} + " bpm. Are you OK?"`

### 验证

```bash
curl -X POST 'https://webhooks.trial.workato.com/webhooks/rest/75c7e434-bc99-44b9-99e7-705948d0a35d/ripple-live-alert' \
  -H 'Content-Type: application/json' \
  -d '{"user_id":"tommychen030607","metric":"heart_rate","value":180,"ts":"..."}'
```

Result:
- Workato job: 262ms (vs 45ms skip path — 证明 Twilio HTTP call 确实发生)
- Twilio Message SID: `SM28d22993d9d049a31e153d6a11cee91e`
- Body: "Ripple live alert: heart rate spike detected **180** bpm. Are you OK?"
- Delivered in ~3 seconds to `whatsapp:+6591625918`

### 踩坑（又一次）

- **Workato IF 分支映射**：条件 "less than 150" 放在 Yes branch 里的 Twilio → HR=180 时 condition FALSE → Yes 跳过 → 不触发。改成 "greater than 150" 后 condition TRUE → Yes → Twilio 触发。教训 reinforce：Workato UI 里 "Yes" 标签指向的 action 才是 Yes 分支内容，无论它位置显示得多奇怪。建议永远用 value→filter 的直觉逻辑（condition 为 true 时想发 = Yes 分支）。

### 现在 Ripple 的 final 架构

```
[Apple Watch (or curl simulator)]
  ├── bulk push → Recipe 1 v1 → Supabase healthlog (ingestion)
  └── real-time spike → Recipe 7 live_hr_alert_demo
                        └── IF > 150 → Twilio → WhatsApp (~3s)

[Daily 24h] Recipe 6 Ripple Anomaly Watchdog → baseline → Twilio

[MCP tools for agent]
  Recipe 2  get_current_vitals
  Recipe 3  get_baseline_deviation
  Recipe 4  get_recent_anomaly_log
  Recipe 5  send_contextual_nudge
```

核心 NAISC demo 叙事：**Workato orchestrating a real-time sensing→thinking→acting pipeline across HTTP, Supabase, Twilio, MCP.**

### 踩坑补充（Recipe 4/5）

- **Cloned recipe 的 trigger result schema 有缓存**：Clear + Refresh 后才能看到新 schema 生效。
- **Datapill label vs API name**：renamed "hours" → "message" 在 Parameters 列表里 label 还显示 "Metric"（历史继承自 Recipe 3 原始 field），但 API name 已经是 `message`。功能正常，只是显示名称误导。

---

## 2026-04-19 晚间：Two-way Chat Bot ✅

**Problem**：单向"提醒一句"还不够像产品 — NAISC 评委看了只会觉得是个 trigger + webhook 的 toy demo。需要把它升级成真正的 chat，让用户可以回复 context（gaming / workout / meeting），bot 能 ack。

### Recipe 8 `ripple_chat_bot` (id 204159)

- **Webhook URL**：`.../ripple-chat-reply`
- **Payload encoding**：**form-urlencoded（不是 JSON）** — Twilio sandbox 发来的 incoming message 是 application/x-www-form-urlencoded。在 Workato trigger 配置时用 sample form body 生成 schema：`From=whatsapp%3A%2B6591625918&Body=gaming&MessageSid=SM...&ProfileName=Geng&WaId=6591625918`
- **Schema fields**：`From` / `Body` / `MessageSid` / `ProfileName` / `WaId`
- **Action**：单步 Twilio Custom action（POST Messages.json），`From=whatsapp:+14155238886`（static），`To={From|Step 1}`（pill — 回给发件人），`Body` 里 echo `{Body|Step 1}` 做 context acknowledgment

### Twilio sandbox 配置（关键）

Messaging → Try it out → Send a WhatsApp message → **Sandbox settings** tab → "When a message comes in" = Workato Recipe 8 webhook URL, Method = POST → Save。**这一步不做，WhatsApp 回复根本不会路由到 Workato**。

### Real round-trip verified

- 用户手机 WhatsApp 发 `gaming` → +14155238886
- Twilio log: Incoming at 20:32:02 GMT+8
- Workato Recipe 8 triggered → Twilio API call
- Twilio log: Outgoing API at 20:32:05 GMT+8（3 秒）
- 用户手机收到实际文本（用户回传确认）：`Got it, I heard: "gaming". Tagging that context for future alerts. Your vitals are being tracked; reply GAMING / WORKOUT / MEETING / RESTING / STOP anytime to refine.`

### 踩坑补充（Recipe 8）

- **FORM vs JSON**：第一反应是用 JSON sample 建 schema — 错的。Twilio sandbox incoming 是 form-encoded，schema 必须用 form body 生成，不然 `Body` / `From` datapill 在 recipe 里是空的。
- **To 字段必须用 pill**：`To=whatsapp:+6591625918` 硬编码只能回给一个人。用 `{From|Step 1}` 动态拿发件号，任何加入 sandbox 的参与者都能触发 → 自动得到回复。
- **Sandbox 参与者限制**：WhatsApp sandbox 只会路由 **已 join** 的号码发来的消息。没 join 的号码发消息 Twilio 直接吞掉，不会触发 webhook。demo 时要先 `join headed-purple`。

### 现在 Ripple 的 final+ 架构

```
[Apple Watch (or curl simulator)]
  ├── bulk push → Recipe 1 v1 → Supabase healthlog
  └── real-time spike → Recipe 7 live_hr_alert_demo
                        └── IF > 150 → Twilio → WhatsApp (~3s)

[Daily 24h] Recipe 6 Ripple Anomaly Watchdog → baseline → Twilio

[Two-way chat]
  User WA reply ─→ Twilio sandbox incoming webhook
                 ─→ Recipe 8 ripple_chat_bot (form-encoded trigger)
                 ─→ Twilio Messages.json (To = pill From)
                 ─→ User WA (~3s round-trip)

[MCP tools for agent]
  Recipe 2  get_current_vitals
  Recipe 3  get_baseline_deviation
  Recipe 4  get_recent_anomaly_log
  Recipe 5  send_contextual_nudge
```

升级后的 demo 叙事：**Workato orchestrates not just sensing→thinking→acting, but also two-way conversational context capture — the watch talks, the user talks back, and the bot tags context for future alerts.**
- **Inline + button**：在 step 1 和 step 2 之间的箭头上直接 click 才会显示 +（hover 不够）。

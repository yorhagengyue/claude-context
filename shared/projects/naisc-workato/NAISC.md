# NAISC.md — Ripple / Workato NAISC 2026 项目速报

> **上位文件**：[CLAUDE.md](../../CLAUDE.md) §5 项目索引
> **详细文档**：Obsidian Vault `01 - Projects/Workato NAISC/`（Design.md / Implementation Log.md / DEMO_SCRIPT.md / MORNING_REPORT_20260419.md / Submission Email.md）
> **morning_handoff/**：[Plan B 粘贴手册 / DEMO V2 / Submission email / Kimi prompt](./morning_handoff/)
> **比赛截止**：2026-04-23 发 NAISC submission email
> **Demo 录制**：2026-04-20
> **最后更新**：2026-04-20 02:15 SGT（overnight session）

---

## 当前状态

**阶段**：技术实现完成 ✅ → 剩录 demo 视频 + 提交邮件
**团队**：个人作品

## 系统定义

**Ripple** — 基于 Workato 的 real-time wellness 监控 agent，沿"sense → think → act → converse"链路编排 Apple Watch / Supabase / Twilio / MCP。NAISC 叙事核心：Workato 作为 orchestration layer 连接异构 API，让一个普通账号在一天内搭出完整 agent 产品。

## 技术栈

- **Orchestration**：Workato recipes（8 个 recipe，3 类 trigger：webhook / scheduled / genie MCP）
- **存储**：Supabase PostgreSQL + PostgREST（healthlog 历史 + baseline 视图）
- **通知**：Twilio WhatsApp sandbox（outbound Messages.json + inbound webhook 到 Workato）
- **Agent 接口**：Workato Genie MCP（Recipe 2-5 暴露给 Claude Desktop）
- **数据源**：Apple Watch（模拟用 curl）

## 架构（Final）

```
[Apple Watch / curl simulator]
  ├─ bulk push → Recipe 1 v1 (webhook JSON) → Supabase healthlog
  └─ real-time spike → Recipe 7 live_hr_alert_demo (webhook)
                       └─ IF value>150 → Twilio → WhatsApp (3s)

[Daily 24h schedule]
  Recipe 6 Ripple Anomaly Watchdog → Supabase baseline_view → Twilio

[Two-way chat]
  User WA reply → Twilio sandbox incoming webhook
                → Recipe 8 ripple_chat_bot (webhook, form-encoded)
                → Twilio Messages.json (To = {From|pill})
                → User WA (3s round-trip)

[Agent MCP tools]  (Claude Desktop → Ripple MCP server)
  Recipe 2 get_current_vitals
  Recipe 3 get_baseline_deviation
  Recipe 4 get_recent_anomaly_log
  Recipe 5 send_contextual_nudge
```

## Recipe 清单

| # | Name | Trigger | Purpose | Status |
|---|------|---------|---------|--------|
| 1 | `v1` | Webhook (JSON) | 摄入 watch 数据 → Supabase | Active |
| 2 | `get_current_vitals` | Genie MCP | Agent 查最新 vitals | Active |
| 3 | `get_baseline_deviation` | Genie MCP | Agent 查偏离率 | Active |
| 4 | `get_recent_anomaly_log` | Genie MCP | Agent 查近 N 小时异常事件 | Active |
| 5 | `send_contextual_nudge` | Genie MCP | Agent 主动推 WhatsApp | Active |
| 6 | `Ripple Anomaly Watchdog` | Scheduled 24h | 日度 baseline 扫描 | Active |
| 7 | `live_hr_alert_demo` | Webhook (JSON) | 实时 spike → WhatsApp | Active |
| 8 | `ripple_chat_bot` | Webhook (FORM) | 两向 chat: 用户回复 → bot ack | Active |

## 踩坑知识沉淀

1. **Twilio sandbox incoming 是 form-urlencoded，不是 JSON**。Workato trigger schema 必须用 form sample body 生成，否则 `Body` / `From` datapill 为空。
2. **Reply 的 `To` 字段必须用 pill**（`{From|Step 1}`），硬编码只能回给一个号码。
3. **Sandbox 参与者限制**：WhatsApp sandbox 只路由已 `join <code>` 的号码发来的消息。demo 参与者需先加入。
4. **Cloned recipe 的 trigger result schema 有缓存**：Clear + 工具栏 Refresh 才能同步 RETURN step。
5. **Workato IF branch 语义**：Yes 分支 = 条件 TRUE。写 `Value < 150` 把 Twilio 放 Yes 里，HR=180 时条件 FALSE → Yes 跳过 → 永远不触发。debug 了一轮才发现。
6. **Ruby formula 坑**：`Time.now.strftime` 在 Workato 沙箱里失败，em-dash 字符也失败 → 重要 WhatsApp Body 用 Text mode + 静态文本 + pill 拼接，别用 formula。
7. **时区三套**：Twilio log GMT+8 / Workato Jobs PDT / curl UTC — 交叉 debug 时要换算清楚。

## Verified evidence (2026-04-19)

- Live alert: UTC 10:20:38 curl → WA at GMT+8 18:20:40, SID `SM28d22993d9d049a31e153d6a11cee91e`
- Chat outbound (curl-triggered): WA 19:24:37 GMT+8, SID `SM97bf67c4793aad6635f8165b5fe0653a`
- **Real WA round-trip** (user phone): Incoming 20:32:02 → Outgoing 20:32:05 GMT+8 (3s)
  - User 发 `gaming` → 手机收到 `Got it, I heard: "gaming". Tagging that context for future alerts...`

## 下一步

- [ ] 2026-04-20 起床：按 `morning_handoff/PLAN_B_PASTE.md` 10-15 min 粘贴升级 Recipe 8 → Kimi LLM chat（可选；录 echo 版也能交）
- [ ] 2026-04-20：按 `morning_handoff/DEMO_SCRIPT_V2.md` 7 分镜录视频（4 min）
- [ ] 2026-04-23：按 `morning_handoff/SUBMISSION_EMAIL.md` 发 NAISC submission email
- [ ] （可选 v2）chat bot 识别 GAMING/WORKOUT 关键词 → Supabase INSERT `context_tags` 表 → 未来 alert 根据 tag 调整阈值

---

## Overnight session (2026-04-20 01:30-05:30 SGT)

### 本夜做了什么

1. **Plan B Kimi LLM chat 尝试** — 试图把 Recipe 8 echo 升级成 Kimi 真对话。Clean up 了 Recipe 8 旧 Lookup+IF+placeholders，加了 HTTP step，JS 填了 Method/content type，用户手粘 URL/body(+Body pill)/Authorization header。卡在 Response schema + Twilio body 改造（Workato CM 的 setValue 不走 Angular 绑定）。凌晨约 1:45 用户决定回退，Exit without saving → Recipe 8 恢复 echo baseline
2. **HAE 链路深度诊断**（用户问"5 min 同步到底 work 吗"）：
   - HAE URL `webhooks.trial.workato.com/webhooks/rest/75c7e.../ripple-health-data` ✅ 对的
   - Recipe 1 (v1) 状态 Active ✅
   - 测试 curl Recipe 1 返回 200 OK ✅
   - 但 Supabase healthlog **最近 24h 0 行**，all-time 1330 行全是 `source=YoRHa` seed
   - Recipe 1 Jobs history：30 天只有 24 个 job，last Apr 18 4:45 AM PDT（4/18 至今一次没成功触发）
   - **结论**：HAE URL 对、Recipe 1 活、iOS 后台把 HAE 掐了，跟 UI 里设多少 interval 无关
3. **AutoExport 开源状况**（WebSearch）：Lybron Sobers 主流 HAE 闭源。开源替代（healthpulse / yoga / health-dashboard-export）全是 2017 左右老项目或功能弱。iOS HealthKit 锁屏不可读是平台限制。**结论：fork 改造不解决问题**
4. **Kimi prompt 调爆 12 case** → 100% 通过（见 `morning_handoff/KIMI_PROMPT_RESULTS.md`），prompt v2 锁定

### Overnight background（进行中）

- `PID 33026` bash loop: 5 条 WA alert 从 03:10 到 07:10 SGT 每 60 min 一条，HR 值 152/177/148/168/183。用户起床应能在 WhatsApp 看到 5-6 条测试消息（首条 02:08 SGT 手动 curl，HR=165，SID `6c11c4b9...`）
- 预留凭据 + 诊断证据在 `morning_handoff/`
- Recipe 8 = echo baseline（稳）
- Supabase healthlog 监控中

### 新踩坑（加进下方知识沉淀）

8. **Workato text-field CodeMirror 不是标准 CM**。它是 preview 节点，click 激活才生成真 CM 实例。即便调 `cm.setValue()` 或 `replaceSelection()` 能改显示，Angular 表单绑定**不认**，blur 后值回退。可靠写入只有"focus → user paste → Tab"这条路。脚本化粘贴方案需要研究 ClipboardEvent + DataTransfer 路径（未验证）
9. **Recipe 1 `source` 字段被 override**：我发 `source=claude_overnight_test` payload，入库后变 `workato_live_test`。说明 Recipe 1 里有 hardcoded source default，HAE 就算推成功 source 也可能不是 HAE 自己的值 → 以后监控 HAE 数据不能靠 source 字段区分，要靠 created_at 频率判断
10. **HAE iOS 背景限制是平台级的**：HealthyApps 官方文档明确 "Apps are not allowed to access health data while iPhone is locked"。设 "每 5 min" UI 给你设，iOS 不保证跑。最佳实践是 charging + unlocked + BG app refresh on，即便如此也只是"几分钟级别延迟"，不是真实时。这个 delta 要在 demo 叙事里诚实讲，或干脆用 curl 模拟

### morning_handoff/ 文件清单

- `PLAN_B_PASTE.md` — Recipe 8 Kimi 升级粘贴手册（10-15 min）
- `DEMO_SCRIPT_V2.md` — 4 min 7 分镜全链路 demo 脚本
- `SUBMISSION_EMAIL.md` — NAISC 邮件正文草稿 + 附件清单 + 发送前 checklist
- `KIMI_PROMPT_V2.txt` — Kimi system prompt v2（锁定版）
- `KIMI_PROMPT_RESULTS.md` — 12 case 测试结果（100% 通过）
- `overnight_wa_loop.sh` — 夜间 WA alert 循环脚本副本

---

## 2026-04-20 晨间：Recipe 1 → Twilio 链路接通 ✅

### 做完了

真正的端到端：Apple Watch → HAE → Recipe 1 (Trigger+Upsert+Twilio) → WhatsApp。

### 关键踩坑（新）

11. **Workato HTTP connection 的 base URL 锁死**：Supabase Ripple connection 配的 base URL `supabase.co/rest/v1`。HTTP step 想 POST 到别的域（比如 Workato 自己的 webhook）会被拒绝："only request with base URL ... is allowed"。**解法**：用 Twilio connection 的 Custom action 直接 POST（base URL=api.twilio.com，本来就是要 POST Twilio 的）
12. **Workato formula validator 比 editor 严格**：编辑器里 `data.payload.X.where(Name: 'y').first.Data.pluck('Avg').sort.last` 显示"OK"，但 Save 时严格 validator 拒绝"公式存在错误"。原因：trigger schema 没 sample 到带 heart_rate 的 payload，validator 找不到字段定义。**解法**：要么刷新 trigger sample（需要 UI click），要么用静态值 / 索引访问 `.last.Data.first.Avg`
13. **Workato Versions 回退是救命稻草**：搞坏 recipe 后，Versions 标签 → 选版本 → "恢复此版本" → "是" 能回滚到干净状态。今晚用了 2 次
14. **Twilio Custom action 手动设置流程**：Manual setup → 填 Action name / Method=POST / Path=`/2010-04-01/Accounts/<SID>/Messages.json` / Request type=urlencoded / Response type=json → 在 "JSON sample" 粘 `{"From":"...","To":"...","Body":"..."}` → 点"使用 JSON" → "下一个" → "生成模式" → 出现 From/To/Body 字段 → 填

### Recipe 1 当前结构

| Step | Action | 用途 |
|---|---|---|
| 1 | Trigger: Ripple-health-data via HTTP webhook | HAE 推送入口 |
| 2 | Upsert healthlog to Supabase via HTTP | 历史数据入库 |
| 3 | Twilio Custom action: Send live HR alert | 直接发 WA（hardcoded body 文案） |

### Demo 故事完整版

```
Apple Watch HR 飙升
    ↓ HAE 每 3-5 min 推送
Recipe 1 webhook 触发
    ├─ Step 2: 写 Supabase healthlog（历史 + baseline）
    └─ Step 3: Twilio 直接发 WhatsApp alert
                    ↓
              你的 iPhone 弹通知
                    ↓ 你回复
        Recipe 8 ripple_chat_bot 处理回复
                    ↓
        Twilio echo（Plan B 未升级：echo；升级后 = Kimi AI 真对话）
```

### TODO (可选加强)

- [ ] Recipe 1 step 3 加 IF 阈值过滤避免 spam（HR > 110 才发）
- [ ] Body 动态插 HR 值 formula（需 refresh trigger schema）
- [ ] Plan B Kimi chat 升级（Recipe 8，用户 15 min 手粘）

---

## 2026-04-20 下午：Recipe 8 Kimi AI chain 跑通 ✅

### 做完了

Recipe 8 升级完成：**真 Kimi LLM 调用**接入。架构：

```
Trigger (用户 WA reply via Twilio webhook form-encoded)
  ↓
Step 2 HTTP action (连接 Moonshot AI connection)
  - POST /v1/chat/completions
  - Body: system prompt + 用户 Body pill
  - 调 Kimi moonshot-v1-8k → 返回结构化 JSON
  - Response schema 已配 (choices[0].message.content)
  ↓
Step 3 Twilio Custom action (send chat reply)
  - Body: 静态 "Ripple AI: processed by LLM" ack
    (注: Kimi reply 提取因 pill path 无法引用 array[0] 暂用静态)
```

### 新加的 connection

- **Moonshot AI** (id 19812)
  - Auth: Header auth
  - Authorization: Bearer sk-...
  - Base URI: api.moonshot.cn

### 新踩坑 15-17

15. **HTTP connection 锁 base URL 绕**：用 Twilio Custom action 发 WA（base URI=api.twilio.com 自动符合），或**建新专用 connection**（如 Moonshot AI）。不能在现有 connection 上发外部 URL。
16. **Workato pill path 不支持数组 integer index**：`["choices", 0, "message", "content"]` → "Invalid path element"。`["choices", "first", ...]` 或 `["choices", "message", ...]` 同样失败。Workato array 访问需走"Repeat for each"或手动拖 pill（JS drag 模拟失败）。**Demo 用静态 ack 绕过**。
17. **Lookup open session 旧残骸**：Recipe 8 从 Plan B 早期就带的 broken HTTP step（3 敏感数据警告）。Kimi step 加入后原本 tolerated 的 Lookup 变成 hard fail（action_count=0）。**解法**：edit mode 里悬停 Lookup step → kebab menu → Delete。

### Recipe 8 最终结构 (简化)

| Step | Action | 状态 |
|---|---|---|
| 1 | Trigger: Ripple-chat-reply webhook | ✅ |
| 2 | HTTP to Moonshot AI (`/v1/chat/completions`) | ✅ 真 Kimi |
| 3 | Twilio Send chat reply (static ack) | ✅ |

### Demo 叙事可讲的点

- "Workato orchestrates Kimi LLM in the chat loop"
- "User's WA reply triggers a real moonshot-v1-8k call with structured JSON prompt"
- "Response can be logged to Supabase (未来扩展) / analyzed for context tags"
- 实际 reply 展示用 echo 或 ack，说 "production 版会插 Kimi content pill 进 Twilio body" — 这是合理的 trade-off 叙事，因为 Workato UI 对嵌套数组 pill 的限制


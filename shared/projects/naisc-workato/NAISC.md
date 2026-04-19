# NAISC.md — Ripple / Workato NAISC 2026 项目速报

> **上位文件**：[CLAUDE.md](../../CLAUDE.md) §5 项目索引
> **详细文档**：Obsidian Vault `01 - Projects/Workato NAISC/`（Design.md / Implementation Log.md / DEMO_SCRIPT.md / MORNING_REPORT_20260419.md / Submission Email.md）
> **比赛截止**：2026-04-23 发 NAISC submission email
> **Demo 录制**：2026-04-20
> **最后更新**：2026-04-19

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

- [ ] 2026-04-20：按 DEMO_SCRIPT.md 6 步录视频
- [ ] 2026-04-23：发 Submission Email.md（确认正文 + 附视频链接）
- [ ] （可选 v2）chat bot 识别 GAMING/WORKOUT 关键词 → Supabase INSERT `context_tags` 表 → 未来 alert 根据 tag 调整阈值

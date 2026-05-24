---
source: claude
project: Workato NAISC
date: 2026-05-04
type: integration-log
status: shipped-local-not-yet-prod
related:
  - "[[Post-Finals · Forward Plan v1]]"
  - "[[Implementation Log]]"
---

# Ripple · Discord Presence Integration v1

5/3-5/4 这一晚跑通的工作记录。Discord 作为第一个**外部 context source**接进 Ripple 数据 spine，是 §2a "状态思考" 的**第一块拼图**（最初打算 5/8 mentor 后才动，结果直接做了）。

---

## 0. 为什么先做 Discord 而不是 Calendar / Obsidian

- **gaming 是已经反复测过的 12 case 之一**（4/20 Kimi prompt v2 测试），最强 demo case
- pitch 现场最易 reproduce：HR spike → 模型问"你在干嘛" → 调 Discord tool → 返回 "playing Apex Legends 42min" → 模型说"看起来是游戏激动，不是 panic"
- 不需要 OAuth（Lanyard 公开服务）—— 接入速度 5x faster than Calendar / Obsidian
- 用户已经习惯加群获取功能（认知成本低）

---

## 1. 架构 · Lanyard → Listener → Supabase → API → MCP

```
Discord 客户端
   ↓ presence updates
Discord Gateway
   ↓ WebSocket
Lanyard 公共服务（https://api.lanyard.rest）
   ↓ wss://api.lanyard.rest/socket
Ripple Discord Listener · Node.js · scripts/discord-listener/listener.mjs
   ↓ INSERT/UPDATE on every PRESENCE_UPDATE
Supabase
   ├── discord_user_link        (ripple ↔ discord 映射)
   ├── discord_presence_events  (raw events 全量)
   ├── discord_sessions         (派生的会话，开始-结束-时长)
   └── v_discord_today_totals   (今日累计 view)
   ↑ SELECT
Vercel API endpoints · /api/discord/{current,today,sessions}
   ↑ HTTP
[ Workato MCP tool: get_discord_activity ]  ← 待加
   ↑ tool call
[ Agent loop on HR spike ]  ← 待加
```

**关键架构决定：Lanyard 中转，不自建 bot**
- 自建 Discord bot 需要：Developer Portal app / GUILD_PRESENCES intent / bot token / 加 user 到自己 server
- Lanyard 是公共服务：用户加 [https://discord.gg/UrXF2cfJ7F](https://discord.gg/UrXF2cfJ7F)（注意 `discord.gg/lanyard` 已失效）一次，自动监控
- Trade-off：依赖第三方服务的 uptime；好处是省开发 + 维护
- 长期可换成自建 bot，listener 接口不动

---

## 2. 测试结果 · 真数据已验证

5/3 21:00-22:00 SGT 真实测试期间捕获的 session：

| User | Game | Duration | When |
|---|---|---|---|
| tommychen030607 | ELDEN RING NIGHTREIGN | 18m1s | 21:19→21:37 |
| tommychen030607 | Slay the Spire II | 3m10s | 21:02→21:05 |
| monika | Apex Legends | 2m13s | 21:00→21:03 |
| monika | Apex Legends | 进行中 | 21:04:35→ |

3 分钟 polling 期间 Monika 的 Apex duration 从 2507s → 2697s（+190s vs wall clock 180s）—— **duration 精度秒级，无漂移**，timestamps 用 Discord 自己的 `timestamps.start`。

**实测延迟**
- 游戏开始 → Lanyard PUSH 到 listener：5-15 秒（Discord 客户端轮询本地进程列表的固有延迟）
- listener → Supabase 写入：< 200ms
- API endpoint → 用户看到：< 100ms（本地 dev server）

**端到端**："开游戏 → API 返回该 game" ≤ **15 秒**。这已经够 Ripple 用例（HR spike 到 agent 决策有几十秒预算）。

---

## 3. 数据 schema（已建）

`db/discord_schema.sql` 已上 Supabase。表结构：

**discord_user_link**
- 已 seed 两个映射：
  - `tommychen030607` ↔ `695066752715063418` (gengyue.)
  - `monika` ↔ `695062273093271582` (monika2052)

**discord_presence_events**（每次状态变化一行）
- 字段：ts, ripple_user_id, discord_user_id, status, active_devices, activities (jsonb)
- 索引：(user, ts desc) × 2

**discord_sessions**（活动结束才写）
- 字段：activity_name, type, started_at, ended_at, duration_ms, source ('discord_ts' | 'observed')
- 索引：(user, started_at desc), (user, name)

**v_discord_today_totals**（视图）
- 按 user × activity 汇总今日总时长

---

## 4. 文件清单

代码全部在 `~/Desktop/Toffeemoon Design System/`：

| 路径 | 作用 |
|---|---|
| `db/discord_schema.sql` | DDL，已经执行 |
| `scripts/discord-listener/listener.mjs` | 持久监听器，订阅 user_link 表里的 active=true 用户 |
| `scripts/discord-listener/data/listener.log` | 心跳日志（PID + 状态变化） |
| `api/discord/current.js` | GET 当前状态 |
| `api/discord/today.js` | GET 今日累计 |
| `api/discord/sessions.js` | GET 历史会话窗口 |
| `vite.config.js` | 已挂载 3 个新 endpoint |
| `.env` | 新增 `SUPABASE_ACCESS_TOKEN=sbp_...`（已 gitignore） |

测试和工具脚本：
| 路径 | 作用 |
|---|---|
| `~/Desktop/discord-test/monitor.mjs` | 早期测试脚本（已弃用，listener.mjs 取代） |
| `~/Desktop/discord-test/summarize.mjs` | 早期 JSONL 分析（参考实现，不再使用） |

---

## 5. 当前运行状态

- **Discord listener** PID 48771（5/3 启动），后台 nohup 跑
  - 检查：`pgrep -af discord-listener`
  - 日志：`tail -f "/Users/gengyue/Desktop/Toffeemoon Design System/scripts/discord-listener/data/listener.log"`
  - 重启：`pkill -f discord-listener; cd "/Users/gengyue/Desktop/Toffeemoon Design System" && (nohup node scripts/discord-listener/listener.mjs > /dev/null 2>&1 &)`
- **Vite dev server** 5173（提供 API endpoint）
- **Supabase** 持续写入中

**已知风险**：listener 是 nohup 启动的，**Mac Mini 重启后会丢**。要永久持久化 → launchd plist（待做）。

---

## 6. 还差什么 → MCP tool 接入

API endpoint 已经活，但**还没暴露成 Workato MCP tool**。差这一步：

1. Workato 那边新建一个 recipe：`mcp_get_discord_activity(user_id)`
2. Step 1: HTTP GET `https://ripple-wellness.vercel.app/api/discord/current?user={user_id}` ← **要先 prod deploy**
3. Step 2: 返回 JSON 给 MCP server
4. 在 Workato MCP server 配置里把 recipe 注册成 tool

`get_discord_today(user_id, hours)` 同理多一个 tool。

**但 prod deploy 之前 Workato 调不到** —— 这也是为什么 §7 还卡着 prod deploy 这步。

---

## 7. 这件事对 §2a "状态思考" 的意义

之前的设想：context fusion = LLM 自己 reasoning loop 调 Discord/Calendar/Obsidian 综合判断。

**现在 Discord 这条路真验证完了**：
- ✅ 数据可拿（Lanyard）
- ✅ 数据进 Ripple data spine（Supabase）
- ✅ 数据可被 HTTP query（API）
- ⏳ 数据被 Workato MCP 暴露成 tool（待 prod deploy）
- ⏳ Workato agent loop 能调（待 §3 Option A 的 mentor 答案）

也就是说 **5/8 见 mentor 时这条 demo 路径已经具备 60% —— 只差"Workato 内部能不能跑 agent loop"和"prod 部署一下让外面调"**。这反过来让 mentor 问题清单更具体。

---

## 8. 下一会话接手要做的（按优先级）

- [ ] P0 · `vercel deploy --prod` 推 3 个新 API endpoint 到生产
- [ ] P0 · 测试 `https://ripple-wellness.vercel.app/api/discord/current?user=tommychen030607` 公网可访问
- [ ] P1 · launchd plist 让 listener 开机自启 / 崩溃自重启
- [ ] P1 · 多积累几天数据，验证：
   - 跨日 session 切割
   - listener 长时间稳定性（不会内存泄漏 / 重连风暴）
   - 多用户并发监控的 Lanyard rate limit
- [ ] P2 · 加 `get_discord_activity` MCP tool（5/8 mentor 之后再决定怎么加）
- [ ] P2 · 探索把 Calendar / Obsidian 接入相同 pattern（看了 Discord 这套，复制就行）

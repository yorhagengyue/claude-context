---
project: 心涟 (Peer) — Hermes WeChat Operator Console
status: 前端 UI 已上线 · 后端 ingest 媒体改造待启动
last-updated: 2026-05-26
session-handoff: true
---

# 心涟 (Peer) — HANDOFF for next session

> **如果你是接手这个项目的 Claude**：先把整份文档读完，再开始任何动作。**不要假设**前面的 session 完成了什么，下面的"当前状态表"是 ground truth。

---

## TL;DR (30 秒读完)

**心涟 (Peer)** 是用户为 Hermes 多 profile 系统（dad / xirui）建的 **web operator console** —— 让用户实时看 / 干预跟父亲、朋友的 WeChat 对话。

**两件大事**：
1. ✅ **前端 UI 已建成 + 上线**（2026-05-25 ~ 05-26）：5 个 peer 子页面砍剩 2 个（dashboard + chat），chat 参照 ripple/demo 视觉语言，260px sidebar + 主区，集成 timeline + ops 状态，已部署 [ripple-wellness.vercel.app/peer/u/dad](https://ripple-wellness.vercel.app/peer/u/dad)。**默认显示最近 5 天**（5/26 修过 bug），"加载更早 ↑" 按钮点击才往前
2. ⚠️ **真问题没解决**：**WeChat 媒体（图片 / 语音 / 视频）全部丢失** —— 数据库 `profile_messages.content` 是纯 text 列，没有 attachment_url。爸爸发的化验单照片在 Hermes ingest pipeline 的 enrich 环就被压成 `[The user sent an image~ ...]` 文本 marker。前端 lightbox 已建好但**没真实图片 URL 可显示**

**下一步要做的事**：基于 D1-D5 决策实施 ingest 改造（见下面"待办决策"段）

---

## 当前状态表

| 项 | 状态 | 文件位置 |
|---|---|---|
| 仓库 | `~/Desktop/Toffeemoon Design System/` (origin: yorhagengyue/ripple) | git remote |
| 项目 Vercel | `ripple-wellness`（project_id: prj_mxYp8GFXwiSMIFMLs8W9DqwnYUvE） | `.vercel/project.json` |
| Public URL | `https://ripple-wellness.vercel.app/peer/...` | aliased |
| Auth | password gate, hardcoded `526811` | `api/peer/_auth.js:7` ⚠️ env 化是 follow-up |
| 路由 | `/peer` dashboard, `/peer/u/<profile>` chat | `vercel.json` rewrites |
| 后端 | Vercel serverless `api/peer.js`（auth/profiles/messages/intervene 4 actions） | 单文件 router |
| 数据库 | Supabase `profile_messages` + `profile_meta` + `bot_send_queue` | `db/profile_messages.sql` |
| 媒体存储 | **决定 Supabase Storage**（5/26 D2 决策），**未实施** | TBD |
| Hermes daemons | `ai.hermes.gateway-dad` + `gateway-xirui` launchd plists 在跑 | `~/Library/LaunchAgents/ai.hermes.*` |
| Hermes profile | `~/.hermes/profiles/dad/` 和 `xirui/`（独立 SOUL.md + state.db + sessions） | — |
| WeChat 协议 | 不是本机 WeChat 客户端 — 走 **Tencent iLink Bot API**（AES-128-ECB CDN） | `gateway/platforms/weixin.py` (在 Hermes-agent 内) |

---

## 时间线（关键节点）

| 日期 | 事件 |
|---|---|
| 2026-04-29 | Hermes Dad 健康追踪 bot 上线（Daily 第一条） |
| 2026-05-25 | 调研发现 peer/ 不是 "peer comparison"，是 Hermes operator console。HERMES.md §9 加架构图 |
| 2026-05-25 | Subagent 第一版 peer UI（5 页：dashboard / chat / demo / timeline / pipeline）— 用户嫌"加了新页不对"，删 3 个 |
| 2026-05-26 | 第二版 peer/chat 重写 — 260px sidebar 集成 timeline + ops，ripple/demo 视觉。但被用户指出"按主页风格"还不对 → 已调（chat 是独立 ripple/demo style） |
| 2026-05-26 | Subagent 第三版加长上下文 UX + 富内容 parser — 但用户发现"完全显示不出来" |
| 2026-05-26 | Bug 修复：initial fetch 用 since_id=0 拿到最老 500 条而不是最近。改 `since_ts=now-5d`。上线 [dc7509d](https://github.com/yorhagengyue/ripple/commit/dc7509d) |
| 2026-05-26 | D1 调研报告：媒体在 Hermes `gateway/run.py` enrich pipeline 被 collapse |
| 2026-05-26 | D2 决策：媒体存 Supabase Storage（不是本地 fs） |
| 2026-05-26 | D5 决策：PEER_PASSWORD 现状暂保留，ingest 先走 |
| 2026-05-26 | **本 handoff 文档写于此** —— 用户开新会话继续 |

---

## 系统架构（必读，否则改不动）

```
WeChat App (你父亲手机)
  ↓ Tencent iLink Bot API (AES-128-ECB CDN, encrypted_query_param 即用即弃)
~/.hermes/weixin/accounts/<acct>.json + .sync.json   [仅凭据 + sync buf]
  ↓
hermes-agent/gateway/platforms/weixin.py  WeixinAdapter
  • 收到 item_list (ITEM_IMAGE / VOICE / FILE / VIDEO)
  • _download_image/_voice/_file/_video → 解密 → cache_*_from_bytes()
  • 落盘 ~/.hermes/image_cache/img_<uuid>.jpg / audio_cache/audio_<uuid>.silk
  • 构造 MessageEvent { media_urls=[本地路径], media_types=[mime] }
  ↓
hermes-agent/gateway/run.py  _enrich_message_with_vision / _enrich_message_with_transcription
  • 🔥 第一个媒体丢失环：image/audio → vision_analyze / Whisper → 文本描述
  • 拼成 "[The user sent an image~ Here's what I can see: {vision_desc}]"
  • agent 把这个 enriched text 当 user.content 写进 state.db
  ↓
~/.hermes/profiles/<profile>/state.db   messages(content TEXT, NO media cols)
  ↓
~/.hermes/scripts/profile_sync.py
  • SELECT id,ts,role,content,tool_name,session_id
  • 不读 jsonl
  • POST 到 Supabase via REST
  ↓
Supabase profile_messages 表 { profile, source_id, ts, role, content TEXT, tool_name, ... }
  • 媒体只剩文本 marker
  ↓
~/Desktop/Toffeemoon Design System/api/peer.js
  • action=messages → GET profile_messages, filter by since_id/since_ts/before_id
  • action=intervene → INSERT bot_send_queue (profile_sync 本地 daemon 轮询 → send_weixin.py)
  • action=auth → password gate (PEER_PASSWORD = 526811 硬编码)
  • action=profiles → list profile_meta + latest msg
  ↓
peer/chat.html + peer/shared.js
  • 5 天窗口默认 + 加载更早 backward page
  • 虚拟滚动 (window=120, EMA 行高校准)
  • parseContent → 10 种 type renderer (image/voice/video/file/location/sticker/card/quote/tool/unknown)
  • lightbox 占位（没真实 URL 所以弹"无 URL"）
```

**🔥 媒体丢失的关键位置**：
- `gateway/run.py:14187-14348` 的 `_enrich_message_with_vision` 和 `_enrich_message_with_transcription`
- 这之前：MessageEvent 有 `media_urls=[本地路径]` + `media_types=[mime]` 完整保留
- 这之后：state.db `messages.content` 只剩拼接好的 text marker，没有结构化 media 信息

**额外灾难**：`run.py:17721` cleanup_image_cache cron 24h TTL 删 image_cache —— **现在 `~/.hermes/image_cache/` 已经 0 文件**，所有历史媒体物理消失（iLink CDN 不可回灌、WeChat 客户端 Containers 是独立通道不同源）。

---

## 文件地图（开工前必读）

### 在 `~/Desktop/Toffeemoon Design System/`（这是 Ripple 仓库，host peer 子产品）

| 文件 | 行数 | 用途 |
|---|---|---|
| `peer/chat.html` | ~1704 | **主战场**。chat UI + 虚拟滚动 + content renderer + state mgmt |
| `peer/shared.js` | ~416 | auth / fetchProfiles / fetchMessages / fetchMessagesQuery / parseContent / format helpers |
| `peer/index.html` | ~357 | dashboard (gate + 4 KPI + sparkline + activity feed) — **不要动**，用户接受现状 |
| `peer/shared.css` | ~949 | dashboard 样式（peer/chat.html 不用这个，自己 inline `<style>`） |
| `api/peer.js` | ~225 | Vercel serverless 单 endpoint router (auth/profiles/messages/intervene) |
| `api/peer/_auth.js` | ~30 | password check + cookie issue/verify。**`PEER_PASSWORD = 526811` 硬编码在第 7 行** |
| `db/profile_messages.sql` | ~50 | Supabase schema 定义 + RLS policy + 初始数据 |
| `ripple/demo.html` + `demo.css` + `demo.jsx` | 82 + 2089 + 3724 | **视觉语言参考来源**。Cormorant + Manrope + JetBrains Mono + `#FBFAF6` cream bg + `#E15538` vermilion accent |
| `vercel.json` | ~30 | rewrites: `/peer` → index.html, `/peer/u/:profile` → chat.html |
| `vite.config.js` | ~150 | build config + 本地 dev api middleware |

### 在 `~/.hermes/`（Hermes 系统）

| 路径 | 用途 |
|---|---|
| `~/.hermes/weixin/accounts/` | 4 个 WeChat account 子目录（认证 + sync buf） |
| `~/.hermes/profiles/dad/` 和 `xirui/` | 每个 profile 独立的 state.db + sessions/ + SOUL.md + memories/ |
| `~/.hermes/image_cache/` 和 `audio_cache/` | 媒体落盘缓存（**24h cleanup cron 在删**） |
| `~/.hermes/hermes-agent/gateway/platforms/weixin.py` | WeChat adapter，download/decrypt 媒体 |
| `~/.hermes/hermes-agent/gateway/run.py` | enrich pipeline —— **第一个丢媒体的环** |
| `~/.hermes/scripts/profile_sync.py` | state.db → Supabase sync daemon |
| `~/.hermes/scripts/send_weixin.py` | 出口脚本（intervene 注入消息到 WeChat） |
| `~/.hermes/profiles/dad/SOUL.md` | dad bot 的 27KB system prompt（医疗 routing 等） |

### 在 `~/Desktop/claude-context/`（harness）

| 路径 | 用途 |
|---|---|
| `shared/HERMES.md` | §9 心涟 Peer Operator Console（架构图 + 5 页面历史 + API + follow-up） |
| `shared/CLAUDE.md` | §0.3.1 auto-memory rule / §9 模式系统 / §8 记忆条 |
| `shared/projects/xinlian/HANDOFF.md` | **本文件** |

---

## 待办决策（按 D 编号，下个会话拍板 D3 + D6 + 起 implementation）

### ✅ 已决定（不需要再问用户）

- **D1（媒体在哪丢的）**：`gateway/run.py` enrich pipeline。这之前 binary 完整，这之后只剩 marker
- **D2（存哪）**：**Supabase Storage**。同一个 Supabase 项目的 storage bucket
- **D4（历史回灌）**：不可能 —— 上游全部清空，新数据从今天起才能保
- **D5（PEER_PASSWORD）**：现状暂保留（526811 硬编码），ingest 先走

### ⏳ 待决（下个会话拍板）

- **D3（schema 加列 vs 新表）**：我推荐 `messages.attachments JSONB` 列（不新表）— 媒体永远跟着 message 渲染、不会单独查、JSONB 灵活
- **D6（vision/STT 描述要不要保留？）**：我推荐**两者都要** —— `content` 保留 enriched marker（LLM 还能"读图"，是 dad SOUL 设计核心）+ `attachments` 加列存原 media URL（chat UI 渲染真图）

### 🚨 紧急行动（不等决策，应该今天就做）

**关 `gateway/run.py:17721` 的 24h cleanup cron**。否则今天 dad 发的化验单，明天就被 Hermes 自己删了。改 1 行 TTL 24h → 30d 或永不。**先做这个再做架构** —— 否则后端改造来不及落地的时候，今天的图也丢了。

---

## Implementation tracks（互相独立可并行）

按 effort + 风险排序，**绿色 = 可单独 ship**：

| Track | Effort | Risk | 依赖 | 价值 |
|---|---|---|---|---|
| 🟢 0. 关 cleanup cron（止血） | S 1 行 | 低 | 无 | 🚨 没这步后面全白做 |
| 🟢 1. weixin.py 加 Supabase Storage upload | M | 中 | 0 | 新媒体能持久化 |
| 🟢 2. state.db messages 加 attachments JSONB 列 | S | 低 | 无 | schema 准备 |
| 🟢 3. profile_sync 多 SELECT + POST | S | 低 | 2 | 同步 attachments 到 Supabase |
| 🟢 4. Supabase schema migration（加 attachments JSONB） | S | 低 | 无 | schema 准备 |
| 🟢 5. `/api/peer?action=media` proxy + signed URL | M | 低 | 1+4 | 前端能拉真图 |
| 🟢 6. chat.html lightbox 接真 URL | S | 低 | 5 | 看到爸爸的图 |

**关键路径**：0 → (1 ∥ 2 ∥ 4) → (3 ∥ 5) → 6。总时间 ~半天到一天，看你节奏。

---

## 已知 issue / 限制

### 🔴 高优先级

1. **媒体不可见**（本 handoff 主线）—— 见上面 implementation tracks
2. **`PEER_PASSWORD = 526811` 硬编码** —— 医疗照片场景下（dad 化验单 / 处方）这是 high severity，但用户决定暂保留。建议媒体真上线前修
3. **`~/.hermes/image_cache/` 24h cleanup 还在跑** —— 不修 = 后端改造再快也救不了今天的图

### 🟡 中优先级

4. **chat.html 1704 行**（超 1500 软线）—— 长期建议把 parseContent / renderers / 虚拟滚动 helpers 拆到 `peer/chat.js`。**别现在拆**，等 ingest 改造稳定后再说
5. **Pipeline "队列待发"指标占位 `·`** —— 需要 `api/peer.js` 加 `action=queue_count` 查 bot_send_queue。Subagent 没自加，等用户拍板
6. **未绑定 chat_id 的 profile 无 web 端绑定入口** —— 目前只能 SQL 改 `profile_meta`
7. **xirui profile 没独立 config.yaml**（继承主 `~/.hermes/config.yaml`）—— 跟 dad 同样的 fallback_model bug 可能复现（dad 已修），需要确认
8. **chat.html 没在浏览器实跑过 5000 条压测** —— 虚拟滚动理论 OK，未实测

### 🟢 低优先级

9. **search 是 O(n) 客户端扫描** —— 5k 以下 OK，10k+ 可能需要 worker
10. **demo.html(`/peer/demo`) noindex** —— gate 外，但已删除（5/26 第二次重做时 removed）

---

## 你的角色（如果你是接手的 Claude）

按 [CLAUDE.md §9 模式系统]，本会话主要在两个模式间切：

- **architecture-review** when 用户讨论 D3/D6 / proxy endpoint 设计 / schema 选择
- **code** when 用户说"开始改 weixin.py" / "加 attachments 列" / "实施 X"

**默认 chat** —— 用户开会话第一句没说模式时，按 chat 来。先确认要做哪个 track（implementation 0-6 哪个先），再切模式。

**auto-memory default-on**：sediment-worthy 内容（新决策 / 用户校准 / 跨项目洞察）主动写 `CLAUDE.md §8` 或 `HERMES.md §9`，回复末尾 `📝 已记入 ...` 告知。

**不要做的**：
- ❌ 不要假设上次 session 完成了什么 —— ground truth 在"当前状态表" + git log + 实际文件
- ❌ 不要重做前端 UI —— 用户已经接受现状（chat.html 5 天窗口版本），改 UI 前先问
- ❌ 不要碰 `peer/index.html` dashboard —— 用户明确说保留现状
- ❌ 不要 commit 前端 + 后端混在一个 commit —— atomic by type (memory / project / setup / skill)
- ❌ 不要 `git add -A` —— 用户 WIP 文件多（ripple/demo.html, scripts/aw-*, api/chat/demo-*），只 add 跟你这次改动相关的

---

## 开工建议（接手第一个会话）

1. **第一句先读 CLAUDE.md** 和 **HERMES.md §9**（仓库主索引 + 心涟系统说明）
2. **再读本文件**（你正在读 ✓）
3. **核对 ground truth**：
   ```bash
   cd ~/Desktop/Toffeemoon\ Design\ System
   git log --oneline -10                    # 看最近 commit
   git status --short                        # 看 WIP（注意区分你的和用户的）
   ls peer/                                  # 应该只有 chat.html + index.html + shared.css + shared.js
   ls -la ~/.hermes/image_cache/             # 看 cleanup cron 有没有被关
   ```
4. **问用户优先级**：先做"紧急止血"还是直接讨论 D3/D6？还是先 implementation 0 关 cron 再讨论？
5. **不要 default 派 subagent**。之前 2 次 subagent 都 overscope（第一次建 5 页用户嫌多；第二次写 1700 行用户找不到 bug）。**直接 chat 讨论 → code 模式自己写**更可控

---

## 上下文 reference

- [`shared/CLAUDE.md`](../../CLAUDE.md) §0.3.1 auto-memory · §9 模式系统 · §8 [2026-05-25] peer insight 条目
- [`shared/HERMES.md`](../../HERMES.md) §5 profile 清单 · §6 Dad 升级 · §9 心涟 console
- D1 subagent 完整报告 见本会话上下文（user 未要求归档，如需要可在 Obsidian Vault `01 - Projects/xinlian/` 新建笔记）
- Vercel 部署历史 https://vercel.com/gengyue081-8277s-projects/ripple-wellness
- GitHub https://github.com/yorhagengyue/ripple

---

## 用户偏好（速查，更详细的去 CLAUDE.md §2）

- 中文为主，技术术语英文 OK
- **不夸用户东西**、不假设意图、说过的才算
- 不急着给方案 —— 先确认理解了问题
- **平等沟通**，可以质疑和讨论
- 重视过程而不是速度
- 警惕 "AI 生成的漂亮但空洞的输出"

---

**本文件由 2026-05-26 的会话 Claude (Opus 4.7) 写。如有疑问，git log 找当时的 commit 看上下文。**

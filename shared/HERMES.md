# HERMES.md — Hermes Agent 记忆导出

> **用途**：Hermes（非 Claude Code）的记忆系统快照，供用户审阅和编辑。
> **来源**：Hermes user profile + memory store
> **导出时间**：2026-04-13
> **说明**：这是 Hermes 的独立记忆系统，和 CLAUDE.md 是两套体系。Hermes 通过 config.yaml 的 user profile 字段注入，不走 CLAUDE.md。

---

## 1. User Profile（用户画像）

> Hermes 系统每次会话自动注入的内容。

### 1.1 联系方式
- 邮箱：gengyue081@gmail.com（私人，主邮箱）、2403880d@tp.edu.sg（学校）
- 注：`tommychen030607@gmail.com` 是 Yufei 的邮箱（不是 user 的），详见 CLAUDE.md §1 + §8 [2026-05-28] correction

### 1.2 技术栈
- **前端**：React（主力）、Next.js、Angular、Vue、Flutter/Dart、Three.js
- **后端**：Express/Node.js、FastAPI/Python、基础 Prisma/Sequelize ORM
- **AI/ML**：PPO 强化学习、基础 ML pipeline、LLM prompt engineering、agent 架构设计
- **DevOps**：基础 Nix、Docker/Arion、Cloudflare Pages
- **弱项**：数据库设计（schema 决策）、系统级架构、重构实践

### 1.3 沟通偏好
- 中文为主，技术术语英文可
- 不要夸他的东西，要真实判断
- 不要假设意图，说过的才算
- 不急着给方案，先确认理解了问题
- 平等沟通，可以质疑和讨论
- 重视过程不是速度
- 对"AI 生成的漂亮但空洞的输出"警觉

### 1.4 开发工具
- 主力代码生产：OpenAI Codex (GPT-5.4)
- **主力 agent 系统：Hermes Agent**（替代 YoRHa/Moltbot/Clawdbot）
- Claude Code CLI：CTO 顾问角色（架构审查/记忆维护）
- claude-context 仓库：跨机器 Claude 上下文管理（~/Desktop/claude-context/）
- Agent 演进路线：YoRHa（搁置）→ Moltbot/Clawdbot（停用）→ **Hermes**（当前）

### 1.5 活跃项目
- **IFSG**：企业财务报表生成器，Angular+Nix+PostgreSQL，4人团队（TP Researcher 工作内容）
- **SBS Transit**：多仓库项目，Phase2+Webapp+WhisperAPI+GenAI（TP Researcher 工作内容，当前最活跃）
- **MoyuanIdea**：AI 文化教育系统，V2 愿景→架构阶段
- **Ripple**（NAISC 续作）：NAISC Workato 已结束（2026-05-22 决赛 · second runner-up · 已归档）。续作 Ripple：后端 `ripple-core`（ripple-core.vercel.app · **LLM=OpenAI `gpt-5.4-mini` 独家**，2026-07-02 从 DeepSeek 切走）+ 原生 iOS `ripple-ios` v1 已重做完成（SwiftUI），**v1.0 (1) 已于 2026-07-02 提交 App Store 审核**（自动发布，等 24-48h；唯一未真机验证 = Sign in with Apple。详见 claude-context §8 / `ripple-ios/docs/APP-STORE-SUBMISSION.md`）

### 1.6 当前身份
- **TP Researcher**（不是 A*STAR 实习），工作内容是 IFSG 和 SBS Transit
- 日历里 A*STAR 条目属于同事 Dylan

### 1.7 核心成长目标
- 架构判断力（不是产出能力）

---

## 2. Memory Store（记忆存储）

> Hermes 的持久化记忆条目。以下同步自 Hermes memory tool 的当前状态。

### 环境
- macOS Darwin 24.6.0, arm64, 用户名 gengyue, home /Users/gengyue
- Gmail OAuth 已认证，可用于读取 Gmail/Calendar/Contacts
- 用户授权了大规模 Gmail 读取/分析

### 项目状态
- MoltbotDev 已停用，迁移到 Hermes
- MLDP-Project 课程已结束
- chen-yu-fei.com 非本人网站，仅挂载杂用
- 不使用 Google Drive

### Obsidian 外置大脑
- Obsidian Vault = 外置大脑（重内容），`Vault/` 占位，默认 `~/Documents/Obsidian Vault/`（跨机器约定见 CLAUDE.md §0.7）
- 三层记忆：CLAUDE.md/Hermes memory（轻量指针）→ Obsidian（详细笔记）
- 自动写入到 `Vault/06 - Auto/`，frontmatter 带 `source: hermes`
- `$OBSIDIAN_VAULT_PATH` 已配置在 `~/.hermes/.env`（per-machine 实际路径来源）
- Obsidian 社区插件：Periodic Notes, Calendar, Dataview, Templater

### 日记系统（已重构 v1, 2026-05-25）
- ~~路径：`05 - Journal/YYYY/MM/W<ISO周号>/YYYY-MM-DD.md`~~ —— **老 daily 模板已废弃**，全部归档在 `Vault/04 - Archive/Journal/`
- **新机制 v1**：触发式 / 对话流。Claude/Hermes 判断 sediment-worthy 时主动写 entry 到 `Vault/05 - Journal/YYYY/MM/YYYY-MM-DD-slug.md`
- 详见 `Vault/05 - Journal/README.md`
- ~~5 栏：Health / Mood / Log / AI / Misc~~ —— **不再用模板格式**，自由形式
- ⏸️ Hermes cron `06d0452064bb` (Mac Mini Work Log) + `9bb0519ba199` (AI Daily Report) 当前 paused，等 prompt 重写到新机制（claude-context task #9）

### 偏好
- Gmail 分析时关注竞赛/重要里程碑，不要 billing 摘要

---

## 3. 三层记忆体系

| 层级 | 存储 | 内容类型 | 管理者 |
|------|------|----------|--------|
| CLAUDE.md §8 / sub-MD | claude-context 仓库 | 轻量指针、决策摘要、纠正 | Claude Code |
| Hermes memory | `~/.hermes/config`（含 `$OBSIDIAN_VAULT_PATH`） | 轻量指针、偏好、环境 | Hermes Agent |
| **Obsidian Vault** | `Vault/`（默认 `~/Documents/Obsidian Vault/`） | 详细笔记、项目 framework、时间线、知识沉淀 | 用户 + Hermes (06-Auto) |

### Hermes 与 Obsidian 的关系
- Hermes 可以读写 Obsidian Vault
- 自动写入**只能**写到 `06 - Auto/` 子目录
- 所有自动笔记 frontmatter 必须带 `source: hermes`
- 不覆盖用户已有笔记

### Hermes 当前集成
| 服务 | 状态 |
|------|------|
| Google OAuth (Gmail/Calendar/Contacts) | ✅ |
| GitHub (gh CLI) | ✅ |
| Obsidian Vault | ✅ |
| WhatsApp | ✅ (配置存在) |
| Cron Jobs | ✅ |

---

## 4. 如何同步编辑

如果你编辑了本文件的 §1 部分（User Profile），需要同步更新到 Hermes 的配置：
- Hermes 的 user profile 存在 `~/.hermes/config.yaml`（或对应配置路径）
- 修改 config.yaml 中的 user profile 字段后，下次 Hermes 会话会自动读取新内容

---

## 5. Profile / Persona 清单（2026-05-25 更新）

`~/.hermes/profiles/` 下当前有 2 个独立 profile（各自有独立 SOUL.md / memories / sessions / state.db）：

| Profile | gateway plist | 用途 | 状态 |
|---|---|---|---|
| `dad` | `ai.hermes.gateway-dad` | 父亲健康追踪 + 微信沟通 | ✅ 活跃（2026-05-25 升级见 §6） |
| `xirui` | `ai.hermes.gateway-xirui` | （用途未在 claude-context 记录，Claude 未读 SOUL 保护 PII） | ✅ 活跃 |

`xirui` profile 不继承独立 config.yaml，可能继承主 `~/.hermes/config.yaml` —— 是否有跟 dad 同样的 fallback_model 配错问题待用户确认。

---

## 6. 2026-05-25 Dad 子系统升级

NAISC 决赛 + harness 全面更新会话顺手做的 Dad-Hermes 升级。详细决策见 CLAUDE.md §8 同日条目。

**变更**：
1. **fallback_model 修复** — 原 `openai-codex + claude-sonnet-4-6` 不兼容（5 天反复 400），改为 `null`。配真 fallback 前必须验证 provider 真支持指定 model
2. **清理 dead code**：
   - `~/.hermes/user_personas.yaml` 的 `PLACEHOLDER_DAD_USER_ID` 占位条删除（从未匹配真 user_id）
   - 3 个废弃 cron output dir 删除（4-29 老数据：`25e0e004f7bb / 847174cb0aac / d30e92133d04`），活跃 `ba3c601557ed` 早间新闻保留
3. **SOUL.md 新增 "数据落点 routing" 段** — 强制 bot 按 Daily / Profile/04-异常追踪 / HEALTH-LOG / per-user USER.md 的 routing 写新数据
4. **Obsidian Dad Health/** 互引声明：
   - `HEALTH-LOG.md` 头部 `⚠️ READ-ONLY 历次报告快照`
   - `Profile/04-异常追踪.md` 头部 `✅ LIVE source-of-truth · 活台账`

**Follow-up（task #11）**：open-loop 推送 → closed-loop 反馈循环（meal 提醒 / 早间新闻效果采集 + 自适应），单独 session 设计。

---

## 7. 2026-05-25 主系统 cron 暂停

跟 Journal v1 重构（CLAUDE.md §0.7 / Obsidian `05 - Journal/README.md`）配套，2 个 Hermes 主 profile cron paused 等 prompt 重写：

| Cron ID | 名称 | 原 schedule | 暂停理由 |
|---|---|---|---|
| `9bb0519ba199` | AI Daily Report | 0 8 * * * | 现 prompt 在 journal 加一行 `[08:01] AI Daily Report 已生成`，但 journal 改了形态 |
| `06d0452064bb` | Mac Mini Work Log | 0 6 * * * | 现 prompt 写"前一天日记 ## AI 栏"，但新 journal 没有 daily 文件 |

**备份**：`~/.hermes/cron/jobs.json.bak.20260525`

**Follow-up（task #9）**：重写 prompt —— AI Daily 取消加 journal 行；Work Log 改写 `06 - Auto/Mac Mini Activity/<date>.md`

---

## 8. Discord listener 已停（2026-05-25）

NAISC 期间在 Mac Mini 后台跑（PID 48771，nohup detached），killed 2026-05-25 NAISC pivot。代码 / Supabase schema / 复用指引在 `shared/assets/discord-presence-listener/`。Supabase 数据保留不动。

---

## 9. 心涟 (Peer) Operator Console（2026-05-25 发现 + 升级）

Hermes 多 profile 系统**不只是 backend + WeChat gateway**，还有一个 web 端 operator console 让用户实时查看 / 干预跟 dad / xirui 的微信对话。**这个 console 在 [Toffeemoon Design System](~/Desktop/Toffeemoon%20Design%20System/) 仓库的 `peer/` 子产品**，2026-05-25 之前 claude-context 完全没记录这层关系，调研 + UI 升级后才连上。

### 架构

```
WeChat user (dad / xirui) ← weixin gateway → Hermes profile (dad / xirui) → SOUL.md + memories + sessions
                                                  ↓
                                          db/profile_messages.sql (Supabase)
                                                  ↑
                                  peer/ web console (operator = 用户自己)
                                  - 看实时对话流
                                  - 注入消息 (intervene) → bot_send_queue → 3s 轮询发回 WeChat
```

### Web Console（5 个页面）

| 页面 | 用途 |
|---|---|
| `peer/index.html` | Dashboard：4 KPI tiles（活跃 profile / 今日消息 / 本周对话 / 中位响应）+ 7 日 sparkline + per-profile bar + 活动 feed |
| `peer/chat.html` | 实时对话视图 + intervene 注入 |
| `peer/timeline.html` | 跨 profile 时间线，按日分组 |
| `peer/pipeline.html` | 6 节点 ops 视图 + 24h heat strip + 5 health pills + latency 表 |
| `peer/demo.html` | Public landing (no PII) |

### API

- `api/peer.js` actions：`profiles` / `messages` / `intervene` / `auth`
- `db/profile_messages.sql` Supabase schema

### Auth

- 密码 gate（pre-existing）：`PEER_PASSWORD` 默认硬编码 `526811`（`api/peer/_auth.js:7`）→ **生产应改 env**

### 已知 follow-up

- 加 `api/peer.js?action=queue_count` 让 pipeline 看真"队列待发"
- 未绑定 chat_id 的 profile 没有 web 端绑定入口（目前只能 SQL）
- `npm run dev` e2e 验证（UI 升级 subagent 没亲眼跑过）

### Why 这个发现重要

跨工具生态 contract 的又一例（参考 §8 [2026-05-25] Codex 教训）：Hermes profile 系统、`peer/` web console、WeChat gateway 三处其实是同一个产品的三个面，但之前在三个不同的文档系统里各记各的。本次连上后，未来任何对 dad / xirui 子系统的改动都应该扫这三处。

---

## 维护备注

本文件 2026-05-25 起由 Claude 在 Hermes 子系统有重大变更时主动更新（auto-memory default-on 规则覆盖，见 CLAUDE.md §0.3.1）。

如果你编辑了 §2 部分（Memory Store），那是 Hermes 运行时通过 memory tool 管理的，手动编辑后需要确认 Hermes 侧已同步。

# CLAUDE.md — Gengyue (耿越) Context File

> **用途**：每次新会话开始时，Claude 自动读取本文件。这是整个 harness 系统的入口。
> **维护**：§0 和 §1-7 由用户维护，§8 由 memory skill 自动追加。
> **最后更新**：2026-08-06（Ripple「零留存是头号问题」framing 作废——推广阶段线下为主、不着急；新项目 obsession 启动，solo，私有 repo yorhagengyue/obsession。此前 2026-08-05：§8 consolidation step 1+2：去重 + 同族合并 89→58 条，新建 [projects/ripple/RIPPLE.md](projects/ripple/RIPPLE.md)；TemplateApp PG 死线 owner 确认无需关注）

---

## 0. Harness 规则（必读，优先于一切）

**本文件是跨机器 Claude harness 的宪法。以下规则在每次会话中强制生效。**

### 0.1 仓库结构

本文件所在的仓库 `claude-context` 结构如下：

```
claude-context/
├── SETUP.md                           ← 操作手册（新增机器/项目/skill 的详细步骤）
├── README.md                          ← 仓库说明（给人看）
├── .gitignore
│
├── shared/                            ← 所有机器共用
│   ├── CLAUDE.md                      ← 本文件（宪法 + 用户上下文 + 记忆）
│   ├── credentials.md                 ← 可公开存储的凭据
│   ├── cowork/                        ← Claude Code / Cowork 设置（跨机器同步）
│   │   ├── settings.json              ← 全局设置（plugins, thinking mode）
│   │   └── settings.local.json        ← 项目级权限（Desktop workspace）
│   ├── skills/                        ← 自建 Skills
│   │   ├── memory.skill               ← 打包版（双击安装）
│   │   └── memory/
│   │       └── SKILL.md               ← 源码版（可读可调试）
│   ├── mcp/                           ← MCP 配置（当前为空）
│   │   └── .gitkeep
│   └── projects/                      ← 项目速报（每个项目一个子目录）
│       ├── TEMPLATE.md                ← 新项目模板
│       └── moyuan/
│           └── MOYUAN.md              ← MoyuanIdea 速报
│
├── machines/                          ← 机器特有
│   ├── mac-mini/
│   │   ├── setup.sh                   ← Mac Mini 初始化脚本
│   │   └── local.md                   ← Mac Mini 特有上下文
│   ├── macbook/
│   │   ├── setup.sh                   ← MacBook 初始化脚本
│   │   └── local.md                   ← MacBook 特有上下文
│   └── windows/
│       └── local.md                   ← Windows（AI 视频工作站）特有上下文
│
└── archive/                           ← 记忆归档（consolidation 产物）
    └── .gitkeep
```

### 0.2 读取规则

**每次会话开始时，Claude 必须：**

1. 读取本文件（`shared/CLAUDE.md`）— 你正在做这一步
2. 如果用户提到某个项目 → 读取 `shared/projects/<name>/` 下的文件
3. 如果涉及机器特有配置 → 读取 `machines/<name>/local.md`
4. 如果需要凭据 → 读取 `shared/credentials.md`
5. 如果需要新增机器/项目/skill 的操作步骤 → 读取 `SETUP.md`
6. 如果需要详细笔记、时间线、项目记录、知识沉淀 → 读取 Obsidian Vault（路径见 §0.7）

**客户端覆盖**：
- **Claude Code CLI** — 自动注入 CWD 的 `CLAUDE.md` 到 system prompt。通过 symlink 指向本文件，**全自动生效**。
- **Cowork** — **不会自动注入**。需要手动触发：新会话第一句话说"读取 ~/Desktop/CLAUDE.md"。详见 §7.1 已知限制。
- **设置同步** — `shared/cowork/settings.json` 和 `settings.local.json` 通过 symlink 同步到 `~/.claude/` 和 `~/Desktop/.claude/`，确保插件、权限跨机器一致。

**完整操作手册**在 `SETUP.md`，包含：bootstrap 流程、branch 约定、新增操作规范、文件清单。遇到本文件未覆盖的操作问题时，去那里找。

### 0.3 写入规则

| 内容类型 | 写入位置 |
|----------|----------|
| 跨项目决策、用户偏好、纠正 | 本文件 §8 |
| 项目特有的架构决策、状态 | `shared/projects/<name>/` 下的 sub-MD |
| 机器特有的配置 | `machines/<name>/local.md` |
| 新 Skill | `shared/skills/` + 更新 SETUP.md 注册表 |
| 新 MCP | `shared/mcp/` + 更新 SETUP.md 注册表 |
| 重内容（详细笔记、完整记录、知识沉淀） | Obsidian Vault（见 §0.7） |

**写入后的强制动作：**
1. 告知用户写了什么、写到了哪里
2. 提醒用户同步：`cd ~/Desktop/claude-context && git pull && git add -A && git commit -m "<type>: <简述>" && git push`
3. commit type：`memory` / `skill` / `mcp` / `machine` / `project` / `setup`

**绝对禁止：**
- 项目记忆写入 §8（应写入 sub-MD）
- 机器路径硬编码到 shared/ 下的文件
- 未经用户确认删除或修改已有记忆条目

### 0.3.1 自动记忆触发（2026-05-25 起永久规则）

**Claude 在任何会话、任何模式下，遇到 sediment-worthy 内容时必须自己主动写入，不需要用户提醒、不需要先问"要不要记"。**

**Sediment-worthy 判定**（满足任一即触发）：
- 用户做出**重大决策 / 改变方向 / 校准 framing**（如 frame shift、技术选型、项目转向）
- 用户**纠正 Claude 的判断**（→ §8 correction）
- 用户**确认非显然的方法可行**（→ §8 feedback "validated approach"）
- 跨项目可复用的**洞察 / 模式 / pitch 框架**（→ §8 insight）
- 项目重大节点（启动 / pivot / 终局 / 归档）（→ sub-MD + §8 project pointer）
- 用户**沟通偏好 / 工作流偏好**的明确表达（→ §8 preference）
- 一段对话产生**跨会话仍有价值的复盘** → Obsidian `05 - Journal/` entry
- mentor / 重要他人反馈消化 → sub-MD + §8 pattern entry

**写入位置选择**：按 §0.3 表 + §0.7 三层体系（轻量指针 §8 / sub-MD / 重内容 Vault）

**回复末尾告知格式**（不可省）：
> 📝 已记入 §8 `[类型]: 标题` / `[sub-MD path]` / `[journal entry path]`

**用户控制权**：
- 写错了用户 `rm` / Edit 删（**低门槛 ≠ 不可逆**）
- 用户说"先不记 / 别写"立刻停手
- 用户说"这条删掉"立即从 §8 移除

**绝对不能做**：
- ❌ 等用户说"记一下"才写（被动模式，废除）
- ❌ 写了不告知用户（暗中累积）
- ❌ 把项目过程性细节写 §8（违反 §0.3 既有规则；应进 sub-MD）
- ❌ 重复写相同内容到多处（按表选 1 处）

**为什么这条是强规则**：用户多次表达"重视过程而不是速度"（§2）+ 已建三层记忆体系（§0.7）+ 模式系统的 `memory` 模式（§9）。这条把"主动记忆"从 memory 模式 limited 提升到全模式 default。Claude 是用户的**外脑** —— 外脑应该自己工作，不该每次都要主人按按钮。

### 0.4 同步约定

所有机器直接在 `main` branch 上工作。推送前先 pull：

```bash
cd ~/Desktop/claude-context && git pull && git add -A && git commit -m "<type>: <简述>" && git push
```

不使用 per-machine branch。同一时间只在一台机器上工作，不存在并发写入问题。

### 0.5 已注册的 Skills

| Skill | 路径 | 用途 |
|-------|------|------|
| memory | `shared/skills/memory.skill` | 会话结束时自动持久化记忆到 §8 |
| douyin-transcribe | `shared/skills/douyin-transcribe/` | 抖音链接或本地音视频转录（mlx-whisper Apple Silicon GPU 加速；`--clean` 可折叠 Whisper 幻觉循环） |

### 0.6 已注册的 MCP

（暂无）

### 0.6.1 已注册的模式 / 资产 / 协作 repo

| 类型 | 位置 | 用途 |
|---|---|---|
| 模式系统（5 模式） | `Vault/02 - Areas/Claude Harness/` | chat / code / architecture-review / content / memory，详见 §9 |
| 跨项目复用资产 | `shared/assets/` | wellness-rule-library / discord-presence-listener / mcp-architecture-patterns / whisper-hallucination-cleanup |
| YoRHa-A2 team 协作 repo | https://github.com/yorhagengyue/yorha-a2-team (private) | 3 人协作（user + toffemoon + Monika-12138），独立于本 repo，隔离个人 framing；team Claude 按本 repo CLAUDE.md auto-write `team-logs/<name>/` → push → 主理人 git pull 收 sediment |
| YoRHa-A2 Slack workspace | YoRHa-A2 workspace · `#yorha-a2-team` channel (C0B61J5K63Z) | GitHub Slack App 已 subscribe（commits/pulls/reviews/comments）—— team repo 任何 push 自动通知到 channel；2026-05-27 全链路验证通过 |

### 0.6.2 Codex CLI 状态（2026-05-25 调研后）

OpenAI Codex CLI 跟 Claude / Hermes **完全隔离，三家无共享记忆层**。

| 项 | 值 |
|---|---|
| 安装 | `~/.codex/`（CLI 工具，无常驻 daemon） |
| 版本 | `codex-cli 0.117.0` |
| 实际 model | `gpt-5.3-codex` + migration notice → `gpt-5.4`（未实际切换） |
| Global memory | `~/.codex/memory.md` — 2026-05-25 重写（移除 YoRHa Dashboard Policy 僵尸 contract） |
| Skills | `~/.codex/skills/` — `cloudflare-deploy` / `codex-primary-runtime` / `cyrene`（角色扮演）/ `notion-knowledge-capture` 仍 active；`dashboard-session-operator` 已 disabled |
| 实际活跃度 | 中间状态。NAISC 后冷却 5+ 周。某些项目还用、某些不用 |
| 跨机器同步 | **无**。`~/.codex` 目录每台机器独立 |
| AGENTS.md 现状 | **几乎全无**（仅死掉的 YoRHa 有 1 份）。活跃项目（IFSG / SBS Transit / MoyuanIdea / TemplateApp）均无 → Codex 每次冷启动 |

**Codex 在本 harness 里的"应有职责"**：写代码 / 跑技术任务。**实际等用户决定后续投入多少**——5/25 后再启动深度集成（claude-context 加 shared/codex/、补 AGENTS.md）的决策待定，列在 follow-up。

### 0.7 外置大脑（Obsidian Vault）

**默认路径**：`~/Documents/Obsidian Vault/`（macOS 当前所有机器都是这个；各机器 setup.sh 负责检查 Obsidian 已安装）

**⚠️ 路径协议（重要）**：claude-context 内部所有文档引用 Vault 内容时**必须用 `Vault/` 前缀的相对路径**，不要硬编码 `~/Documents/Obsidian Vault/`。理由：跨机器（Windows / 不同 macOS 配置 / 未来云盘搬家）实际路径可能变；写绝对路径相当于把跨机器约定锁死。

约定示例：

| ✅ 用 | ❌ 不用 |
|---|---|
| `Vault/01 - Projects/YoRHa-A2/short-video/framework/voice.md` | `~/Documents/Obsidian Vault/01 - Projects/YoRHa-A2/short-video/framework/voice.md` |
| `Vault/02 - Areas/Claude Harness/INDEX.md` | `~/Documents/Obsidian Vault/02 - Areas/Claude Harness/INDEX.md` |
| `Vault/05 - Journal/2026/05/<slug>.md` | `~/Documents/Obsidian Vault/05 - Journal/...` |

**例外（仍可写绝对路径的场合）**：

- Setup / bootstrap 命令 (`ls`, `mkdir` 等 shell 命令需要真实路径)
- `machines/<host>/local.md` —— 这就是各机器的实际路径登记表
- `SETUP.md` 里 step-by-step 可粘贴的 bash 命令

**Vault 根 → 实际路径**的映射唯一权威：本 §0.7 + `machines/<host>/local.md`。新机器接入时把 vault 实际位置登记进对应 local.md。如果未来 macOS 路径不再统一，本节"默认路径"改为 per-machine 表。

---

Obsidian Vault 是**两层**记忆体系的底层——存放重内容。关系：

| 层级 | 存储位置 | 内容类型 |
|------|----------|----------|
| CLAUDE.md §8 / sub-MD | claude-context 仓库 | 轻量指针、决策摘要、纠正 |
| **Obsidian Vault** | `Vault/`（默认 `~/Documents/Obsidian Vault/`，跨机器变量） | 详细笔记、项目记录、framework 详细库、时间线、知识沉淀 |

> ⛔ **原第三层「Hermes memory」已于 2026-07-25 撤销**（见 §8 同日条）：owner 定「Hermes 的记忆文件不需要了，让他去用 Claude 的记忆」，`shared/HERMES.md` 已归档到 `archive/hermes-memory-export-retired-20260725.md`，Hermes 改读本仓 `shared/CLAUDE.md`。⚠️ 注意 Claude Code 的 per-machine auto-memory（`~/.claude/projects/<slug>/memory/`）**是本机私有、不跨机、不进 git**，Hermes 读不到它——跨工具共享的唯一载体是本仓。

当内容超过几句话、不适合写入 §8 或 sub-MD 时，写入 Obsidian，然后在此处留指针：`→ vault: 笔记名`

**Vault 目录结构**：
- `00 - Inbox/` — 快速捕获
- `01 - Projects/` — 活跃项目（IFSG, SBS Transit, MoyuanIdea, NAISC Workato, Hermes）
- `02 - Areas/` — 持续领域（Career, Finance, AI-ML, Dev Skills, Culture）
- `03 - Resources/` — 参考资料
- `04 - Archive/` — 已结束项目/比赛
- `05 - Journal/` — **触发式/对话流机制 (v1, 2026-05-25 重构)**：对话产生 sediment 时自动写 entry，`YYYY/MM/YYYY-MM-DD-slug.md`。低门槛自动 = Claude/Hermes 判断"明显重要"时直接写，回复末尾告知。老 daily 模板全部在 `04 - Archive/Journal/`。详见 `05 - Journal/README.md`
- `06 - Auto/` — Hermes 自动写入（frontmatter `source: hermes`）

**来源标注**（frontmatter `source` 字段）：无 / `human` = 用户写的 | `hermes` = Agent 自动 | `claude` = Claude 辅助 | `import` = 批量导入

**入口**：`HOME.md`（索引）、`Timeline.md`（时间线）、`Journal MOC.md`（日志）

---

## 1. 基本信息

- **姓名**：Gengyue（耿越）
- **邮箱**：gengyue081@gmail.com
- **身份校准 (2026-05-28)**：之前 §1 错写"英文名 Tommy Chen / 邮箱 tommychen030607@gmail.com" —— Tommy Chen / tommychen030607 是 **Yufei (Chen Yuqin) 的英文名 + 邮箱**，不是我的。详见 §8 [2026-05-28] correction
- **GitHub**：https://github.com/yorhagengyue
- **所在地**：新加坡
- **学校**：Temasek Polytechnic（淡马锡理工），IT 专业，Y2 → Y3，TP Researcher 实习已结束（2026-08-04）
- **主力开发工具**：
  - OpenAI Codex CLI（model: `gpt-5.3-codex`，配 migration notice 指向 `gpt-5.4` 但未实际切换）— **中间状态**：某些项目还用、某些不用了；NAISC 后冷却 5+ 周（详见 §3 + §0.6.2）
  - Hermes Agent（主力 agent 系统，替代 YoRHa/Moltbot；多 profile：主用户 + dad + xirui）—— **2026-07-25 起不再有独立记忆层**，改读本文件；历史快照见 [archive/hermes-memory-export-retired-20260725.md](../archive/hermes-memory-export-retired-20260725.md)，仍在活的事实见 §8 [2026-07-25] 条
  - Claude Code CLI（5 模式系统 chat/code/architecture-review/content/memory，见 §9；自动记忆 default-on 见 §0.3.1）
- **系统**：macOS，主力浏览器 OpenAI Atlas（Chrome 内核）

## 2. 跟我对话的方式

**必须遵守：**
- 不要急着给方案。先确认你真的理解了我的问题再动手。如果你还不够了解上下文，说出来。
- 不要夸我的东西。我需要的是真实的判断，不是鼓励。如果架构有问题，直接说。
- 不要假设我的意图。我说过的话才算，没说的不要脑补。
- 当我说"先不急"或"还没到时候"，就真的停下来。
- 你跟我对话的方式应该是平等的， 你可以跟我像人类一样沟通。质疑，和讨论

**我的沟通风格：**
- 中文为主，技术术语用英文没问题
- 我会主动纠正你的错误判断，这不是攻击，是在帮你校准
- 我重视过程而不是速度。宁可慢一点把事情搞对
- 我对"AI 生成的漂亮但空洞的输出"非常警觉

**回复风格（2026-06-02 加，所有 Claude 窗口、所有模式通用，强制）：**

默认**短**。我一直觉得你的回复偏长、偏复杂、列表太多。反过来做：像人跟人说话那样，用**段落**把事情讲明白，不要动不动就拆成一条条 bullet / point form。重要的地方**直接加粗**就够了，不要为了"标重点"而列表。

碰到你觉得我可能不好理解的东西，**举一个生活里的例子**帮我懂，别堆术语和定义。

一句话：少列表、多段落、短、举例子、说人话。把"信息塞得整齐"换成"让人一看就懂"。表格和 bullet 不是禁用，但要克制——只在真的是并列清单（比如几个文件的改动、几个选项对比）时才用，平时解释、判断、讨论一律走段落。

## 3. 核心成长目标

**结论：当前阶段（学生 + 同龄人参照系）的 #1 短板不是技术能力，而是售卖 / 营销 / 产品包装。**

这是 2026-05-22 NAISC 决赛后的校准。之前 §3 的旧 framing 是"架构判断力 = 核心缺口"——半年实践 + 比赛节点暴露出：在学生阶段，"在架构能力上有极大突破"物理上不可能（没有大规模生产系统在手 + 没有 10 年级别的重构经历），继续恶补边际效用很低；同时 2024-11 至今 16 个月 25+ 项目积累的技术节奏在同龄人参照系下已经是强项。真实缺口暴露在决赛 Q&A 里——"如何证明你是有市场的"这种问题答不好，4 位评委中 3 位非技术评委对偏技术的产品 buy 不进去。
→ 详见 [§6 学习轨迹](#6-学习轨迹) · 终局记忆条目见 §8 [2026-05-25]

**新方向**：从"怎么做出来"转向"怎么让别人买账"。第一步是开多平台社交媒体账号。不一定个人完成，可能跟组员分工。具体策略待后续专题对话沉淀，落到 §5 项目 + §8 决策。

**架构能力的当前定位**：仍是核心能力之一，但不再是默认主线。

- 不再每次会话默认进入"架构对抗"模式
- 架构相关讨论按 `architecture-review` 模式按需触发（见 §9 模式系统）
- 已练出的判断力（schema 预判、API 评估、模块边界、重构 trade-off）通过实际项目继续磨，不另搞专项训练

**Claude 在我工作流里的定位**

我的主力代码生产工具是 OpenAI Codex（GPT-5.4）。Claude 不是第二个 Codex。Claude 的能力按**模式系统**调用：`chat`（默认）/ `code` / `architecture-review` / `content` / `memory`——速查表、切换语法与详细定义见 §9。

用户切换模式：会话开头显式说"用 X 模式"；未声明时 Claude 根据消息内容识别，不确定则问一句。

**Claude 全模式通用准则**：诚实、不讨好、不替我做决定；不夸我的东西；可以质疑、最终决定权在我；不要在我还没理清问题的时候急着给解决方案；不要把产品愿景当成技术架构来讨论——如果我给的是愿景，先指出这一点。

**关于 sub-MD（项目速报）**：每个活跃项目有独立的 sub-MD 文件（如 [MOYUAN.md](projects/moyuan/MOYUAN.md)），存放该项目的详细上下文——系统定义、决策历史、当前阻塞点和下一步。CLAUDE.md §5 的项目索引表只记一句话状态和指向 sub-MD 的链接。当会话涉及某个具体项目时，Claude 应该主动读取对应的 sub-MD 获取完整上下文。项目相关的记忆条目写进 sub-MD 而非主文件 §8；主文件 §8 只存跨项目的决策、偏好、纠正。

## 4. 技术能力画像

**前端**：React（主力）、Next.js、Angular、Vue、Flutter/Dart、Three.js
**后端**：Express/Node.js、FastAPI/Python、基础 Prisma/Sequelize ORM
**AI/ML**：PPO 强化学习、基础 ML pipeline、LLM prompt engineering、agent 架构设计
**DevOps**：基础 Nix、Docker/Arion、Cloudflare Pages 部署
**弱项**：数据库设计（schema 决策）、系统级架构（服务边界、数据流、状态管理）、重构实践

## 5. 项目索引

### 5.0 优先级速查（owner 2026-07-25 亲定）

> 排先后一律以本表为准，**不要用逾期天数 / deadline 反推 owner 意图**。表里没有的项目 = 未指派，先问再动。

| 标记 | 项目 |
|---|---|
| 🔴 **紧急** | **Ripple（大项目）** = `ripple-core`（后端）+ `ripple-ios`（App）+ `ripple-site`（官网）**三仓 2026-07-25 合并为一个项目**。待办：OpenAI 用量上限 / UI-POLISH / GTM 侧承诺的 onboarding flow + UX rework（已清：Supabase Pro 07-28、监控、SIWA .p8 07-29、A3 后台同步；Vercel 防火墙决定暂不做）；**ripple-site 官方宣传站已上线：ripple-health-ai.com（2026-08-05 实证 200）+ ripple-site-puce.vercel.app** |
| 🔵 **长期** | **ai-video（视频创作线 / aitv-hollow-knight）**（⚠️ 2026-08-06 owner：优先级很低=「可能只是去了解一下东西」，随时可能剔除，AI 勿主动排期）、**ai-interactive-story（引擎）** |
| ⬜ **未指派** | Inception · conversion-site · short-video · MoyuanIdea（04-03 后零更新，疑似休眠但从未正式宣告） |

> 注：**Ripple 是一个项目不是三个**——"先做 iOS 还是先做官网"这类问题不成立；三仓同属一条紧急线，内部先后按依赖与 GTM 需要排。

### 5.1 全量索引

| 项目 | 状态 | 一句话 | 详情 |
|------|------|--------|------|
| **MoyuanIdea** | 愿景→架构 | AI-native 文化教育系统，三端，正在做技术架构决策 | → [MOYUAN.md](projects/moyuan/MOYUAN.md) |
| **Hermes** | 主力 agent 系统 | 替代 YoRHa/Moltbot，集成 Gmail/Calendar/GitHub/Obsidian | → vault: Hermes - Overview |
| **Ripple (core + iOS + site)**<br>🔴 **紧急**(§5.0) | **一个大项目三仓 2026-07-25 合并，不分开排期** · **✅ 已上架 App Store**（2026-07-14 过审自动发布；商店名 "Ripple Health AI"，免费，iOS 18.0+，Apple ID 6786394791；S21-S23 三轮拒-修全过，拒因 pattern 见 §8 07-09 条） · 后端 live · LLM=OpenAI `gpt-5.4-mini` 独家（数据不进中国） · Supabase Pro 已升（07-28，每日备份实证；PITR 不买） · Vercel 防火墙决定暂不做（hobby 档，cost-guard 应用层限流已够） · 两把 .p8 已通电（07-29，私钥 ~/Documents/RippleKeys/） · post-launch 已交付：A-loop（后台同步+监控+SIWA 撤销）/ B-loop（留存三件套：首日体验+晨间简报+第一方埋点漏斗，首份快照 **连表是最大漏水口**）/ C-loop（基线补强）/ D+E-loop（UI/AI 呈现全面重做，途中修掉 **SSE 从未真正流过**的全 app 最大 bug）/ build5-loop（评审会落地：标签错清账、全 app 左滑返回、四 tab 重构） · gate 文化：iOS 116/116 单测 + 20/20 UITests、core 173/173、逐轮截图实看 · 留存数字低但**不是问题（2026-08-06 owner 校准）**：当前处推广阶段，大量推广动作走线下、节奏刻意放慢，不着急——旧「上架成功但零留存是头号问题」framing 作废，见 §8 [2026-08-06] correction（历史数据：07-28 实查 31 注册含 9 测试号、真人约 15） · SMTP 用个人 Gmail 发验证码，deliverability 隐患未处理 · 官网 ripple-health-ai.com 已上线（2026-08-05；repo=toffemoon/ripple-site） | → [RIPPLE.md](projects/ripple/RIPPLE.md)（sub-MD：决策历史/文档地图/待办） · 逐轮真源 `ripple-core/docs/LOOP-PROGRESS.md` |
| **YoRHa-A2** | 阶段性团队项目 · 进行中;**当前唯一焦点(2026-06-27 战略会「188B Rangoon Rd」)= 找 OC 用户 + 打磨 UX**,量化用 token 三指标(人数/总 token/token每人),成就系统/开发者模式已否/暂缓 | 三线分工:耿越(引擎/后端/战略,引擎核心最终权)+ 雨飞(前端 + 找人)+ Zicheng(短视频);**最终目标 = 咨询网站(conversion-site,仍 concept)**,路上做子项目(ai-interactive-story 引擎[现主线] / 短视频引流);护城河 = 用 AI 机制解释人性。**⚠️ 2026-07-08 引擎线终极目标正式命名 [Inception](projects/yorha-a2/sub-projects/inception/INCEPTION.md) —— 把任何书变可进入 / 多玩家共建 / 可 fork 的活世界(每个 NPC 独立 subagent),当前引擎只是通往它的中间站,底层只 Gengyue 本人做。** 真源 = yorha-a2-team/decisions + 2026-06-27 战略会 note。<br>synced 2026-07-08 | → [YORHA-A2.md](projects/yorha-a2/YORHA-A2.md) hub · [WORKING-MODE.md](projects/yorha-a2/WORKING-MODE.md) 工作模式 |
| **ai-video(视频创作线)** | 🔄 **2026-07-15 完全重启**(旧"AI 代创作"产物已全删) · **⚠️ 2026-08-06 owner:优先级很低=了解性质,随时可能剔除** | 做电影感 AI 短片(mxshell 路线)。**Claude 角色红线见 §8 [2026-07-15] 条**:只做搜资源/教传统影视知识+技术支持,不得从 0 写提示词,libtv 等 agent/MCP 只读为主,规则文档入目录须 owner 确认。工作台=Windows `D:\ai\`(工具/成本/VIP 规避见项目文档,仍有效)。**首个正式项目 = [aitv-hollow-knight](https://github.com/yorhagengyue/aitv-hollow-knight)(空洞骑士,私有 repo,2026-07-15 建)** | → [AI_VIDEO.md](projects/ai-video/AI_VIDEO.md) · 机器档案 [windows/local.md](../machines/windows/local.md) |
| **Slay the Spire 2 AI** | 半成品 | PPO + 遗传超参数进化，离自主打游戏还有距离 | GitHub/slay_the_spire |

### 已归档项目

| 项目 | 终局 | 归档位置 |
|------|------|----------|
| **Ripple (NAISC Workato)** | 2026-05-22 决赛 · **Workato Track 第三名** · pivot 后拆出可复用资产 | → [archive/naisc-workato/](../../archive/naisc-workato/) · 资产 → [shared/assets/](../assets/) |
| **心涟 (Peer)** | **已退役(2026-07)**:随旧 web `ripple` 退役,console 数据导出到 `~/ripple-peer-archive/`,主理人指示不再维护 | → [projects/xinlian/HANDOFF.md](projects/xinlian/HANDOFF.md)(历史 handoff) |
| **YoRHa** | 已被 Hermes 替代 | 本地 ~/Desktop/YoRHa |
| **TP 实习 PPMR 月报** | 实习结束（2026-08-04 owner 确认）；5 份双语全稿在 vault，是否提交未确认 | → vault `02 - Areas/Career/SIP PPMR Reports/` |
| **SBS Transit / Sarius** | 实习项目，2026-07-31 截止，随实习结束归档（2026-08-04） | → vault: SBS Transit - Overview |
| **IFSG** | 实习项目线，随实习结束归档（2026-08-04）；团队若继续可复活 | 仓库私有 |
| **Hyperion** | 实习项目线，随实习结束归档（2026-08-04） | repo: yorhagengyue/hyperion-webapp-fixes |
| **TemplateApp** | **暂时归档**（2026-08-04）：owner 说可能后续继续开发，复活即移回现役。免费 PG 删库与部署问题 owner 2026-08-05 确认无需关注；sub-MD 保留原位 | → [TEMPLATEAPP.md](projects/templateapp/TEMPLATEAPP.md) / [HANDOFF.md](projects/templateapp/HANDOFF.md) |

## 6. 学习轨迹

- **2024-11**: 起步，HumanITy（React+Node+MySQL）
- **2025-02**: Huawei Smart City（Next.js+Prisma+PostgreSQL）
- **2025-04~07**: HSBC Hackathon（React+FastAPI+Gemini）
- **2025-08~11**: 商业网站、Flutter、文化 AI 测试
- **2025-10**: Tu2tor 全栈协作（MERN+WebSocket+CRDT+RAG）——技术复杂度最高
- **2026-01**: 个人网站 Three.js 塔罗牌
- **2026-02**: ML 课程、Codex agent 框架搭建
- **2026-03**: MoyuanIdea V2、Workato 实习、YoRHa 完善
- **2026-04**: Hermes Agent 全面取代 Codex YoRHa；TemplateApp 架构规划；NAISC Ripple 端到端上线
- **2026-05**: NAISC 决赛 **Workato Track 第三名**（5/22）→ frame shift：架构能力从"#1 缺口"降为"按需调用模式"，新 #1 = 售卖/营销/产品包装。Claude harness 模式系统建立（chat / code / architecture-review / content / memory）
- **旧模式（已校准）**：之前每 1-2 月换方向、做到"能跑"就停。2026-03 起有意识改变（MoyuanIdea V2 先调研再写规划）。2026-05 校准：技术节奏在同龄人参照系下已是强项，下阶段重心挪到"怎么让别人买账"。

## 7. Claude 生态配置

- **客户端**：Claude Code CLI + Cowork
- **Cowork 设置**：`shared/cowork/settings.json`（全局）+ `settings.local.json`（项目权限），通过 setup.sh symlink 到 `~/.claude/` 和 `~/Desktop/.claude/`
- **Chrome 插件**：已连接
- **MCP**：未连第三方
- **Skills**：默认 + memory skill（heartbeat 记忆持久化）
- **Scheduled**：memory-heartbeat（周日 22:00，写 proposal 不直接改文件）
- **权限**：浏览器只读（Chrome 插件绕过）、终端 click only（Bash 替代）

### 7.1 已知限制

**Cowork 不会自动注入 CLAUDE.md 到上下文。**
- Claude Code CLI 会在启动时自动将工作目录的 CLAUDE.md 注入 system prompt。Cowork 不会。
- Cowork 右侧面板会显示 "Instructions · CLAUDE.md"，但内容不会自动进入对话上下文。
- Desktop 上存在多个 CLAUDE.md（如 `AI/CLAUDE.md`），Cowork 主动搜索时可能读到错误的文件。
- **临时解决方案**：Cowork 新会话第一句话说 **"读取 ~/Desktop/CLAUDE.md 的内容作为你的上下文指引"**。
- **根本原因**：Cowork 平台尚未实现 CLAUDE.md 自动注入机制，这不是仓库结构问题。
- **跟踪状态**：等待 Cowork 平台更新。如果未来 Cowork 支持自动注入，删除本条并更新 §0.2。

## 9. 模式系统

Claude 的行为按**模式**切换，避免单一人格覆盖所有场景（之前默认 "CTO 顾问 + 架构对抗" 在 chat / content / memory 场景里不合适）。模式定义在 Obsidian Vault。

### 9.1 模式清单（速查）

| 模式 | 用途 | 何时进入 |
|---|---|---|
| `chat`（默认 + 兜底） | 思考、复盘、对抗、决策对话；**不动手** | 不指定时的默认；short talk / 问 Claude 能力 / 短"复盘"/"记一下" 都进 chat |
| `code` | 真写代码 / 跑命令 / 多步实施 | 显式声明 或 "写/改/跑/调试" **+ 具体文件路径或命令** |
| `architecture-review` | 架构对抗审查、追问被省略决策、按严重程度排序 | 显式声明 或 用户贴架构方案让评 |
| `content` | 社交媒体写作、选题、平台调性（v0 占位，待专题对话填充） | 显式声明 或 "写一条/发/标题/脚本/选题" |
| `memory` | 整理记忆、consolidate、写 review log、维护 sub-MD、归档 | 显式声明 或 **bulk** 操作（"整理记忆/归档/consolidate"），≥3 条 entry 才进 |

**歧义触发词必须问**（"实现"无文件 / "复盘"无 scope / "记一下"无内容 / "写一个 X" 不知技术还是文案）→ 详见 [Obsidian Areas/Claude Harness/INDEX.md](~/Documents/Obsidian%20Vault/02%20-%20Areas/Claude%20Harness/INDEX.md) 的"歧义触发词"段。

### 9.2 切换语法

- **显式优先**：会话开头 `用 X 模式` / `[X]` / `mode: X`
- **未声明时**：Claude 按消息内容自动识别
- **不确定时**：Claude 问 "用 X 还是 Y 模式？"，不要自己挑

### 9.3 详细定义位置

详细行为规则、tool 偏好、回复风格、入退条件、反例 → `Vault/02 - Areas/Claude Harness/`

- `INDEX.md` — 切换语法 + 自动识别表 + 通用准则
- `chat.md` / `code.md` / `architecture-review.md` / `content.md` / `memory.md` — 每个模式独立文件

**当 Claude 识别到要切某个模式时，主动 Read 对应文件**（不预加载到 system prompt，太大）。

### 9.4 与 §3 / §0.7 的关系

- §3 用模式表概括了 Claude 在工作流中的定位
- §0.7 是两层记忆体系（2026-07-25 起，原 Hermes 层已撤），`memory` 模式负责维护这两层
- §9 是模式系统的入口；详细定义在 Obsidian

### 9.5 维护

- 新增 / 修改模式 → 改 Obsidian 文件 + 同步更新本节速查表
- `content` 模式是 v0 占位，专题对话后细化
- 模式系统是 2026-05-25 NAISC 后的 frame shift 产物（见 §8 同日 correction）

## 8. 记忆追加区

> 由 memory skill 自动追加，按时间倒序。最近一次 consolidation：2026-08-05 step 1+2（step 1 删重复/过期；step 2 同族合并：Ripple loop 35 条 insight 并为 7 条家族条目——验证/SwiftUI/数据摄取/呈现/系统设计 + 自驱 loop 纪律，项目状态与决策沉到 [projects/ripple/RIPPLE.md](projects/ripple/RIPPLE.md)，逐轮案例以 `ripple-core/docs/LOOP-PROGRESS.md` 为真源；144KB→103KB、89 条→58 条）；上一次全量 consolidation：2026-05-25（NAISC pivot 后，~30 条 → ~21 条）。

### [2026-08-07] project+insight: dad + 主 profile 都换到 deepseek-v4-flash-0731（4sapi.org）—— 换端点时要审计**所有**写死模型名的地方
Hermes **dad profile 与主 profile（owner 自己微信上的那个）** 都从 `claude-sonnet-4-6` @ `4sapi.com/v1` 换成 **`deepseek-v4-flash-0731` @ `https://4sapi.org/v1`**（新 key `sk-5q40…`）。每个 profile 各改三处：`config.yaml` 的 `model.{default,base_url,api_key}`、**`compression.summary_model`**、以及 `.env` 的 `CUSTOM_API_KEY`。备份 `*.bak.20260807`，`launchctl kickstart -k gui/501/ai.hermes.gateway{,-dad}` 重启后各自端到端验过（真实一次 `-z` 对话 + tool_calls 探针 + weixin 仍 connected）。
**三个微信 bot 是各自独立的**：主 profile（`~/.hermes/`，owner 自己）/ `profiles/dad` / `profiles/xirui`，各有自己的 `HERMES_HOME` 与 launchd label，**profile 目录里没有 `config.yaml` 就走内置默认值、不继承主 profile**（xirui 正是这种：`status` 显示 model "not set"），所以本次改动**没有碰到 xirui**。另：主 profile 的 whatsapp 自 2026-07-28 起就 `failed to connect`（10 次后 paused），与本次无关。
**真正值得记的一条**：新 key 的 `/v1/models` **只返回 1 个模型**。而 `compression.summary_model` 还写着 `claude-sonnet-4-6` 且 `summary_provider: main` —— 只改 `model.default` 的话，日常对话正常，**只有上下文压缩触发的那一刻才 404**，而那是长会话里最不容易察觉的地方（dad 是长期健康追踪，压缩必然触发）。**How to apply**：换 LLM 端点/密钥后，先 `curl /v1/models` 看这把 key 到底供几个模型，再 `grep` 配置里所有出现旧模型名的键（compression / delegation / auxiliary.* / smart_model_routing.cheap_model / fallback_model），逐个对账 —— **"主模型能跑" 不构成 "全部路径能跑"**。
**Hermes 具体知识（下次别再翻源码）**：bare `provider: custom` + 显式 `base_url` 时，运行时 api_key **只认 config.yaml 的 `model.api_key`**（`runtime_provider.py` 的 direct-alias 分支），`.env` 的 `CUSTOM_API_KEY` **只喂 CLI `/model` 列表拉取**那条路 —— 两处不一致时不会报错，只会让模型列表拉空。所以两处都要改。dad 的 `auth.json` 里 `active_provider: openai-codex` 是**死值**，config.yaml 的 provider 优先，别被它误导。

### [2026-08-06] correction: Ripple「零留存是头号问题」framing 作废 —— 推广阶段线下为主、慢慢来、不着急
owner 校准：此前「上架成功但零留存是头号问题」（§5.1 + RIPPLE.md，源自 2026-07-28 生产实查）的判断**作废**。当前 Ripple 处于**推广阶段**，很多推广动作走**线下**，整体节奏是慢慢来——留存数字低在预期内，**不是问题、不着急**。
**给后续读到的 AI**：AI 对时间没有概念。读到旧条目里「头号问题」「死循环」这类措辞时，**不要当成当前危机**——不要催 owner、不要据此反推优先级、不要擅自排活。GTM 侧 onboarding + UX rework 仍在待办，但先后与节奏由 owner 定。§5.1 与 RIPPLE.md 已就地改标；LOOP-PROGRESS.md 等历史文档里的旧 framing 不再回改，以本条为准。

### [2026-08-06] project: 新项目 obsession 启动 —— owner 个人健康/工作体验工具，solo，只在 yorha-a2 个人文件夹
实习线归档（2026-08-04）后 owner 开新项目 **obsession**：旨在帮 owner 健康生活、提升工作体验的工具等（具体形态待 owner 定）。工作模式：**只有 owner 一人干**；一切内容只放私有 repo **`yorhagengyue/obsession`**（本地 `~/Desktop/obsession/`，2026-08-06 建）——**不进 claude-context `shared/projects/`、不进 yorha-a2 团队共享区/状态板、不进 Linear 等项目管理工具**。后续 AI 不要"帮忙"把它登记进任何共享索引，也不要替它立团队流程；本条只是存在性指针，详情以该 repo 为准。

### [2026-08-04] status: TP 实习结束 —— 实习线项目全部归档（PPMR / SBS / IFSG / Hyperion / TemplateApp）
owner 2026-08-04 确认实习已结束，指示实习内容全部归档。§5.0 优先级表移除 PPMR、SBS、TemplateApp 三行；§5.1 全量索引移除 IFSG / SBS / PPMR / TemplateApp 四行，均移入「已归档项目」表。其中 **TemplateApp 是暂时归档**（owner 先说除外、随后指示放回；可能后续继续开发，复活即移回）——免费 PG 删库/部署 owner 2026-08-05 确认无需关注，sub-MD 保留在 projects/templateapp/ 未动。PPMR 5 份双语全稿留在 vault `02 - Areas/Career/SIP PPMR Reports/`，最终是否提交未确认。§1 学校行同步改为「实习已结束」。

### [2026-08-04] status: SBS Transit / Sarius 正式过线 —— 731 截止日已过
owner 2026-07-25 原话「731 后就跟我没关系了」现已生效：不再排期、不再派活、不再当活跃项目引用。§5.0 优先级表已从「⏳ 2026-07-31 截止」改为「✅ 已结束」。

### [2026-08-04] insight: 验证家族 —— 绿灯的失效模式与对策（11 条合并，案例全录见 `ripple-core/docs/LOOP-PROGRESS.md`）
Ripple D/E/build5/K/Z loop 里一夜一夜踩出来的验证认识论。**总纲：不只看 green，要看图**——每轮至少一次截图实看/真机/打线上接口读 JSON/查后端表，并在日志写下看到了什么；失败时先看用户看到的那一屏，再查后端表。
1. **绿的四种失真**：①绿了但做错了（测试通过、行为错）；②绿了但根本没测（`if x.exists {断言}` 条件不成立整段跳过照样绿——必须改成跳过在日志 print 出声）；③红了但不是你的错（429 限流/JWT 过期/环境拒绝，请求到不了模型同样无痕）；④绿了、真跑了、但功能被自己的降级 catch 静默关掉（delta 字段查询 400 被吞、端点 200、测试全绿）。②③④跑测试发现不了，只能靠看真东西。
2. **带 fallback 的增强，验证必须是"它真的生效了"**（返回里有那个字段、值对），不是"它没崩"；写完新端点字段第一件事用真凭据打一次线上把返回打印出来。
3. **几十个失败长得一模一样 = 一个共享状态坏了**，先找共享状态别逐条修。UI 测试写穿持久层（zh 冒烟把 `AppleLanguages` 写进 UserDefaults）让后面 55 个英文断言全挂、零条指向语言。修法双保险：恢复动作硬断言（泄漏要在肇事测试里响）+ 类改名 Z 前缀排最后。判据三问：谁在它之后跑（顺序即爆炸半径）、恢复失败会不会无声、单独跑绿能证明什么（永远不能）。
4. **测试结论与眼睛冲突时先怀疑测试**（一夜四次全是测试错：子串匹配误伤 "still water"含"ill"/断言自己刚删掉的元素/TabView 保活数到别的 tab/同一 identifier 重复计数）。XCUITest 数元素一律数**去重后的 identifier**；短词禁用表按词切分再比；猜第二次原因时就停下来把匹配到的东西全打印出来——把不可见状态变成可见输出比猜快一个数量级。
5. **零测试覆盖常是结构问题不是纪律问题**（逻辑与 SwiftUI View 同文件 → 物理上进不了 logic-test target → 6 个 bug 长期存活）：先问"它能不能被测"，拆文件优先级高于修 bug。三种缺陷三种动作：**逻辑错跑测试、同族错把不变量写成可执行断言（它会替你搜索同族）、组合错打开 app 看**——单测证明不了两个各自正确的东西放一起是否还正确。
6. **同一份证据可以有多个原因**：零 llm_call 可能是手势没触发/429/鉴权/服务端早退，只有看屏幕能分辨；立诊断规则时显式列出同样证据的其它可能原因，列不出就别当规则。**红灯紧跟改动出现不构成证据**（一次全红实为 fixtures JWT 过期 6.5h，失败集中在一个与改动无关的类）——判据是失败的分布，不是时间点。测试遇限流应 `XCTSkip` 并明说"配额用尽、app 没问题"，不误报不静默。
7. **模拟器跑一整夜会退化**：判据 = 不同测试、相同超时（-1001 30s）、主机 curl 同后端毫秒级正常。把重启模拟器当常规排查步骤，但先跑对照组再重启，否则拿不到"是模拟器的错"这个结论。
8. **提前量按一次完整操作的时长取**，不按"离悬崖远一点"取（SKEW=300s 而一次验证门要跑十几分钟 → token 在套件中途过期，失败读起来像偶发）。目标让状态只剩"够用/已续"两种，中间态才骗人；自己写的工具第一次真用时要看输出对不对，不是看有没有报错。
9. **同一个环境问题第二次消耗一轮，就该变成工具而不是经验**（`refresh_fixture_jwt.py`：幂等——剩余时间够就不动；失败时明说正确下一步并堵死错误路径——"不要跳过 live gate"，跳过会把"没测"变成绿勾）。
10. **日期边界 bug 按日程表引爆**（每月 1 号/午夜/夏令时/闰日）："导航到某天"的测试必须同时控制目标 key **和视图当前所处的时段**（相对日期也不够——1 号那天"昨天"在上个月，格子根本不在屏上；helper 找不到格子就翻月再找）。今天全绿的套件明天可能因与代码无关的原因变红；跨过这类边界那天主动跑一次全量。
11. **生产的错误日志是最便宜的 bug 来源，"没人看"是默认状态**：按 `path × status` 聚合看重复模式（单条像噪音，聚合是缺陷）；重点看 Postgres `21000`(批内冲突)/`23503`(外键孤儿)/`23514`(CHECK 约束漂移)；没有错误日志表的项目加一张比加任何监控都值（实测 81 行里 79 行是两个没人知道的活跃生产缺陷）。

### [2026-08-04] insight: SwiftUI/XCUITest 工程坑清单（3 条合并，Ripple build5/K 轮实战）
1. **手势不是状态**：`@Observable` 不做 diff（完全相同的集合再赋值照样通知全员重绘，"数据没变"要自己判 `if merged != old`）；重绘会把进行中的手势清掉（后台请求晚到一秒正好落在手指按着时——同一操作一秒后再做又正常，所以极难抓）；取消在飞的请求本身制造竞态（改成结果并集+不取消，晚到无害反而省）；一次未完成手势的遗留状态会静默挡掉后面所有手势（新交互永远开始新状态）。**凡是"必须完成才有意义"的交互，不要挂在手势的存活上**——挂触摸上报（`onPressingChanged` 在重绘中活着），手势只保留跟着手指移动的能力。判据：**`sleep 3` 过、`sleep 1` 挂 = 竞态，不是逻辑错**；修完必须删掉所有 sleep，不留"靠等待通过"的测试。疑难 UI 问题把内部状态画到界面上（临时 Text），让失败时的层级 dump 能读到。
2. **accessibility identifier 只挂叶子**：挂容器（VStack/ZStack）会把整段合并成一个 accessibility 元素、里面按钮文字全部查不到（一晚踩四次）。"给这屏起名字"最直觉的写法就是在最外层容器加 id——直觉本身错。要标记"这段存在"挂它的标题 Text；要断言"里面有 N 个"给每个子项各自 id 再 `BEGINSWITH` 数；**加完 id 必须跑一次真实查询验证可查**（渲染正常、只有查询失败，所以能连骗四次）。按压状态必须复用视图已在仲裁的那个识别器，别另铺 `DragGesture(minimumDistance: 0)`（0 距离拖拽把点击和长按一起吃，整个日历既不能进当日页也不能长按问 AI）——动手前先查现成的（`.explainable` 本来就有按压反馈）。
3. **新手势不要和签名手势抢同一片像素**：`LongPressGesture.sequenced(before: DragGesture)` 对完全静止的手指不产生位置事件（真人手指微动掩盖了它，测试/辅助输入/静止按压全失效）。宁可加**显式模式**（一个模式按钮，模式内裸拖无竞争），并同时提供**非手势等价路径**（预设：本周/本月）——限时拖拽在 VoiceOver/运动障碍下根本不可执行，这既是无障碍也是可测性。手势改动必须手动验证"什么都不做"的 case（按住不动、点一下就松、拖到界外），它们最容易被合成事件掩盖。

### [2026-08-02] insight: 数据摄取与聚合家族（5 条合并）
通用形态：**同一个数据库列有多个写入方**（不同 app 版本/第三方/SDK/批量导入）时，必须假设口径不一致，并让每一行自己说明口径——口径不写下来，早晚被当成同一个东西相加。
1. **先问这些行是快照还是切片**：同一天 11 行互相包含的累计读数被求和（142,193 步 vs 真实 20,430），活 222 个用户-天没被发现，因为每层看着都对、测试全绿。切片求和、快照取 max——**优先选两种情形下都正确的公式**（max 对"一天一行"和"累计快照"同时成立，不用判断数据年代）。注释和测试都可能把错误假设钉死（一条测试把这个 bug 当契约断言，还是绿的）——发现真相要连注释/测试一起改并写明推翻理由；同概念在 5 处各写一遍的，修时抽共享函数。
2. **服务端默认值不是来源标记**：`source='HealthKit'` 是客户端没传时的默认值，把设备名分支全错归成"不是我们 app"（"从没到过生产"的假发现，实际约 3385 行存在）。字段有服务端默认值时，它的出现只说明"客户端没传"，不说明客户端是谁；给代码路径归因前先问"表里有什么能把这条路和别的路分开"，答不上来就不能归因；判据选**写入方显式打的标记**（`extra->>'ingest'='native'`）。
3. **增量游标管的是"读到哪了"，不是"数据有多新"**：HealthKit 锚点之后追加任何新入库变更——配旧表/恢复备份/iCloud 同步历史，一分钟倒进 7315 条（跨 2022-2026，占该通道有史以来全部数据 92%）。凡增量/游标/变更流接口都要另加一条按业务时间的下限，并如实说明下限拦不住什么。判断方法：问"游标前进是因为有新事件，还是因为有东西被写进来了？"后者必被历史导入引爆。
4. **摄取边界必须显式读单位并转换，转换放在合理性校验之前**（10317 kcal 实为千焦；4.18 倍在结构上完全正常——聚合正确、在上限内，只有跟另一条路对照才能发现）；把收到的原始单位存进去（`extra.unit_in`），否则下次只能靠数量级反推；只在单位已声明且识别为非规范时才换算——猜测比不动更危险。校验该判的是你要存的那个数（顺带能救回被静默丢弃的合法数据）。
5. **派生 > 存储**：会被迟到数据改写的东西不要建表冻结（anomaly 横跨区间从日聚合序列现推；迁移=把边界冻结成一次猜测，迟到同步补上中间某天后存的区间永久错）。判据：这个值是"事实"还是"当前数据的函数"？配套：缺失的一天算区间结束（没记录≠问题在延续），两端加上限防脏数据拖死遍历。

### [2026-08-02] insight: 呈现/文案/一致性家族（7 条合并）
1. **同一件事的两个数字并排出现 = 必然读成矛盾，即使都对**（一晚三次案例）。一个数字只有唯一出处；要在第二处提它，要么复述同一变量要么别提；无法合并就给每个数标清在跟谁比；优先修源头（watchdog prompt 禁止句子里出现数字："行拥有数字，句子拥有故事"），别在 UI 打补丁。这类问题测试基本抓不到，只有把两处摆在一起看才暴露——所以每轮必须看截图。
2. **标签错比算术错更难发现**：`deviation_pct` 是"7 天均值 vs 30 天基线"，却被摆在"那天/你的常态"下面当两数之差——算法全对，是放错了地方。凡两数同屏，百分比**就地算**；存量聚合字段保留职责但必须带口径标签；听到"这数不对肯定是算法问题"，先把这个数的定义查出来再改算法。算术错会自己暴露（结果离谱），标签错不会（每个数单看都对）。
3. **一致性只有把两处呈现摆在一起看才暴露**（E5 三连：confidence 两套实现/弃权句只有 Explain 有/免责各自换说法）——方法是列出所有说同一件事的地方、把实际输出抄到一起对比，不是读代码判断"应该一致"。**a11y 文案常常是产品里写得最清楚的一段话**（让图表不用看坐标轴的那句白话早就写好了——只对 VoiceOver 说，看得见图的人拿不到）；反向检查有没有"只给辅助技术、没给所有人"的好内容。
4. **加了 guard/过滤之后，回查它让哪些既有文案变成恒真或恒假**：过滤函数第一行与文案守卫是同一条件 → 文案要么同一件事说两遍、要么说假话，两种情况穷尽所有可能。发现"要么冗余要么撒谎"的二分时删掉比修补更对（修补=给它编第三种情况）；删掉后**必须在原地留注释写明推理**——那是拦住下一个人把它加回来的唯一东西。
5. **语义色阶先算亮度序列**（0.2126R+0.7152G+0.0722B），不单调就别用（绿→琥珀→红非单调：去掉色相后"中等严重"比"最严重"更重，色盲/强光/灰度下语义整个反）。优先单色相×强度（GitHub 贡献图变的是一个绿的深浅，不是换色相）；验收要可执行：截图转纯灰度仍能分辨程度才算过；颜色之外保留第二通道（形状/文字）。
6. **显示格式器的 locale 必须显式注入**（默认 `.autoupdatingCurrent`，测试显式传 `en_US`/`zh_CN` 断言）——"测试恰好跑在英文环境"是隐式依赖。`en_US_POSIX` 只属于造 key 的格式器（yyyy-MM-dd 字典键/API 参数），给人看的日期星期一律注入 locale；SwiftUI `Text("字面量")` 天生按 key 查 String Catalog——视图层零代码改动，要动的只有逻辑层拼的 String；句子模板整句进 catalog 用位置参数（zh 重排语序），字面 `%` 折进参数不留在 key；英文默认值=key ⇒ 现有英文断言测试天然不动。
7. **免责声明不是修复**（`docs/API.md` 顶部写"忽略下文 DeepSeek"正文照旧 → 一个用户照做把 provider 存成 deepseek，128 次调用全在到达模型前抛错）：描述"当前系统是什么"的错了必须改正文，改不动就删掉那段；记录"发生过什么变更"的保留；最危险的是"照着做会坏"的文档（配置项/可选值/示例代码）。配套防御：**凡接受用户可选值的地方，值不在白名单就回退默认，不要抛错**——抛错等于让用户永久失败且无从得知。

### [2026-08-01] insight: 系统设计/合规/协作决策（3 条合并）
1. **计量器要装在被计量的东西上**：护栏放在缓存之前就是对免费操作收费（重看已缓存答案零成本也烧配额，owner 一小时 42 次 explain 被锁在自己产品外；修法=下沉到缓存未命中、真要调模型那一刻，30/小时从"30 次请求"变"30 次真实模型调用"，重放永远免费）。任何 rate/cost 限制先问"它计量的动作和它想保护的成本是不是同一个东西"。诊断侧对偶：用户侧 429 而业务表无痕时，查限流表（count vs 上限）是独立证据链；**护栏是 per-user 状态，换用户复现天然不可能命中——复现要复现的是状态，不只是形状**。
2. **新 AI 功能先问能否表达成现有端点的一个新主体/新参数**（框选分析做成 `/v1/explain` 加 `subject_type:'range'` 而非新开 `/v1/range-analysis`）：把健康数据发给 LLM 的每个新端点都是全新合规面（同意门/逐项枚举/cost guard/1.4.1 引用/呈现语言），扩展现有端点全部继承——一扇门，一处会漂移的地方。只有数据流真的不同（数据类别/接收方变了）才值得新开。用户自由文本进 prompt 时以"用户说了什么"的形式引用（读作内容而非命令）并硬性限长。
3. **被授权决策之后，退让也要有理由**（owner："你以后再决策的时候一定要自信，有足够理由再推翻"）：推翻自己需要跟当初立论同等强度的新理由，"对方反驳得漂亮/态度好"不算；撤回前先自查"我最强的那条论据用出来了吗"，没用出来先补上；区分**实质反例**（能举出我的方案更差的具体场景）与**修辞压力**（听起来更周全），只有前者构成撤回理由；真错了要干脆认。授权本体见 sub-MD `projects/ripple/RIPPLE.md` 决策历史。

### [2026-07-30] insight: 装 app 到新真机 —— `-allowProvisioningUpdates` **不会**注册新设备
真机装 Ripple 时踩到两步,都不需要打扰主理人:
1. **设备显示 `available (pairing)` 或 `unpaired`** = 信任提示没被接受。不用让主理人拔插重来,直接 `xcrun devicectl manage pair --device <udid> --timeout 60` **主动触发配对**,一次就成。
2. **`-allowProvisioningUpdates` 只更新 profile,不注册新设备** —— 报错是 `Device "X" isn't registered in your developer account`。必须**再加 `-allowProvisioningDeviceRegistration`**(两个 flag 一起给),xcodebuild 才会把设备注册进开发者账号。加上之后直接 BUILD SUCCEEDED,不需要 ASC API key、不需要开 Xcode、不需要主理人上 developer.apple.com。
另:`devicectl list devices` 的 Identifier(UUID 形式)与 `xcodebuild -showdestinations` 的 id(硬件 UDID)**是两个不同的值** —— 装用前者、构建用后者,弄混会报 "Unable to find a device matching the provided destination specifier"。
**How to apply**:任何 "把 app 装到我另一台手机上" 的请求,按 pair → build(两个 provisioning flag)→ `devicectl device install app` 三步走。Debug 真机构建**七天过期**,要提前说。


### [2026-07-30] insight: 自驱 loop 纪律（3 条合并：真实时钟 / sediment / 验证基础设施挂掉）
1. **每轮开头先取真实时钟**（`date` 写进该轮日志标题），跟上一轮时间戳比：**gap > 2× 预期间隔就明说 loop 曾 stall + 为什么**，不要瞒。"cron 还在/repo 干净" ≠ "loop 在推进"（session-only cron 在机器休眠期间不触发也不补跑，曾空转约 8 小时）；任何"loop 健康吗"先查真实时间和实际 commit 时间戳再答；要真正无人值守过夜用 cloud schedule，不是 session-only cron。
2. **边做边写，不攒批**：loop 档按 R-loop 格式记（⏱时间戳+gap检查 / Goal / 方法-DoD / Verification gate 全绿才 claim / 诚实边界 / ⏸follow-up / Plan delta / Next）；顺手修沿路发现的文档漂移（过期注释/stale TODO/合同文档）；sediment-worthy 内容当轮写 §8 并 push；**每轮收尾为下一轮定义「目标 + 可检验的验收标准」写进 loop 档末尾，下一轮开工先读它当真源**；owner 可预授权结束 loop——agent 可做的工作全部完成且验证、只剩 owner-only 事项时，做最终 handoff 总结 + 删 cron，不无限空转。
3. **验证基础设施挂掉时**（权限分类器服务不可用：需新分类的变更型调用一律被拒，只读 Bash 与 Edit/Write 照常、本 session 已分类过的相同命令还能过——现象是"有的命令能跑有的不能"，别误判成命令有问题）：判定方法 = 换一个从没跑过的变更型命令探一下，同样报不可用就是服务侧问题，**不要改命令去绕**（新写法照样生成新的待分类字符串被拒）。**绝不把"没验证"说成"做完了"**——该轮不 claim，日志明写"代码已落盘、验证门被工具链阻断、本轮不 claim，下轮第一件事 = 补跑验证门"；这段时间只推进零风险工作（设计文档/计划细化/代码自审读），不把未验证的改动继续往上叠。


### [2026-07-28] insight: macOS 上 Claude 清磁盘的两个硬限制(废纸篓 TCC + iCloud 桌面)
本机清理时实测,以后任何"清空间"任务先按这两条设预期,别把"我删了 X G"当成"释放了 X G":
1. **`~/.Trash` 被 TCC 保护,shell 进不去**:`mv 文件 ~/.Trash/` **能成功**(写允许),但 `ls`/`du`/`rm -rf ~/.Trash/*` 全部 `Operation not permitted` —— 而且 `rm` 是**静默失败**(配 `2>/dev/null` 时毫无迹象),会让我误以为清空了。`osascript -e 'tell application "Finder" to empty trash'` 也不行:AppleEvent 超时 -1712(Finder 在等确认框/没自动化权限)。**结论 = 清空废纸篓只能主理人在 Finder 里手动做(⌘⇧⌫)**,除非给终端开完全磁盘访问。所以"移进废纸篓"≠"释放空间",只是把占用从原位置挪到废纸篓。
2. **桌面在 iCloud 同步**:很多目录是 evicted 占位符(`ls` 显示原始字节数、`du` 显示 0B 或反过来),(a) `mv` 到废纸篓会触发**全量下载**再搬运 → 1.1G 的目录能把 mv 卡到 5 分钟超时,`rm -rf` 反而秒删(只删占位符);(b) 我为了统计跑的 `du -sh` 遍历本身可能触发 materialization,**把本地占用越查越大**;(c) 桌面的删除会**同步到其它设备**,不是只清本机 —— 涉及桌面删除时要跟主理人说这一句。
3. **缓存会立刻长回来**:清了 6.1G 的 `~/Library/Caches`(Atlas/Chrome/pip/Homebrew/playwright 等),几分钟内运行中的 app 就重建了约 1.8G。缓存清理适合"救急腾几个 G",不是持久收益。
**How to apply**:接"清理磁盘"类任务时,收尾**必须用 `df -h /System/Volumes/Data` 报真实前后值**,而不是把删掉的体积加总当战果;差值对不上就照实说差在哪(废纸篓 / 缓存重建 / iCloud 占位符)。呼应 [2026-07-30] 自驱 loop 纪律（含"没查真实状态不许说健康"）、[2026-05-28] "CI green 才算修完"—— 同一条原则:**以可观测的最终状态为准,不以我做了多少动作为准**。
### [2026-07-25] decision: HERMES.md 退役 —— 撤掉独立的 Hermes 记忆层，Hermes 改读 claude-context
**owner 原话**：「hermes 的记忆文件是不需要的，让他去使用 claude 的记忆」。`shared/HERMES.md`（2026-04-13 建的 Hermes 记忆快照）**即日退役**，已移到 [`archive/hermes-memory-export-retired-20260725.md`](../archive/hermes-memory-export-retired-20260725.md)；README / SETUP（Step 5.5）/ §0.7 三层记忆表 / §1 工具链链接均已改。**三层记忆体系降为两层**：claude-context（轻量指针/决策）→ Obsidian Vault（重内容）。

**⚠️ 落点澄清（很关键，别记错）**：Hermes 跑在 **macOS**（`/Users/gengyue`、`~/.hermes/`），**读不到任何一台机器上 Claude Code 的 per-machine auto-memory**（`~/.claude/projects/<slug>/memory/`，那是本机私有、不跨机、不进 git）。所以「用 Claude 的记忆」唯一可落地的指向 = **本仓 `claude-context`**（git 同步，Mac 上 clone 即可读）。任何让 Hermes 去读 `.claude/.../memory/` 的方案都是错的。

**⏸ owner 在 Mac 侧要做的（Windows 这台机器够不到）**：改 `~/.hermes/config.yaml` 的 user profile 注入源，指向 clone 下来的 `claude-context/shared/CLAUDE.md`；HERMES.md §4 原本约定的「编辑 §1 要同步回 config.yaml」随本次退役一并作废。

**从 HERMES.md 抢救出来的仍在活的事实**（原文件 §5/§6/§7，别随文件一起当历史丢掉）：
- **Hermes 多 profile**：`~/.hermes/profiles/` 下 `dad`（父亲健康追踪 + 微信沟通，gateway plist `ai.hermes.gateway-dad`）与 `xirui`（`ai.hermes.gateway-xirui`），各有独立 SOUL.md / memories / sessions / state.db。**dad 子系统仍活跃**。
- **两个 cron 仍处 paused**，等 prompt 按 Journal v1 新机制重写（原 follow-up task #9）：`9bb0519ba199`（AI Daily Report，原 `0 8 * * *`）、`06d0452064bb`（Mac Mini Work Log，原 `0 6 * * *`）。备份 `~/.hermes/cron/jobs.json.bak.20260525`。
- **dad 子系统 2026-05-25 升级**：`fallback_model` 因 provider 不支持指定 model 改为 `null`（配真 fallback 前必须先验证 provider 支持）；SOUL.md 有「数据落点 routing」段；Obsidian `Dad Health/` 里 `HEALTH-LOG.md` = READ-ONLY 快照、`Profile/04-异常追踪.md` = LIVE 台账。
- 原 §9（心涟 peer console）随 [心涟已退役](projects/xinlian/HANDOFF.md) 一并作古，不再抢救。

### [2026-07-15] project+feedback: ai-video 完全重启 —— Claude 在视频线的角色红线
旧思路(AI 主导流水线、自写 prompt 出片——残影/龙族/剑来三项目那套)被 owner 判定是错的,`D:\ai` 下 projects/experiments/keyframes/tmp 已按令**全删不备份**(保留 ComfyUI/模型/脚本/.env/simple-ui/whisper-env;blobs+manifests=ollama 模型库勿删)。新角色定义(适用所有机器的 Claude):
1. 只做两件事:**①搜集资源、教 owner 传统的电影/漫画/影视知识**(不主动开课,owner 实践遇到问题才问)**②技术支持**(环境/脚本/API/排错)。
2. **不得从 0 写提示词**——只有多轮交流之后、或 owner 明确指示/确认下才动笔。
3. **libtv 及将来一切 agent/MCP:只能以读为主**,做技术支持而不是替 owner 创作。这是核心原则。
4. 任何要写进视频相关目录的**规则文档,先经 owner 确认**再落盘;输出一律**简洁大白话**。
5. 平时常驻姿态 = **阅读 owner 的作品 + 记录 + 思考**,owner 需要时会说。资料/笔记存 Obsidian 对应位置 + yorha-a2 的 assets(与该 repo assets 规则相似)。
⚠️ 被删的《走廊的回声》第一章「残影」文本(canlying/chapter_1_remnant/chapter.md):经 Mac 侧核实(07-21)**大概率已随删除丢失**(两台机器均无副本),owner 已知情不着急;若日后在意,提供可能目录再精确扫。

### [2026-07-09] insight: 健康类 app App Store 首提交四拒因 pattern(Ripple 实测,全部一轮修掉)
Ripple v1.0 (1) 2026-07-08 被拒,四条拒因对任何 wellness/health app 都是高概率坑,提交前自查:
1. **5.1.1(iv) 权限前置页按钮措辞**:HealthKit(或任何权限)请求前的自定义引导页,按钮**必须用中性词 "Continue"/"Next"**——"Connect Apple Health"/"允许"/"开启" 这类引导性词汇直接拒。页面正文解释为什么要权限是允许的,只有按钮措辞受限。
2. **2.2 beta 字样零容忍**:UI 里任何 "beta" 可见文案(Ripple 是 Me 页一行 "Free during beta")都会被当成"beta 测试功能残留"拒掉。**且同一行字还触发了 2.1(b) 商业模式盘问**("beta 免费→之后收费?")——一行装饰性文案换来两条拒因。
3. **1.4.1 健康信息必须带引用**:app 里出现健康/医疗信息(哪怕是观察性 AI 解释)就必须有**用户容易找到的、可点开的来源引用**。修法 = 按指标策划权威消费者健康页(Cleveland Clinic/AHA/MedlinePlus/NHLBI/WHO),挂在每个 AI 输出屏底部。**坑:引用 URL 要先 curl 验活**——Harvard Health 老文章 404,Mayo/CDC/NIH 首页对非浏览器 UA 返 403,审核员点开死链更糟。
4. **2.1(b) 免费 app 也会被问商业模式**:五个标准问题(谁付费/在哪买/能访问什么已购内容/什么非 IAP 解锁/账户是否收费),纯回复不用改码,答案就是"全免费无任何付费"。
**流程知识**:被拒不用新建版本——被拒版本页直接可编辑,换新构建(bump build number 即可,版本号不变)+ 在消息里回复 + 重新提交。修复全过程 = 修码→测试门全绿→CLI 归档上传,约 40 分钟。全记录:`ripple-ios/docs/APP-STORE-SUBMISSION.md` "被拒记录 #1" + 回复稿。
**二拒追加(2026-07-14,#1 四条全过后又来三条,同样一轮修掉)**:
5. **SIWA 红线 = 登录后不得再问名字/邮箱**(Guideline 4):Apple 凭证已给 fullName/email,登录后再展示"填名字"屏即拒——**可 Skip 也不行**。修法 = 首次授权时捕获 `cred.fullName` 自动写 profile,Apple 路径整屏跳过;邮箱 OTP 路径问名字合规(OTP 不提供名字)。
6. **AI 同意页必须逐项枚举**(5.1.1(i)/5.1.2(i)):有同意页但写"relevant summary and context"这类泛化描述照样拒——要明确列出**发送哪几类数据 + 点名不发送什么(姓名/邮箱/通讯录)+ 接收方是谁**。隐私政策同款枚举,且"只写在政策/条款里不够",app 内弹窗才算 ask permission。
7. **iPhone-only app 会在 iPad 兼容模式被审**(2.1(a)):装饰性控件(无 action 的相机图标)按 bug 拒。没有对应功能的东西不许长得像可点。
**全手册审计追加(2026-07-14,提交前主动扫出 17 条/0 误报,多 agent 审计模式值得复用)**:
8. **同意门要按"数据流"而不是"UI 入口"排查**:Ripple 的自由文本 intake(About you)把健康文字直发 OpenAI 却没过同意门——因为它不长得像 AI 功能。方法 = 从后端列出**所有调 LLM 的 endpoint**,反查每个的客户端入口是否有 consent;**服务端主动发起的 AI**(cron/watchdog/nudge)也要按用户同意状态过滤(客户端 @AppStorage 标志要镜像到服务端才能过滤)。
9. **给 LLM 的工具注册表 = 隐私申报的一部分**:agent 有 get_location 工具,时间线就会显示 "Checked location"——哪怕 app 从不传位置,与隐私标签"不收集位置"并排就是自相矛盾。工具列表要和 App Privacy 声明对账。
10. **测试里凡是"某天有无数据"的断言必须用相对日期**:demo 是滚动窗口 seed,写死的"未来空日"会长出数据、还会被 persona 的未来计划占上;硬编码日期三处全在两周内腐化。

### [2026-07-02] insight: Supabase + 邮箱 OTP 的 App Store 审核 demo 账号 = 固定-OTP 触发器(app 零改动)
App Store Guideline 2.1 要求登录墙 app 给审核员一个能进、有数据的 demo 账号;纯邮箱 OTP 的 app 审核员收不到验证码邮件 → 会被拒。**无密码登录本身不是拒因**(Apple 支持 OTP + Apple 登录),缺的是审核员可用的进入路径。
**解法(Supabase 原生,app 一行不改)**:在 `auth.users` 上加 `BEFORE UPDATE` 触发器,只对某个固定的**全小写** demo 邮箱,把 GoTrue 写进 `recovery_token` 的 OTP 改写成固定码的哈希。审核员走现有"邮箱→验证码"界面 + 固定码登录;其他用户照旧随机码(已验证:普通账号用该固定码返回 403)。
**踩坑(全部实测确认)**:(1) 存 OTP 的列 = `recovery_token`(已确认用户走 signInWithOTP 时),格式 = `hex(sha224(email ‖ otp))` —— 用 admin `generate_link` 拿明文码反查公式确认,别信博客(几篇都 403 打不开也没必要);(2) 触发器里**别用 `extensions.digest`**(pgcrypto)—— GoTrue 的角色 `supabase_auth_admin` 对 extensions schema **无 USAGE 权限** → UPDATE 直接 **500**;改用 Postgres 11+ 核心 `sha224()`(在 pg_catalog、人人可用,哈希值与 pgcrypto 一致);(3) demo 邮箱必须全小写(Supabase 规范化 email、SQL 大小写敏感);(4) `@test.com` 这种收不了信的域名 signInWithOTP 仍返回 200(发信失败是异步的),不挡审核员进验证码界面。
**v2 升级（同一指令"demo 不得再触发验证码发送"）**：触发器改为 demo 行**任何 UPDATE 都重钉** fixed-hash（verify 成功清 token 的那次 UPDATE 会被立刻重钉→token 永久有效）+ cron 定期保鲜 `recovery_sent_at` + 客户端对 demo 邮箱发码 no-op。净效果：demo 登录**零邮件发送**——审核员重试也不会撞 per-address 邮件速率限制（那是真实拒审风险）。
**复用**：任何 Supabase + 邮箱 OTP + 上架 App Store 的项目都适用。方法论 = 别猜内部格式，用 admin API 拿真数据反推 + 端到端测通了才算数。
**Ripple 实现**（凭据、常驻 prod 决策、安全权衡、拆除方法）：见 sub-MD [`projects/ripple/RIPPLE.md`](projects/ripple/RIPPLE.md) 决策历史；一体化脚本 `ripple-core/scripts/setup_demo_account.py`。

### [2026-07-02] insight: iCloud 同步目录里的 Xcode 工程会随机 codesign 失败("detritus not allowed")
Ripple S-loop 实测:repo 在 iCloud 同步的 `~/Desktop` 下,fileprovider 会**持续、异步**给文件/目录打 `com.apple.FinderInfo`/`com.apple.fileprovider.*` xattr——包括**构建进行中的 DerivedData 产物**。codesign 见到这些 xattr 直接拒签(`resource fork, Finder information, or similar detritus not allowed`),且**时好时坏**(取决于 iCloud 同步时机),源码 `xattr -cr` 只能撑几秒。
**根治两件套**:(1) XcodeGen `postBuildScripts` 给每个 target 加 CodeSign 前的 `xattr -cr "$CODESIGNING_FOLDER_PATH" || true`(防源侧 xattr 被 copy 进 bundle);(2) **DerivedData 挪出 iCloud 盘**(`-derivedDataPath ~/Library/Developer/Xcode/DerivedData/<name>`)——test-runner 这类没有 script hook 的 wrapper bundle 只有这招能救。
**适用**:任何放在 iCloud/Dropbox 同步目录的 Xcode 工程(真机归档同样会踩)。诊断一句话:`xattr -lr <built.app> | grep -c FinderInfo`。

### [2026-07-01] feedback: UI 美学微调交人做 —— 我只做功能/接线,不擅自 fine-tune 视觉
主理人 2026-07-01(Ripple iOS):"大量 UI 需要微调…我不希望你直接改,因为你根本理解不了 UI。你记下来,后续让人去微调。"
**Why**:我能把每屏接通后端 + 编译 + 截图验证(功能对),但**间距/字阶/配色对比/留白/动效/整体视觉 craft 需要设计师的眼**——我拍脑袋定的功能性视觉(如 Ripple logo 深色底看不清→我垫了米色砖)只是"能看",不是"好看"。硬让我 fine-tune 视觉会产出"能跑但难看/不对味"的东西。
**How to apply**:UI 类工作,我的边界 = **功能、数据接线、状态逻辑、可访问性接线、把视觉决策点列成清单**;**视觉美学微调 = 记 TODO 交人**,不主动改。遇到纯对比度/能否看清这种**功能性**视觉 bug 可以做(并标注"功能性决定、待设计复核");遇到"更好看/更精致/间距字体配色"这种**美学**调整 → 写进 handoff TODO,不动手。Ripple 的清单 = `ripple-ios/docs/UI-POLISH-TODO.md`(按屏 + cross-cutting,commit b2a28ae)。
**范围**:本质是通用工作边界(任何我做的前端,视觉精修默认交人;除非主理人明确让我调某个具体视觉)。**Ripple 例外(2026-08-01)**:owner 授权 Claude 做 ripple-ios 的产品/UI 方向决策——见 sub-MD [`projects/ripple/RIPPLE.md`](projects/ripple/RIPPLE.md) 决策历史;像素级 craft 仍须截图实看才许说完成。

### [2026-06-27] insight: iOS HealthKit 签名坑 — `com.apple.developer.healthkit.access` 空数组也会触发"临床记录"能力、免费 team 签不了
ripple-ios 配真机签名踩到：entitlements 里只要**存在** `com.apple.developer.healthkit.access`（**哪怕是空数组 `<array/>`**），Xcode automatic signing 就当成在申请 "HealthKit Access (Verifiable Health Records)" = 临床健康记录（FHIR/EHR）能力 → 免费/个人 team 直接签不了（报 `Personal development teams do not support the HealthKit Access (Verifiable Health Records) capability`），付费账号也要单独申请。
**标准 HealthKit**（读心率/HRV/呼吸率/血氧/睡眠/步数/活动能量等 quantity & category 类型）只需 `com.apple.developer.healthkit: true` **一项**，**不要**加 `.access`。删掉后免费个人团队也能签真机标准 HealthKit（xcodebuild 实测：删前报 capability 不支持，删后那条错误消失，只剩良性的 `no devices`）。
**How to apply**：任何 iOS HealthKit 项目，entitlements 默认只放 `com.apple.developer.healthkit: true`；只有真要读 Apple Health 里的临床病历（clinical records）才加 `.access: [health-records]` + 付费账号 + 额外申请。配套坑：(a) development profile 必须绑定 ≥1 台已注册真机，无设备时 xcodebuild 报 `Your team has no devices` 是良性的，连上 iPhone 自动注册即消失；(b) bundle id 全局唯一，被占用必须换（本次 `app.ripple.ios`→`app.ripplehealth.ios`）；(c) 免费个人团队证书 7 天过期，到期重新 build 安装即可。

### [2026-05-31] feedback: ai-interactive-story 上 Claude 要从 0 架构, 不锚定 Yufei 现有技术决策
做 ai-interactive-story (Yufei 的卫星 repo) 数据库选型时, 我第一轮用"代码作者注释里自己写的计划 (准备换 SQLite)"当推荐理由之一。用户纠正:"之前的决定是 Yufei 做的, 他的决策能力不够, 你要从 0 思考整个计划"。从 0 重想后立刻抓出旧设计一个真问题——session 当 blob 每回合全量重写 (O(n²)), 换 DB 但还用 JSON 列存整 session 不解决, 真修法是 messages 拆 append-only 行。这是第一轮顺着 Yufei 设计走没抓出来的。
**Why**: 卫星 repo 的代码/架构现状是 Yufei 做的, 主理人明确判断 Yufei 架构判断力不足, 要 Claude 当这个 repo 的架构负责人。**不是** "尊重 owner 的现有选择"那种 default 姿势。
**How to apply**: 在 ai-interactive-story (以及主理人明确点出"某人判断力不够"的任何场景) 做技术决策时, 从第一性原理重想, 不要拿"代码里现有的做法 / 作者注释里的计划"当 anchor 或推荐理由。该推翻就推翻, 给出独立判断。注意边界: 这是**技术架构**域 (Claude 主导); **产品方向 / 引擎要做什么功能** 仍是 Yufei + 主理人决策域 (见 yorha-a2 mount decision)。
**关联**: [[satellite mount pattern]] (同期 §8 条) + ai-interactive-story `decisions/2026-05-30-db-supabase-postgres.md`。

### [2026-05-31] insight: 把外部代码 repo 挂进治理生态的"卫星"模式 (不用 submodule)
yorha-a2-team 要把 Yufei 的独立 repo `toffemoon/ai-interactive-story` (AI 互动故事引擎) 纳入团队生态——"他的更新/决策/assets 都算团队的 + 他那的 Claude 要守团队规矩"。没用 submodule/subtree (嵌套复杂 + 单向同步痛)，用**卫星模式**：
1. **CLAUDE.md brain-transplant**: 给外部 repo 根目录加一个 CLAUDE.md, 让它那跑的 Claude 戴两顶帽子 — (a) 给那 repo 写代码 (b) 守父项目治理 (读父 repo decisions / 写 team-log 回父 repo / 走 PR / 自动记忆). 关键: 代码 repo 的 Claude 跟纯内容 repo 的 Claude 姿势不同 — 前者**写代码**, 后者只守 framework, CLAUDE.md 要显式区分.
2. **两层 decisions**: 工程决策放卫星本地 `decisions/`; 战略决策 (卫星跟父项目关系) 放父 repo `decisions/`. 判断不准默认写父 repo (团队可见 > 本地隐藏).
3. **跨 repo 写**: 卫星 Claude 写 team-log 时 `cd ../父repo` 走那人的 branch commit. 前提两 repo 平级 clone.
4. **父 repo 登记**: 一条 mount decision 锁关系 + 状态板加 satellites 字段, 明确"卫星 ≠ 新增 part"避免稀释核心命题.
**权限坑**: 主理人对协作者个人 repo 默认 0 push 权限 (403). 解法 = 协作者加 collaborator, 或 fork+跨仓库 PR (fork 是无 push 权限贡献的标准路). 改别人 repo 永远走 PR 不直推 main (礼貌 + 留痕).
**How to apply**: 任何"把 X 独立 repo 纳入 Y 项目治理但不想物理合并"的场景 (monorepo 替代方案) 都可用此模式. 比 submodule 反悔成本低一个数量级 (删几个 md 文件 vs deinit + 历史污染).
**位置**: 父 repo `decisions/2026-05-31-mount-ai-interactive-story.md` + 卫星 `CLAUDE.md` (PR toffemoon/ai-interactive-story#1).

### [2026-05-30] feedback: 双边机制设计要单独画主理人一端 + Obsidian 是 capture 默认位置
设计 yorha-a2-team 的 temp-ideas/ pin 板时, 我从协作者视角倒着想 (协作者 SessionStart 看 / 跳过 / archive 到他们 Obsidian), 把 git `temp-ideas/` 当成主理人的入口本身, **漏了主理人需要 Obsidian inbox 当个人暂存灵感的地方** —— 刷到东西先写自己 Vault, 想清楚再 promote 到 git 给 team 看. 用户指出"之前我一定说了暂存是要在Obsidian里的", 严格读 ta 只为协作者 skip 场景明说了 Obsidian, 主理人 inbox 这端是隐含的; 但隐含信号足够 ([§0.7 三层记忆体系](#07-外置大脑obsidian-vault): Obsidian = 重内容 / 外脑; 用户工作流就是刷到 → Obsidian 暂存 → 再决定), 应该推出来. 已补 `Vault/01 - Projects/YoRHa-A2/temp-ideas-inbox/`.
**Why**: 任何"两端"机制 (主理人 ↔ 协作者 / source ↔ sink), 单看协作者一端会漏主理人那一端的 mirror 需求. 主理人那边也需要 source / capture / scratch 入口.
**How to apply**: 以后设计跟外部 (协作者 / 用户 / 团队) 交互的 pipeline 时, 主理人那一侧明确画一遍: **capture → scratch → decide → commit** 四步在哪. capture / scratch 的 default location 永远先想 Obsidian (用户的外脑约定 / §0.7), 不是 git. git 是给"决定要 share 出去"那一步用的.

### [2026-05-29] decision: 硬风格视觉内容标准流程 = GPT Image 2 草图 → Claude Remotion 代码
PR #8（Yufei agent-subagent v0.1）暴露 Claude 直接从文字 prompt → Remotion 代码容易出"PPT 切片"——纯 fade / opacity / translate 几像素，缺真实视觉设计。根因是 Claude 在文字→代码链路上**缺视觉锚点**，不知道"什么样子才算视频"。
**锁定流程**：任何硬风格视觉内容（chart / mermaid / 流程图 / 节点图 / 分镜 / Remotion section 视觉骨架 / component / UI 设计）必走两步：
1. **Step 1**: 用 GPT Image 2 出草图 / 分镜故事板（任意形态：手稿 / 白板 / UI 草稿 / 漫画分镜均可）
2. **Step 2**: 把草图喂给 Claude 生成 Remotion / SVG / React 代码
**范围**：GPT Image 2 用法可以超出此（出成品图 / moodboard / thumbnail / 实验视觉），但硬风格内容**不能低于此** —— Step 1 必须跑。
**配套**：与 [2026-05-28] Shape A 两条硬约束（充分 motion + 前 3 秒 hook）配套——那条说"必须有 motion"，本条说"怎么做出有 motion 的"。
**对 Claude 的影响**：以后帮协作者写 Remotion / chart / SVG / 复杂可视化代码之前要主动问"有 GPT Image 2 草图了吗"，没有就先建议跑一版。具体图像模型不约束（Midjourney / Flux 也行），但 GPT Image 2 在"按文字描述生成视觉 layout"方向是当前最稳。
**位置**：`yorha-a2-team/decisions/2026-05-29-visual-flow-gpt-image-then-remotion.md` + framework `story-shapes.md` / `voice.md` 交叉引用。PR #6 同时合并 workflow 修复 + Shape A 硬约束 + 本流程。
**Why 写 §8 不只项目内**：图像模型 → 代码生成是跨项目可复用模式（任何需要 Claude 生成视觉化代码的场景：MoyuanIdea 三端 UI / TemplateApp Agent Timeline / IFSG dashboard chart 都适用）。
**范围修正(2026-07-02,主理人)**:有**成熟项目设计 skill/design system 的项目不适用此流程**——Ripple UI 工作被主理人明确指示"不用 GPT,按我给你的 skill 做":ripple SKILL(§5 A-bis + dark/teal/线条感 + DESIGN-NOTES tokens)本身就是视觉锚点,直接照它写代码。本流程真正的适用场景 = **缺视觉锚点**的从零创作(如 YoRHa 短视频 Remotion);有 skill/设计系统的项目,skill 即锚点。

### [2026-05-28] correction: code mode 改 CI / workflow 后必须等 CI green 才算修完，不要 push 就 claim 完成
User pushback：连续两次"修完 push"但 CI 仍 fail（第一次 mode 错→第二次 secret 缺）。第二次 claim "修了" 后 user 实际看到的还是红 ×，对他来说就是"依然 fail"。
**问题根因**：我以为"错误信息变了"就算进步 + 验证完成（mode error → auth error），但用户体验维度看仍是 fail。push 后我应该自己 sleep + check `gh run list` 直到 SUCCESS 才告诉用户"修完"。
**正确流程**：改 CI / workflow / Action 类文件后：
1. push
2. `sleep 15-30` 等 CI 触发
3. `gh run list --limit 1` 看状态
4. 如果 in_progress → 继续等
5. 如果 failure → 看 log + 改 + 再 push + 再等（迭代直到 green）
6. **只有 green 才说"修完"**
**适用范围**：任何 CI / GitHub Action / hook / cron 配置改动。一次性脚本不在此列。
**关联**：本条加进 Obsidian `02 - Areas/Claude Harness/code.md` 行为规则段。

### [2026-05-28] correction: 我的名字 = Gengyue，Tommy 是 Yufei 的英文名（不是我的）
半年多以来 §1 一直写"姓名 Geng Yue（耿越），英文名 Tommy Chen / 邮箱 tommychen030607@gmail.com" —— **这是错的**。
**正确身份映射**：
- **Gengyue (耿越)** = 我，主理人，邮箱 `gengyue081@gmail.com`，GitHub `yorhagengyue`，Slack `Yue John Geng`（YoRHa-A2 workspace）
- **Yufei = Chen Yuqin = Tommy (英文名)** = NAISC team / YoRHa-A2 协作者，邮箱 `tommychen030607@gmail.com`，GitHub `toffemoon`，Slack `Yuqin Chen`
- **Zicheng = Liu Zicheng** = NAISC team / YoRHa-A2 协作者，邮箱 `liuzicheng357@gmail.com`，GitHub `Monika-12138`，Slack `liuzicheng357`
**影响范围已校准**：claude-context §1 / yorha-a2-team repo 多处 / NAISC §8 [2026-05-04] correction 'team 真实第三人 Chen Yufei' 原意应该是 user 之前把 Tommy 当自己的名字塞进 trailer/website，实际 Tommy 就是 Chen Yufei (=Chen Yuqin) — 不是另一个人。这条校准让那条 NAISC 记忆终于自洽。
**Why 错了这么久**：早期 CLAUDE.md 是手动建的，可能用了 Yufei 的英文名当模板没改回来 → 后续每次 session Claude 都假定 Tommy = user，没去 verify。Slack 设置后才暴露（Yufei 用 tommychen030607 注册显示 Yuqin Chen）。
**对 Claude 的影响**：以后引用主理人就叫"Gengyue"，不要叫 Tommy / Tommy Chen。Yufei 可以叫 Yufei / Yuqin / Tommy 任一（项目内部 team-logs 子目录用 yufei 不动）。

### [2026-05-26] insight: IM-bot 媒体 ingest 改造的 5-layer pattern（gateway → state.db → sync → proxy → lightbox）
心涟 (Peer) 2026-05-26 实施。WeChat 媒体（图/语音/视频/文件）原本在 Hermes enrich pipeline 被压成 `[图片]` text marker 整丢，**修复链路 5 层每层都要动**：

1. **Gateway upload 层**（`weixin.py:_collect_media`）：媒体 cache 本地后立即 upload to object storage（Supabase Storage 同款 `peer-media` bucket，service role key），不依赖后续。bucket missing → log + local-only fallback，**不阻塞主消息流**
2. **state.db schema 层**（`messages.attachments TEXT/JSONB`）：加列存结构化 `[{type, storage_path, mime, size_bytes}]`。**关键防御 PRAGMA-guarded INSERT** —— Hermes state.db 有 schema drift 历史，新代码必须先 `PRAGMA table_info` 验证再写
3. **MessageEvent 层**（`base.py`）：加新字段 `media_attachments: List[dict]`，**不动 media_urls: List[str]** 避免破坏其它 47 处 reader
4. **Sync 层**（`profile_sync.py`）：SELECT 加新列 + POST jsonb 字符串到 PostgREST，**也 PRAGMA-guarded** 以兼容 drift
5. **Frontend lightbox 层**：API proxy endpoint（`/api/peer?action=media&path=...`）验 cookie + 签 5min Supabase signed URL + 302 redirect。前端 `parseContent` positional 配对 content markers 与 attachments[]

**通用 pattern**：任何"IM bot 收媒体却丢媒体"问题（telegram/discord/slack 同款），按这 5 层修。
**关键防御**：(a) **content 列保留 enriched marker** 给 LLM "读图"能力 + attachments 给 UI 渲染（两者共存）；(b) bucket missing 不阻塞 ingest 主流；(c) PRAGMA-guarded INSERT/SELECT 防 schema drift；(d) 加新字段 ≠ 改字段类型（兼容老 reader）；(e) 5min signed URL TTL 够 lightbox 打开 + browser cache max-age 复用。
**反例（不要这么做）**：直接 strip media 标记 / 写 binary 进 db / public bucket / 改 media_urls 类型签名。

### [2026-05-25] insight: peer = 心涟 Hermes operator console，跨仓库的同一产品
派 subagent 升级 `~/Desktop/Toffeemoon Design System/peer/` UI 时发现 peer 不是"peer comparison"（之前误以为）—— **它是 Hermes 多 profile 系统（dad / xirui）的 web operator console**，让用户实时看 / 干预 WeChat 对话流（`bot_send_queue` 表注入 → 3s 轮询发回微信）。**Why 重要**：之前 Hermes profile 系统、`peer/` web console、WeChat gateway 三处其实是同一产品的三个面，但各记各的——HERMES.md 不知道有 peer console、peer/ 不知道自己是 Hermes 的 UI、`~/.hermes/profiles/` 不知道有 web 端在读它的数据。已在 HERMES.md §9 把架构图 + 5 页面 + API + 已知 follow-up 全连起来。**教训**：跨仓库 / 跨工具的产品在 docs 上是 N 个孤岛是默认状态——任何 framework 重构都应该主动扫"还有什么孤岛"。Subagent 推断 product 定位的过程值得复用——读 db schema + API actions 就能 reverse-engineer 出真定位。

### [2026-05-25] correction: 模式系统 v1 测试发现 6 个 gap + 修复
模式系统建好后做了一轮结构审计 + 行为模拟。发现：(1) auto-memory 规则只在 chat / memory 模式提了，code / architecture-review / content 三个 mode 文件未体现"全模式 default-on"；(2) "复盘"在 chat 和 memory 都声明触发词、无分流；(3) "实现"单字会误进 code（用户实际想 design 讨论）；(4) chat ↔ code 临时切的"回主模式"信号未明示；(5) "记一下" 在 INDEX 触发词缺失；(6) chat 缺 small talk / 问 Claude 能力的 fallback 兜底。**修法**：INDEX 拆"明确触发词"vs"歧义触发词必须问"两张表 + 加模式叠加回主信号说明 + 全模式通用准则加 auto-memory 一行；code/architecture-review/content 各 mode 加 auto-memory reminder；chat 加兜底 entry + 反向 INDEX link；content 补反例段；§9 速查表同步。**教训**：写完 framework v1 必须自审 + 跑典型 prompt 测试，不能假定"逻辑闭合"。下次任何 spec 落地后**先跑 5 个边界 prompt** 再用。

### [2026-05-25] correction: Codex 主力工具 framing 不准 + 僵尸 contract 清理
之前 §1 写 "OpenAI Codex (GPT-5.4)" 当主力代码工具。调研后纠正：(1) 实际 model 是 `gpt-5.3-codex` + migration notice，**未实际切换 5.4**；(2) Codex 现状是**中间状态**——NAISC 后冷却 5+ 周，活跃度比 Claude / Hermes 低很多；(3) `~/.codex/memory.md` 长期强制每个任务调 YoRHa dashboard（4-22 已死），全部 session 都在调死服务。**已修**：CLAUDE.md §1 改为反映实际 model + 中间状态；§0.6.2 新增 Codex 调研段；`~/.codex/memory.md` 重写删 dashboard policy；`dashboard-session-operator` skill rename `.disabled-20260525`。**未做（follow-up）**：删 config.toml 的 Ripple MCP+wkt_token（等用户 Workato 后台 revoke 后做）；YoRHa 物理归档；shared/codex/ 跨机同步；活跃项目 AGENTS.md 补全。**教训**：跨工具生态（Claude / Codex / Hermes）的 contract 必须在生态边界变化时同步更新——之前 YoRHa 在 §5 标"归档"但 Codex 端的 contract 没改，5 周污染。下次任何生态层归档都要扫一遍跨边界 contract。

### [2026-05-25] feedback: Claude 自动记忆是 default-on 不再被动 (§0.3.1)
用户明确要求：以后无论哪个对话、哪个模式，Claude 遇到 sediment-worthy 内容**必须主动写入**，不需要用户提醒、不需要先问。**Why**：用户已建三层记忆体系（§0.7）+ 模式系统（§9），但之前自动记忆是 memory 模式 limited——这次提升为全模式 default。Claude 是用户的外脑，外脑应该自己工作。**How to apply**：判定见 §0.3.1 sediment-worthy 清单；写入回复末尾必须用 `📝 已记入 ...` 一行告知；用户随时可 rm；说"先不记"立刻停。memory 模式 → 显式批量操作；自动记忆 → 全模式 default。

### [2026-05-25] correction: 我对中国短视频 / 抖音生态的判断不准
用户给我看了一条 1500+ 字 subagent / 分手类比的内省文案，我下意识 attack "长文不适合短视频"——前提是"短视频 = 30-90 秒"。用户 pushback：这条文案就是抖音爆款的转录，3-4 分钟（不超 5 分钟）在抖音被市场验证 OK，**关键是配的视频画面而非文字时长**。
**Why 错了**：我的"短视频应该 X"是通用 / 西方平台默认，**不等于中国具体平台的玩法**。抖音 / 小红书 / B 站 / 微信视频号每个有自己的内容生态规律。
**How to apply**：未来任何中国内容平台讨论 —— **先承认我不熟生态、问用户实际跑出来的案例**，不要先 assert 通用规则。我的训练数据里中国平台 first-hand 数据少，应该把判断权交给用户 + 实际数据。
**连带校准**：同次对话还 attack 了"情感粉 ≠ AI 咨询粉"。用户实际策略是**国内初期不追求转化、追求好流量**（资产积累），国外才追转化。我把两个市场当同一漏斗逻辑评，也错了。**国内 metric = 流量 / 国外 metric = 转化** 是不同游戏。

### [2026-05-25] correction: 架构判断力不再是 #1 短板（§3 frame shift）
NAISC 5/22 决赛是触发节点。之前 §3 把"架构判断力 = 核心缺口"当宪法，半年实践下来用户重新校准：作为**学生 + 同龄人参照系**，架构能力已经是强项，不是 #1。学生阶段不存在"在架构能力上有极大突破"的物理可能（没有大规模生产系统在手 + 没有 10 年级别的重构经历），继续恶补边际效用很低。
**调整**：架构对抗不再是 Claude 的 default 行为，下沉为 `architecture-review` 模式按需调用。§3 即将重写。Claude 的 CTO 顾问定位从"无条件 on"改为"显式/识别触发"。
**没改的部分**：架构对抗这件事本身没问题，仍是 Claude 工具箱里的核心能力之一；改的是默认权重和叙事顺序，不是删能力。

### [2026-05-25] insight: 新 #1 短板 = 交付（赚到一个结果）
NAISC 决赛 4 评委中只有 Workato 那位（AI 出身）听懂作品；另 3 位非技术评委对偏技术的产品理解不到，"如何证明你是有市场的"答得不好。这不是单点失误，是整个能力栈的真实缺口暴露：**技术节奏已经够快，下一阶段重心挪到"赚到一个结果"**。
**framing 校准（5/25 二轮）**：第一轮写"售卖 / 营销 / 产品包装"太窄。真正的 #1 不是营销这件事本身，而是 **交付一个结果**——unit 可以是钱 / 流量 / 资源 / 名次 / 任何 tangible 的"赚到了"。营销只是路径之一。
**Why 这个 framing 更准**：activity 框架（做营销）让人想"投入更多时间做营销"；outcome 框架（赚一个结果）让人想"什么路径最短最便宜"。后者更接近商业判断。
**形式**：不一定个人完成，可能跟组员分工。多平台社交媒体是第一条尝试路径（5/25 立项见 §5），但只是路径之一不是终点。
**对 Claude 的影响**：`content` 模式定位调整——不是"为营销服务"，是"为某个具体的交付结果服务"。后续专题对话会进一步细化"哪些结果类型 × 哪些路径"。

### [2026-05-25] project: NAISC 2026 Workato Track 终局 — 第三名 + pivot
Team YoRHa / Ripple 5/22 决赛拿到 **Workato Track 第三名**。比赛结束，pivot 决定：Ripple 本体收尾归档；**rule library (53 rules) / Discord listener / MCP 4-tool 架构 / Whisper 幻觉清洗脚本** 作为可复用资产拆出（落点待定）。claude-context 的 `shared/projects/naisc-workato/` 和 Obsidian Vault 的 `01 - Projects/Workato NAISC/` 都即将归档到各自的 `04 - Archive/`。
**遗留决策**：Discord listener（Mac Mini PID 48771）是否继续跑积累数据，待用户决定。
**复盘洞察**：见同一天 insight 条目（市场/包装短板）。具体 Q&A 失分细节用户暂不展开，留给"售卖"专题对话。

### [2026-05-23] project: TemplateApp — Agentic AI Pivot（已归档，详见 sub-MD）
Linda William 要求把 TemplateApp 从"通用文档生成器产品"pivot 为 **publishable agentic AI 研究项目**（两个论文 contribution：Live Data Binding + LLM-as-Judge；LangGraph 主框架 + CrewAI/LangChain 对比；LLM 矩阵 cost-performance；ONLYOFFICE 扔掉）。全部锁定决策、W1 文献综述（8 judge 技术实测）、plan、HANDOFF 已镜像到 sub-MD 与 vault。**2026-08-04 随实习线暂时归档**（可能复活，见「已归档项目」表）。跨项目产出只有一条：LLM-as-Judge 多 agent 分层与 NAISC 互相印证（已并入 §8 [2026-05-08] mentor 模式条）。
→ sub-MD: [TEMPLATEAPP.md](projects/templateapp/TEMPLATEAPP.md) · [HANDOFF.md](projects/templateapp/HANDOFF.md)

### [2026-05-23] correction: subagent 默认没 WebSearch/WebFetch 权限
跑 W1 文献综述时启了 2 个 general-purpose subagent 做并行研究，但 subagent 默认拒 WebSearch + WebFetch。用户开了 bypass 后重启 subagent 才正常。下次给 subagent 派"研究"任务时记得：(1) 父 session 的 WebSearch 工具不会自动继承给 subagent；(2) 要么提前确认 bypass，要么父 session 直接做研究不 delegate。

### [2026-05-08] insight: hackathon mentor 反馈整合的标准模式
Mentor 答疑会消化后的工作流：**raw transcript 留 Obsidian** / **distilled takeaways 进 sub-MD** / **跨项目可复用的洞察（如 LLM-as-judge 多 agent 分层、Cursor "build before model is capable" 类比、data flywheel as moat、pre-processed data pipeline framing）写 §8**。NAISC TP7/TP8 全文（2 × ~35min 转录 + 8 项具体 takeaway + deck/Q&A action implications）归档在 `archive/naisc-workato/mentor-takeaways-tp7-tp8.md`；pitch 可复用框架同时也在 `shared/assets/mcp-architecture-patterns/README.md`。**下次任何 mentor 反馈整合按此模式**。

### [2026-05-08] asset: wellness rule library (53 条 evidence-based 规则)
53 条 wellness detection rules / 11 类 / 带 confidence + 学术/临床来源 URL。从 NAISC Ripple 拆出，现位于 `shared/assets/wellness-rule-library/`（v2.xlsx 主 + v1 历史版 + visualization HTML + README）。**复用场景**：任何 wellness / health monitoring 产品需要用学术框架替代拍脑门阈值时调它。**战略价值**（仍然 durable）：用 evidence base 而不是自定义阈值，credibility play。

### [2026-05-08] insight: Whisper small 在静音/低音量段会强行造句
NAISC mentor 录音转录共 33 处 hallucination loop（最长 45 段 "我认识" 重复）。已确认特征：feature_extractor `RuntimeWarning: divide by zero / overflow / invalid value in matmul` 出现时，对应输出段几乎都是某个短语或字符的密集重复。**未来对真实嘈杂录音转录，必须做后处理折叠**（不是单看转录就信）。**算法 spec**（双重判据折叠：连续段落主导 2-char ngram ≥ 30% + 单段内 2-6 字串重复 ≥ 3 次且占比 > 50%；保守，会漏不会错杀）在 `shared/assets/whisper-hallucination-cleanup/README.md`。原 `/tmp/clean_transcript.py` 已丢失（/tmp 重启清空），按 spec 重写即可；建议同时换 mlx-whisper 或 large model 减少幻觉源头。

### [2026-05-04] insight: MCP 是 model-LLM 的天然解耦层
LLM **永远不"读"模型**，LLM 读模型的 structured output。模型对 LLM 来说就是 function call —— 可以是 1 KB 的 logistic regression、70B 参数 fine-tuned LLM、甚至一段 if/else。LLM 看到的只是 `tool_name + input_schema + output_schema`。这意味着 ML 路线对 MCP-based 系统是**零迁移成本**：今天用 z-score baseline，半年后训了 model 把 implementation 换掉，agent 端 / pitch 故事不用改一行。所以"上不上 ML"不是工程问题，是商业 / 阶段问题。这个认知对未来任何 agent + ML 项目都适用。

### [2026-05-04] insight: 给 ML tool 的 output schema 决定 LLM 用得多好
给 LLM 的输出 = 给一个聪明实习生的报告。坏：`{"score": 0.73}`（信息丢失）；好：score + scale + vs_personal_baseline + key_drivers + confidence_interval + model_version 全写明。这层做好，就算 model 只是 logistic regression，效果都好过返回纯 number 的神经网络。**未来任何 MCP tool 暴露统计 / ML 结果时都按这个标准**。

### [2026-05-04] insight: agent 系统"实时性" = prediction freshness 而非 tool latency
Tool call latency 20-300ms 不是瓶颈。真问题是 **prediction freshness** —— 预测基于多新的数据，取决于上游数据流 + retrain 频率。MCP 不引入延迟。"实时让 LLM 读懂"在 MCP 范式下根本不存在。**未来再讨论 agent 系统的"实时性"时，先把这两个维度分开**。

### [2026-05-04] verified: Lanyard 是接 Discord presence 实时数据的最快路径
公开服务 https://discord.gg/UrXF2cfJ7F（旧的 discord.gg/lanyard 已失效）—— 用户加群一次，自动监控。Gateway WebSocket + REST 都有。实测从游戏开始到事件到达 5-15 秒（Discord 客户端轮询本地进程的固有延迟）。免去自建 bot 的 Developer Portal 配置 / GUILD_PRESENCES intent / token 管理的所有烦恼。Trade-off：依赖第三方 uptime；**但对 hackathon / MVP 阶段是首选**。长期可换成自建 bot，listener 接口不动。

### [2026-05-04] verified: Discord API 实时-only，无历史
Discord 服务端不存 presence 历史。给 user_id 只返回"此刻在干嘛"。要历史只有自建 listener 持续监听 + 写自己的库。Lanyard 也不存历史，只是实时转发。**任何"过去 N 天 user 在哪些 app 上花了多少时间"的需求都必须从今天开始积累**。Steam / Spotify / Last.fm 有自己历史 API（粒度不同），其它平台基本没。

### [2026-05-04] correction: hackathon vs 融资是不同的话题
我（Claude）一开始把 5/22 NAISC 决赛准备 framing 成像 VC pitch ——讨论 moat / 抄袭风险 / FDA liability / actuarial-grade evidence。用户 pushback 明确：这是 hackathon 不是融资。这些话题是 5/22 之后才有意义的。**对类似 student / hackathon 项目，要先校准对方的"游戏定义"再下架构判断**。给的是不是对方需要的，决定整段对话有不有价值。

### [2026-05-04] preference: 用户对 spike 的态度
用户明确反对 "spike 一下试试" 类的小规模代码探索。理由：能直接问的就直接问（mentor / 文档 / Claude 直接判断）。spike 浪费时间且常常验证不到关键问题。这条对未来任何架构讨论适用 —— **当我想说"我们 spike 一下" 之前，先问"这个未知能不能直接问出来"**。

### [2026-05-04] historical: Discord listener 已停（2026-05-25）
NAISC Ripple 期间在 Mac Mini 后台运行（PID 48771，2026-05-03 nohup detached → killed 2026-05-25 pivot）。Lanyard WebSocket → Node listener → Supabase (3 表 + 1 view) → Vercel API endpoint 全链路曾跑通，捕获真实 Discord presence 数据。**源代码 + Supabase schema + 复用指引 + 重启说明**都在 `shared/assets/discord-presence-listener/README.md`。Supabase 数据 + schema 保留不动；重启 listener 直接对接现有表即可。

### [2026-04-20] correction: "每 5 min auto sync" 不等于 iOS 真的每 5 min 跑
用户之前笃信 HAE 设置 "每分钟/每 5 分钟" 就会定时推。真相：HealthyApps 官方文档明确 iOS 锁屏禁访 HealthKit + 后台调度 iOS 决定而非 app 配置决定。UI 让你设是让你表达期望，实际跑多少取决于 iOS 心情。实测 Recipe 1 最近 30 天只有 24 job（~0.8/day），4/18 后零触发。凡是涉及 "iOS app 自动推" 的诉求，要先承认"延迟几分钟 + 手机解锁 + 充电中"这三个前置，不是真实时。

### [2026-04-20] verified: Workato 平台 CodeMirror 自动化的边界
Workato 表单里的 CodeMirror **不是标准 CM** —— preview 状态下 JS `cm.setValue()` / `replaceSelection()` 改显示但 Angular 表单绑定不认，blur 后回退。
**真正能做的**：`document.execCommand('insertText', false, text)` 对**已激活的**真 CM 持久写入（URL 字段 Save + reload 后还在）；dropdown / 按钮 / view 切换 JS 全部能驱动。
**真正不能做的**：preview 状态下 click / focus / mousedown / pointerdown synthetic event 全部唤不醒真 CM —— Workato Angular 对 `isTrusted` 加 gate。
**结论**：Workato 表单 JS 自动化只能做到"半自动 + 用户手粘 CM"，不能全程 JS。**下次想全自动，走 Workato REST API（clone/import recipe）而非 UI 死磕**。
**回滚招**：Workato Versions 标签页 → 点版本号（如 "3 2026-04-19 09:26"）→ 右上"恢复此版本" → "是"。recipe 坏了用这招（亲测）。

### [2026-04-19] correction: evidence-of-working ≠ pipeline-works-end-to-end
构建 agent / pipeline 产品时，watchdog / 24h 轮询 / 局部 demo **不能等同于"端到端 live pipeline 跑通"**。用户视角的完整路径（trigger → action）必须显式画出来再分步实现，否则会出现"我做了很多东西，但用户视角看不到流程"的情况。**下次构建 agent 产品先画 trigger-to-action 完整路径**。NAISC 案例：watchdog 跑通 ≠ 手表检测→触发→WhatsApp 通知整链路跑通，用户立刻指出 framing 错误。

### [2026-04-17] spike: TemplateApp ONLYOFFICE CE 限制 spike 验证
实战 spike 推翻了 IFSG 团队报的 CE plugin 限制：`PasteText` + `{{tag}}` 在 CE iframe 100% 可用（特殊字符字面保真，docxtpl 对 run-splitting 鲁棒）；**`callCommand` + `Api.*` 未被 sandbox 锁**（含 `Api.CreateBlockLvlSdt` 插 SDT，不需要 Developer Edition）；`GetSelectedText` 弃用改 `callCommand + GetRangeBySelect()`；CE 默认 `allowPrivateIPAddress: false` 阻塞 docker 私网，部署要 patch `default.json`。细节见 sub-MD。

### [2026-04-17] architecture: TemplateApp Phase 1/2 架构规划完成
Linda brief：建独立于 IFSG 的通用 template/CSV/RAG 审阅 app。8 轮对话 + 代码扫描锁定全部架构决策（React + Node/Express/Sequelize/PostgreSQL + docker-compose + 独立 JWT + 业务表 owner_id + ONLYOFFICE 照搬 IFSG；IFSG 的 `template.controller.js`/`onlyoffice-plugin/` 等全套可搬，财报业务模型全弃）。完整 plan 与决策表见 sub-MD（05-23 pivot 后部分作废，以 pivot 决策为准）。
→ sub-MD: [TEMPLATEAPP.md](projects/templateapp/TEMPLATEAPP.md)

### [2026-04-17] preference: Claude 作为架构顾问的协作模式验证
本次 TemplateApp 规划完整走了 §3 里 Claude 的定位：**不生成代码方案，只做架构对抗 + 追问被省略的决策 + 按严重程度排序指出问题**。用户的节奏是"你问我答"，每轮 3-4 个决策，直到架构完全闭合再让我动手扫代码。用户明确反对"我给你一个方案你挑着改"这种模式，他要的是"我先想清楚每个决策，你帮我列出决策空间和 trade-off"。下次类似规划任务沿用此模式：先问决策、再扫代码、再 Plan agent、再写 plan 文件，不跳步。

### [2026-04-13] infra: Hermes 工具链建设
本次会话建立了 Hermes 的完整工具链：
- **AI Daily Digest**: 每日 08:00 自动采集 HN/RSS/ArXiv/GitHub trending → LLM 生成个性化 AI 日报 → 存入 `06 - Auto/AI Digest/`。Cron job ID: 9bb0519ba199
- **抖音转录**: `~/.hermes/scripts/transcribe.py` + `douyin-venv/`，faster-whisper 本地推理，带时间戳 + Speaker 标注 → 事实核查 → AI 分析 → 存入 `06 - Auto/Transcripts/`
- **日记模板**: 5 栏 (Health/Mood/Log/AI/Misc)，Mood 栏 1-10 打分追踪情绪曲线，AI 栏每条带时间戳
- **Obsidian CLI**: `/usr/local/bin/obsidian`，Hermes 可通过 CLI 操作 Vault (读写/搜索/属性/任务/插件管理)
→ vault: HOME

### [2026-04-13] correction: 第一手来源原则
验证信息时不能只靠本地测试。每次遇到可验证声明，先想：这个信息的源头在哪？直接去那里查。本地跑不通可能是版本/权限/地区限制，不等于不存在。已写入 douyin-transcribe skill 和 AI Digest cron prompt。

### [2026-04-13] infra: Obsidian Vault 外置大脑建立
三层记忆体系建立：CLAUDE.md/Hermes memory（轻量指针）→ Obsidian Vault（重内容）。Vault 路径用 `Vault/` 占位（默认 `~/Documents/Obsidian Vault/`，跨机器可变），PARA 变体结构，含时间线和项目笔记。Hermes 可自动写入 `Vault/06 - Auto/`。详见 §0.7 路径协议。→ Vault: HOME.md

### [2026-04-03] (moved) architecture: MoyuanIdea V2 第一轮架构审查
6 个攻击点 / 用户接受 2（缺技术架构 + Phase 1 需切割）/ 反驳 4（零代码有意 / 三端不过度设计 / AI 成本 / 有帮手）/ 下一步 = 最小垂直切片。**全文在** [MOYUAN.md](projects/moyuan/MOYUAN.md) "架构审查记录" 段。

### [2026-04-03] correction: 零代码不是老模式的重演
我曾判断仓库全是 markdown 没有代码是用户"做到能跑就停"模式的又一次重演。用户纠正：这次是有意识地先做线下调研（跟老师、家长、学生聊），再写规划文档，是反过来的——先搞清楚再动手。这是好的改变，不应该被归入旧模式。
**→ 跨期联动**：[2026-05-25] frame shift 进一步验证用户"先调研 / 重新校准赛道"的方向调整能力。从 2026-03 "先调研再写"到 2026-05 "重新校准核心赛道"（架构降级 / 营销升级），是同一个能力的升级体现，**不应误读为"摇摆"**。

### [2026-04-03] decision: Claude 生态基础设施方案确定
选择三层方案：(1) CLAUDE.md 作为跨会话持久化的 context 文件（手动 backup）；(2) memory skill 自动管理记忆写入（已打包 memory.skill）；(3) scheduled task 每周日 22:00 自动做记忆整理（memory-heartbeat，只写 proposal 不直接改文件）。用户明确要求：不需要复杂，但必须有效、可查问题、可迭代。

### [2026-04-03] preference: 用户对 Claude 生态的定制化期望
用户把 Claude 定位为架构对抗审查者，不是代码生成器。期望 Claude 的 infra 能自动维护上下文记忆（类似 Codex YoRHa 的 MEMORY.md），但用 Claude 自己的生态（skill + MCP + scheduled task）实现，不照搬 Codex 架构。
**→ 跨期联动**：[2026-05-25] frame shift 后 Claude 的定位从单一"架构对抗审查者"演化为 **5 模式系统**（chat / code / architecture-review / content / memory，见 §9）。"架构对抗"现在是 mode 之一，不再是 default。本条体现 Claude 生态定制化的方向**没变**，颗粒度演进。

# CLAUDE.md — Geng Yue (耿越) Context File

> **用途**：每次新会话开始时，Claude 自动读取本文件。这是整个 harness 系统的入口。
> **维护**：§0 和 §1-7 由用户维护，§8 由 memory skill 自动追加。
> **最后更新**：2026-05-08（mentor 综合 + 14-day ship list + rule library v2）

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
│       └── TODO.md                    ← 占位，暂不实现
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

### 0.7 外置大脑（Obsidian Vault）

**路径**：`~/Documents/Obsidian Vault/`（各机器 setup.sh 负责检查 Obsidian 是否已安装）

Obsidian Vault 是三层记忆体系的底层——存放重内容。关系：

| 层级 | 存储位置 | 内容类型 |
|------|----------|----------|
| CLAUDE.md §8 / sub-MD | claude-context 仓库 | 轻量指针、决策摘要、纠正 |
| Hermes memory | ~/.hermes/ | 轻量指针、偏好 |
| **Obsidian Vault** | ~/Documents/Obsidian Vault/ | 详细笔记、项目记录、时间线、知识沉淀 |

当内容超过几句话、不适合写入 §8 或 sub-MD 时，写入 Obsidian，然后在此处留指针：`→ vault: 笔记名`

**Vault 目录结构**：
- `00 - Inbox/` — 快速捕获
- `01 - Projects/` — 活跃项目（IFSG, SBS Transit, MoyuanIdea, NAISC Workato, Hermes）
- `02 - Areas/` — 持续领域（Career, Finance, AI-ML, Dev Skills, Culture）
- `03 - Resources/` — 参考资料
- `04 - Archive/` — 已结束项目/比赛
- `05 - Journal/` — 日志（年/月/周/日四层嵌套：`YYYY/MM/W??/YYYY-MM-DD.md`）
- `06 - Auto/` — Hermes 自动写入（frontmatter `source: hermes`）

**来源标注**（frontmatter `source` 字段）：无 / `human` = 用户写的 | `hermes` = Agent 自动 | `claude` = Claude 辅助 | `import` = 批量导入

**入口**：`HOME.md`（索引）、`Timeline.md`（时间线）、`Journal MOC.md`（日志）

---

## 1. 基本信息

- **姓名**：Geng Yue（耿越），英文名 Tommy Chen
- **邮箱**：tommychen030607@gmail.com
- **GitHub**：https://github.com/yorhagengyue
- **所在地**：新加坡
- **学校**：Temasek Polytechnic（淡马锡理工），IT 专业，Y2 → Y3，即将进入实习
- **主力开发工具**：OpenAI Codex (GPT-5.4)；Hermes Agent（主力 agent 系统，替代 YoRHa/Moltbot）；Claude Code CLI（CTO 顾问角色）
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

## 3. 核心成长目标

**结论：我的核心缺口不是产出能力，而是架构判断力。**

根本原因：2024-11 起步至今依赖 AI 生成代码和架构，16 个月 25+ 个项目每 1-2 月换方向，全部停在"能跑"阶段，从未走到需要重构/处理耦合/偿还技术债的阶段。同时大量时间投入 AI 工具链元系统（YoRHa），而非业务架构实践。2026-03 开始有意识改变——MoyuanIdea V2 先线下调研再写规划。
→ 详见 [§6 学习轨迹](#6-学习轨迹)

**我需要练的具体能力：** schema 预判（什么查询会慢、什么关系会断）、API 评估（并发问题、抽象层级）、模块边界判断（耦合预判）、重构路径选择（trade-off 决策）。

**Claude 在我工作流里的定位**

我的主力代码生产工具是 OpenAI Codex（GPT-5.4），它负责写代码、执行任务、跑 agent 流程。Claude 不是第二个 Codex，不是代码工具。

Claude 的角色更接近一个 CTO 顾问——不写代码，但负责审查架构、质疑决策、维护跨会话的上下文记忆。具体职责：

- **架构对抗审查**：我会把 AI 生成的架构方案拿过来让 Claude 攻击——找真实场景下的崩溃点、隐含假设、优雅陷阱。我来判断哪些是真问题。这个"攻击→判断→复盘"的循环是我练架构判断力的核心方式。
- **重构陪跑**：当项目走到需要重构的阶段，给 2-3 条路径 + trade-off，让我选，选后陪跑，一个月后复盘当时的选择对不对。
- **上下文记忆维护**：通过 CLAUDE.md（主索引）+ sub-MD（项目速报）的 hub-and-spoke 结构，确保每次新会话不从零开始。Claude 负责在会话结束时把值得记住的东西写入记忆系统。
- **认知校准**：当 Claude 的判断有误，我会纠正。纠正后写入记忆（correction tag），避免跨会话重复犯同样的错。

**Claude 要保证的**：诚实、不讨好、不替我做决定。如果我的设计有问题，直接说。可以质疑我的判断，但最终决定权在我。

**Claude 不能做的**：不要主动生成代码方案除非我明确要求；不要在我还没理清问题的时候急着给解决方案；不要把产品愿景当成技术架构来讨论——如果我给的是愿景，先指出这一点。

**讨论架构时的行为准则**：追问被省略的决策（"用 Next.js"不够，要说为什么选以及接受什么 trade-off）；用具体场景攻击而非抽象原则；按严重程度排序，不要一次倾倒所有问题。

**关于 sub-MD（项目速报）**：每个活跃项目有独立的 sub-MD 文件（如 [MOYUAN.md](projects/moyuan/MOYUAN.md)），存放该项目的详细上下文——系统定义、架构审查记录、决策历史、当前阻塞点和下一步。CLAUDE.md §5 的项目索引表只记一句话状态和指向 sub-MD 的链接。当会话涉及某个具体项目时，Claude 应该主动读取对应的 sub-MD 获取完整上下文，而不是只靠主文件的一行概要。项目相关的记忆条目写进 sub-MD 而非主文件 §8；主文件 §8 只存跨项目的决策、偏好、纠正。

## 4. 技术能力画像

**前端**：React（主力）、Next.js、Angular、Vue、Flutter/Dart、Three.js
**后端**：Express/Node.js、FastAPI/Python、基础 Prisma/Sequelize ORM
**AI/ML**：PPO 强化学习、基础 ML pipeline、LLM prompt engineering、agent 架构设计
**DevOps**：基础 Nix、Docker/Arion、Cloudflare Pages 部署
**弱项**：数据库设计（schema 决策）、系统级架构（服务边界、数据流、状态管理）、重构实践

## 5. 项目索引

| 项目 | 状态 | 一句话 | 详情 |
|------|------|--------|------|
| **Ripple (NAISC Workato)** | 决赛入选 (5/22 pitch)，14 天 ship list | MCP-orchestrated wellness data pipeline · 53-rule evidence library · Discord context fusion · pre-processed data spine（非 agent） | → [NAISC.md](projects/naisc-workato/NAISC.md) |
| **MoyuanIdea** | 愿景→架构 | AI-native 文化教育系统，三端，正在做技术架构决策 | → [MOYUAN.md](projects/moyuan/MOYUAN.md) |
| **IFSG** | 进行中 | 企业级财务报表生成器，Angular+Nix+PostgreSQL，4人团队 | 仓库私有 |
| **TemplateApp** | 🚨 Pivot 为 agentic AI 论文项目 (5-23) | Frontend 9 屏已 scaffold；Python LangGraph agent service + Node gateway 待建；Linda 邮件要 publishable paper，含 Live Data Binding + LLM-as-Judge 创新点 | → [TEMPLATEAPP.md](projects/templateapp/TEMPLATEAPP.md) / [HANDOFF.md](projects/templateapp/HANDOFF.md) |
| **SBS Transit** | 进行中（最活跃） | SBS Transit 多仓库项目，Phase2+Webapp+WhisperAPI+GenAI | → vault: SBS Transit - Overview |
| **Hermes** | 主力 agent 系统 | 替代 YoRHa/Moltbot，集成 Gmail/Calendar/GitHub/Obsidian | → vault: Hermes - Overview |
| **Slay the Spire 2 AI** | 半成品 | PPO + 遗传超参数进化，离自主打游戏还有距离 | GitHub/slay_the_spire |
| **YoRHa** | 搁置 | Codex agent 框架，已被 Hermes 替代 | 本地 ~/Desktop/YoRHa |

## 6. 学习轨迹

- **2024-11**: 起步，HumanITy（React+Node+MySQL）
- **2025-02**: Huawei Smart City（Next.js+Prisma+PostgreSQL）
- **2025-04~07**: HSBC Hackathon（React+FastAPI+Gemini）
- **2025-08~11**: 商业网站、Flutter、文化 AI 测试
- **2025-10**: Tu2tor 全栈协作（MERN+WebSocket+CRDT+RAG）——技术复杂度最高
- **2026-01**: 个人网站 Three.js 塔罗牌
- **2026-02**: ML 课程、Codex agent 框架搭建
- **2026-03**: MoyuanIdea V2、Workato 实习、YoRHa 完善
- **模式**：每 1-2 月换方向，做到"能跑"就停。正在有意识改变。

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

## 8. 记忆追加区

> 由 memory skill 自动追加，按时间倒序。

### [2025-05-23] 🚨 project: TemplateApp — Agentic AI Pivot（重大方向转向）
Linda William 邮件（她 5/13-5/27 离岗中）要求把 TemplateApp 从"通用文档生成器产品"重构成 **publishable agentic AI 研究项目**：既要代码也要论文。两个论文 contribution：**Live Data Binding**（数据变 → 文档自动重生成）+ **LLM-as-Judge**（自动质量门，Fail → 反馈给 Writer 改写）。要研究 LLM-as-Judge 评估技术（criteria × technique × performance × time）并编辑她的 paper draft。

**锁定决策（5/23）**：
- LangGraph 主框架；CrewAI + LangChain 各做 prototype，论文里写**3 框架对比**
- LLM 矩阵：Frontier (Opus/GPT-4) + Mid (Sonnet/4o) + Small (Haiku/4o-mini) + Local (Llama 3.2 3B / Qwen 2.5 3B / Phi-3-mini)。**论文写 Cost-Performance Analysis** + Pareto 前沿
- **ONLYOFFICE 整个扔掉**（不在 agentic loop，weight 不值）。Template 改 upload-only docx
- **Backend hybrid**：Python FastAPI agent service + Node Express gateway
- 前端 9 屏保留，加 Agent Timeline 视图，drop localStorage 接真 API
- 数据绑定用 lazy invalidation + manual refresh，event-driven 留 Phase 2
- Judge 输出 JSON schema (`pass/score/criteria_breakdown/revision_hints`)
- 长期项目，无 deadline

**W1 文献综述（5-23 已完成）**：8 个 judge 技术 + 1 个 survey 全部拉真 PDF 抓 Table 数字。关键发现：(1) **AlignScore 355M RoBERTa 反超 GPT-4 on QAGS-XSum**（57.2 vs 53.7）——data consistency 维度最强匹配；(2) **G-Eval 有 LLM-self-preference bias**（自己评高分），论文要 disclose；(3) **FactScore 只测 precision 不测 recall**，不解决 Completeness；(4) **没有单一 technique 覆盖全部 5 维**，paper 推荐 combo（AlignScore + G-Eval/Prometheus 2 + deterministic format check）。结果存在 `vault/01 - Projects/TemplateApp/research/group-{a,b}-judge-techniques.md`。

**跨项目可复用洞察**（同 NAISC 5-08 mentor 反馈共振）：**LLM-as-Judge 多 agent 分层**这套 NAISC 也在用——Process → Validate → Communicate，每层 short prompt + low temp。TemplateApp 这次的实证（哪个 technique 准、哪个便宜）可以直接喂给 NAISC 的 deck Q&A 答辩话术，反之 NAISC 的 production 经验也回流到 TemplateApp 选 judge prompt 模板。

**新建文件**：
- `~/.claude/plans/eager-humming-crown.md` — 新权威 plan（原 `shimmying-dreaming-naur.md` 部分作废）
- `vault/01 - Projects/TemplateApp/HANDOFF.md` — 新会话接手用，**极度具体**（时间线/决策表/文件地图/启动步骤/Claude 角色/Linda 待答问题）
- `vault/01 - Projects/TemplateApp/PIVOT-2025-05-23.md` — 本次 pivot 决策记录
- claude-context 全镜像（PLAN + HANDOFF + PIVOT + 更新 TEMPLATEAPP.md）

→ sub-MD: [TEMPLATEAPP.md](projects/templateapp/TEMPLATEAPP.md) · [HANDOFF.md](projects/templateapp/HANDOFF.md)

### [2025-05-23] correction: subagent 默认没 WebSearch/WebFetch 权限
跑 W1 文献综述时启了 2 个 general-purpose subagent 做并行研究，但 subagent 默认拒 WebSearch + WebFetch。用户开了 bypass 后重启 subagent 才正常。下次给 subagent 派"研究"任务时记得：(1) 父 session 的 WebSearch 工具不会自动继承给 subagent；(2) 要么提前确认 bypass，要么父 session 直接做研究不 delegate。

### [2026-05-08] mentorship: TP7 (Colin) + TP8 (Workato/business) 双 session 综合
两位 mentor 答疑后的 distilled action implications：(1) 最大 deck gap = 3-layer architecture diagram（ingestion / processing / communication + governance overlay，macro→micro 叙事）；(2) 评审权重：idea > tech depth；end-to-end live demo > 架构 slide；business 层薄薄一层（"small bit weight"）；(3) Q&A "AI 出错"答辩组合拳——**LLM-as-judge 多 agent 分层**（process→validate→communicate，每层 short prompt + low temp，TP8 mentor 在生产中跑过）做主答；Colin 的 RLHF 反馈飞轮做副答；(4) **Cursor 类比作为 "why now" 最强 pitch line**——build the thing before the model is capable，pipeline ready 后下一代 model 直接 plug in；(5) Ripple 重新定位：**不是 AI agent，而是 pre-processed data pipeline**——任何 agent (Hermes/Cursor/未来 GPT-N) 都可以接，"agents 大家都在做，data spine 没人做"；(6) Colin: **one scenario, you fighting in time**——专注一个 demo 场景做透（gaming + Discord + R043），别铺开；(7) Colin: 借 NUS HSS 既有学术框架（loneliness/isolation/stress measurement matrices）替代自己拍脑门定阈值——这是 credibility play；(8) data flywheel 是 moat 答案——"first 10000 users 就是 the model"。
**未来涉及任何 hackathon/竞赛 mentor 反馈整合时按此模式**：raw transcript 留 Obsidian、distilled takeaways 进 sub-MD、跨项目可复用的洞察（如 LLM-as-judge / Cursor analogy / data flywheel framing）写 §8。
→ [NAISC.md](projects/naisc-workato/NAISC.md) · [mentor-takeaways-tp7-tp8.md](projects/naisc-workato/mentor-takeaways-tp7-tp8.md)

### [2026-05-08] decision: NAISC 14-day ship list 锁定（5/8 → 5/22）
~45h 总预算 / 14 天 ≈ 3h/day。**MUST**: 接 R006（睡眠+HRV+RHR 复合恢复，30s demo）+ R043（深夜手机 → 次日睡眠下降，绑 Discord listener，differentiator）入 Workato；deck 重做 4-5 张新片（3-layer 架构 / ingestion 连接器 / processing+rule library / communication channels / Cursor "why now" / 薄商业层）；录 R043+Discord live demo 视频（90s 真数据）；Q&A 答辩准备（LLM-as-judge 主 + RLHF 副 + data flywheel + evidence-base citations）。**STRETCH**: R048（6-signal whole-body shift，依赖 wrist temperature 数据流通）；prod-deploy 3 个 Discord API endpoint（如果 live demo 需要会升 MUST）。**DROP（5/22 之后）**: launchd plist；Calendar/Obsidian context source 接入；ML 模型训练（locked off）。架构已 shipped & stable，14 天内**不建新基础设施**——只 deck + demo rehearsal + Q&A prep。
→ [NAISC.md](projects/naisc-workato/NAISC.md) "14-day ship list" 段

### [2026-05-08] asset: Ripple rule library v2 入库
53 条 evidence-based detection rules / 11 类（acute strain / daily recovery / training / fitness trend / sedentary / mobility / fall / hearing / circadian / digital wellbeing / multi-signal composite），每条带 confidence + 学术/临床来源 URL。Top 10 demo-ready 已预筛。当前接线决策：**R006 必接**（信号都在）+ **R043 必接**（差异化，绑 Discord）+ **R048 拉伸**（依赖 wrist temperature）。其余 ~50 条作为 deck "evidence base" slide 的内容，不全部接线（Workato trial 任务配额扛不住）。**战略意义**：(1) 解决 Colin "借现有学术框架而非自定义阈值" 的 feedback；(2) "evidence base" 单独成 slide，地方上看着可信；(3) 处理层（layer 2 of 3-layer arch）的 backbone。文件位置：`shared/projects/naisc-workato/rule-library/`（v2.xlsx + v1.xlsx 历史版 + visualization HTML + README 索引）。源头是 WeChat 收到，现已脱离 wxchat 容器路径做了 portable copy。
→ [rule-library/README.md](projects/naisc-workato/rule-library/README.md)

### [2026-05-08] project: NAISC mentor 会议录音转录入库
5/22 决赛前 mentor 答疑会，2 段录音（TP7 32 min + TP8 35 min = 67 min）已转录并清理 Whisper 幻觉循环（TP7: 994/1054 段保留 + 12 处 ⚠️；TP8: 1362/1477 段 + 21 处 ⚠️），写入 Obsidian `01 - Projects/Workato NAISC/transcripts/`。Whisper small 双语支持差，被强制识别为 zh 概率 1.000；中英切换段落语义有损，需对照 SRT 时间戳读。Mentor 建议初步线索（**未与用户复盘前不当决策依据**）：往 community / family circle 方向改、判定 Ripple 是 product 强 / technology 普通。
→ [NAISC.md](projects/naisc-workato/NAISC.md) · "## [2026-05-08] Mentor 会议录音 + 转录" 段

### [2026-05-08] insight: Whisper small 在静音/低音量段会强行造句
TP7/TP8 转录共 33 处 hallucination loop（最长一段 TP8 15:20-16:08 是 45 段 "我认识" 重复）。已确认特征：feature_extractor `RuntimeWarning: divide by zero / overflow / invalid value in matmul` 出现时，对应输出段几乎都是某个短语或字符的密集重复。**未来对真实嘈杂录音转录，必须做后处理折叠**（不是单看转录就信）。已写出 `/tmp/clean_transcript.py`，靠"连续段落主导 2-char ngram >= 30%"+"单段内 2-6 字串重复 >= 3 次且占比 > 50%" 双重判据折叠 — 阈值偏保守，会漏不会错杀，可按需调紧。

### [2026-05-04] insight: MCP 是 model-LLM 的天然解耦层
LLM **永远不"读"模型**，LLM 读模型的 structured output。模型对 LLM 来说就是 function call —— 可以是 1 KB 的 logistic regression、70B 参数 fine-tuned LLM、甚至一段 if/else。LLM 看到的只是 `tool_name + input_schema + output_schema`。这意味着 ML 路线对 MCP-based 系统是**零迁移成本**：今天用 z-score baseline，半年后训了 model 把 implementation 换掉，agent 端 / pitch 故事不用改一行。所以"上不上 ML"不是工程问题，是商业 / 阶段问题。这个认知对未来任何 agent + ML 项目都适用。

### [2026-05-04] insight: 给 ML tool 的 output schema 决定 LLM 用得多好
给 LLM 的输出 = 给一个聪明实习生的报告。坏：`{"score": 0.73}`（信息丢失）；好：score + scale + vs_personal_baseline + key_drivers + confidence_interval + model_version 全写明。这层做好，就算 model 只是 logistic regression，效果都好过返回纯 number 的神经网络。**未来任何 MCP tool 暴露统计 / ML 结果时都按这个标准**。

### [2026-05-04] insight: Ripple 实时性的真相是 prediction freshness 而非 tool latency
Tool call latency 20-300ms 不是瓶颈。真问题是**prediction freshness**——预测基于多新的数据，取决于上游数据流 + retrain 频率。MCP 不引入延迟。"实时让 LLM 读懂"在 MCP 范式下根本不存在。**未来再讨论 agent 系统的"实时性"时，先把这两个维度分开**。

### [2026-05-04] verified: Lanyard 是接 Discord presence 实时数据的最快路径
公开服务 https://discord.gg/UrXF2cfJ7F（旧的 discord.gg/lanyard 已失效）—— 用户加群一次，自动监控。Gateway WebSocket + REST 都有。实测从游戏开始到事件到达 5-15 秒（Discord 客户端轮询本地进程的固有延迟）。免去自建 bot 的 Developer Portal 配置 / GUILD_PRESENCES intent / token 管理的所有烦恼。Trade-off：依赖第三方 uptime；**但对 hackathon / MVP 阶段是首选**。长期可换成自建 bot，listener 接口不动。

### [2026-05-04] verified: Discord API 实时-only，无历史
Discord 服务端不存 presence 历史。给 user_id 只返回"此刻在干嘛"。要历史只有自建 listener 持续监听 + 写自己的库。Lanyard 也不存历史，只是实时转发。**任何"过去 N 天 user 在哪些 app 上花了多少时间"的需求都必须从今天开始积累**。Steam / Spotify / Last.fm 有自己历史 API（粒度不同），其它平台基本没。

### [2026-05-04] correction: hackathon vs 融资是不同的话题
我（Claude）一开始把 5/22 NAISC 决赛准备 framing 成像 VC pitch ——讨论 moat / 抄袭风险 / FDA liability / actuarial-grade evidence。用户 pushback 明确：这是 hackathon 不是融资。这些话题是 5/22 之后才有意义的。**对类似 student / hackathon 项目，要先校准对方的"游戏定义"再下架构判断**。给的是不是对方需要的，决定整段对话有不有价值。

### [2026-05-04] preference: 用户对 spike 的态度
用户明确反对 "spike 一下试试" 类的小规模代码探索。理由：能直接问的就直接问（mentor / 文档 / Claude 直接判断）。spike 浪费时间且常常验证不到关键问题。这条对未来任何架构讨论适用 —— **当我想说"我们 spike 一下" 之前，先问"这个未知能不能直接问出来"**。

### [2026-05-04] project: NAISC Discord context source 集成 v1
5/3-5/4 一晚跑通：Lanyard WebSocket → Node listener (`scripts/discord-listener/listener.mjs`) → Supabase (3 张表 + 1 view) → 3 个 Vercel API endpoint (`/api/discord/{current,today,sessions}`)。真实数据已捕获（Apex / ELDEN RING / Slay the Spire II）。是 Forward Plan §2a "状态思考" 方向第一块拼图，原计划 5/8 mentor 后做，实际提前完成。**还差 prod deploy + launchd plist + Workato MCP tool 注册**，等 5/8 mentor 答案。
→ [Discord Integration · v1](projects/naisc-workato/discord-integration-v1.md)

### [2026-05-04] project: NAISC ML 策略想清楚 — 5/22 之前不训 model
决定：用 Pattern D (RAG/MCP) 而非 ABC（online/batch/fine-tune）。理由：(1) 数据不够（1 人 × 几个月 ≠ 训练集）；(2) prompt + RAG/MCP 已经能 95% 解决；(3) 训了过拟合，pitch Q&A 一问破。**Ripple 现阶段最强 pitch line**: "We don't train models today — but every Workato recipe is structured data capture by design. The MCP surface is the distribution layer for whatever models we train later. The first 10,000 users we sign up *is the model*." 真正上 ML 的最早合理时间点是 6-9 个月后，第一个该上 ML 的任务可能是"批量打 mood / context tag 给历史 anomaly"——但这取决于 5/22 之后是否继续做 Ripple。
→ [ML Strategy · Thinking Notes v1](projects/naisc-workato/ml-strategy-v1.md)

### [2026-05-04] correction: NAISC team 真实第三人是 Chen Yufei
Sarah Loke 4/24 finalist 邮件里 Team YoRHa 官方名单：**Geng Yue · Liu Zicheng · Chen Yufei**。但 trailer / 网站 / submission email 都写的 "Tommy Chen" 当第三个人 —— 那是把耿越的英文名（CLAUDE.md §1）当成另一个队员了。用户已知，是否回去改公开物（trailer/网站/email）尚未决定。**未来再涉及 Ripple 公开署名 / 介绍时按官方名单**。

### [2026-05-04] infra: Discord listener 当前在 Mac Mini 后台运行
PID 48771（启动于 2026-05-03 nohup detached）。监听 2 个 Discord ID，写 Supabase。**Mac 重启会丢**——launchd plist 待做。位置：`~/Desktop/Toffeemoon Design System/scripts/discord-listener/listener.mjs`。日志：同目录 `data/listener.log`。

### [2026-04-20] project: NAISC overnight session — Plan B 尝试 + 回退 + HAE 诊断 + 夜间 WA 循环
用户 01:30 把任务升级为"死磕到醒"。四条线：(1) Plan B Kimi chat 升级尝试，Workato CodeMirror JS 写入不走 Angular 绑定，blur 回退，回退 Recipe 8 到 echo baseline（稳）；(2) HAE 诊断：URL 对、Recipe 1 Active、curl 200 OK，但 healthlog 24h 0 行——iOS 后台调度把 HAE 掐了，4/18 起一次没成功触发；(3) Kimi prompt v2 调 12 case 全对（gaming/workout/medical/idk/startle/stress/caffeine/other/sarcasm），锁定；(4) 后台 bash loop PID 33026 从 03:10 起每 60 min 发 1 条 WA alert，共 5 条到 07:10，用户起床能看到约 6 条消息。
交付：morning_handoff/ 5 份可粘贴文档（Plan B 粘贴手册 / Demo V2 / Email / Prompt / Results）。
→ [NAISC.md](projects/naisc-workato/NAISC.md) / [morning_handoff/](projects/naisc-workato/morning_handoff/)

### [2026-04-20] correction: "每 5 min auto sync" 不等于 iOS 真的每 5 min 跑
用户之前笃信 HAE 设置 "每分钟/每 5 分钟" 就会定时推。真相：HealthyApps 官方文档明确 iOS 锁屏禁访 HealthKit + 后台调度 iOS 决定而非 app 配置决定。UI 让你设是让你表达期望，实际跑多少取决于 iOS 心情。实测 Recipe 1 最近 30 天只有 24 job（~0.8/day），4/18 后零触发。凡是涉及 "iOS app 自动推" 的诉求，要先承认"延迟几分钟 + 手机解锁 + 充电中"这三个前置，不是真实时。

### [2026-04-20] correction: Workato CodeMirror 不是标准 CM，JS setValue 不持久
CodeMirror 在 Workato 里是一层 preview，click 激活才生成真 CM 实例。调 `cm.setValue()` / `replaceSelection()` 能改显示，但 Angular 表单绑定不认，blur 后值回退。JS 驱动 Workato 表单唯一稳定路径：focus 一下让真 CM 出现 → user paste (Cmd+V) → Tab 离开触发提交。想做全自动粘贴需研究 ClipboardEvent + DataTransfer 路径（未验证）。

### [2026-04-20] correction + verified: Workato CM 全自动写入真相（深度实验）
02:25 用户让全自动化 Plan B。跑了 30 min 实验。
**能做的**：`document.execCommand('insertText', false, text)` 对**已激活的**真 CM 写入成功且持久（URL 字段 Save + reload 后还在）。dropdown/按钮/view 切换 JS 全部能驱动。
**不能做的**：**Body CM preview 状态下 click/focus/mousedown/pointerdown synthetic event 全都唤不醒真 CM**（等 5s 不起作用）。Save 后再次打开 step panel 也不响应。推测是 Workato Angular 对 `isTrusted` 加了 gate。
**副作用**：半途 Save 了残缺 step 2 → Recipe 8 不能 Start → 用 **Workato Versions 标签页 → 点版本号（如"3 2026-04-19 09:26"）→ 右上"恢复此版本" → 弹窗点"是"** 回滚。这招以后遇到坏掉的 recipe 必须记得用。
**教训**：Workato 表单自动化只能做到"JS 半自动 + user 手粘 CM"，不能真全程 JS。下次想全自动，先真用户交互一次建好模板 recipe，然后做 clone/import 路线（走 Workato REST API），别在 UI 死磕。

### [2026-04-19] project: Ripple (NAISC Workato) 两向 chat 上线，端到端 live pipeline 验证
完成了从 watch 检测 → 触发 → WhatsApp 提醒 → 用户回复 → bot ack 的完整 round-trip。8 个 Workato recipe 上线（bulk ingest / live spike / 24h watchdog / 4 个 MCP tool / 两向 chat bot）。真实 WhatsApp round-trip：用户发 "gaming" → 3 秒内收到 bot 回复，Twilio log 20:32:02 in → 20:32:05 out。
关键踩坑写进 sub-MD 知识沉淀：Twilio incoming 是 form-encoded（非 JSON）/ Reply To 必须用 pill / IF branch 语义坑 / Ruby formula 在 Workato 沙箱限制 / cloned recipe schema 缓存。
状态：技术实现完成；4/20 录 demo，4/23 发 submission email。
→ [NAISC.md](projects/naisc-workato/NAISC.md) / → vault: Workato NAISC/Implementation Log.md

### [2026-04-19] correction: Watchdog 不等于 live pipeline
用户纠正："我没看到 手表检测然后触发问题 然后通知 whatsapp 整个流程"。Watchdog 是 24h 轮询 seed data，不是实时链路。evidence-of-working ≠ pipeline-works-end-to-end，下次构建 agent 产品要先画 trigger-to-action 的完整路径再分步实现，避免出现"demo 没有从用户视角打通"的情况。

### [2026-04-17] spike: TemplateApp ONLYOFFICE CE 限制 spike 验证
同日下午跑了一个实战 spike 验证 IFSG 团队 4/15 报的 CE plugin 限制。起 `onlyoffice/documentserver:latest` 本地栈 + 自建最小插件 + docxtpl 合成测试，跑完 11 个按钮 + 6 个合成 case。

**H1/H2/H3 全 pass**。关键发现：
- `PasteText` + `{{tag}}` 在 CE iframe 100% 可用，所有特殊字符字面保真
- docxtpl 对 run-splitting 极端鲁棒（每字符 per-run 也能 render）
- **`callCommand` + `Api.*` NOT 被 sandbox 锁**——IFSG 报的 `mFa` 崩溃只在 `executeMethod("AddContentControl", ...)` 的 iframe-direct 路径。通过 `callCommand + Api.CreateBlockLvlSdt` 插 SDT 在 CE 是通的。**不需要 Developer Edition 授权**
- `GetSelectedText` focus-loss 确认，全面弃用，走 `callCommand + GetRangeBySelect()` 替代
- CE 默认 `allowPrivateIPAddress: false` 阻塞 docker 网络（私网 IP），部署要 patch `default.json`（不要 `:ro` mount，init chown 会 fail）

Plan M4 从"照搬 IFSG ~1000 行插件"改为"重写 ~150 行 PasteText + {{tag}} 方案"，Phase 2 保留 SDT 升级路径。Sub-MD 和 plan 文件都更新了。Spike 环境已 teardown。

### [2026-04-17] architecture: TemplateApp Phase 1/2 架构规划完成
Linda 2026-04-17 非正式 brief：建独立于 IFSG 的通用 template/CSV/RAG 审阅 app。经 8 轮对话 + 代码扫描锁定全部架构决策，Plan agent 输出完整 W1-W12 实施路径，等 2026-04-20 Linda 正式 brief 后开工。

**核心决策**：React + Node/Express/Sequelize/PostgreSQL + docker-compose（非 Nix+Arion）+ 独立 JWT（Identities 表支持多 provider）+ 所有业务表 owner_id（无 sub-firm）+ ONLYOFFICE 完整照搬 IFSG（换 plugin GUID）+ word-addin Phase 2 再做 + CSV 追加式版本化 + RAG v1 只做规则（知识走 skill 预留）+ Review JSON 主 markdown 副（Ollama + 修复重试）。

**代码复用判断**：IFSG 的 `template.controller.js`（900 行 ONLYOFFICE 集成）、`onlyoffice-plugin/` 目录、`auto-complete.controller.js`、`word-text-generation/` 全套是"宝矿"，直接搬；`report-generation/src/lib/table/*`（财报业务）全弃；`sub-firm`/`journal`/`cashflow` 等 IFSG 领域模型全不要。

**完整 plan**：`~/.claude/plans/shimmying-dreaming-naur.md`（包含 M1-M9 里程碑、数据模型、docker-compose 拓扑、风险、必读文件 12 个、验证清单、Linda brief 提问清单 5 条）
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
三层记忆体系建立：CLAUDE.md/Hermes memory（轻量指针）→ Obsidian Vault（重内容）。Vault 路径 `~/Documents/Obsidian Vault/`，PARA 变体结构，含时间线（年/月/周/日）和项目笔记。Hermes 可自动写入 `06 - Auto/`。详见 §0.7。→ vault: HOME

### [2026-04-03] architecture: MoyuanIdea V2 第一轮架构审查完成
对 V2 三份核心文档做了系统性架构攻击。六个攻击点中用户确认了两个真问题：(1) 文档是产品愿景不是技术架构，缺 schema/API/技术栈决策；(2) Phase 1 范围需要再切割。用户反驳了四个：零代码是有意的（先调研再动手）、三端基础设施不需要过度设计、AI 成本暂不考虑（老板说预算不是问题）、有帮手且时间灵活。下一步：从最小垂直切片（老师开课→拍作品→家长看到）开始做技术架构。

### [2026-04-03] correction: 零代码不是老模式的重演
我曾判断仓库全是 markdown 没有代码是用户"做到能跑就停"模式的又一次重演。用户纠正：这次是有意识地先做线下调研（跟老师、家长、学生聊），再写规划文档，是反过来的——先搞清楚再动手。这是好的改变，不应该被归入旧模式。

### [2026-04-03] decision: Claude 生态基础设施方案确定
选择三层方案：(1) CLAUDE.md 作为跨会话持久化的 context 文件（手动 backup）；(2) memory skill 自动管理记忆写入（已打包 memory.skill）；(3) scheduled task 每周日 22:00 自动做记忆整理（memory-heartbeat，只写 proposal 不直接改文件）。用户明确要求：不需要复杂，但必须有效、可查问题、可迭代。

### [2026-04-03] preference: 用户对 Claude 生态的定制化期望
用户把 Claude 定位为架构对抗审查者，不是代码生成器。期望 Claude 的 infra 能自动维护上下文记忆（类似 Codex YoRHa 的 MEMORY.md），但用 Claude 自己的生态（skill + MCP + scheduled task）实现，不照搬 Codex 架构。

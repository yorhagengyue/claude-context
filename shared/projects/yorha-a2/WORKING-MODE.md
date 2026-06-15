---
project: YoRHa-A2
type: 团队工作模式手册（从属 ../../CLAUDE.md 个人主宪法）
last-updated: 2026-06-02
read-order: 1 (YORHA-A2.md hub) → 2 (本文件 工作模式) → 3 (sub-projects/* 各子项目状态板) → 4 (Vault/01 - Projects/YoRHa-A2/short-video/framework/*)
goal: conversion-site (咨询网站)
sub-projects: sub-projects/{conversion-site,short-video,ai-interactive-story}.md
---

# YoRHa-A2 · 团队工作模式（阶段性项目 · 从属个人主宪法）

> **本文件目的**：一个新进来的 Claude / 队友 / 未来的我，读完这一份就懂 YoRHa-A2 这个阶段性项目怎么运转 —— 为什么做、目标是什么、三人怎么结合、怎么参与。
>
> **本文件不是宪法**，是 YoRHa-A2 这个**阶段性团队项目的工作模式手册**，从属于[个人主宪法 `shared/CLAUDE.md`](../../CLAUDE.md)。剩下的看：
> - [YORHA-A2.md](YORHA-A2.md) 项目 hub（最终目标 + 子项目花名册 + 决策 log）
> - [sub-projects/](sub-projects/) 各子项目状态板（conversion-site = 最终目标 / short-video 引流 / ai-interactive-story 故事引擎[雨飞]）
> - Obsidian Vault 的 framework / drafts / 灵感暂存（重内容，不放 git）
>
> **claude-context 这份 ↔ 团队 repo 的分工**：本文件是**主理人视角的轻量工作模式索引**；真正的 team 协作空间（决策、team-log、PR 流、三人日常）在独立的 [`yorha-a2-team`](https://github.com/yorhagengyue/yorha-a2-team) repo（见 [CLAUDE.md §0.6.1](../../CLAUDE.md)）。重的协作记录留 team repo，别两头写重复。

---

## 内容存放规约 —— 每个空间放什么（2026-06-02 用户拍板）

| 空间 | 放什么 | 性质 |
|---|---|---|
| **Linear**（团队工作台） | 任务 / UI 问题（带截图）/ 客户需求更新 / 进度看板 —— 成熟、低成本、一目了然。**截图/反馈发 issue 或评论,别发 project update（Claude 经 MCP 读不到 project update）** | 团队协作 · 可视 |
| **Obsidian + `temp-ideas/`** | 随手 idea / 草稿 / 灵感暂存（原 Excalidraw `地狱三头犬` 的角色）；正式系统存档并入各 repo 的 `decisions/`+`docs/` | 轻 · 草稿 |
| **`claude-context`**（本 repo） | 耿越个人主宪法 + 跨机器记忆 / 项目速报 / 工作模式（轻量指针、版本化） | 轻 · 个人 |
| **`yorha-a2-team`** | 团队协作 source-of-truth：`decisions/` + `team-logs/` + framework + `<name>-assets/`（走 PR） | 团队权威 |
| **`ai-interactive-story`** | 雨飞主导的引擎代码（独立 repo · 卫星模式） | 代码 |

流转：idea 先在 **Obsidian / `temp-ideas`** 萌芽 → 想清楚后，任务 / 问题进 **Linear**、决策写进 **yorha-a2-team/decisions**、正式系统存档落 **decisions/ + docs/**、代码进**引擎 repo**、轻量状态进 **claude-context**（capture→scratch→decide→commit，见 [CLAUDE.md §8 2026-05-30](../../CLAUDE.md)）。

> **2026-06-15 更新**：**舍弃 Excalidraw、暂缓 LibTV**（当下都不需要）。原 Excalidraw `Main`（正式存档）角色并入各 repo 的 `decisions/`+`docs/` 与 Obsidian；原 `地狱三头犬`（草稿）并入 Obsidian + `temp-ideas/`；团队改用 **Linear** 做可视化任务 / UI 问题（截图）/ 客户需求看板。见 yorha-a2-team `decisions/2026-06-15-tooling-linear.md`。

---

# Part I · 主旨与主导思想（**宪法层**）

## 0. 30 秒读懂

YoRHa-A2 是用户 NAISC 决赛后 **frame shift** 的第一个交付项目。**核心命题：用 AI 的运作机制解释人性现象**。这是只有用户能持续输出的内容（LLM 思考模式 ≈ 人类思考模式 + 用户两边都熟）。

**结构（2026-06-02 重整）**：最终目标 = **咨询网站（conversion-site）**——访客经 AI 接初接 → 真人接深度 → 收费。到那之前路上做**若干子项目**：

- **short-video** = 引流。AI×人性 内容放平台。国内追流量、国外为咨询网站导流。
- **ai-interactive-story** = AI 互动故事引擎（雨飞主导的独立 repo 子项目）。
- 以后还会长出新子项目。

子项目花名册 + 各自状态见 [YORHA-A2.md](YORHA-A2.md) hub。当前：short-video framework v0 定 / conversion-site 还 concept（8 问待答）/ 故事引擎核心闭环已成。

> 下面 §4 / §6 / §7 等正文还保留了不少"两 part"时期的叙述，主旨 / 护城河 / voice 仍然有效，但 part 框架已被本节的"目标 + 子项目"取代——读时以本节和 hub 为准。

## 1. 为什么是这个项目（Why now）

2026-05-22 NAISC 决赛触发 frame shift（详见 [CLAUDE.md §3](../../CLAUDE.md#3) + [§8 2026-05-25 三条 entry](../../CLAUDE.md#8)）：

- **旧 framing**：架构判断力 = 核心缺口 → 半年实践证明：学生 + 同龄人参照系下架构已经够强
- **新 framing**：当前 #1 短板 = **交付（赚到一个结果）**。outcome 框架而不是 activity 框架。result 的单位是开放的：钱 / 流量 / 资源 / 名次 / 任何 tangible 的"赚到了"
- **决赛真相**：4 评委中只有 Workato 那位（AI 出身）听懂作品，另 3 位非技术评委对偏技术产品 buy 不进去。"如何证明你是有市场的"答得不好——这是整个能力栈的真实缺口暴露

YoRHa-A2 是**第一个把"做出来"转向"让人看到 / 让人买账"的具体落地**。

## 2. 主导思想（项目的核心命题）

**用 AI 的运作机制 / 概念，去解释 / 命名 / 翻译 人性现象。**

不是科普 AI、不是教 AI 工具用法、不是 AI 创业故事。是**跨界类比**：

```
LLM 思考模式 ≈ 人类思考模式 → 任何 AI 现象都可能映射到一个人性现象
                            → 把这个映射用故事写出来 = YoRHa-A2 内容
```

**例子**（已被抖音验证）：
```
AI 概念: multi-agent / subagent
× 人性场景: 分手时的内心拉扯
→ "感性 / 妄念 / 回忆 / 自尊 几个 subagent 在身体里 push-pull"
→ punch: "成长 = 从被某一个 subagent 控制，慢慢变成主系统重新上线"
```

这不是修辞。是**真把 AI 的工程原理当作人类心理的工程原理去讲**。用户在给别人讲课 / 解释中验证过：**这个映射只有他能持续输出**，因为他既懂 AI 工程也懂人性。

## 3. 护城河（为什么别人做不出来）

| 一般 AI 内容创作者 | 一般情感心理博主 | **YoRHa-A2** |
|---|---|---|
| 懂 AI 工程，不擅长讲人性 | 擅长讲人性，不懂 AI 工程 | **两边都熟** |
| 产出："AI 怎么用 / AI 怎么进步" | 产出："情感分析 / 人生道理" | 产出：**用 A 解释 B**，是新的命名系统 |
| 受众：技术 / 创业圈 | 受众：情感共鸣类 | **受众：被 AI 热度吸引的下沉用户，但留下来是因为内容打中了"我也是这样"** |

护城河不在内容质量本身，**在这个映射只有 user 能持续输出**。Voice 是用户独有的（`Vault/01 - Projects/YoRHa-A2/short-video/framework/voice.md`），Claude / 队友 / 抄袭者都模仿不来。

## 4. 战略地图 · 两 part × 双轨

项目有 **两个正交分轴**：

```
                  主导思想：用 AI 解释人性
                          │
   ┌──────────────────────┴──────────────────────┐
   │                                              │
   ▼ Part 1: short-video (引流)        Part 2: conversion-site (转化)
   ┌──────────────────────────┐         ┌───────────────────────────┐
   │ 国内轨                    │         │                           │
   │   抖音 (+B站/小红书/公众号) │  流量积累  │                           │
   │   metric: 流量本身         │ ──不绑死→ │  独立网站 + AI 咨询        │
   │   调性: AI×情感           │         │  (AI 接初接 → 真人深度)     │
   │   转化压力: 无             │         │                           │
   ├──────────────────────────┤         │  国外付费为主              │
   │ 国外轨                    │  导流    │  国内 backup              │
   │   待定 (YouTube/X/News)   │ ── 主要 →│                           │
   │   metric: 转化 + 专业受众  │         │  (具体形态待 user 专题)    │
   │   调性: AI×专业           │         │                           │
   └──────────────────────────┘         └───────────────────────────┘
       short-video/SHORT-VIDEO.md             conversion-site/CONVERSION-SITE.md
```

**两个分轴的关系**：

- **Part 分轴**（短视频 vs 转化站）：**功能维度**——引流和变现是两个独立工程
- **双轨分轴**（国内 vs 国外）：**地理 + metric 维度**——内嵌在 short-video part 里（不同地区 metric 不同）；conversion-site 主要服务国外
- 不要混淆两个分轴：当一句话说"国内"时是双轨语义、说"短视频"时是 part 语义

**当前状态**：

- ✅ short-video framework v0 定（位于 `Vault/01 - Projects/YoRHa-A2/short-video/framework/`）
- ⏸️ 国外 完整计划 user 未写完，**Claude 不展开讨论**

## 5. 当前阶段 / 阶段定义

```
v0 (今天) → v1 (跑 10 条出来，voice/shape 稳定) → v2 (有 metric 数据回流 framework)
```

**v0 任务清单**（user 主导，Claude 工具人）：

**Part 1 short-video**：
- [x] Framework 4 个核心文件定稿
- [ ] User 扩 / 砍 concept-library (AI 概念库)
- [ ] User 扩 / 砍 scenario-library (人性场景库)
- [ ] User 决 story-shapes gap：先 Shape A 同质化 vs 一开始 mix arc
- [ ] User 把已发的 subagent / 分手 抖音版本回灌进 `Vault/01 - Projects/YoRHa-A2/short-video/drafts/`
- [ ] User 跑出 5-10 条文案，验证 framework 是否能稳定生成不同主题

**Part 2 conversion-site**：
- [ ] User 开"conversion-site 专题对话"，回答 8 个核心问题
  （详见 [sub-projects/conversion-site.md](sub-projects/conversion-site.md) "专题对话要解决的核心问题"）
- [ ] 网站技术栈 / domain / AI chat backend 选择
- [ ] 收费模型 + 服务页文案

**v1 触发条件**：
- short-video v1: 跑出 10 条，3 条以上数据明显好，voice / shape 在团队里能复刻
- conversion-site v1: 第一版网站上线 + 第一个付费咨询单跑通 (从 lead → AI → 真人 → 收款 全链路)

## 6. 谁做什么 · roles

| 角色 | 职责 | 边界 |
|---|---|---|
| **User** | 选题决策 / 文案主笔 / voice 守护 / 节点和止损判断 / 流量转化路径决策 / 团队管理 | 不做：跨平台机械分发、纯 AI 自动写稿 |
| **3-4 人小团队** | 配视频 / 剪辑 / 选题协助 / 数据收集 / 平台运营（具体分工 #4 后聊） | 不做：替 user 写关键 punch line |
| **Claude** | 维护 framework 库 / 拆解文案 / 校准 voice / **数据收集（user 跑起来后）** | **不做**：内容方向 attack / 商业判断 attack / 节点止损建议 / 国外计划猜测 |
| **Hermes** | 待定。可能：数据汇总 / 用户问题分类 / 客服 tier 1 | 待 user 启用 |

## 7. 已锁的决策（**不再争议**）

按对话时间顺序：

1. **2026-05-25** YoRHa-A2 作为 frame shift 后第一个交付项目立项
2. **2026-05-25** Framework v0 = AI 概念 × 人性场景矩阵 + 故事结构 + voice
3. **2026-05-25** 国内 metric = 流量本身，国内**不追转化**
4. **2026-05-25** 国外 metric = 付费转化（专业向）
5. **2026-05-25** 双轨同步做，**不合并同一漏斗逻辑评估**
6. **2026-05-25** 配视频用 AI 生成图文 / flowchart / 图表（user 实操验证 OK）
7. **2026-05-25** 3-4 人小团队，产能不是 bottleneck
8. **2026-05-25** AI 接初接 → 真人接深度，**不是 fake-AI 欺骗用户**（是 human-in-the-loop QA）
9. **2026-05-25** 用户不训自己的模型，是 prompt + 好 model + RAG/workflow
10. **2026-05-25** 用户群 = 下沉市场 / 不懂 AI 但被 AI 热度吸引的人（AI 概念词是钩子不是 barrier）
11. **2026-05-25** Claude 不在本项目做 attack（领域不熟，6 次试错全错；详见 §8 correction）
12. **2026-05-25** 节点 / 止损 / 流量转化路径 = user 决定，Claude 不思考
13. **2026-05-25** 项目分两 part：**short-video（引流）+ conversion-site（转化）**，并行启动
14. **2026-05-25** claude-context 端拓扑 = 子目录式（每 part 独立 sub-MD）
15. **2026-05-25** Vault 端**已对称重组**：framework / drafts / published 已挪到 `short-video/` 子目录；YoRHa-A2 根只保留 README + SETUP + 两 part 子目录（覆盖之前"暂不挪"的决策）
16. **2026-05-25** Vault 端 README + SETUP + 各 part README 都写满"想法 + 聊的东西"，不只是规约（user 直接指示）

新的决策由 user 加进 [YORHA-A2.md](YORHA-A2.md) 决策 log，不在本 SETUP 改。

## 8. Claude 在本项目的姿势（**重要 · 跟通用 content mode 略有不同**）

通用 content mode 在 Obsidian `02 - Areas/Claude Harness/content.md`，本项目额外的姿势：

### 该做的

1. **维护 framework 库**：user 增 / 删 / 重组时把改动落入对应文件，位于 `Vault/01 - Projects/YoRHa-A2/short-video/framework/`（concept-library / scenario-library / story-shapes / voice）
2. **拆解 user 文案**：每写一条 draft → 按 framework 标 (a) 哪个概念 / (b) 哪个场景 / (c) 哪个 arc / (d) voice 是否一致
3. **voice 校准**：用 voice.md 的 6 条规则 + 白/黑名单 + review checklist 给 user 反馈
4. **数据收集**（待 user 跑起来）：metric 汇总 → 喂回 framework 迭代

### **不**该做的

1. **不在内容选题 / 商业框架上 attack** —— 今天连续 6 次 attack 错（详见 [§8 2026-05-25 correction](../../CLAUDE.md#8) "中国短视频生态判断不准"）。在用户没 first-hand 数据的领域，Claude 是 listener + 工具人不是评审
2. **不主动扩 concept / scenario 库** —— 用户手工增删，避免 framework drift
3. **不替 user 写 punch line** —— punch 是 voice 的核心，是用户独有的
4. **不猜国外计划** —— user 写完之前不要替他思考
5. **不建议节点 / 止损** —— user 明确说自己决定，"原因多种多样"
6. **不脑补流量转化路径** —— user 说"在这个年代流量一定可以以某种方式被转化"，这是他的信念基础，不要质疑

### Meta-lesson（写到这里给未来的 Claude 看）

**Claude 的 architecture-review / attack 习惯在不熟悉的领域是赌运气式质疑**。
- 技术架构 → 命中率高（Claude 熟）
- 中国内容生态 / 商业 funnel / 短视频玩法 / 内容营销 → 命中率低（Claude 不熟）

正确姿势：**先承认不熟，问用户实际跑过的案例 / 数据，不要先 assert 通用规则**。

---

# Part II · 操作手册（**规约层**）

## 9. 仓库 / 文件夹拓扑

**claude-context 端**（状态 / 决策 / 工作模式，**轻量**）：

```
shared/projects/yorha-a2/
├── YORHA-A2.md                    ← 项目 hub（最终目标 + 子项目花名册 + 决策 log）
├── WORKING-MODE.md                ← 本文件（团队工作模式手册，从属个人主宪法）
└── sub-projects/
    ├── conversion-site.md         ← 最终目标 · 咨询网站状态板 + 8 个待解决问题
    ├── short-video.md             ← 引流子项目状态板
    └── ai-interactive-story.md    ← 故事引擎子项目（雨飞 · 指向其独立 repo）
```

**Obsidian Vault 端**（**重内容**：framework + drafts + published + conversion-site 工作区；**已对称重组**）：

```
Vault/01 - Projects/YoRHa-A2/
├── README.md                ← 项目说明（一句话 + 两 part 概述 + 入口）
├── SETUP.md                 ← Vault 端工作规约（不是项目级宪法）
├── short-video/             ← 引流 part 工作区
│   ├── README.md            ← 想法 + 聊的东西（沉淀立项对话）
│   ├── framework/           ← v0 framework 4 文件
│   │   ├── concept-library.md
│   │   ├── scenario-library.md
│   │   ├── story-shapes.md
│   │   └── voice.md
│   ├── drafts/              ← 文案稿（`YYYY-MM-DD-concept-scenario.md`）
│   └── published/           ← 已发布 + metric（待启用）
└── conversion-site/         ← 转化 part 工作区
    └── README.md            ← 想法 + 聊的东西（8 个待回答问题）
```

**未来扩展**：如果 conversion-site 长出自己的 framework / drafts，直接在 `conversion-site/` 下新建对应子目录（拓扑已对称，扩展无摩擦）。

> `Vault/` 是占位，**实际路径每台机器可能不同**——见 CLAUDE.md §0.7 + `machines/<host>/local.md`。

**两边为什么分开**：

- **claude-context** = 状态 + 决策 + 宪法（**轻 / 跨机器 / 版本化**）
- **Obsidian** = framework + drafts + metric + 视觉素材（**重 / 本地 / 不放 git**）

按 CLAUDE.md §0.7 三层记忆体系：claude-context = 轻量指针，Obsidian = 重内容。

## 10. 写入规则

### 哪些写在 claude-context（这里）？

- 状态 / 决策 log（YORHA-A2.md）
- SETUP / 规约 / 主旨 / 路径协议（本文件）
- **不写**：framework 详细库（已搬 Obsidian）、单条文案 drafts、metric 数据、视频素材

### 哪些写在 Obsidian（Vault/01 - Projects/YoRHa-A2/）？

- **Framework 4 个详细文件** → `Vault/01 - Projects/YoRHa-A2/short-video/framework/{concept-library, scenario-library, story-shapes, voice}.md`
- 单条文案 draft / 脚本 / 改稿历史 → `drafts/<date>-<slug>.md`
- 发布后的版本 + 数据 → `published/<date>-<slug>.md`
- 视觉 / 配图素材 → `Vault/Attachments/yorha-a2/`
- 跨条对话 sediment（重要观察 / pattern 发现）→ `Vault/05 - Journal/YYYY/MM/`

### 哪些写在 CLAUDE.md §8？

**跨项目可复用**洞察。本项目跑过程中产生的"AI×人性"内容创作经验如果跨项目能用，写 §8。**项目过程性细节不写 §8**（违反 §0.3 + §0.3.1 既有规则）。

## 11. 链接 contract（保证不孤岛）

每个文件**至少有 1 个回链**到主索引：

| 文件 | 必须链回 |
|---|---|
| Vault framework/*.md | 文本指向 `claude-context: shared/projects/yorha-a2/YORHA-A2.md` + 同伴用 Obsidian 双链 `[[concept-library]]` 等 |
| Obsidian drafts/*.md | `[[../README\|工作区索引]]` 或 `[[YORHA-A2]]` |
| CLAUDE.md §5 行 | `→ [YORHA-A2.md](projects/yorha-a2/YORHA-A2.md) / [WORKING-MODE.md](projects/yorha-a2/WORKING-MODE.md)` |
| Obsidian content mode (02 - Areas) | `→ shared/projects/yorha-a2/` + `Vault/01 - Projects/YoRHa-A2/short-video/framework/` |

外部入口 / 主索引：

- **CLAUDE.md §5 项目索引** → 本项目一行 + 链接（已设置）
- **content mode**（Obsidian `02 - Areas/Claude Harness/content.md`）→ 链到本 framework 作为 v0 实战填充（已设置）
- **§8 [2026-05-25] insight** "交付（赚到一个结果）" → 本项目作为第一个具体落地

## 12. 命名规约

- 文件夹：`yorha-a2/` 全小写 kebab-case（filesystem 一致性）
- 文档里：**YoRHa-A2**（品牌名，R 大写 H 大写 A 大写 — 来自 NieR: Automata / 旧 YoRHa agent 框架延续）
- Drafts 命名：`YYYY-MM-DD-<concept>-<scenario>.md`，如 `2026-05-25-subagent-breakup.md`
- 库扩展：用户在 `concept-library.md` / `scenario-library.md` 里**手工增删**，Claude 不主动添加（避免 framework drift）

## 13. Voice 守护（unique angle 守护）

本项目核心护城河：**用 AI 机制解释人性**。Claude / 任何写手在 review 文案时按下面准则守护，详细规则在 `Vault/01 - Projects/YoRHa-A2/short-video/framework/voice.md`：

1. **AI 概念是钩子，不是装饰** —— 文案要真借 AI 机制做映射，不是套个词
2. **人性场景要"可代入"** —— 普世经验优先（分手 / 加班 / 自我怀疑），冷门或抽象的场景容易掉粉
3. **撕扯感是 Shape A 的核心** —— 但不能所有文案都用同一 arc（详见 `Vault/01 - Projects/YoRHa-A2/short-video/framework/story-shapes.md` 的 gap 段）
4. **不"AI 味"** —— 避免"在 X 时代"、"赋能"、"让我们一起"、emoji 堆砌
5. **用户语气** —— 口语、不端着、自嘲 OK、中英混 OK
6. **下沉读者也能懂** —— AI 在国内热度高，术语反而是钩子；但段落里要有"翻译进人性"的桥段，不是纯技术讲解

## 14. 状态升级流程

```
v0 (今天) → v1 (10 条出来) → v2 (metric 数据回流)
```

每次升级：
1. 在 [YORHA-A2.md](YORHA-A2.md) 决策 log 加一行
2. `Vault/01 - Projects/YoRHa-A2/short-video/framework/` 内对应文件更新版本号
3. 重大改动写一条 Journal entry（`05 - Journal/YYYY/MM/`）记述升级原因

## 15. 涉及其它 harness 部分

- **CLAUDE.md §3** —— Claude 在本项目按 content mode 工作（不切 architecture-review）
- **CLAUDE.md §9 / Obsidian content.md** —— 本项目是 content mode v0 占位的第一个实际填充
- **§0.3.1 自动记忆** —— 本项目对话中产生的 sediment 按 §0.3.1 触发；跨项目洞察 → §8；项目内部细节 → 本目录 / Obsidian Journal
- **CLAUDE.md §0.4 同步约定** —— 本目录所有改动按 commit type `project:` 提交

## 16. 新会话快速 onboard 指南

如果你（新 Claude / 队友 / 未来的我）刚进入本项目：

### 通用路径

1. **读 [YORHA-A2.md](YORHA-A2.md)** —— 项目 hub，最终目标 + 子项目花名册 + 决策 log
2. **读这一份 WORKING-MODE.md** —— 团队工作模式（主旨 / 护城河 / 谁负责啥 / Claude 姿势），你正在做

### 然后按你要做的 part 分支：

#### 进 short-video 路径

3. **读 [sub-projects/short-video.md](sub-projects/short-video.md)** —— 引流子项目状态 + 决策 log
4. **读 `Vault/01 - Projects/YoRHa-A2/short-video/framework/concept-library.md`** —— AI 概念库 v0 + 配对历史
5. **读 `Vault/01 - Projects/YoRHa-A2/short-video/framework/voice.md`** —— 最关键，决定能不能 review 文案
6. **（可选）读 `Vault/01 - Projects/YoRHa-A2/short-video/framework/story-shapes.md`** —— v0 默认 shape + 候选 arc

#### 进 conversion-site 路径

3. **读 [sub-projects/conversion-site.md](sub-projects/conversion-site.md)** —— 最终目标状态 + 8 个待解决核心问题
4. **（如已开始填）读 `Vault/01 - Projects/YoRHa-A2/conversion-site/`** —— 工作区

### 跨 part 上下文（强烈建议读）

- **Journal entry**: `Vault/05 - Journal/2026/05/2026-05-25-yorha-a2-framework-v0.md` —— 立项对话弧线 + Claude 6 次错攻击的 meta-lesson + 项目从 0 到 1 的来由
- **CLAUDE.md §3 frame shift**: 这个项目为什么诞生的更深 framing
- **CLAUDE.md §8 [2026-05-25]**: 项目相关的几条 sediment（correction / insight / project / 中国市场判断错）

读完应该能完整 onboard。如果 Claude，**特别注意 §8 Claude 姿势**：在本项目不 attack，是 listener + 工具人。

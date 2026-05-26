---
project: YoRHa-A2
status: framework v0 · 待跑第一波
last-updated: 2026-05-25
upstream: ../../CLAUDE.md §5
manifesto: SETUP.md (主旨 + 主导思想 + roles + 决策)
---

# YoRHa-A2 — 内容产线 / 交付项目速报

> **本文件 = 当前状态板 + 决策 log + 下一步**。
> 主旨 / 主导思想 / 双轨战略 / Claude 姿势 / 操作规约 全部在 [SETUP.md](SETUP.md)。
> 第一次进来读 [SETUP.md](SETUP.md) 先。

---

## TL;DR

**一句话**：用 AI 的运作机制解释人性现象的内容项目。frame shift 后第一个交付项目。**当前阶段**：framework v0 定稿，待 user 跑出第一波 10 条文案验证。

**双轨 metric**：国内追流量（资产积累，不变现）/ 国外追转化（专业向、付费咨询，未启动）。

**核心命题**：LLM 思考模式 ≈ 人类思考模式，这个映射只有 user 能持续输出 = 护城河。已被 subagent / 分手 那条抖音文案验证。

完整框架 / 战略 / why-now → [SETUP.md](SETUP.md)。

---

## 当前状态

| 维度 | 状态 |
|---|---|
| Framework v0 | ✅ 定稿（4 文件 in framework/） |
| 已验证内容样本 | subagent / 分手类比（抖音爆款，user 转录给 Claude） |
| AI 概念库 | 🌱 31 个 seed（待 user 扩 / 砍） |
| 人性场景库 | 🌱 5 大类 seed（待 user 扩 / 砍） |
| Story shapes | 🌱 Shape A 默认 + 5 个候选 arc（gap：先同质化 vs mix 待 user 定） |
| Voice | ✅ 6 条规则 + 白/黑名单（从 subagent 那条逆向抽取） |
| 国内首条发布 | ⏳ 等 user 把已有抖音版本回灌进 Obsidian drafts/ |
| 国外计划 | ⏸️ user 未写完，暂搁置 |
| 节点 / 止损 / 转化路径 | 🔒 user 决定，Claude 不思考 |
| 账号矩阵 / 执行节奏 / 团队分工 (#4 #5) | ⏸️ 后聊 |

## Framework v0 概要

```
选题 = AI 概念 × 人性场景  (矩阵生成)
  (a) AI 概念库      → framework/concept-library.md
  (b) 人性场景库     → framework/scenario-library.md
  (c) 故事结构 / arc → framework/story-shapes.md
  (d) 语气 / voice  → framework/voice.md
```

(配视觉 / 发布节奏 / 数据复盘) **不进 framework**——是后期 SOP，不是创作框架。

详细的 4 个文件 link：
- [framework/concept-library.md](framework/concept-library.md) — AI 概念库 + 配对历史
- [framework/scenario-library.md](framework/scenario-library.md) — 人性场景库 + 反例
- [framework/story-shapes.md](framework/story-shapes.md) — Shape A 已验证 + 5 候选 + gap 警告
- [framework/voice.md](framework/voice.md) — 6 voice 规则 + 白/黑名单 + review checklist

## 团队 / 形态

- 3-4 人小团队（具体分工 #4 后聊）
- 产能不是 bottleneck（配视频用 AI 生成图文 / flowchart / 图表，user 实操验证）
- 文案 + 配视频的形态例：subagent / 分手 那一条

## 双轨策略（user 已锁）

| 轨 | 平台 | metric | 当前阶段 |
|---|---|---|---|
| **国内** | 抖音先，后续 B站/小红书/公众号 | **流量本身**（粉丝/播放/互动）—— 不追转化 | framework 定，待跑第一波 |
| **国外** | 待定（YouTube / Twitter / Newsletter 候选） | **付费转化**（专业向、AI 咨询） | user 计划未写完，暂搁置 |

完整战略图见 [SETUP.md §4 战略地图](SETUP.md)。

## User 决定不让 Claude 介入的部分

明确写出来避免未来混淆（详细原因 + 全部 12 条已锁决策见 [SETUP.md §7](SETUP.md)）：

1. **节点 / 止损** —— "原因多种多样，让我去做"。Claude 只做后续数据收集
2. **流量作为资产 → 后续转化路径** —— "在这个年代流量一定可以以某种方式被转化"
3. **#4 账号矩阵 + #5 执行节奏** —— 后聊，不在 framework v0 范围
4. **国外计划具体形态** —— user 写完之前不替他猜

## Claude 在本项目的职责

详见 [SETUP.md §8 Claude 在本项目的姿势](SETUP.md)。一句话：**listener + 工具人，不是评审**。

**该做**：维护 framework 库 / 拆解 user 文案 / voice 校准 / 数据收集（待启动）。

**不该做**：在内容选题 / 商业框架上 attack（领域不熟，6 次试错全错；详见 [§8 2026-05-25 correction](../../CLAUDE.md#8) "中国短视频生态判断不准"）。

## 下一步（pending user）

- [ ] User 扩 / 砍 AI 概念库（[framework/concept-library.md](framework/concept-library.md)）
- [ ] User 扩 / 砍 人性场景库（[framework/scenario-library.md](framework/scenario-library.md)）
- [ ] User 决定 story-shapes gap：**先靠 Shape A 同质化建立账号风格识别度（前 3-6 个月）vs 一开始 mix 2-3 个 arc** —— 这条对识别度影响很大
- [ ] User 把已发抖音的 subagent / 分手版本回灌进 `01 - Projects/YoRHa-A2/drafts/`
- [ ] User 跑出 5-10 条文案验证 framework

## 决策 log

| 日期 | 决策 | 出处 |
|---|---|---|
| 2026-05-25 | YoRHa-A2 立项作为 frame shift 后第一个交付项目 | 本对话 |
| 2026-05-25 | Framework v0 = AI 概念 × 人性场景矩阵 + 故事结构 + voice | 本对话 |
| 2026-05-25 | 国内国外双轨 metric 分离（流量 vs 转化）| 本对话 |
| 2026-05-25 | Claude 不介入节点 / 止损 / 转化路径决策 | 本对话 |
| 2026-05-25 | 配视频用 AI 生成图文，3-4 人团队产能 OK（user 实操验证） | 本对话 |
| 2026-05-25 | 用户群 = 下沉市场但被 AI 热度吸引（AI 词是钩子非 barrier） | 本对话 |
| 2026-05-25 | AI 接初接 → 真人接深度（不是 fake-AI 欺骗） | 本对话 |
| 2026-05-25 | 不训自己模型，是 prompt + 好 model + RAG/workflow | 本对话 |
| 2026-05-25 | Claude 不在本项目做 attack（领域不熟） | 本对话 |

完整宪法 + 操作手册见 [SETUP.md](SETUP.md)。

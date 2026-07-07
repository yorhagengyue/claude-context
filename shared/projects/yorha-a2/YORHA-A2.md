---
project: YoRHa-A2
type: stage-project hub
status: 阶段性团队项目 · 进行中（当前主线 = ai-interactive-story）
last-updated: 2026-07-08
parent: ../../CLAUDE.md (个人主宪法)
working-mode: WORKING-MODE.md
goal: conversion-site (咨询网站)
sub-projects:
  - sub-projects/conversion-site.md (= 最终目标)
  - sub-projects/short-video.md (引流)
  - sub-projects/ai-interactive-story.md (owner: Yufei)
---

# YoRHa-A2 — 阶段性团队项目 hub

> **YoRHa-A2 是什么**：耿越（主理人）+ 雨飞 + Zicheng 三人的一个**阶段性协作项目**。它从属于[个人主宪法 `shared/CLAUDE.md`](../../CLAUDE.md) —— 主宪法是耿越永久的 harness，YoRHa-A2 只是挂在它下面、有始有终的一个项目，不是另一部宪法。
>
> - 三人怎么结合着干、各自负责什么 → [WORKING-MODE.md](WORKING-MODE.md)
> - 每个子项目的状态 → `sub-projects/` 下对应文件

## TL;DR

**最终目标**：做出一个**咨询网站（conversion-site）**——访客经 AI 接初接、真人接深度、最后收费。这是整个项目要交付的那个结果。

**怎么到那**：不是一步到位，而是路上做**若干子项目**，每个既是独立产出、也为最终目标积累能力 / 流量 / 资产。**当前主线子项目 = AI 互动故事引擎**（找 OC 用户 + 打磨 UX）；短视频（引流）在侧。后面还会长出新的。

**护城河**：用 AI 的运作机制解释人性现象——这个映射只有耿越能持续输出（既懂 AI 工程又懂人性，已被抖音 subagent / 分手 文案验证）。完整论证在 [WORKING-MODE.md](WORKING-MODE.md)。

## 子项目花名册

| 子项目 | 角色 | owner | 状态 | 详情 |
|---|---|---|---|---|
| **conversion-site** | 最终目标 · 咨询网站 | 耿越 | concept（8 个核心问题待答） | [sub-projects/conversion-site.md](sub-projects/conversion-site.md) |
| **short-video** | 引流 | 耿越 | framework v0 · 待跑第一波 | [sub-projects/short-video.md](sub-projects/short-video.md) |
| **ai-interactive-story** | AI 互动故事引擎（独立 repo）· **当前主线** | 雨飞(内容/前端) + Gengyue(引擎核心) | 前后端共存 · 前端已 cutover 到 frontend-next(2026-07-08) | [sub-projects/ai-interactive-story.md](sub-projects/ai-interactive-story.md) |

> 子项目跟最终目标的关系不一定是直线：短视频给目标引流；**故事引擎现在是团队主线**（2026-06-17 战略排序更新），当前焦点 = 找 OC 用户 + 打磨 UX。**⚠️ 2026-07-08 重大转向:故事引擎的终极目标正式命名为 [Inception](sub-projects/inception/INCEPTION.md) —— 把任何书变成可进入、多玩家共建、可 fork 的活世界;当前引擎只是通往它的中间站(底层只 Gengyue 本人做,未来若分歧再拆两份)。** 将来如何接进咨询网站是后话。新增子项目就加一行 + 在 `sub-projects/` 建一个文件。

## 阶段

```
v0（现在） → v1（咨询网站第一版上线 + 第一单全链路跑通） → v2（metric 回流迭代）
```

各子项目自己的 v0 / v1 触发条件写在它们各自文件里。

## Claude 在本项目的姿势

跟个人主宪法 content / chat 模式一致，**一句话**：内容选题 / 商业框架 / 网站架构上 Claude 是 listener + 工具人，不 attack（领域不熟，已 6 次试错全错）；纯技术架构（如故事引擎那个 repo）才主导。详见 [WORKING-MODE.md](WORKING-MODE.md) 的 Claude 姿势段。

## Vault 工作区

重内容（framework 详细库 / drafts / 视觉素材 / 主理人灵感暂存）在 Obsidian `Vault/01 - Projects/YoRHa-A2/`，不放 git。claude-context 这边只存状态 + 决策 + 工作模式（轻量、跨机器、版本化）。

## 项目级决策 log（跨子项目）

| 日期 | 决策 | 出处 |
|---|---|---|
| 2026-05-25 | YoRHa-A2 立项，frame shift 后第一个交付项目 | 立项对话 |
| 2026-05-25 | 主导思想 = 用 AI 机制解释人性 | 同 |
| 2026-05-25 | 最终目标 = 咨询网站；国内 metric = 流量、国外 metric = 转化 | 同 |
| 2026-05-27 | 建独立 `yorha-a2-team` repo 做 team 协作 + Slack `#yorha-a2-team` 接 GitHub App | sync 决策 |
| 2026-05-31 | 雨飞的 `ai-interactive-story` 以"卫星 repo"模式挂进团队（不用 submodule） | §8 + 卫星 mount 决策 |
| 2026-06-02 | **结构重整**：从"两 part（短视频 + 咨询站）"改为"最终目标 = 咨询网站 + 多个子项目"；A2 文档从属个人主宪法、不再自称项目级宪法；claude-context 端 `SETUP.md`→`WORKING-MODE.md`，各产出挪进 `sub-projects/` | 本次对话 |

子项目内部决策写各自文件，不重复到这。

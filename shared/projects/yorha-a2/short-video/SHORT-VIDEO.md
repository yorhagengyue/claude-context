---
project: YoRHa-A2
part: short-video
status: framework v0 · 待跑第一波
last-updated: 2026-05-25
upstream: ../YORHA-A2.md
manifesto: ../SETUP.md
---

# YoRHa-A2 · short-video part 状态板

> **本 part 角色**：**引流**。把"用 AI 解释人性"的内容打出去吸流量 / 粉丝 / 互动。**不直接转化** —— 转化在另一 part（[../conversion-site/CONVERSION-SITE.md](../conversion-site/CONVERSION-SITE.md)）。
>
> 项目级宪法 / 主旨：[../SETUP.md](../SETUP.md)
> 顶级状态板：[../YORHA-A2.md](../YORHA-A2.md)

---

## TL;DR

**一句话**：YoRHa-A2 短视频 part = 用 AI 概念解释人性现象的内容产线。**已被 subagent / 分手类比文案在抖音验证**。当前 framework v0 定稿，待跑第一波 10 条文案。

## 当前状态

| 维度 | 状态 |
|---|---|
| Framework v0 | ✅ 定稿（4 文件在 `Vault/01 - Projects/YoRHa-A2/short-video/framework/`，**当前归属本 part**） |
| 已验证内容样本 | subagent / 分手 抖音爆款（user 提供） |
| AI 概念库 | 🌱 31 个 seed（待 user 扩 / 砍） |
| 人性场景库 | 🌱 5 大类 seed（待 user 扩 / 砍） |
| Story shapes | 🌱 Shape A 默认 + 5 候选 arc（gap：先同质化 vs mix 待 user 定） |
| Voice | ✅ 6 条规则 + 白/黑名单 |
| 国内首条发布 | ⏳ 待 user 把已发抖音版本回灌 `Vault/01 - Projects/YoRHa-A2/short-video/drafts/` |
| 国外专业向 | ⏸️ user 完整计划未写完，暂搁置 |
| 节点 / 止损 / 转化路径 | 🔒 user 决定，Claude 不思考 |
| 账号矩阵 / 执行节奏 / 团队分工 (#4 #5) | ⏸️ 后聊 |

## Framework v0 概要

完整 4 文件在 Obsidian Vault：`Vault/01 - Projects/YoRHa-A2/short-video/framework/`

```
选题 = AI 概念 × 人性场景  (矩阵生成)
  (a) AI 概念库      → framework/concept-library.md
  (b) 人性场景库     → framework/scenario-library.md
  (c) 故事结构 / arc → framework/story-shapes.md
  (d) 语气 / voice  → framework/voice.md
```

## 双轨（本 part 内部，国内 vs 国外）

| 轨 | 平台 | metric | 当前阶段 |
|---|---|---|---|
| **国内** | 抖音先，后续 B站/小红书/公众号 | **流量本身**（粉丝/播放/互动）—— 不追转化 | framework 定，待跑第一波 |
| **国外** | 待定（YouTube / Twitter / Newsletter 候选） | 主要为 conversion-site **导流**，本身也追**专业向受众积累** | user 计划未写完，暂搁置 |

## 跟 conversion-site part 的关系

- **国内短视频** → 流量积累，转化路径不绑死 conversion-site（流量可以"以某种方式被转化"，user 信念）
- **国外短视频** → 主要任务是**给 conversion-site 导流**。所以国外内容形态要跟 conversion-site 的服务受众对齐
- **转化路径决策** 在 user 手里（Claude 不思考）

## 下一步（pending user）

- [ ] User 扩 / 砍 AI 概念库（`Vault/01 - Projects/YoRHa-A2/short-video/framework/concept-library.md`）
- [ ] User 扩 / 砍 人性场景库（`Vault/01 - Projects/YoRHa-A2/short-video/framework/scenario-library.md`）
- [ ] User 决定 story-shapes gap：**先靠 Shape A 同质化建立账号风格识别度（前 3-6 个月）vs 一开始 mix 2-3 个 arc**
- [ ] User 把已发抖音的 subagent / 分手版本回灌进 `Vault/01 - Projects/YoRHa-A2/short-video/drafts/`
- [ ] User 跑出 5-10 条文案验证 framework
- [ ] 国外短视频完整计划（user 决定，等 conversion-site 一起想）

## 决策 log（本 part 范围）

| 日期 | 决策 | 出处 |
|---|---|---|
| 2026-05-25 | Framework v0 = AI 概念 × 人性场景 矩阵 + Shape A 默认 + 6 条 voice 规则 | 立项对话 |
| 2026-05-25 | 国内 metric = 流量本身，**不**追转化 | 立项对话 |
| 2026-05-25 | 国外短视频形态待 user 写完整计划再决定 | 立项对话 |
| 2026-05-25 | 配视频用 AI 生成图文 / flowchart / 图表（user 实操验证） | 立项对话 |

## Vault 工作区

本 part 工作区已挪到 `short-video/` 子目录下（Vault 端两 part 对称重组完成）：

- `Vault/01 - Projects/YoRHa-A2/short-video/README.md` — 想法 + 聊的东西（沉淀立项对话）
- `Vault/01 - Projects/YoRHa-A2/short-video/framework/` — 4 文件
- `Vault/01 - Projects/YoRHa-A2/short-video/drafts/` — 文案稿（一条 = 一文件）
- `Vault/01 - Projects/YoRHa-A2/short-video/published/` — 已发布 + metric（待 SOP 定后启用）

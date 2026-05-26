---
project: YoRHa-A2
part: conversion-site
status: concept · 待专题
last-updated: 2026-05-25
upstream: ../YORHA-A2.md
manifesto: ../SETUP.md
---

# YoRHa-A2 · conversion-site part 状态板

> **本 part 角色**：**转化**。把短视频引来的流量在自家网站上转化成付费用户 / 资源 / 关系。
> **当前状态**：concept 阶段，具体形态等专题对话。
>
> 项目级宪法 / 主旨：[../SETUP.md](../SETUP.md)
> 顶级状态板：[../YORHA-A2.md](../YORHA-A2.md)
> 短视频 part：[../short-video/SHORT-VIDEO.md](../short-video/SHORT-VIDEO.md)

---

## 已知 framing（立项对话从 short-video 那条流出来）

**核心命题**：独立网站 + AI 咨询入口。

```
访客（从短视频引来）
  ↓
AI 接初接（chat 形态，把用户问题/想法说清楚）
  ↓
真人接深度（具体方案 / 落地咨询）
  ↓
收费（按次 / 套餐 / 实施费）
```

**两个候选受众**（已锁的市场判断）：
- **国外付费转化（主）** —— 专业向，付费意愿高
- **国内 backup** —— 国内不主追转化（短视频 part 国内追流量），但承接零散转化

**冷启动策略**（已锁）：
- 早期 **人扮 AI** —— 不是欺骗，是 **AI generated + human-in-the-loop QA 兜底**（避免初期 prompt 不稳定带来的低质量回答）
- 不训自己 model —— 用好 model + 好 prompt + RAG / workflow 组合
- 跟为爸爸 / xirui 做的多 profile Hermes 思路类似（参考 CLAUDE.md §5 心涟 项目）

## 当前状态

| 维度 | 状态 |
|---|---|
| 受众选边 | ✅ 国外付费为主 / 国内 backup |
| 服务形态 | ⏳ concept（AI 咨询接初接 → 真人深度），具体待专题 |
| 网站技术栈 | ⏸️ 未定 |
| Domain / 部署 | ⏸️ 未定 |
| AI 咨询的 prompt / workflow | ⏸️ 未定 |
| 收费模型 | ⏸️ 未定（按次 / 套餐 / 订阅 / 实施费） |
| 内容（landing / 服务页 / FAQ）| ⏸️ 未定 |

## 专题对话要解决的核心问题（user 想清楚后填）

按优先级（user 校准）：

- [ ] **服务定位**：咨询服务卖什么具体结果？（不是"AI 咨询" 这种泛词，是"帮我 X" 的具体动词）
- [ ] **目标客户画像**：国外哪个圈层？技术 founder / 非技术 founder / 企业管理者 / 个人专业人士？
- [ ] **AI 接初接的具体设计**：什么样的对话流？参考 user 跟 Claude 现在的对话姿势？参考心涟 dad profile 的 nudging？
- [ ] **价格 / 收费**：单次 / 套餐 / 订阅？锚定什么对比物（Toptal? Fiverr? 个人教练?）
- [ ] **网站技术栈**：Next.js + Supabase？或者用 no-code（Framer / Webflow）？AI chat 用什么 backend？
- [ ] **Domain 注册**：什么域名？跟 YoRHa-A2 品牌怎么衔接？
- [ ] **冷启动 0 → 第一个客户**：怎么验证？短视频引来的人怎么算"合格 lead"？
- [ ] **真人接深度的工作流**：谁接？怎么排期？怎么交付？

## 跟 short-video part 的关系

- 短视频 = 漏斗顶（引流）；conversion-site = 漏斗底（变现）
- **国外短视频内容形态需要等 conversion-site 受众想清楚再定**（要给 conversion-site 引对的人，不是引随便什么人）
- 国内短视频不绑死本 part（user 信念："流量一定可以以某种方式被转化"）

## 下一步（pending user）

- [ ] User 开"conversion-site 专题对话"，把上面 8 个核心问题想清楚一部分
- [ ] 想清楚后回填本文件 + 拆 sub-MD（如 conversion-site/AI-CHAT-SPEC.md / WEBSITE-DESIGN.md）

## Vault 工作区

- `Vault/01 - Projects/YoRHa-A2/conversion-site/` — placeholder（等专题对话填）

## 决策 log（本 part 范围）

| 日期 | 决策 | 出处 |
|---|---|---|
| 2026-05-25 | 受众主战场 = 国外付费 + 国内 backup | 立项对话 |
| 2026-05-25 | AI 接初接 → 真人深度的两层服务架构（不是 fake-AI） | 立项对话 |
| 2026-05-25 | 不训自己 model（prompt + 好 model + RAG/workflow） | 立项对话 |
| 2026-05-25 | 本 part 当前 concept 阶段，具体形态待 user 专题想清楚 | 本对话 |

## 当前 Claude 在本 part 的姿势

跟项目级一致（详见 [../SETUP.md §8](../SETUP.md)）：

- ✅ 维护本状态板，user 想清楚什么填什么
- ✅ 在 user 专题对话时按 chat 模式 listener + 校准
- ❌ **不**主动 attack 受众 / 价格 / 网站架构（先听）
- ❌ **不**主动猜技术栈 / 部署方案
- ❌ **不**替 user 做"AI 咨询长什么样" 这种产品决策

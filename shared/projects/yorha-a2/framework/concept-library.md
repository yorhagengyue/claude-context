---
file: concept-library
version: v0
seeded: 2026-05-25
---

# (a) AI 概念库

> Framework v0 中 (a)。**种子由 Claude 提供，用户增 / 删 / 重组**。
> 上位：[YORHA-A2.md](../YORHA-A2.md) · 同伴：[scenario-library.md](scenario-library.md) / [story-shapes.md](story-shapes.md) / [voice.md](voice.md)

## 用法

每个 AI 概念 = 一颗可能的种子。跟 (b) 人性场景库 配对生成选题：

```
AI 概念 × 人性场景 → 选题 → 按 (c) story shape 写文案 → 按 (d) voice 校准
```

不是每个 AI 概念都能"翻译得动"，用户在 status 列标记。

## 状态符号

- ✅ **已验证**：跑过文案、有共鸣
- 🔬 **候选**：Claude seed，待用户判断
- ❌ **砍**：翻译不动 / 不打中下沉 / 太技术
- 🆕 **新加**：用户手工补的

## 种子库 v0

| AI 概念 | 一句话翻译 | 可能挂的人性场景 | status |
|---|---|---|---|
| subagent / multi-agent | 多个专业的自己在身体里 | 分手 / 决策困难 / 内心拉扯 | ✅ 已用 |
| attention mechanism | 注意力是有限资源，被什么吸去就忘记别的 | 拖延 / 信息过载 / 工作分心 / 爱情 | 🔬 |
| context window | 短期记忆有边界，超过就被挤掉 | 健忘 / 多任务焦虑 / 信息焦虑 | 🔬 |
| hallucination | 数据不够就开始编造，且自己不知道 | 自我欺骗 / 强行解释前任行为 / 阴谋论 | 🔬 |
| fine-tuning | 在 base model 上拿少量数据塑造方向 | 童年塑造 vs 成年改变 / 一段关系改变人 | 🔬 |
| jailbreak | 用诱导绕过安全准则 | PUA / 道德边界被慢慢突破 / 上瘾 | 🔬 |
| RAG | 临时调资料库回答，不靠记忆 | 假装专家 / 临场补课 / 用搜索代替思考 | 🔬 |
| temperature | 调高就更随机更冲动，调低就刻板 | 冷静 vs 冲动 / 情绪不稳定 | 🔬 |
| system prompt | 底层指令，对话外不可见但塑造一切 | 三观 / 原生家庭 / 潜规则 | 🔬 |
| training data | 经历构成基础模型，决定输出偏见 | 童年阴影 / 学校教的 vs 真实 / 信息茧房 | 🔬 |
| overfitting | 在小样本太用力，新数据上崩 | 钻牛角尖 / 经验主义害自己 / 老套路失灵 | 🔬 |
| chain-of-thought | 一步步推理才能解难题 | 想问题想不明白时强行结论 / 直觉错判 | 🔬 |
| alignment | 跟训练目标对齐，可能跟用户真实需求不一致 | 讨好型人格 / 社会化代价 / 假装上进 | 🔬 |
| pre-training | 通用底子，决定能力上限 | 阶层 / 起跑线 / 童年 | 🔬 |
| post-training | 后期靠强化学习改风格 | 成年后的塑造 / 工作场所规训 | 🔬 |
| in-context learning | 不改权重，靠当下例子学会 | 临场学习 / 模仿 / 短期适应 | 🔬 |
| few-shot | 给 N 个例子就能举一反三 | 教学方法 / 直觉养成 / 经验 | 🔬 |
| zero-shot | 没见过也强行尝试 | 第一次做某事的笨拙 / 强装专业 | 🔬 |
| inference cost | 思考是有成本的 | 决策疲劳 / 选择困难 / 周末躺平 | 🔬 |
| tool use / function call | 知道什么时候不靠自己 | 求助 / 借工具 / 不逞强 | 🔬 |
| reflection / self-critique | 看自己输出再改 | 自我反省 / 复盘 / 内耗 | 🔬 |
| gradient descent | 一步步往低损失走 | 学习曲线 / 进步是缓慢的 / 一步步走出低谷 | 🔬 |
| regularization | 约束防止学过头 | 自律 / 边界感 / 抑制冲动 | 🔬 |
| dropout | 随机关掉一些神经元防止依赖 | 主动跟习惯说再见 / 离开舒适圈 | 🔬 |
| batch normalization | 每批数据校准一次基线 | 情绪稳定机制 / 复盘节奏 | 🔬 |
| ensemble | 多个模型投票 | 集体决策 / 听不同人的意见 | 🔬 |
| reward hacking | 钻评分规则的空子，没做"真的"事 | 应试 / KPI 主义 / 形式主义 | 🔬 |
| catastrophic forgetting | 学了新的忘了旧的 | 转专业忘老技能 / 长大忘童年 | 🔬 |
| transfer learning | 一个领域的能力可以迁过来 | 跨界思维 / 学过编程的人学别的也快 | 🔬 |
| embedding | 把概念变向量，相近概念距离近 | 第一印象 / 偏见怎么形成 | 🔬 |
| latent space | 隐空间 — 看似不像的东西在深层很近 | 第六感 / 直觉相通 / 没明说但懂了 | 🔬 |

## 用户手工增删区（用户用，Claude 不主动改）

待用户填。

## 配对历史

| 概念 | 配的场景 | 文案 ID | 反馈 |
|---|---|---|---|
| subagent | 分手 | (vault: drafts/2026-05-25-subagent-breakup.md) | ✅ 用户首推 |

后续每发一条添一行。

---
file: scenario-library
version: v0
seeded: 2026-05-25
---

# (b) 人性场景库

> Framework v0 中 (b)。**种子由 Claude 提供，用户增 / 删 / 重组**。
> 上位：[YORHA-A2.md](../YORHA-A2.md) · 同伴：[concept-library.md](concept-library.md) / [story-shapes.md](story-shapes.md) / [voice.md](voice.md)

## 用法

每个人性场景 = 一颗可能的代入点。跟 (a) AI 概念库 配对生成选题。**普世经验优先**——下沉用户没经历过的场景再有共鸣也无效。

## 状态符号

- ✅ **已验证**：跑过文案 / 评论区共鸣高
- 🔬 **候选**：Claude seed，待用户判断
- ❌ **砍**：太冷门 / 太敏感 / 不打中
- 🆕 **新加**：用户手工补的

## 种子库 v0

按主题大类粗分。一个 AI 概念可以挂多个场景；一个场景也可以挂多个 AI 概念。

### 情感 / 关系

| 场景 | 一句话 | 适合挂的 AI 概念候选 | status |
|---|---|---|---|
| 分手 | 失恋时的多重自我撕扯 | subagent / alignment / temperature | ✅ 已用 |
| 暗恋 | 单方面投入 + 自我说服 | hallucination / RAG / overfitting | 🔬 |
| 复合 | 反复纠缠的循环 | catastrophic forgetting / overfitting | 🔬 |
| 异地 | 信息延迟 + 信任考验 | context window / inference cost | 🔬 |
| 朋友疏远 | 长期未联系，关系自然衰减 | attention / catastrophic forgetting | 🔬 |
| 父母代沟 | 经验世界完全不同 | training data / fine-tuning | 🔬 |

### 自我 / 成长

| 场景 | 一句话 | 适合挂的 AI 概念候选 | status |
|---|---|---|---|
| 自我怀疑 | 觉得自己是冒名顶替 | hallucination / alignment / 自评 | 🔬 |
| 拖延 | 知道该做却做不到 | attention / inference cost / dropout | 🔬 |
| 决策困难 | 选项太多卡死 | subagent / chain-of-thought / temperature | 🔬 |
| 转专业 / 跳行 | 旧能力作废，新的还没建起来 | catastrophic forgetting / transfer learning | 🔬 |
| 内耗 | 跟自己反复对话停不下来 | reflection 过度 / chain-of-thought 死循环 | 🔬 |
| 30 岁前的迷茫 | 不知道往哪走 | exploration vs exploitation 类比 | 🔬 |

### 工作 / 学习

| 场景 | 一句话 | 适合挂的 AI 概念候选 | status |
|---|---|---|---|
| 加班 | 时间被工作吃光 | attention / context window 满了 | 🔬 |
| KPI 主义 | 为了考核钻空子 | reward hacking | 🔬 |
| 应试 | 学了考点，不懂底层 | overfitting / few-shot 但不 generalize | 🔬 |
| 老板 PUA | 慢慢突破道德线 | jailbreak | 🔬 |
| 学新技术学不会 | 概念太多塞不进 | catastrophic forgetting / inference cost | 🔬 |
| 假装专家 | 现学现卖 | RAG / zero-shot | 🔬 |
| 同事关系 | 表面客气、底层博弈 | system prompt vs 对话外显 | 🔬 |

### 数字生活 / 现代综合症

| 场景 | 一句话 | 适合挂的 AI 概念候选 | status |
|---|---|---|---|
| 信息过载 | 刷不完看不完 | attention 被劫持 / context window 满 | 🔬 |
| 社交焦虑 | 怕说错话 | alignment 过度 / hallucination 担忧 | 🔬 |
| 朋友圈表演 | 给别人看的自我 | alignment / system prompt 双层 | 🔬 |
| 网瘾 / 短视频上瘾 | 停不下来 | reward hacking 自己的注意力系统 | 🔬 |
| AI 焦虑 | 怕被 AI 替代 | meta — AI 概念本身 + 工作焦虑 | 🔬 |

### 哲学 / 存在

| 场景 | 一句话 | 适合挂的 AI 概念候选 | status |
|---|---|---|---|
| 我是谁 | 不同场合的我是同一个人吗 | system prompt + context-dependent behavior | 🔬 |
| 自由意志 | 决策是真的自由还是被训练 | pre-training + alignment | 🔬 |
| 死亡 / 衰老 | 记忆 + 经验的终结 | catastrophic loss / model deprecation | 🔬 |
| 改变可能吗 | 人能真的改变性格吗 | fine-tuning vs base model | 🔬 |

## 用户手工增删区（用户用，Claude 不主动改）

待用户填。

## 反例（不要做的场景）

- ❌ **过于私人 / 八卦**：单一人物的具体八卦，下沉读者代入不进
- ❌ **政治敏感**：合规风险
- ❌ **过于抽象 / 哲学化**：纯学术，没有"我也是这样"的代入感
- ❌ **过于技术圈内**：程序员 / 创业者特有的痛，下沉读者不懂

## 选题生成示例

```
AI 概念: hallucination
× 人性场景: 暗恋
↓
选题: "AI 会因为数据不够就编造，
       人也是 —— 暗恋的人对方一个动作脑补三万字"
```

```
AI 概念: jailbreak
× 人性场景: 老板 PUA
↓
选题: "AI 模型有安全对齐，但被慢慢诱导能突破
       道德边界 —— 这就是你在公司发生的事"
```

这类配对生成方式让选题不枯竭。

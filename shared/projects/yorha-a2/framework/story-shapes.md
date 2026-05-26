---
file: story-shapes
version: v0
seeded: 2026-05-25
---

# (c) 故事结构 / arc 模式

> Framework v0 中 (c)。**v0 默认是 subagent shape；其它 arc 标 🔬 待验证**。
> 上位：[YORHA-A2.md](../YORHA-A2.md) · 同伴：[concept-library.md](concept-library.md) / [scenario-library.md](scenario-library.md) / [voice.md](voice.md)

## 已验证 v0 默认 arc

### Shape A · 撕扯升华（subagent shape）✅

```
1. 技术概念 [钩子]
   "一个完整的 agent 处理复杂任务时，不会只靠一个脑袋硬扛..."

2. 情绪场景代入 [钩 + 锚]
   "感情也是这样。当她决定和我分手的时候..."

3. 撕扯加剧 [核心戏剧张力]
   感性 / 妄念 / 回忆 / 自尊几个 subagent 在 push-pull
   每段一个角度，节奏短句

4. punch line 升华 [收 + 立意]
   "所谓成长，大概就是从被某一个 subagent 控制，
    慢慢变成自己这个主系统重新上线。"
```

**为什么这条 shape 跑得通**：技术钩子吸引好奇心 → 情绪场景让用户代入 → 撕扯让用户感到"对，我也是这样" → punch 给一个**新的解释框架**让用户带走。这是 "认知 + 情绪 + 行动建议" 三层都到的结构。

**已验证**：subagent / 分手 那一条已经在抖音被市场证明（用户告知）。

---

## v0 gap 警告

**全部用 Shape A 会同质化**。同样是"AI×人性"，如果每条都是"撕扯升华"，账号会快速被读者识别为公式产物 → 失去新鲜感。

**用户校准点（待回答）**：

- (i) 先靠同质化建立账号风格识别度（前 3-6 个月所有内容用 Shape A），稳定后再扩 arc？
- (ii) 一开始就 mix 2-3 个 arc 形态，避免单调？

如果选 (i) → 后面 3-6 个月只用 Shape A，其它 arc 暂时冻结
如果选 (ii) → 从下面 🔬 arcs 中选 2-3 个进入 active set

## 🔬 候选 arc（待验证）

### Shape B · 双线对照

```
1. 设置两条线（AI 怎么做 / 人怎么做）
2. 并排展开，对比相似 + 对比差异
3. 结尾给一个 takeaway：人比 AI 多了什么 / 少了什么
```

适合：alignment vs 人的讨好型、temperature vs 决策风格、training data vs 童年经历

**风险**：纯对比缺乏戏剧张力，可能"对、然后呢？"

### Shape C · 反讽 / 错位 🔬

```
1. 表面讲一个 AI 的工程问题（严肃技术框架）
2. 中段轻轻一转，发现讲的是某种社交/情感现象
3. 用户笑出来 / 苦笑
4. 不强行立意，留白
```

适合：reward hacking / hallucination / overfitting 这类有"啊原来这就是..."的概念

**风险**：要求笔力 / 节奏，写不好就尬

### Shape D · 第二人称叙事 🔬

```
1. 直接对读者说"你"
2. 描述一个 you 都经历过的场景
3. 用 AI 概念给这个场景"命名"
4. 结尾："这个东西在 AI 里叫 X"，让读者感到被命名 = 被理解
```

适合：context window 满了 / catastrophic forgetting / attention 被劫持

**风险**："你" 用过头会冒犯感，距离感不对

### Shape E · 假设性 / 思想实验 🔬

```
1. 提一个荒诞前提："如果你能 fine-tune 一个前任 / 父母 / 自己..."
2. 推演会发生什么
3. 暴露问题本质
4. 收尾："你不能 fine-tune 别人。你只能 fine-tune 自己"
```

适合：fine-tuning / pre-training / 改造他人的幻想

**风险**：太抽象，下沉读者代入慢

### Shape F · 解释型 / 教学 🔬

```
1. 直接讲一个 AI 概念是什么
2. 用 1-2 个生活类比
3. 不强行升华，目的是"科普 + 让你觉得 AI 这事我懂了"
4. 适合短视频的快节奏 (30-60 秒版本)
```

适合：所有概念都能套，但 voice 容易变成"AI 老师"，破坏 YoRHa-A2 的"内省"调性

**风险**：变成纯科普号，跟"AI×人性"角度脱节

## Shape 选择 decision tree（v0）

```
选题 = AI 概念 × 人性场景
  ↓
人性场景有强情绪 + 普世经验？
  ├── Yes → Shape A (撕扯升华，默认)
  └── No  → 看具体角度：
            ├── 对比维度强 → Shape B
            ├── 有荒诞 / 反讽点 → Shape C
            ├── 想给"被理解感" → Shape D
            ├── 想做思想实验 → Shape E
            └── 知识科普为主 → Shape F (谨慎，可能脱角度)
```

**v0 默认建议**：80% 用 Shape A，20% 试其它 Shape，跑 1 个月后看哪些 Shape 数据好留下、差的砍。

## 不在本文件维护的部分

- 配视觉 / 镜头节奏 → 后期 SOP
- 平台特定的开头 3 秒钩子 → 后期 SOP
- 数据 / metric 解读 → 后期 SOP

## 配对历史

| Arc | 配对概念+场景 | 文案 ID | 实际效果 |
|---|---|---|---|
| A · 撕扯升华 | subagent × 分手 | drafts/2026-05-25-subagent-breakup.md | ✅ 抖音验证 |

后续每发一条添一行。

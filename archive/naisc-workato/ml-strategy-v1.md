---
source: claude
project: Workato NAISC
date: 2026-05-04
type: strategy-notes
status: thinking-not-decided
related:
  - "[[Post-Finals · Forward Plan v1]]"
  - "[[Discord Integration · v1]]"
---

# Ripple · ML 策略思考笔记 v1

5/4 跟 Claude 聊出来的 ML 决策框架。**不是要立刻做，是想清楚**：以后什么时候做 ML、做什么、不做什么、怎么跟 MCP 衔接。

---

## 1. 一个反直觉的核心认知

**MCP 是天然的 model-LLM 解耦层**。

```
LLM 永远不"读"模型。LLM 读模型的输出。
```

模型对 LLM 来说就是一个 function call。模型可以是：
- 1 KB 的 logistic regression
- 70B 参数的 fine-tuned Llama
- 一张查表
- 一段 if/else
- 甚至一个 z-score 计算

LLM 不知道也不需要知道。LLM 看到的只是 `tool_name`、`input schema`、`output schema`。

→ **这意味着 ML 这条路对 Ripple 是"零迁移成本"**。今天用 z-score baseline，半年后训了 model 把 implementation 换掉，**LLM 端 / agent 端 / pitch 故事不用改一个字**。

→ 所以 ML 的"上不上"不是工程问题，是**商业 / 阶段问题**。

---

## 2. ML 商业价值的四个层次（**阶段相关**）

| 阶段 | 用户量 | ML 商业价值 | Ripple 当前 |
|---|---|---|---|
| Hackathon / pre-product | 1-10 | 0 | ✅ 这里 |
| MVP SaaS | 100-1k | personalization 起作用 | 可能 6 个月 |
| 增长期 | 10k-100k | 预测 + 网络效应 | 1-2 年 |
| 平台 | 100k+ | actuarial-grade B2B | 3-5 年 |

**四种价值机制**：

1. **Personalization** —— Whoop/Oura/Fitbit Premium 卖订阅本质卖这个。用户跑了 6 个月 baseline → 离开 Ripple 等于失去 6 个月的个人模型。**hackathon 阶段不存在**。

2. **预测 vs 反应** —— 反应式（"你现在心率高"）几乎没商业价值。预测式（"未来 7 天 HRV 趋势预测抑郁发作 P=0.72"）**保险 / EAP / 企业健康买这个**。

3. **合规级证据** —— B2B 客户买的不是"准确"，是"我能不能用这数字写进合同 / 提交监管 / 算保费"。要 AUROC / FPR / TPR，z-score 答不了。**Ripple 至少 Series A 阶段才碰得到**。

4. **网络效应** —— 每个新用户给系统打 label → 让系统对下一个新用户更准。**Ripple 4/19 双向 chat bot 收集的 user-tagged events 是数据飞轮的入口，目前最被低估的资产**。

---

## 3. Ripple 现阶段最强 pitch line（不撒谎不夸大）

> "We don't train models today — but every Workato recipe is structured data capture by design. The MCP surface is the distribution layer for whatever models we train later. The first 10,000 users we sign up *is the model*."

→ 比 "we trained a model on Apple Watch data" **强 100 倍**，评委追问没破绽。

---

## 4. ML 训练范式的四种 pattern · 何时用什么

### A · Online Learning

- **机制**：每个新样本立刻更新权重
- **真实用例**：HFT、广告点击预估、实时反欺诈（**几乎都是高频领域**）
- **何时用**：毫秒级决策 + 每秒数千样本 + 需要 streaming 总线
- **Ripple 评判**：❌ **永远不该用**。样本率分钟级、决策不需要毫秒，复杂度不值

### B · Batch Retrain（**生产 ML 95% 用这个**）

- **机制**：每晚 / 每周 / 每月调度，从 0 训 → 验证 → canary → 部署
- **真实用例**：Netflix（夜间）/ Spotify Discover（每周）/ 信用风险（每月）
- **何时用**：大多数情况；天-月级 freshness 够用、需要可验证可回滚
- **Ripple 评判**：✅ **6-12 个月后，对特定任务**用。例如：
  - 每晚 batch："基于过去 7 天预测今天 recovery score"
  - 每周 batch："context tag classifier" —— 把 user 历史 tagged events 转成 supervised classifier

### C · Continuous Fine-Tuning（**复杂 + 算力贵**）

- **机制**：Pretrained base model + LoRA / 顶层微调 + 周月级 adapter 更新
- **真实用例**：Bloomberg GPT、医学影像、Whisper LoRA per speaker
- **何时用**：base model 不错但需要专业化 + 千+任务样本 + 推理量大能摊薄成本
- **Ripple 评判**：⏳ **12+ 月后，特定任务**。微调 frontier LLM（Claude / Kimi）这阶段**100% 浪费钱** —— prompt + RAG 已经能解决 95%

### D · Retrieval-Augmented (RAG / MCP) ← **Ripple 现在该用的**

- **机制**：模型不变，**新数据进 Supabase / vector DB → 查询时检索注入 prompt**
- **Ripple 评判**：✅ **Ripple 的 MCP 架构已经是这个**。新数据进 Supabase 那一刻，下一次 LLM query 就能查到 —— **这就是真正的"实时更新"，模型本身不动**

---

## 5. 模型 → MCP tool · 工程套路

当未来真做了模型（Pattern B 或 C），怎么让 LLM 用上：

```
模型训练完 → 写 tool handler 函数 → 包装成 rich JSON 输出 → 暴露成 MCP tool
```

**核心：输出 schema 要"对 LLM 友好"**

❌ 坏输出：`{"score": 0.73}` —— LLM 看了等于没看
✅ 好输出：
```json
{
  "recovery_score": 0.73,
  "scale": "0-1, higher = better",
  "vs_personal_baseline": "1.4σ below 30-day median",
  "key_drivers": [
    {"feature": "hrv_7d_drift", "value": -0.42, "weight": 0.35}
  ],
  "confidence_interval_95": [0.58, 0.84],
  "model_version": "recovery-v3.2"
}
```

→ **给 LLM 的输出 = 给一个聪明实习生的报告**。单位、对照、driver、置信度、版本，全都写明。

→ 这层做好，**就算 model 只是 logistic regression，效果都好过返回纯 number 的神经网络**。

---

## 6. 模型 serve 的 5 种 pattern · Ripple 选哪个

| Pattern | Latency | Ripple 用例 |
|---|---|---|
| **In-process**（pickle 进 serverless）| 50-150ms | 轻量分类器 |
| **Dedicated server**（FastAPI / Triton）| 100-500ms | 大模型 / 需要 GPU |
| **Batch precompute** ← **Ripple 90% 选这个** | 20ms | 日级预测：recovery score / mood drift |
| **Model-as-service**（HuggingFace / Replicate）| 200-1000ms | 不想自运维 GPU |
| **Fine-tuned LLM 本身**（model = LLM）| 直接 LLM 推理 | 极少数 |

**Ripple 真要做的预测都是日 / 周级**：
- "今天的 recovery score"
- "未来 7 天抑郁风险"
- "最近 14 天 baseline drift"

→ 没必要每次 LLM 调都 inference。**每晚 batch 跑一次写进 Supabase 一列，tool 只 SELECT，latency < 30ms**。这是最经济的方案。

---

## 7. 实时性的真相

**Tool call latency**（LLM 调 → 拿到响应）：20-300ms · **不是瓶颈**
**Prediction freshness**（prediction 基于多新的数据）：取决于上游数据流 + retrain 频率 · **才是真问题**

→ MCP 不引入延迟。"实时让 LLM 读懂"在 MCP 范式下根本不存在。**真问题是数据管道和 retrain pipeline**。

---

## 8. 决策

**5/22 之前不做 ML**。理由：
- 数据不够（1 人 × 几个月 ≠ 训练集）
- 训了过拟合，pitch Q&A 一问破
- prompt + 现在的 RAG/MCP 已经能 95% 解决

**应该做的**：
- 把 retrieval 层做厚（Discord 已经接，下一步 Calendar / Obsidian）
- 改进 baseline 算法（7d rolling vs 30d，识别 slow drift）
- 让 LLM 的 prompt 带上 user tagged events 做 few-shot
- 把"我不训 ML，我做 evidence-based retrieval"包装成 pitch line

**真正上 ML 的最早合理时间点**：6-9 个月后 + 第一个 paid 客户场景出现 + 数据量过 100 用户 × 30 天。
**第一个该上 ML 的任务**：批量打 mood / context tag 给历史 anomaly —— 直接的产品体验改善 + 减少手动 tag 负担。

→ **但这取决于 5/22 之后是否继续做 Ripple**。技术问题，但本质是产品 / 个人方向问题。后面再想。

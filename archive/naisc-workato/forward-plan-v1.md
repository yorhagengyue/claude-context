---
source: claude
project: Workato NAISC
date: 2026-04-25
updated: 2026-05-04
type: forward-plan
status: working-doc · partially-shipped
phase: post-submission · pre-mentorship
related:
  - "[[NAISC]]"
  - "[[Submission Email · Final v4]]"
  - "[[Trailer Script · Full Narration v1]]"
  - "[[Discord Integration · v1]]"
  - "[[ML Strategy · Thinking Notes v1]]"
  - "[[Implementation Log]]"
---

> **2026-05-04 更新**：原本 §2a 状态思考方向第一块拼图（Discord context source）**已经做出来了** —— 见 [[Discord Integration · v1]]。
> ML 策略想清楚了 —— 见 [[ML Strategy · Thinking Notes v1]]。
> §5 mentor 问题清单仍未变 —— 5/8 见 mentor 时仍按那份去问。

# Ripple — Post-Finals Forward Plan v1

> 时间窗：2026-04-25（决赛入选）→ 2026-05-08（mentorship）→ 2026-05-22（pitch）
> 这份文档是 **5/8 mentorship 前的工作档**：记录 Ripple 现状、定锁前进方向、整理要带去问 mentor 的问题清单。

---

## 0. 当前状态 · 2026-04-25

### 比赛进展
- **入选 NAISC 2026 Workato Track 决赛**（Sarah Loke / Workato 官方邮件确认 · 4/24 16:42 SGT 收到）
- 决赛 7 个队伍之一，pitch 5 月 22 日（Fri）
- mentorship slot tentative on 5 月 8 日（Fri）

### 团队（Sarah 官方名单）
- **Team YoRHa**
- Geng Yue（耿越 / Tommy Chen）
- Liu Zicheng
- **Chen Yufei**（— 注意：trailer / 网站 / submission email 里之前写的是 "Tommy Chen" 当作第三个人，那是把耿越的英文名当成另一个队员了。Sarah 官方记录是 Chen Yufei）

### 已交付（submission package）
- **Trailer**：~4 分钟，11 scene + 用户自录 site tour，YouTube `https://youtu.be/NbFPHHf_jz8`
- **网站**：https://ripple-wellness.vercel.app/ ，hero + 嵌入 trailer + /pipeline /chat /timeline 子页面
- **Live prototype**：Workato MCP server `https://1720.apim.mcp.trial.workato.com/`，4 tools 上线（`get_current_vitals` / `get_baseline_deviation` / `get_recent_anomaly_log` / `send_contextual_nudge`）
- **8 recipes** 在 Workato Ripple 项目下运行：bulk ingest / live HR spike / 24h anomaly watchdog / 4 个 MCP skill recipes / 双向 chat bot
- **真实数据**：Apple Watch → HAE → Workato → Supabase → MCP → Claude / Codex / Cursor 全链路通

### 已知风险 / 弱点（4/19-4/20 memory 留档）
- **iOS HAE 后台调度不稳** — Recipe 1 (`live_hr_alert_demo` ingest) 最近 30 天只触发 24 次（~0.8/day），4/18 后零触发。HAE 文档明确 iOS 锁屏禁访 HealthKit + 后台调度 iOS 决定
- **Workato CodeMirror UI 自动化失败** — Plan B 升级 Kimi chat 时尝试用 JS 自动写 recipe 字段，CM preview 状态下 click/focus synthetic event 全部唤不醒真 CM。结论：**Workato 表单不能全程 JS 自动化**，只能 user 手动粘贴
- **Ruby formula sandbox 限制** — 4/20 memory 中已踩坑
- **Workato trial 账号** — endpoint URL 含 `.trial.` 字样，月任务配额未确认

---

## 1. 决赛 vs 提交 — 这是不同性质的事

submission 那一关考的是**录制好的作品**：评委自己时间里看 trailer / 翻 deck / 点 link 试 prototype。靠的是 polish、叙事、film 节奏感。Ripple 在这一关赢了。

decision 那一关考的是**现场表现 + Q&A + 7 队同台对比**。评委只需要从 7 队里**记住 1 队**就够。Q&A 的目的是来刺穿薄弱处。

→ **让 Ripple 进决赛的东西不会让 Ripple 赢决赛**。

trailer 里那种 "The body speaks before the words do" 的 poetry 在 pitch 现场是负担。评委（学生 + 工程师 + business 人）想要的是 "what does this DO that wasn't possible before / who pays first / how does it scale"。

但用户的 pushback 是对的：**这是 hackathon 不是融资**。所以下面那些（被抄袭风险 / 长期 moat / FDA liability）**不是这一阶段的问题**。这一阶段的问题是 ——

> **5/8 mentorship 怎么用 + 5/22 pitch 之前能加深什么**？

---

## 2. 后续方向 — 用户的两个设想

### 2a. 状态思考 / Context Fusion（**主线**）

**核心想法**：现在的链路 watch → workato → supabase → MCP → AI client，AI client 拿到的是 vitals 数字。**这数字是 panic 还是 gaming 还是 caffeine —— 现在是用户手动告诉的**（4/19 双向 chat 里 user 输入 "gaming"）。

**升级目标**：HR spike 触发 → agent 自己跑一圈 context 调用 → 自己推断 "gaming" → 自己记录。Human-in-loop 只在低置信度时介入。

**示例 context source**：
- Discord（gaming 是已经反复测过的 12 case 之一，最强 demo case）
- Calendar（meeting / class —— "during a meeting → not gaming → maybe stress"）
- Obsidian（user 的当日记录）
- Maps / 地点
- 其它 planner / scheduler app

**对 Workato Track 叙事的价值**：
- "Workato 不只是数据 spine，**还是 agent runtime**"
- 现有 4 tool MCP 池子 → 扩到 8-10 tools（加 `get_calendar_window` / `get_discord_presence` / `get_obsidian_today` / `record_inferred_context(reason, confidence)`）
- 增加 1 个新 recipe：`agent_context_loop` —— webhook 触发 → LLM call → tool routing → 收集 → 写回
- pitch 现场可以说："**The same MCP surface that powers Claude / Cursor now powers Ripple's own internal reasoning loop.**" 这是 Workato 平台的 dogfooding moment

**子问题（推迟到方向锁定后再讨论）**：
- 选哪几个 context source 作为 5/22 之前的 ship target
- 低置信度时怎么处理（auto-record + tag / auto-message user 确认 / 双向 chat 复用）
- 各 source 的接入工作量（Discord OAuth, Calendar 已有 Workato connector, Obsidian 需要自建）

### 2b. 一键报警 + Map + IMU 姿态（**Phase 2**，5/22 之后做）

**用户原话设想**：
- 监测到地图上以"跑步速度"前进 + watch 姿态确认手臂摆动 → 确认在跑步
- 运动突然停止 + watch 水平 → 可能摔倒 → 触发紧急
- 一键报警按钮（user-initiated 紧急）

**为什么放 Phase 2**：

1. **Apple Watch IMU 数据 HealthKit 不导出**。HAE 拿不到原始 accelerometer / gyroscope。要做 posture 检测需要**自己写 Watch app 订阅 CoreMotion** —— Swift 新栈、App Store 审核流程、不在已有 Workato 数据 spine 上
2. **Apple 已做 fall detection**（SE / Series 8+ 系统级 feature，60 秒确认窗 → 自动 SOS）。你做的不是 "有没有摔" —— 是非紧急状态的歧义消除（HR=150 是 panic 还是 gaming chair stress 还是 car accident），价值定位要重新讲
3. **Maps + 速度 + 姿态 = 三个新数据轴**，对 Workato 数据 spine 是新接口
4. **Emergency 触发的 liability ceiling** —— 误报一次 SOS 是真成本，需要保守阈值 + 二次确认

**结论**：5/22 之前不做。25 天里做不出能演的版本，只会让 pitch 多一个 promise，少一个 deliverable。比赛后做 v0.2 release。

---

## 3. 状态思考的架构选项

### Option A · agent reasoning **跑在 Workato 内**

`agent_context_loop` recipe 自己持有 messages array，调用 LLM API，拿回 tool_calls，路由到子 recipe / connector / MCP tool，收集结果，回灌 messages，再调 LLM，直到没有更多 tool_calls 为止，最后写 inference 到 Supabase。

**Pro**：
- 对 Workato Track 评委叙事最强 —— "Workato is the agent runtime AND data spine AND skill surface"
- 完全在 Workato 平台内闭环，pitch 时 demo 路径清晰
- 不依赖任何外部 reasoner

**Con**：
- Workato 是不是真能跑 LLM tool-calling loop —— **未验证**（见 §4）
- Trial 账号配额可能撑不住 agent loop 的 task 倍增

### Option B · agent reasoning **跑在外部**（Claude Desktop / Cursor / 自建 agent）

外部 agent 订阅 Ripple 事件流（webhook 或 polling），自己跑 reasoning，调用 Workato MCP tool 拿 context，写回 inference。Workato 退到纯 data spine + tool surface 角色。

**Pro**：
- **已经 partial 实现** —— 你 4/19 的双向 chat bot 就是这个范式（Kimi 在外部跑，Workato 提供 tool）
- 可行性 100% 已知
- 不消耗 Workato trial 配额做 reasoning

**Con**：
- Workato Track 评委叙事被稀释 —— "你只是用 Workato 当数据库 + 工具仓库，reasoning 在别处"
- Pitch 现场要解释为什么 "Workato is the runtime" 这句话只在数据层成立

### 我的判断

**Option A 是 pitch 制胜方向**，但前提是 Workato 平台能力真够。**Option B 是兜底**，至少保住"已交付"。

**这个选择的关键决策点是 Option A 在 Workato 内的可行性** —— 这是带去问 mentor 的核心问题。

---

## 4. Option A 在 Workato 内的可行性预判（待 mentor 确认）

### 4.1 一个 LLM tool-calling agent loop 拆解 = 6 个能力

```python
init messages
loop (max N):
  resp = LLM(messages, tools=schema)
  if not resp.tool_calls: break
  for tc in resp.tool_calls:
     result = dispatch(tc.name, tc.args)
     messages.append(tool_msg(result))
record final
```

| # | 能力 | Workato 的判断 | 信心 |
|---|---|---|---|
| 1 | LLM HTTP 调用 | HTTP connector + 已在 Moonshot.AI recipe 用过 Kimi | **HIGH** ✅ |
| 2 | 动态终止的循环 | "Repeat with stop condition" / "Repeat until" | **MEDIUM** 需 mentor 确认 |
| 3 | 跨迭代的 mutable state（messages array growing）| Workato 2024+ 有 List/Object Variables action | **MEDIUM** 需 mentor 确认 |
| 4 | tool name → recipe 的动态 dispatch | "Call recipe by name" / sub-recipe + IF chain | **HIGH** 笨但能做 ✅ |
| 5 | LLM 响应 JSON 解析（提取 `tool_calls` array）| Ruby formula sandbox 受限（4/20 memory），基础 parse OK，**嵌套 parse 不确定** | **MEDIUM** |
| 6 | 时间 / 任务配额 | trial 账号，月任务上限未知 | **LOW** 必须查 |

### 4.2 三个真风险（按严重度排序）

**P0 · Trial 账号配额** —— 决定生死

一次 agent loop 触发 ≈ 1 LLM 调用 × 6-8 iterations × 平均 4 step / iteration ≈ **30 task / 次**。

如果 demo 期间 50 次触发 / 天 × 30 task = **1500 tasks/day**。Workato trial 通常 1000-2500 tasks/month。**可能 3 天烧光月配额**。

→ 必须查的数：当前 trial plan 的月 task 上限 + 当前用量 + 剩余天数 + 升级路径

**P1 · Mutable state 在 Repeat 循环内能否稳定**

LLM 的 messages array 每次循环要 append 新元素。有两条路：
- (a) `List Variables` action append（2024+ feature，trial 是否启用未知）
- (b) Supabase round-trip：起头 INSERT 一行，每 iteration UPDATE jsonb_array_append。**100% 能跑**，但每迭代 +2 step，task 消耗 2×

→ 必须确认：Variables action 在循环内的 idempotency / persistence semantics

**P2 · Ruby formula 解析嵌套 JSON**

OpenAI / Anthropic 风格响应：
```json
{"choices":[{"message":{"tool_calls":[{"id":"...","function":{"name":"get_calendar","arguments":"{...}"}}]}}]}
```

要从这里：
- 提 `tool_calls` 是数组（外层 parse OK）
- 遍历它
- 拿 `function.name` 和 `function.arguments`（**arguments 是嵌套 JSON 字符串还要二次 parse**）

4/20 memory 写过 "Ruby formula 在 Workato 沙箱限制"。**嵌套 JSON 二次 parse 在沙箱里能不能干净走通是个未知数**。

→ 退路：让 LLM 输出非标准格式（plain JSON 不嵌套，比如 `tool_name: ..., args_field_a: ..., args_field_b: ...`），用 system prompt 约束。**仍然能做，但 tool 调用规范要自己定**，不是 OpenAI / Anthropic 标准。

### 4.3 我的可行性下注

- **总体：60-70%**
- 配额够 + 能力都验证 OK：85%
- 配额不够，但能升级 / 临时换账号：65%
- Variables action 不能用，走 Supabase round-trip：仍 OK，task 消耗 2×
- 嵌套 JSON 解析失败，退到 plain JSON 协议：仍 OK，多一道 prompt engineering

### 4.4 最坏情况退路

**Option A 完全跑不通 → 退回 Option B**。

Option B 已经 partial 实现（Claude Desktop 已经能调 4 tool）。沉没成本低。叙事退到 "Workato is the data spine and skill surface"，Workato Track 仍然成立但少一个 climax。

---

## 5. 5/8 Mentorship · 要确认的问题清单

按优先级 P0 / P1 / P2 排。带这份去。

### P0 · 不确认这些就不能锁定 Option A

- [ ] **Trial 账号月 task 上限是多少 / 当前已用多少 / 还剩多少天**？
- [ ] **比赛期间有没有临时升级 / 提配额的窗口**？（hackathon 一般会有）
- [ ] **Workato 推荐的 LLM tool-calling 模式是什么**？官方有没有 best practice / sample recipe？或者直接走 AI Hub / Genie 的 prebuilt agent runtime？
- [ ] **`Repeat with stop condition` 在 Workato 里到底叫什么 step / 怎么用**？最大迭代上限多少？
- [ ] **List / Object Variables action 在 trial 上启用了吗 / 在 Repeat 内 append 稳定吗**？

### P1 · 影响实现路径选择

- [ ] **Recipe-to-recipe call（Call recipe action）的延迟和 task 消耗**？vs HTTP 走 MCP endpoint 自循环？哪个 Workato 推荐？
- [ ] **Ruby formula 沙箱的 JSON 解析能力上限**？嵌套 JSON 二次 parse 行不行？有没有更原生的 JSON path 提取 step？
- [ ] **MCP server 的多 client 并发处理** —— 同一个 tool 如果被两个 client 同时调，Workato 怎么排队？
- [ ] **AI Hub / Genie 是 Workato 的 agent 框架吗**？它和直接写 recipe 调 LLM 的关系是什么？决赛队伍用 AI Hub 是不是更"地道"？

### P2 · 加分项 / 长远

- [ ] **Workato 本身有没有 "agent" 概念的官方原语**？还是说所有 agent 都得用户自己用 recipe 拼？
- [ ] **MCP server 在 Workato 上的官方位置 —— 是 GA 产品还是 trial-only feature**？
- [ ] **决赛队伍 demo 时常见的稳定性问题 / 兜底方式**？

### 顺便要 mentor 看一眼的东西

- [ ] 现有 8 recipes 的整体架构（让 mentor 30 秒扫一下，看有没有明显反模式）
- [ ] live_hr_alert_demo 的 trigger 频率太低问题（HAE 后台调度不稳）—— 有没有 Workato 侧的解法
- [ ] pitch 期间的 demo 稳定性兜底建议

---

## 6. 5/8 之后的决策树

```
mentor 给的答案
├── 配额够 + 能力齐 → Option A 全力推（agent_context_loop 是核心 deliverable）
├── 配额不够但可升级 → 申请升级，仍走 Option A
├── 配额够但能力缺 → 用退化版（plain JSON 协议 / Supabase 兜底 state）走 Option A
└── 配额不够 + 不能升级 → Option B（外部 agent + Workato 数据），调整 pitch 叙事
```

锁定方向后，再决定：
- 选哪 1-2 个 context source 第一批接（Discord + Calendar 当前候选）
- 低置信度怎么处理（复用双向 chat / silent record / mute）
- pitch 现场 demo 用什么 trigger（live HR spike / 预录 / 手按按钮）
- deck 重新打磨方向（pitch 用 deck 和 submission 用 deck 是不同物种）

**这一层在 5/8 之前不展开**，避免 mentor 给完答案之后还要重写。

---

## 7. 5/8 之前 Claude / 你要做的事

- [x] 把这份现状 + 方向 + 问题清单整理成 Obsidian 文档（**本文件 · 已完成**）
- [ ] **Trailer / 网站 / submission email 里的 "Tommy Chen" 是否要改成 "Chen Yufei"** —— 你的决定。改的话 ~10 分钟我能帮你改完重 deploy
- [ ] 保留 8 recipes 不动，**不在 mentor 答案前修改架构**
- [ ] 如果 5/8 之前队友（Liu Zicheng, Chen Yufei）想加入这条思考线，把这份文档共享给他们
- [ ] 5/8 当天前 1 小时再过一遍这份文档，确认问题顺序

**不做**：
- ❌ spike 测 Workato 平台能力（用户明确反对：直接问 mentor 即可）
- ❌ 写任何 agent loop 代码（方向没锁，写了白写）
- ❌ 决定 context source / 置信度策略（用户明确推迟）
- ❌ 重做 deck（pitch deck 形态等 mentor 给方向）

---

## 8. 关键日期总览

| 日期 | 事件 | 准备物 |
|---|---|---|
| 2026-04-25 | 决赛入选邮件收到，本文档创建 | — |
| 2026-04-25 → 2026-05-08 | 思考期，**不动代码**，把文档完善 | 本文件 + 队友共识 |
| 2026-05-08（Fri） | Workato Mentorship slot | 本文件第 5 节问题清单 |
| 2026-05-08 → 2026-05-22 | Build phase，方向锁定后冲刺 | 待定 |
| 2026-05-22（Fri） | NAISC Workato Track 决赛 pitch | deck v2 + live demo + Q&A 预案 |

---

> **下一次更新**：5/8 mentorship 之后，把 mentor 答案填回 §5 问题清单，然后开 §6 决策树 → 锁定 Option A/B → 写 v2 forward plan

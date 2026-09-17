# FREELANCE — 线上接单/赚钱线速报

> **用途**：赚钱线的项目速报。方向、平台状态、行动清单、英文资产（resume / Upwork profile / proposal 模板）都在这。
> **状态**：Week 1 — 平台申请阶段
> **最后更新**：2026-08-12（立项 + 方向锁定 + 平台核实 + 英文资产 v1）

---

## 0. 方向（2026-08-12 owner 锁定）

- **身份**：PR/公民 → 新加坡境内 freelance/自雇**无法律限制**（此前担心的 MOM Student's Pass 限制不适用）
- **市场**：只打国际英文平台（USD）
- **时间**：Y3 开学后每周 10–20 小时
- **策略**：两条腿——AI 数据平台管现金流 + Upwork AI-agent 细分管天花板
- **优先级**：以赚钱为优先（owner 原话）。这是 §3「交付一个结果」第一次以钱为 unit 落地
- **Claude 边界**：调研、筛单、写全部文案、盯单可做；**注册账号 / 收付款 / KYC 一律 owner 自己点**

## 1. 腿 A：AI 数据平台（现金流）

2026-08-12 核实结果，按优先级排：

| 优先 | 平台 | 状态 | 单价（核实到的） | 备注 |
|---|---|---|---|---|
| 1 | **Mercor** (mercor.com) | ✅ 全球远程 | 平均 ~$31/h，coding 评审更高 | 行业最大：$10B 估值、3 万活跃 contractor、日发 $1.5M。最需求：code generation 评审 / bug detection / 架构 review / 写 gold-standard 解。Python/Rust/C++/TS 最抢手。入口 = resume + ~20min AI 视频面试（英文口语） |
| 2 | **micro1** (micro1.ai) | ✅ 全球 | curated、均价高于 Outlier | AI recruiter 面试制；任务少但质量高。ML/训练基础设施类最高（宣传 $100+/h，信一半） |
| 3 | **Outlier** (outlier.ai) | ✅ 全球、门槛最低 | coding 专项 $30–45/h，一般 $18–30 | 量最大、最容易进；口碑差评集中在「任务时有时无」。定位 = 打底填空，不当主力 |
| 4 | **Alignerr** (alignerr.com) | ✅ 可投 | 宣传 $25–50/h | 同时只能投 7 个项目、面试流程口碑差。挑 2–3 个 coding 项目投即可 |
| 5 | Turing | ⚠️ 观望 | 高但偏 FTE | 3–6 个月准全职合同为主，跟 10–20h/周冲突。有 part-time LLM trainer 批次再看 |
| ❌ | DataAnnotation | **出局** | — | 2026-08 核实：只收 US/CA/UK/IE/AU/NZ 六国，支付合规硬限制，新加坡不在名单 |

**预期管理**：申请 → 首个付费任务，典型 3 天–3 周（面试 + 排队）。Mercor/micro1 是英文口语视频面试，内容 = 讲自己的工程经历；Ripple（真上架）+ agent 系统是最硬的素材。

## 2. 腿 B：Upwork AI-agent 细分（天花板）

- **细分定位**：AI agent / RAG chatbot / LLM API 集成 / n8n 类自动化。这类单量大，且 owner 有真上架产品当证据，比多数投标人硬
- **费用现状（2026 核实）**：service fee 按合同 0–15% 浮动（多数 ~10%）；connect $0.15/个，一个 proposal 6–16 个（$0.9–2.4）；Freelancer Plus $19.99/月含 100 connects——**先不买**，profile 100% 后再充最小额度 connects。非美国 freelancer 全口径损耗 13–18%（含汇率），报价时算进去
- **报价策略**：起步 **$28–30/h**（低于 $25 会吸引坏客户，高于 $35 新号难成单）；前 3–5 单目标 = 攒 5 星评价，接 $100–500 的小 fixed-price；5 个好评后提到 $45–60/h
- **投标纪律**：只投 proposal 数 <15、payment verified 的单；每周 5–8 个 proposal；proposal 由 Claude 按 §4.3 模板代写、owner 过目发出
- **Fiverr**：暂缓（第 3 周后可选）——先聚焦，不摊薄

## 3. 每周节奏（10–20h）

| 时段 | 内容 | 时长 |
|---|---|---|
| 数据平台任务 | Mercor/micro1/Outlier 上有单就做 | 6–10h |
| Upwork 投标 | Claude 筛单 + 代写 proposal，owner 审发 | 3–4h |
| 复盘 | 跟 Claude 过一遍：哪些 proposal 有回音、单价调不调 | 0.5–1h |

## 4. 英文资产（v1 草稿，owner 过目后用）

### 4.1 Resume（Mercor/micro1 投递用，⚠️ 处需 owner 确认）

```
GENG YUE (Gengyue)
Singapore (PR) · gengyue081@gmail.com · github.com/yorhagengyue

Full-stack & AI engineer. Shipped a consumer AI health app to the Apple App Store
(solo-built client + backend), and build LLM agent systems end to end.

PROJECTS
• Ripple Health AI — iOS app live on the App Store (2026). SwiftUI client +
  Python backend (Supabase/Postgres), OpenAI API integration, HealthKit data
  pipeline. Passed App Store review incl. health-data consent & compliance
  (four rejection rounds resolved). 116 unit tests / 20 UI tests gated per release.
• Hermes — personal multi-profile LLM agent system: WeChat gateway, tool use,
  vision routing, cron jobs, persistent memory. Runs 24/7 in production for
  3 real users.
• NAISC 2026 (national AI competition) — 3rd place, Workato track: wellness
  monitoring agent with MCP tool architecture + evidence-based rule library.
• Tu2tor — real-time collaborative tutoring platform (MERN, WebSocket, CRDT, RAG).

EXPERIENCE
• Software Engineering Intern, Temasek Polytechnic (Mar–Aug 2026 ⚠️确认起止月).
  Agentic document-generation research prototype (LangGraph, LLM-as-Judge
  evaluation); enterprise workflow automation (Workato); production web app fixes.

EDUCATION
• Diploma in Information Technology, Temasek Polytechnic — Year 3,
  expected 2027 ⚠️确认毕业年.

SKILLS
Python (FastAPI), TypeScript/JavaScript (React, Next.js, Node), Swift/SwiftUI,
OpenAI & Claude APIs, RAG, agent/MCP architecture, PostgreSQL/Supabase, Docker.
```

### 4.2 Upwork profile 草稿

- **Title**: `AI Agent & LLM App Developer | RAG, OpenAI/Claude APIs, Automation | Shipped App Store AI Product`
- **Hourly rate**: $30
- **Overview**:

```
I build AI features that actually ship. My own AI health app is live on the
Apple App Store — I built the SwiftUI client, the Python backend, and the
OpenAI-powered insight engine, and took it through App Store review including
health-data compliance.

What I can do for you:
• AI agents & chatbots — OpenAI / Claude API, tool use, RAG over your docs/data
• LLM integration into existing web or iOS apps (React/Next.js, FastAPI, SwiftUI)
• Workflow automation — connect your tools so work happens without you
• Full-stack builds — from schema to deployed product (Supabase/Postgres, Vercel)

How I work: clear scope before I start, daily progress notes, tested code
(my own app ships behind 130+ automated tests). Based in Singapore (SGT) —
convenient overlap with US evenings and EU mornings.

Small, well-defined first projects welcome — I aim to be your repeat developer,
not a one-off.
```

- **Skills tags**: AI Agent Development · LLM · RAG · OpenAI API · Chatbot Development · Python · FastAPI · React · Next.js · Node.js · iOS/SwiftUI · PostgreSQL · Supabase · Automation
- **Portfolio 三件**：① Ripple（App Store 链接 + 两张截图）② NAISC 第三名（自动化 agent，一段描述 + 图）③ Hermes（架构图 + 描述，注明 private production system）

### 4.3 Proposal 模板（Claude 每单代填）

```
Hi {name} — about your {their exact goal, their words}:

Closest thing I've shipped: {most relevant proof, one line — e.g. "a health-AI
iOS app now live on the App Store, OpenAI-powered, with strict consent flows"}.

For your project I'd: 1) {concrete step}, 2) {concrete step}, 3) {concrete step}.
First milestone ({deliverable}) within {X} days.

One question before quoting precisely: {sharp scoping question that shows
you read the post}.

— Gengyue · Singapore (SGT, overlaps US evening / EU morning)
```

规则：≤150 词；第一行永远复述对方原话，不用通用开场；必带一个「读过帖子才问得出」的问题。

## 5. 收款与记账

- **收款**：Upwork → 本地银行或 Wise（汇率损耗更小）；Mercor 走 Stripe（支持 SG 银行）；Outlier 多走 PayPal → 需要一个 SG PayPal
- **记账**：每笔收入记一行（日期/平台/小时/USD/到手 SGD）——年度 IRAS 报税自雇收入要用。放 vault `02 - Areas/Finance/freelance-income.md`（首笔收入时建）

## 6. 决策历史

- **2026-08-12 立项 + 方向锁定**：owner「以赚钱为优先」；四问答案 = PR/公民、国际 USD、10–20h/周、两条腿。同日核实平台名单（DataAnnotation 出局，Mercor 主攻），英文资产 v1 落盘。→ §8 同日 project 条

# TEMPLATEAPP.md — TemplateApp 项目速报

> **上位文件**：[CLAUDE.md](../../CLAUDE.md) §5 项目索引
> **本地路径**：`~/Desktop/intern/templateapp/`
> **仓库**：本地（未建远程，pending Esther authorization）
> **完整 plan**：[PLAN.md](./PLAN.md)（同目录） / Obsidian 镜像 `~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/PLAN.md`
> **接手文档**：[HANDOFF.md](./HANDOFF.md) / Obsidian 镜像 `~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/HANDOFF.md` ← 新会话先读这个
> **本次 pivot 决策记录**：[PIVOT-2025-05-23.md](./PIVOT-2025-05-23.md)
> **最后更新**：2025-05-23

---

## 🚨 当前阶段：Agentic AI Pivot（2025-05-23）

Linda William 邮件要求把项目重构为 **agentic AI 框架**，作为 publishable 论文交付（既要代码也要论文）。

**两个论文 contribution**：
1. **Live Data Binding** — 数据源版本变化 → 自动标记 dependent reports 为 stale，触发重生成
2. **LLM-as-a-Judge** — 自动质量门：Writer 输出 → Judge 评分（5 维度）→ Pass=交付 / Fail=反馈给 Writer 改写

**ONLYOFFICE 整个扔掉**。Backend 改 Python agent service (FastAPI + LangGraph) + Node Express gateway hybrid。前端 9 屏保留，加 Agent Timeline 视图。

完整决策见 [PIVOT-2025-05-23.md](./PIVOT-2025-05-23.md) 和 [HANDOFF.md](./HANDOFF.md)。

---

## 当前状态（2025-05-23）

| Component | Status | Notes |
|---|---|---|
| 前端 scaffold | ✅ 完成 | 9 屏（Auth/Templates list+editor/Schemas list+editor/Datasets/Generate Wizard/Review/Rules）。localhost:5173 跑通。tsc + build 干净 |
| 前端 → 真实 API | ❌ TODO | 现用 localStorage stub，要切换到 Node gateway fetch |
| Node Express gateway | ❌ TODO | `templateapp/api/` 还只有 README |
| Python agent service | ❌ TODO | 将在 `templateapp/agent-service/` |
| W1 LLM-as-Judge 文献综述 | ✅ 完成 | 8 个技术 + 1 个 survey paper。结果在 vault `research/group-a-judge-techniques.md` + `group-b-judge-techniques.md` |
| 论文 W2 编辑 | ❌ TODO | Figure 1 重画、Table 1 填、加 5 个新 section |
| Gold-standard test set | ❌ TODO | benchmarking 的瓶颈，~20-30 cases |

## 团队
- **Geng Yue**（耿越 / Tommy Chen）— intern，project owner
- **Linda William** — manager，论文 co-author；on leave 5/13-5/27
- **Esther** — admin，GitHub authorization 待批
- **Ms Hu** — 邮件待重发

## 技术栈（pivot 后）

| 层 | 选型 | 理由 |
|---|---|---|
| 前端 | React (Vite + TS) + Tailwind | 已 scaffolded，不动 |
| Python agent | FastAPI + LangGraph (primary) + CrewAI + LangChain (paper compare) + docxtpl + Pydantic | Python 是 agentic 生态主战场 |
| Node gateway | Express + Sequelize + PostgreSQL + JWT | Auth + CRUD + 代理 SSE |
| LLM matrix | Claude (Opus/Sonnet/Haiku) + GPT-4/4o/mini + Gemini Pro/Flash + Ollama (Llama 3.2 3B / Qwen 2.5 3B / Phi-3-mini) | Multi-tier benchmarking 是论文核心 contribution |
| 多租户 | 所有业务表 `owner_id` | 简化 IFSG 模型 |
| ~~ONLYOFFICE~~ | **弃** | 不在 agentic loop；v1 用上传 .docx 替代 |
| Word add-in | Phase 2+ | 长期 |
| 数据绑定 | Lazy invalidation + manual refresh | event-driven 留 Phase 2 |
| Judge 输出 | JSON schema (`pass/score/criteria_breakdown/revision_hints`) | 机器可解析；revision loop 用 |

## Figure 1 → 现有屏幕映射

| Figure 1 Agent | 前端屏 | 当前状态 |
|---|---|---|
| Dataset agent | `/datasets` | UI ✅ / 逻辑 ❌ |
| Loader agent | (backend) | ❌ |
| Template agent | `/templates`, `/templates/edit` | UI ✅，TemplateEditor.tsx 还有 ONLYOFFICE mock 要拆 |
| Report Writer | `/runs` (Generate Wizard) | UI ✅ / 逻辑 ❌ |
| LLM Judge | `/review` | UI ✅ / 逻辑 ❌ |
| Orchestrator | (backend) + `/runs/timeline` (新增) | ❌ |

## W1 LLM-as-Judge 文献综述 — 关键发现（5-23）

8 个技术验证（拉真 PDF 抓 Table 数字）：

| Technique | 核心 | 关键数字 | 适用 criteria |
|---|---|---|---|
| **G-Eval** | CoT + form-filling weighted prob, GPT-4 backbone | Spearman 0.514 avg SummEval；**有 LLM-self-preference bias** | Clarity, Completeness, Format |
| **GPTScore** | LLM 条件生成 log-prob | FLAN-T5-XL 3B 反超 GPT-3 175B | Clarity（与 G-Eval 重复） |
| **FactScore** | Atomic fact 拆 + 检索验证 | 1.4% ER (Inst-LLAMA, InstructGPT)；$0.01/gen（vs $4 human）；**只测 precision 不测 recall** | Accuracy（高 stakes 审计） |
| **AlignScore** | 355M RoBERTa NLI 统一对齐 | **反超 GPT-4 on QAGS-XSum 57.2 vs 53.7** | ★ **Data consistency**（最强匹配） |
| **Prometheus / 2** | 开源 judge model (7B/8x7B) | Pearson r 0.897（vs GPT-4 0.882）；rubric-driven | Clarity, Completeness, Accuracy |
| **SelfCheckGPT** | 多次采样一致性 → 幻觉检测 | AUC-PR 93.42（sentence） | 弱配 — consistent hallucination 看不见 |
| **TrueTeacher** | T5-11B + ANLI distill | TRUE ROC-AUC 87.8（超 teacher 84.9） | Data consistency（次于 AlignScore） |
| **RAGAS** | Faithfulness / Relevance / Context relevance | WikiEval 95% / 78% / 70% human agreement | RAG 场景，TemplateApp 不直接用 |

**Combo 推荐**：AlignScore（data consistency）+ G-Eval/Prometheus 2（其他四维度）+ deterministic 规则（format compliance）。**没有一个 technique 覆盖全部 5 维**。

## 长期方向（沿用 4-27 决策）

TemplateApp 是**长期产品**，不是一次性实习交付。最终目标是 **Obsidian-style 本地优先**，最终自建编辑器替换 ONLYOFFICE。

Pivot 后简化：ONLYOFFICE 直接跳过，进入 markdown-source / 自建编辑器路径的入口。v1 用上传-only 顶住，未来再做富文本。

## 决策历史（关键节点）

完整决策表见 [HANDOFF.md](./HANDOFF.md) "Locked decisions" 节。这里只列里程碑：

- **2026-04-17** — 8 轮 Q&A 锁 13 个架构决策（Node Express、ONLYOFFICE、Ollama、`{{tag}}` 等）
- **2026-04-17 spike** — ONLYOFFICE CE + docxtpl + `{{tag}}` 验证通过
- **2026-04-27** — Linda 正式 brief，需求扩展（双用例 / 1:N / 多表 / 反向 Excel）
- **2026-04-29** — 前端 6 轮 Claude Design 设计 + scaffold 完成
- **2025-05-23** ★ **Agentic AI Pivot** — 项目转向 publishable research，ONLYOFFICE 弃，backend hybrid，多 tier LLM matrix

## 下一步（plan execution order）

按 [PLAN.md](./PLAN.md) "Suggested execution order"：

```
1.  W1 文献综述                         ✅ DONE 5-23
2.  Gold-standard test set 建（20-30 cases）
3.  W3a Python agent-service skeleton
4.  W3a end-to-end 跑通 gold-standard
5.  W2 §Framework intro + 重画 Figure 1
6.  W3b 框架对比 prototype（CrewAI + LangChain）
7.  W3b 框架 benchmark 跑
8.  W3b 多 tier model prototype
9.  W3b model benchmark 跑
10. W2 填 Table 1 + 各 Results 章节
11. W3c Node gateway（Auth → Datasets）
12. W3d 前端接 real API + Agent Timeline 视图 + ONLYOFFICE 拆除
13. W2 polish + §Limitations
```

时间无限，不是 deadline 是依赖顺序。

## 风险

1. **Judge calibration** — Judge 普遍过度乐观；需要人工 gold-standard 校准
2. **LLM cost** — 多 tier benchmarking 烧钱；Haiku/4o-mini 走量产，Opus 跑 ceiling
3. **Hybrid backend 复杂度** — Node ↔ Python HTTP 延迟 + ops 负担
4. **SSE 兼容** — Agent Timeline 需要 SSE 穿透 Vite + Express proxy
5. **论文 deadline 未知** — Linda 5/27 回再问
6. **本地 Llama 70B 硬件** — Mac 跑不动，可能只做 3B 级 local ceiling
7. **gold standard set 是 bottleneck** — 没 ground truth 论文 "judge works" 站不住脚

## 待 Linda 5/27+ 确认的开放项

1. 论文目标会议/期刊 + 投稿 deadline
2. Claude API 预算
3. Co-author 列表（Geng Yue + Linda + Ms Hu？）
4. Gold-standard test set 谁来标
5. 实现是否随论文一起开源
6. ONLYOFFICE 弃用她确认吗
7. 4-27 扩展项（多表 / 反向 Excel / Case B）在论文 scope 内还是简化

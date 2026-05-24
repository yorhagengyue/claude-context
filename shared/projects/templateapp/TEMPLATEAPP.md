# TEMPLATEAPP.md — TemplateApp 项目速报

> **上位文件**：[CLAUDE.md](../../CLAUDE.md) §5 项目索引
> **本地路径**：`~/Desktop/intern/templateapp/`
> **仓库**：本地（未建远程，pending Esther authorization）
> **完整 plan**：[PLAN.md](./PLAN.md)（同目录） / Obsidian 镜像 `~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/PLAN.md`
> **接手文档**：[HANDOFF.md](./HANDOFF.md) / Obsidian 镜像 `~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/HANDOFF.md` ← 新会话先读这个
> **本次 pivot 决策记录**：[PIVOT-2025-05-23.md](./PIVOT-2025-05-23.md)
> **最后更新**：2026-05-24

---

## 🚨 当前阶段：Agentic AI Pivot（2025-05-23）

Linda William 邮件要求把项目重构为 **agentic AI 框架**，作为 publishable 论文交付（既要代码也要论文）。

**两个论文 contribution**：
1. **Live Data Binding** — 数据源版本变化 → 自动标记 dependent reports 为 stale，触发重生成
2. **LLM-as-a-Judge** — 自动质量门：Writer 输出 → Judge 评分（5 维度）→ Pass=交付 / Fail=反馈给 Writer 改写

**ONLYOFFICE 整个扔掉**。Backend 改 Python agent service (FastAPI + LangGraph) + Node Express gateway hybrid。前端 9 屏保留，加 Agent Timeline 视图。

完整决策见 [PIVOT-2025-05-23.md](./PIVOT-2025-05-23.md) 和 [HANDOFF.md](./HANDOFF.md)。

---

## 当前状态（2026-05-24）

| Component | Status | Notes |
|---|---|---|
| 前端 scaffold | ✅ 完成 | 9 屏（Auth/Templates list+editor/Schemas list+editor/Datasets/Generate Wizard/Review/Rules）。localhost:5173 跑通。tsc + build 干净 |
| 前端 → 真实 API | 🔄 部分完成 | Auth、runs/review、Generate Wizard selected-run generation、real run history metadata、stale-run Regenerate action、persisted run Details expansion、schemas/templates list+editor、datasets、rules 已接 Node gateway 并通过 browser smoke；Auth 会发现 configured OAuth providers；generation 不再使用固定 demo case，HistorySection 不再使用静态 mock jobs；active rules 会随 selected run 进入 Python case；`scripts/verify-l0-runtime.sh` 已提供一条命令 local runtime acceptance（启动 Python/Node/frontend、browser smoke 全绿含 `runsRegenerateOk` / `runsEventsOk`、清理释放端口） |
| Node Express gateway | 🔄 部分完成 | health、JWT auth/session L0（默认 memory，optional Postgres auth persistence with `auth_identities` 已有）、configurable OAuth2/OIDC authorization-code login L0、Python generate/review/SSE proxy、`/runs/generate` + active `/rules` context handoff + sanitized `llmTraceSummary` run metadata retention、`/runs/:id/regenerate` manual stale-run refresh、`/runs/:id/events` persisted sanitized timeline/judge detail、stored DOCX template handoff to Python `docx_template` mode、`/runs` metadata list/detail/delete、request-owner-scoped live-data L0、schemas/templates/datasets/rules/run metadata CRUD L0（默认 memory，optional request-owner-scoped JSONB Postgres persistence with `app_runs` 已有）、DOCX placeholder upload parsing、CSV/XLSX dataset ingest、local/S3-compatible uploaded-file storage + `fileRef` metadata + owner-checked download endpoints + L0 cleanup、local upload backup/restore drill、local DB+upload restore drill、production upload-storage guards / backup-policy checks、SQL migration runner + L0 foundation migration、Postgres auth/app-data/live-data foundation、tests/build 已有；local Docker Postgres auth/app-data/live-data smoke + migration smoke + DB/upload restore drill + local Docker MinIO S3-compatible smoke 已于 2026-05-24 用 `DB_HOST_PORT=55432` 跑通；real Google/Microsoft OAuth smoke、external/cloud object-storage proof、managed deployment backup restore proof、live LLM/model evidence、production DB hardening 仍待做 |
| Python agent service | 🔄 部分完成 | FastAPI L0 pipeline、deterministic/source-consistency/hybrid judge、20-case V0 + 50-case synthetic V1 + 80-case synthetic V2 gold sets、V1/V2 second-human review packet exporter/artifacts + adjudication analyzer/summaries、`judge_rule_sets` state/metadata handoff、Responses-first OpenAI adapter + rule `rubric_context` prompt contract + non-content trace metadata/provider token-usage pass-through、env-gated OpenAI source-consistency adapter + no-key-safe benchmark runner + non-content trace metadata/provider token-usage pass-through、real-rubric benchmark token-usage CSV/summary surfacing、LangGraph conditional/checkpoint/resume L0 graph、LangChain wrapper、CrewAI native sequential task-callback path、framework ergonomics L0 audit artifact、pytest 130+ tests 已有 |
| W1 LLM-as-Judge 文献综述 | ✅ 完成 | consolidated survey、Table 1 source、judge architecture、primary-source verification log、Table 1 paper-safe audit、manuscript citation-key ledger、reference skeleton、13-entry literature/framework `references-draft.bib`、BibTeX usage audit、artifact citation map、P1 citation/reference gap audit 已有；Table 1 已清理并机械守护 SelfCheckGPT/AlignScore/Prometheus2/time-cost 高风险 wording；draft BibTeX 当前 13 keys / 13 entries / 0 audit issues；final venue citation style 仍待做 |
| 论文 W2 编辑 | 🔄 部分完成 | Figure 1 asset + `.mmd`/`.svg`/`.png` render + caption、methodology/architecture/live-data-binding/setup/evidence-status/preliminary results/error analysis、judge-technique/framework/model-tier results drafts、limitations sections、manuscript v0 skeleton、Linda P0 DOCX/Markdown review draft + change summary、repeatable P0 DOCX structural audit、P1 figure/table checklist、citation-safe introduction/scope pass、Related Work prose first pass、citation-key ledger、reference skeleton、draft BibTeX、artifact citation map、package-relative artifact appendix draft、citation-to-claim matrix、release-readiness audit、tool-landscape Annex policy、P1 citation gap audit 已有；`scripts/verify-paper-package-l0.sh` 已成为首选 no-key paper/package gate；P0 generated manuscript 已通过 release-readiness strict audit（0 blockers），internal keys 在输出层转换成 Artifact A1-A20 review-package references；QuickLook first-page DOCX smoke 和结构审计已过；model-tier section 明确为 no-live-results；full visual render QA blocked by missing `soffice` and Word PDF export timeout；final venue/release policy 和 live evidence 仍未完成 |
| Gold-standard test set | 🔄 V2 synthetic 完成 | 20-case V0 + 50-case synthetic V1 + 80-case synthetic V2 JSONL + schema/distribution validation 已验收；V1/V2 CSV/Markdown second-human review packets 和 adjudication summaries 已有；外部 reviewer/adjudication labels 仍待做 |
| Demo seed data | ✅ L0 完成 | `scripts/seed-demo-data-l0.js` 可通过 public API seed demo account/schema/dataset v1-v2/template/rules；不依赖个人本地文件 |
| Observability | 🔄 部分完成 | Node gateway 可选 JSON request logging 已有；rubric/source-consistency LLM adapter outputs 已包含 non-content prompt hashes、prompt/response chars、latency、provider token-usage pass-through when available、cost fields；real-rubric/model-tier benchmark rows/summaries 已可带出 provider token usage，并仅在显式 per-1M-token pricing inputs 或 provider-reported cost 存在时估算 cost；durable trace retention 和生产级 cost control 仍待做 |
| Framework prototypes | 🔄 部分完成 | LangGraph conditional/checkpoint/resume L0 graph、LangChain Core wrapper、CrewAI native sequential task-callback path、`framework_ergonomics_l0.*` L0 source/test/benchmark audit 已有；CrewAI memory/delegation/tool ergonomics 和生产级 framework comparison 尚未测量 |
| Reproducibility/deployment docs | ✅ L0 完成 | `docs/reproducibility-package.md`、`docs/deployment-l1.md`、`docs/credential-gated-evidence-runbook.md` 已覆盖 no-key reproducibility、L1 guardrails、seed data、request logs、launch blockers、credential-gated evidence commands |
| Internal peer review | ✅ P0 完成 | `paper-reviews/internal-peer-review-v1.md` 已完成 P0 major-revision review、risk list、revision roadmap、overclaim audit |
| P0 response-to-review log | ✅ P0 完成 | `paper-reviews/p0-response-to-review-log.md` 已把 8 个 major review findings 映射到 response、remaining blockers、fix-now roadmap、P1 open decisions |
| P0 evidence-boundary mitigation | ✅ P0 完成 | Results sections 和重新生成的 Linda P0 DOCX/Markdown 已加入 `Evidence type` / `Claim boundary`，防止 deterministic/interface/no-run artifact 被误读为 live LLM/model evidence |
| P0 evidence-status table | ✅ P0 完成 | `paper-drafts/section-evidence-status.md` 已集成进重新生成的 P0 manuscript，集中说明 supported / unsupported claims |
| Submission scope options | ✅ P0 完成 | `paper-drafts/submission-scope-options.md` 已给出 Option A pilot/scaffold 与 Option B empirical LLM evaluator 两条 Linda 决策路线 |
| P0 benchmark-label wording | ✅ P0 完成 | 论文正文已将 V0/V1/V2 表述为 author-labeled synthetic calibration data pending second-human adjudication，不再暗示 externally adjudicated gold-standard evidence |
| Citation-to-claim matrix | ✅ P0 完成 | `paper-drafts/citation-to-claim-matrix.md` 已映射 14 个 major paper-facing claims 的 evidence/status/safe wording/unsafe wording/P1 action |
| Review artifact package | ✅ L0 完成 | `scripts/build-review-package-l0.py` 可生成 `/Users/yorha/Downloads/templateapp-review-package-l0`，带 `MANIFEST.json` SHA-256 checksums；`scripts/build-artifact-appendix-l0.py` 可生成 `paper-drafts/artifact-appendix-l0.md`，把 A1-A20 映射到 package-relative paths / checksums / evidence boundaries；仍非 final public/supplement release |
| Linda demo script | ✅ L0 完成 | `demo/linda-demo-script.md` 已覆盖 5-minute flow、failure recovery、expected screenshots、evidence boundaries |
| Beta feedback loop | ✅ L0 完成 | `demo/beta-feedback-form.md`、`demo/beta-feedback-triage.md`、`demo/beta-feedback-summary-template.md` 已覆盖 feedback capture/triage/summary |

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
| Dataset agent | `/datasets` | UI + Node metadata CRUD + CSV/XLSX upload parser L0 ✅ / durable integration ❌ |
| Loader agent | (backend) | Python L0 ✅ / durable data-source integration ❌ |
| Template agent | `/templates`, `/templates/edit` | Python parser ✅；Node/front templates metadata CRUD + DOCX placeholder upload parsing L0 ✅；TemplateEditor 旧 mock editing surface 已拆；local uploaded-file storage/download L0 ✅；render preview 待做 |
| Report Writer | `/runs` (Generate Wizard) | UI + Node `/runs/generate` selected-record case builder + `/runs/:id/regenerate` stale manual refresh + `/runs/:id/events` persisted timeline/judge detail + active rule-set context + stored-DOCX handoff + queryable run metadata + Python L0 ✅ |
| LLM Judge | `/review` | UI + deterministic/hybrid interface L0 ✅；real LLM benchmark ❌ |
| Orchestrator | (backend) + `/runs/timeline` | Python L0 + frontend timeline + LangGraph MemorySaver pause/resume L0 ✅；production cross-process LangGraph checkpoint/retry ❌ |
| Judge rules | `/rules` | UI + Node rule-set CRUD L0 ✅；active rule-set context 已进入 Python `PipelineState` + deterministic/hybrid metadata + LLM rubric prompt payload ✅；live LLM benchmark ❌ |

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
1.  W1 文献综述                         ✅ DONE
2.  Gold-standard test set 建（20-80 cases） 🔄 V2 + review packets + adjudication analyzer DONE; external adjudication pending
3.  W3a Python agent-service skeleton       ✅ L0 DONE
4.  W3a end-to-end 跑通 gold-standard       ✅ L0 DONE
5.  W2 §Framework intro + 重画 Figure 1     ✅ draft/asset/render DONE; final manuscript insertion/layout check pending
6.  W3b 框架对比 prototype（CrewAI + LangChain） 🔄 LangChain runtime + CrewAI native sequential task callbacks DONE，CrewAI memory/delegation/tool ergonomics 未测
7.  W3b 框架 benchmark 跑                  ✅ V0 DONE，CrewAI native stage-callback rows + framework ergonomics L0 audit included
8.  W3b 多 tier model prototype             ✅ scaffold DONE
9.  W3b model benchmark 跑                  ❌ live run 待 API key/budget
10. W2 填 Table 1 + 各 Results 章节          🔄 draft DONE，final evidence 待补
11. W3c Node gateway（Auth → Datasets）      🔄 auth/OAuth L0/proxy/request-owner-scoped live-data/schemas/templates/datasets/rules/run metadata + active rule-set context handoff + stored-DOCX handoff + DOCX upload parse/download/cleanup + CSV/XLSX ingest/download/cleanup + local/S3-compatible uploaded-file storage + local restore drill + DB/upload restore drill + local Docker MinIO smoke + production storage-policy guard + SQL migration runner + Postgres auth with provider identity table + request-owner-scoped JSONB app-data persistence foundation + local Docker Postgres smoke L0 DONE，real Google/Microsoft OAuth smoke + external/cloud object-storage proof + managed deployment restore proof + live LLM/model evidence + production DB hardening 待做
12. W3d 前端接 real API + Agent Timeline 视图 + ONLYOFFICE 拆除 🔄 runs/review/schemas/templates/datasets/rules/timeline/history DONE，production persistence hardening 待做
13. W2 polish + §Limitations                 🔄 limitations draft done; final polish pending
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

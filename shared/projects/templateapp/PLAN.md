# TemplateApp — Agentic AI Pivot (Linda 5-23 Brief)

> **Status**: Direction locked 2025-05-23. Long-term project — no immediate deadline.
> **Predecessor plan**: `~/.claude/plans/shimmying-dreaming-naur.md` (pre-pivot, M1-M9 generic CRUD). Most data models survive; the orchestration layer flips.
> **Paper draft**: `~/Downloads/Draft Paper - Documentation.docx`

## Context

Linda (manager, on leave 5/13–5/27) reframed TemplateApp from "generic document generator" into **publishable agentic-AI research**. Her market analysis (29 tools surveyed in the draft's Table 2) shows none combine the two innovations she's making the paper contribution:

1. **Live Data Binding** — generated documents stay linked to source data; data change triggers re-generation
2. **LLM-as-a-Judge** — automated quality gate that scores Writer output against a rubric and loops with revision instructions on Fail

The implementation must follow her **Figure 1** framework (Orchestrator + Dataset + Loader + Template + Writer + Judge with feedback loop), expressed in a recognized agentic stack.

Timing-wise lucky: backend was unwritten when the pivot hit. No code thrown away. Frontend (9 pages) maps 1:1 to the agents.

## Locked decisions (5/23)

| Decision | Choice |
|---|---|
| **Primary framework** | LangGraph |
| **Comparison prototypes** | CrewAI + LangChain (same Writer→Judge pipeline) |
| **LLM matrix** | Multi-tier: Frontier (Claude Opus / GPT-4/5) + Mid (Sonnet / GPT-4o / Gemini Pro) + Small commercial (Haiku / GPT-4o-mini) + Local large (Llama 3.1 70B) + Local small (Llama 3.2 3B, Qwen 2.5 3B, Phi-3-mini). Judge benchmarked across all tiers. |
| **Backend stack** | Hybrid: **Python agent service + Node Express gateway** |
| **Frontend addition** | Agent run timeline view (new page) + wire existing pages to real API (drop localStorage stubs) |
| **Scope** | Long-term. W1 + W2 + W3 (a–d) all in. No deadline. |
| **Frontend stack** | React + Vite + TS + Tailwind (no change) |
| **Data binding mechanism** | Lazy invalidation (version-graph) + manual refresh button; auto-refresh later phase |
| **Judge output format** | JSON with fixed rubric schema (pass/fail/score/criteria_breakdown/revision_hints) |
| **Template editor** | **Drop ONLYOFFICE.** v1 = upload-only (user types `{{tags}}` in Word desktop, uploads .docx, app parses + shows column palette for reference). Future = markdown-source path (Phase 2+). |

## Architecture (post-pivot)

```
┌──────────────────────────────────────────────────────────────┐
│                    Frontend (React)                          │
│  Templates · Schemas · Datasets · Generate · Review · Rules  │
│                  + Agent Run Timeline                        │
│        Template editor: upload-only docx (no ONLYOFFICE)     │
└────────────────────────┬─────────────────────────────────────┘
                         │ REST + SSE
                         ▼
┌──────────────────────────────────────────────────────────────┐
│         Node Express Gateway (api/)                          │
│  Auth · Templates CRUD · Schemas CRUD · Datasets CRUD ·      │
│  Rules CRUD · Static · proxies /generate /review to Python   │
│  Postgres (Sequelize)                                        │
└────────────────────────┬─────────────────────────────────────┘
                         │ HTTP + SSE for streaming
                         ▼
┌──────────────────────────────────────────────────────────────┐
│         Python Agent Service (agent-service/)                │
│  FastAPI                                                     │
│  ┌─────────────────────────────────────────────────────────┐│
│  │  LangGraph DAG                                          ││
│  │  Orchestrator → Dataset → Loader → Template → Writer ──→Judge ─┐│
│  │                                              ▲────feedback───┘ ││
│  │                                              (revision loop)   ││
│  └─────────────────────────────────────────────────────────┘│
│  Comparison prototypes: CrewAI version, LangChain version    │
│  LLM clients:                                                │
│    - anthropic-sdk-python (Claude tiers)                     │
│    - openai SDK (GPT-4o / mini)                              │
│    - google-genai (Gemini Pro / Flash)                       │
│    - ollama / llama-cpp-python (local Llama / Qwen / Phi-3)  │
│  docxtpl for rendering                                       │
└──────────────────────────────────────────────────────────────┘
```

**ONLYOFFICE is removed.** Template ingestion is now:
- User authors template.docx in MS Word / LibreOffice desktop, manually typing `{{full_name}}` etc.
- Uploads .docx to TemplatesList (existing upload flow already in design)
- Backend parses placeholders via docxtpl introspection (`get_undeclared_template_variables`)
- Frontend TemplateEditor.tsx shows: file metadata + parsed placeholder list + column palette **as reference** (not click-to-insert anymore)
- Spike `spike/` directory and ONLYOFFICE docker config become historical artifacts. Don't delete (still useful reference), but no longer in deployment.

## Workstreams

### W1 — Research: LLM-as-a-Judge literature review

**Goal**: Fill Linda's Table 1 (`Criteria | Technique | Performance | Time`).

Techniques to cover (minimum):
- **G-Eval** (Liu et al., NeurIPS 2023) — CoT + form-filling, GPT-4 backbone
- **GPTScore** — token log-prob weighted, reference-free
- **FactScore** (Min et al., 2023) — atomic fact decomposition; for Accuracy / factuality
- **AlignScore** (Zha et al., 2023) — alignment to source; for Data Consistency
- **Prometheus** / **Prometheus 2** (Kim et al., 2024) — open-source judge model; for Format / Clarity / Completeness
- **SelfCheckGPT** — sample consistency; for hallucination detection
- **TrueTeacher** — NLI-based factual consistency
- **CheckEval / RAGAS** — RAG-specific judges (Accuracy + Data Consistency)

Map each → Linda's 5 criteria (Accuracy, Completeness, Clarity, Data consistency, Format compliance). Record published metrics (correlation with human, accuracy on benchmark), typical latency, computational cost.

**Output**: structured notes in `~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/research/llm-judge-survey.md`; populates Table 1.

### W2 — Paper editing: Draft Paper - Documentation.docx

Concrete changes to the .docx:

1. **Redraw Figure 1** — Image 2 in current draft is generic Orchestrator/Dataset/Loader/Template/Writer/Judge. Replace with our concrete instantiation:
   - Orchestrator: LangGraph StateGraph
   - Dataset: Python agent calling Loader API on stored DataSource versions
   - Loader: Python normalizer + type inference
   - Template: docxtpl placeholder resolution from stored Template
   - Writer: docxtpl rendering + Claude API for narrative slots
   - Judge: Claude (Opus) with rubric prompt → JSON output
   - Add the version-graph data binding arrows showing DataSource→Report dependencies
2. **§Architecture Mapping** (new) — describe each agent's contract (input/output/dependencies)
3. **§Live Data Binding Mechanics** (new) — version graph: every Report stores `{table_id → version_id}` map; when any source bumps version, Report marked stale; user can manually trigger refresh or system auto-refreshes via scheduler (future)
4. **§LLM-as-a-Judge Methodology** (new) — rubric structure, JSON schema for feedback, revision-loop termination criteria (max N retries, score threshold)
5. **§Framework Comparison** (new) — table comparing LangGraph vs CrewAI vs LangChain on:
   - Native loop/feedback support
   - Checkpoint/state persistence
   - Code lines for same pipeline
   - Runtime overhead
   - Community/citations
   - Diagram-ability for papers
6. **Populate Table 1** with W1 findings
7. **§Experimental Setup** (new) — corpus (mock student reports), full **multi-tier model matrix**, metrics
8. **§Results — Judge Technique** (new) — judge accuracy on synthetic Pass/Fail cases, average revision rounds, end-to-end latency, per-technique results
9. **§Results — Model Tier Cost-Performance** (new, key contribution) — same judge prompt run across:
   - **Frontier**: Claude Opus 4.x, GPT-4/5
   - **Mid**: Claude Sonnet 4.6/4.7, GPT-4o, Gemini Pro
   - **Small commercial**: Claude Haiku, GPT-4o-mini, Gemini Flash
   - **Local large**: Llama 3.1 70B (if GPU available)
   - **Local small**: Llama 3.2 3B, Qwen 2.5 3B, Phi-3-mini

   For each: accuracy vs human gold-standard, latency (ms/eval), cost (USD/eval, $0 for local). Plot **Pareto frontier**. Identify "smallest model that maintains ≥90% of frontier accuracy" — this is the practical recommendation.
10. **§Limitations & Future Work** (new) — judge calibration on edge cases, hardware constraints for local models, multi-criteria weighting

### W3 — Implementation

#### W3a — Python agent service (primary, LangGraph)
Path: `templateapp/agent-service/`

```
agent-service/
├── app.py                  # FastAPI entry
├── pyproject.toml
├── agents/
│   ├── orchestrator.py     # LangGraph StateGraph definition
│   ├── dataset.py          # Fetch DataSource → versions
│   ├── loader.py           # Normalize rows
│   ├── template.py         # Resolve placeholders
│   ├── writer.py           # docxtpl + Claude narrative slots
│   └── judge.py            # Claude-as-judge with rubric
├── prompts/
│   ├── writer.md
│   └── judge-rubric.md
├── schemas/
│   ├── state.py            # LangGraph state type
│   └── judge_output.py     # Pydantic for JSON judge result
├── routes/
│   ├── generate.py         # POST /generate
│   ├── review.py           # POST /review
│   └── stream.py           # SSE for agent run events
└── tests/
```

#### W3b — Comparison prototypes (framework × model)
Path: `templateapp/agent-service/prototypes/`

**Framework comparison**:
- `prototypes/crewai_pipeline.py` — same Writer→Judge pipeline using CrewAI's role-based agents
- `prototypes/langchain_pipeline.py` — same pipeline using LangChain's LCEL + manual loop
- `prototypes/benchmark_framework.py` — runs all 3 over the same N test cases, records: total time, LLM calls, code lines, success rate
  → paper §Framework Comparison

**Model-tier comparison** (separate axis, runs on whichever framework wins):
- `prototypes/judge_models.py` — pluggable LLM backend (Claude / OpenAI / Gemini / Ollama)
- `prototypes/benchmark_models.py` — runs same judge prompt on every model in the matrix; records accuracy vs gold standard, latency, USD cost per eval
- `prototypes/gold_standard.jsonl` — human-labeled test set (~20-50 cases). Each case: `{document_text, expected_pass: bool, expected_findings: [...]}`. This is the foundation; without it the model comparison is hand-wavy.
  → paper §Cost-Performance Analysis

**Local model setup**:
- `prototypes/ollama_setup.md` — instructions to run Ollama with Llama 3.2 3B, Qwen 2.5 3B, Phi-3-mini locally
- `prototypes/llama_cpp_setup.md` — alternative via llama-cpp-python for finer control

#### W3c — Node Express gateway
Path: `templateapp/api/`

Mostly the original Phase 1 plan (`shimmying-dreaming-naur.md` M1-M6) but trimmed:
- Auth (M1) — JWT + Identities + Users (own table). No change.
- Templates CRUD (M2) — upload docx, parse `{{tags}}` server-side via docxtpl, store
- **REMOVED: M3 ONLYOFFICE callback** — no in-browser editing, no callback dance
- **REMOVED: M4 ONLYOFFICE plugin** — no plugin
- Datasets CRUD + Tables + Versions (M5) — same data model
- Rules CRUD (M8 surface only; execution moves to Python)
- **NEW**: proxy `/api/generate` and `/api/review` to Python agent service; relay SSE
- Skip: previous M7 (report generation logic) — moved to Python

Existing data model in `shimmying-dreaming-naur.md` mostly carries over. Templates table now stores raw docx blob (or path) — no editing session metadata needed.

#### W3d — Frontend additions / changes
- **New page**: `src/pages/runs/AgentTimeline.tsx` — visualize Orchestrator's DAG live: each agent node lights up with status (idle/running/done/failed); Judge node shows score + revision number; SSE-driven
- **Existing pages**: drop localStorage stubs, wire to Node gateway REST (`@/api/*.ts` files); keep the contract surface the same
- **TemplateEditor.tsx** — **gut the ONLYOFFICE mock-doc**, replace with:
  - Upload zone (.docx) — already in TemplatesList NewTemplateArea, just promote here
  - Read-only docx preview pane (server renders docx → PDF or HTML via libreoffice headless, frontend shows iframe of that)
  - Column palette stays on the right, but **read-only / informational**: shows which columns are referenced by the parsed `{{tags}}`, no click-to-insert
  - Optional: "Re-upload to edit" button → user downloads, edits in Word, uploads new version
- **Review.tsx**: replace mock findings with real judge JSON output; show revision history (round 1 score 0.62, round 2 score 0.78, round 3 0.91 → pass)
- **Generate Wizard**: after Run, push user to Agent Timeline view

## Critical Files (will be created or modified)

| Path | Status | Reason |
|---|---|---|
| `~/Downloads/Draft Paper - Documentation.docx` | edit | All W2 additions |
| `templateapp/agent-service/` | new | All W3a / W3b code |
| `templateapp/api/` | new | Node gateway code (mostly per shimmying-dreaming-naur.md M1-M6) |
| `templateapp/frontend/src/pages/runs/AgentTimeline.tsx` | new | W3d |
| `templateapp/frontend/src/api/*.ts` | new | API client layer to replace localStorage |
| `templateapp/spike/docxtpl-test/render.py` | reuse | Writer agent base code |
| `~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/research/llm-judge-survey.md` | new | W1 output |
| `~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/PLAN.md` | update | Sync agentic pivot |

## Suggested execution order

Not a deadline, just a dependency order:

```
1.  W1 literature review                              ← paper-quality work starts
2.  Build gold-standard judge test set (~20-30 cases) ← unlocks any benchmarking
3.  W3a skeleton (FastAPI + LangGraph + judge + writer)
4.  W3a end-to-end on gold-standard cases             ← first real numbers (frontier judge)
5.  W2 §Framework intro + redraw Figure 1             ← parallel with 3-4
6.  W3b framework prototypes (CrewAI + LangChain)
7.  W3b framework benchmark run                       ← §Framework Comparison numbers
8.  W3b model prototypes (multi-tier LLM matrix)
9.  W3b model benchmark run                           ← §Cost-Performance numbers
10. W2 fill Table 1 + §Framework Comparison + §Experimental Setup + §Results — Judge + §Results — Model Tier
11. W3c Node gateway (M1 Auth → M6 Datasets) — long tail, parallel-izable
12. W3d frontend wiring + Agent Timeline view + TemplateEditor.tsx ONLYOFFICE rip-out
13. W2 polish + §Limitations section
```

Steps 1-10 produce a paper draft Linda can review. Steps 11-12 are productization.

## Verification

| Workstream | Done when |
|---|---|
| W1 | `llm-judge-survey.md` covers ≥8 techniques, each mapped to ≥1 of Linda's 5 criteria with citation + reported metric + latency |
| W2 | `.docx` rebuilds via pandoc; new figure embedded; tracked changes used so Linda sees diff |
| W3a | `curl POST /generate` on a mock template + dataset returns a docx + judge JSON; Fail case triggers ≥1 revision round |
| W3b | `python prototypes/benchmark.py` outputs a CSV with: framework × N_runs × {time, LLM_calls, code_lines, success_rate} |
| W3c | `curl` walks the full route table (Auth → CRUD → /generate → /review) HTTP 200; Postgres migrations clean |
| W3d | dev server: Agent Timeline page receives SSE events live during a generate run; all existing pages still work with real backend |

## Risks / open issues

1. **Judge calibration** — judge will likely be optimistic regardless of model. Need human-labeled gold-standard set (~20-50 cases) to evaluate the judge itself. Without this, paper's "judge works" claim is hand-wavy. **Building this gold set is a bottleneck task** — should plan it early.
2. **Cost** — frontier model benchmarking × N test cases × N models × multiple revision rounds adds up fast. Budget plan needed. Mitigation: small commercial models (Haiku / 4o-mini) can do bulk runs, frontier reserved for ceiling experiments.
3. **Hybrid backend complexity** — Node ↔ Python HTTP adds latency + ops overhead. Worth it for ecosystem split but: who runs migrations? Python or Node? My default: Node owns the DB (Sequelize migrations), Python is stateless and reads via Node's API.
4. **Frontend SSE compatibility** — agent timeline needs server-sent events through Node proxy. Confirm Express SSE works with Vite dev proxy.
5. **Paper deadline unknown** — Linda hasn't said when she wants to submit. We should ask her on return.
6. **Local model hardware** — Llama 3.1 70B needs serious GPU. If user only has a Mac (M-series), llama.cpp with quantization works for ≤8B models. Local small (3B class) is the realistic local-ceiling for this paper. 70B optional / nice-to-have.
7. **No ONLYOFFICE = lost rich editing UX** — for v1 it's fine (upload-only). When we eventually want in-app authoring, options are Tiptap, Lexical, or our own markdown-source editor. Phase 2 decision.

## What's NOT in scope

- Throwing away the existing frontend (it survives the pivot)
- Rewriting the paper from scratch (only edits + new sections)
- Production scaling, multi-tenancy, SaaS hosting
- Phase 2 word-addin (stays Phase 2)
- ONLYOFFICE — **dropped entirely**, no plan to revisit unless Linda specifically asks
- Building an in-app rich editor (Tiptap / Lexical / markdown source) — Phase 2+; v1 is upload-only
- Real-time auto-refresh on data change (lazy invalidation only this phase)

## After Linda returns (5/27+)

Questions to bring:
1. Target conference/journal + submission deadline?
2. Budget for Claude API?
3. Co-authors? (Geng Yue + Linda William + Ms Hu?)
4. Human-labeled ground truth set — who builds it?
5. Open-source the implementation alongside the paper?

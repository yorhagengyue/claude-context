---
source: claude
updated: 2025-05-23
purpose: Onboarding doc — read first when picking up TemplateApp in a new session
---

# TemplateApp — Project Handoff

> **If you're a new Claude session or person taking this over, read this entire file before doing anything.** It compresses 6 weeks of decisions, false starts, and current state into one page (well, a few). Spend 10 minutes here and you'll know what's going on. Skip it and you'll waste 2 hours discovering things the hard way.

---

## What this project is, in 4 sentences

TemplateApp is **耿越 (Geng Yue)** 's intern project at Temasek Polytechnic under **Linda William** (manager). Started 2026-04-13 as a "generic document generator" rewrite of IFSG's template + report chain. **Pivoted on 2025-05-23 into a publishable agentic-AI research project**: the deliverable now includes both running code AND a paper (`~/Downloads/Draft Paper - Documentation.docx`). The two paper innovations are **Live Data Binding** (regenerate documents when source data changes) and **LLM-as-a-Judge** (automated quality gate with revision loop).

---

## People

| Person | Role | Contact / notes |
|---|---|---|
| **Geng Yue** (耿越 / Tommy Chen) | Intern, project owner | `tommychen030607@gmail.com`. macOS user. Sees Claude as "CTO advisor" not code generator — challenge architecture, don't auto-implement (CLAUDE.md §3). |
| **Linda William** | Manager, paper co-author | Brief delivered via voice (audio at `~/Downloads/Temasek Polytechnic 6.m4a`). On leave **5/13–5/27**. Email of 5/23 sets the agentic pivot. |
| **Esther** | Admin, GitHub access gatekeeper | GitHub push for templateapp repo still pending her authorization (as of 4/27). |
| **Ms Hu** | Email thread of unclear scope | One email needs to be rewritten and resent. Low context. |

---

## How we got here (chronological)

**2026-04-13** — Linda mentions project informally. Reference codebase identified: IFSG monorepo at `~/Desktop/ifsg/`. `template.controller.js` (~900 lines, ONLYOFFICE integration) and `report-generation/` are the closest existing chains worth porting.

**2026-04-17** — 8-round architecture Q&A locks Phase 1 plan. Decisions:
- React + Vite + TS frontend (over Angular/Next)
- Node + Express + Sequelize + PostgreSQL backend
- docker-compose orchestration (NOT Nix+Arion)
- Own JWT auth with `identities` table for future Firebase/Google
- All business tables carry `owner_id` (multi-tenant by user, no sub-firm)
- ONLYOFFICE for template editing — copy IFSG's full plugin
- word-addin → Phase 2
- CSV append-only versioning (DataSource → Datasets versions → DatasetColumns)
- RAG v1 = only rules (no knowledge yet; knowledge will be skills)
- Review output: JSON primary, markdown secondary
- Local Ollama for LLM
- **`{{tag}}` text-based placeholders** (validated by spike — see below)

Spike result: `templateapp/spike/` proved ONLYOFFICE CE + docxtpl + `{{tag}}` end-to-end works. CE community edition is sufficient — no Developer Edition needed. `callCommand` bypass for the SDT crash IFSG team hit. `GetSelectedText` permanently abandoned (focus-loss bug). Spike has been torn down (`docker compose down -v`) but files preserved for reference.

Plan file written: `~/.claude/plans/shimmying-dreaming-naur.md` — **this is the PRE-PIVOT plan, now partially superseded**.

**2026-04-20** — Other project (NAISC Workato) consumed several days. TemplateApp paused.

**2026-04-27** — Linda formal brief (audio `~/Downloads/Temasek Polytechnic 6.m4a`, transcript at `vault/01 - Projects/TemplateApp/transcripts/2026-04-27 brief.md`). Scope expanded significantly:
- **Two use cases must both work in Phase 1**:
  - A: CSV/Excel + custom template (original direction)
  - B: IFSG-style — user defines schema manually, then drags column-name tags into template
- **Per-row generation**: 1 template + 1 data source = N docx (30 students → 30 reports)
- **Multi-table data sources**: DataSource contains multiple Tables joined by `user_id`; multi-sheet Excel = each sheet a Table
- **Templates from scratch**: not just upload, also blank-template-in-app
- **Reverse Excel skeleton**: app generates an empty Excel with the template's column headers, teacher fills in, uploads back

**2026-04-29** — Frontend designed via Claude Design across 6 iteration rounds. 9 pages scaffolded with React+Vite+TS+Tailwind+react-router. All build clean, all routes 200. localStorage stubs for data. **Backend untouched** at this point.

**2026-05-23** ★ **THE AGENTIC PIVOT** — Linda emails: restructure as agentic AI for a publishable paper. Two innovations: Live Data Binding + LLM-as-Judge. Follow her draft paper Figure 1. **This conversation locked these decisions** (see "Decisions" below):
- LangGraph as primary framework; CrewAI + LangChain as comparison prototypes
- Backend → Hybrid: Python agent service (FastAPI + LangGraph) + Node Express gateway
- **ONLYOFFICE dropped entirely**. Template ingestion becomes upload-only docx (user types `{{tag}}` in Word desktop)
- LLM comparison matrix: Frontier (Opus/GPT-4/5) + Mid (Sonnet/GPT-4o) + Small (Haiku/4o-mini) + Local (Llama/Qwen/Phi-3)
- Agent run timeline view added to frontend
- Frontend keeps as-is, drops localStorage stubs, wires to real APIs

Plan written: `~/.claude/plans/eager-humming-crown.md` — **this is the AUTHORITATIVE current plan**.

---

## Current state (2025-05-23)

| Component | Status | Notes |
|---|---|---|
| Frontend scaffold | ✅ Done | 9 pages, `templateapp/frontend/`. `npm run dev` on 5173. tsc + build clean. |
| Frontend → real API | ❌ TODO (W3d) | All pages use localStorage; need swap to fetch to Node gateway |
| Node Express gateway (api/) | ❌ TODO (W3c) | Empty placeholder. Auth + CRUD + proxy to Python |
| Python agent service | ❌ TODO (W3a) | FastAPI + LangGraph + Claude API. Will live at `templateapp/agent-service/` |
| LangChain + CrewAI prototypes | ❌ TODO (W3b) | For paper's Framework Comparison section |
| Multi-tier LLM benchmark | ❌ TODO (W3b) | For paper's Cost-Performance section |
| Gold-standard judge test set | ❌ TODO | ~20-30 human-labeled cases. **Blocking** for any judge benchmark |
| W1 literature review (LLM-as-Judge) | 🔄 In progress | 2 subagents running 5-23, output to `vault/research/group-a-judge-techniques.md` + `group-b-judge-techniques.md` |
| Paper edits | ❌ TODO (W2) | Figure 1 redraw, Table 1 fill, new sections (Architecture Mapping, Data Binding Mechanics, LLM-as-Judge Methodology, Framework Comparison, Experimental Setup, Results × 2, Limitations) |
| ONLYOFFICE removal | ❌ TODO | Frontend TemplateEditor.tsx still has mock-doc placeholder pretending to be ONLYOFFICE iframe; needs rip-out |

---

## File map (everything important)

### Code
```
/Users/yorha/Desktop/intern/templateapp/
├── frontend/                        ✅ DONE — scaffold + 9 pages
│   ├── src/
│   │   ├── App.tsx                  ← 10 routes
│   │   ├── main.tsx
│   │   ├── index.css                ← brand palette + animations
│   │   ├── components/{Layout,Sidebar}.tsx
│   │   ├── ui/{Button,TypeBadge,TagChip,SeverityPill,EmptyState}.tsx
│   │   ├── pages/
│   │   │   ├── auth/Auth.tsx
│   │   │   ├── templates/{TemplatesList,TemplateEditor,...}.tsx
│   │   │   ├── schemas/{SchemasList,SchemaEditor,...}.tsx
│   │   │   ├── datasets/Datasets.tsx
│   │   │   ├── runs/{GenerateWizard,Step1Template,...}.tsx
│   │   │   ├── review/Review.tsx
│   │   │   └── rules/RulesPage.tsx
│   │   └── store/schemas.ts          ← localStorage layer (to be replaced)
│   ├── design/                       ← Claude Design HTML refs, chat history, prompts
│   │   ├── PROMPT.md                 ← Claude Design boilerplate
│   │   ├── chat-history.md
│   │   ├── HANDOFF.md                ← (from Claude Design pkg, not this file)
│   │   ├── Auth.html ... Review.html ← original Claude Design exports
│   ├── package.json
│   ├── tailwind.config.js
│   └── tsconfig.json
├── api/                              ❌ TODO — Node Express gateway
│   └── README.md                     ← only a stub
├── agent-service/                    ❌ TODO — Python+FastAPI+LangGraph
├── services/{llm-service,report-service}/  ❌ Empty placeholders, will be folded into agent-service
├── spike/                            ✅ HISTORICAL — ONLYOFFICE+docxtpl validation
│   ├── docker-compose.yml            (ports 9981+8082)
│   ├── plugin/                       ONLYOFFICE plugin reference
│   ├── docxtpl-test/render.py        ← reuse this for Writer agent
│   └── README.md                     ← step-by-step validation notes
├── word-addin/                       Phase 2 stub
├── docs/
├── docker-compose.yml                Skeleton, needs update post-pivot
└── 规划.md                            (probably old)
```

### Plans
```
/Users/yorha/.claude/plans/
├── eager-humming-crown.md            ★ CURRENT authoritative plan (agentic pivot, 5/23)
└── shimmying-dreaming-naur.md          PRE-PIVOT plan — most M1-M9 data model survives,
                                        but ONLYOFFICE work is dropped
```

### Paper
```
~/Downloads/Draft Paper - Documentation.docx
- Title: "Agentic AI for Generic Document Generation with Live-Data Binding and LLM Evaluator"
- Has 3 inline images:
  - Image 1: Microsoft "Agentic AI Lifecycle Stages" example
  - Image 2: Figure 1 — Orchestrator + 5 agents + Judge with feedback loop  ★ THE FIGURE TO REDRAW
  - Image 3: Layer architecture (Perception → Memory → Reasoning → Action → Judge → Governance → Feedback)
- Table 0: Gap analysis (Hallucination/Data Binding/LLM-Judge)
- Table 1: EMPTY skeleton — Criteria × Technique × Performance × Time (to fill from W1 research)
- Table 2: 29 tools comparison (filled by Linda) — Annex 1
```

### Vault (Obsidian)
```
~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/
├── PLAN.md                           Long-form spec (mirror of eager-humming-crown.md)
├── TemplateApp - Overview.md         Project hub note
├── HANDOFF.md                        ← this file
├── PIVOT-2025-05-23.md               (TODO) Decision record for the pivot
├── research/                         ← W1 outputs go here
│   ├── group-a-judge-techniques.md   (in progress)
│   └── group-b-judge-techniques.md   (in progress)
└── transcripts/
    └── 2026-04-27 brief.md           Linda's formal brief transcript + raw text
```

### claude-context mirror (cross-machine sync, git)
```
~/Desktop/claude-context/shared/
├── CLAUDE.md                         Geng Yue's main context file. §8 has memory
├── projects/templateapp/
│   ├── PLAN.md                       Mirror of eager-humming-crown.md
│   ├── TEMPLATEAPP.md                Sub-MD summary
│   └── HANDOFF.md                    Mirror of this file
```

---

## Locked decisions (with timestamps)

| ID | Date | Decision | Why |
|---|---|---|---|
| D-001 | 4-17 | React + Vite + TS over Angular/Next | Vite speed; TS for the LLM-rich domain |
| D-002 | 4-17 | docker-compose (not Nix+Arion) | Faster to demo; IFSG team uses Nix and it's heavy |
| D-003 | 4-17 | Own JWT auth with Identities table | Phase 2 Firebase/Google can add as another identity row |
| D-004 | 4-17 | All business tables: `owner_id` | No sub-firm hierarchy (IFSG complexity not needed here) |
| D-005 | 4-17 → 5-23 | ~~ONLYOFFICE for template editing~~ | **Dropped 5-23 (D-020)** |
| D-006 | 4-17 | word-addin = Phase 2 only | ONLYOFFICE covers Phase 1 |
| D-007 | 4-17 | Append-only dataset versioning | Auditability; no destructive edits |
| D-008 | 4-17 | RAG v1 = rules only | Knowledge via skills later; not in Phase 1 |
| D-009 | 4-17 | Review output: JSON primary + markdown | Machine + human consumption both needed |
| D-010 | 4-17 → 5-23 | ~~Ollama local LLM only~~ | **Expanded 5-23 (D-019) to multi-tier matrix** |
| D-011 | 4-17 | `{{tag}}` text placeholders | Editor-agnostic; works in any text editor or our future custom editor |
| D-012 | 4-27 | Two use cases A+B both Phase 1 | Linda's brief explicit requirement |
| D-013 | 4-27 | 1:N per-row report generation | Linda: 30 students = 30 docx |
| D-014 | 4-27 | Multi-table data sources | Linda: it's a mini-DB, not a CSV bucket |
| D-015 | 4-27 | Reverse Excel skeleton endpoint | Linda: teachers need a template to fill |
| D-016 | 4-29 | Frontend via Claude Design, 6 rounds | Faster than hand-coding visual iteration |
| D-017 | 4-29 | Click-to-insert (not drag) for column palette | ONLYOFFICE sandbox blocks cross-iframe drag |
| D-018 | 5-23 | **LangGraph primary framework** (CrewAI + LangChain prototypes for paper compare) | Native loop/state machine fits the Pass/Fail revision loop best |
| D-019 | 5-23 | **Multi-tier LLM matrix** (Frontier/Mid/Small/Local) | Cost-Performance Analysis is the key new paper contribution |
| D-020 | 5-23 | **ONLYOFFICE dropped entirely** | Not in agentic loop; weight not justified; original plan already flagged eventual replacement |
| D-021 | 5-23 | **Hybrid backend: Python agent service + Node gateway** | Python ecosystem has the agentic libs; Node keeps the CRUD/Auth/SSE simpler |
| D-022 | 5-23 | **3-framework comparison in paper** with prototypes | User explicit ask; framework choice is a contribution |
| D-023 | 5-23 | **Frontend: add Agent Timeline view** | Visualize Orchestrator DAG live; demo value for paper |
| D-024 | 5-23 | **Lazy invalidation + manual refresh** for data binding | Simpler than push/event sourcing; user retains control |
| D-025 | 5-23 | **Judge JSON output schema** (pass/score/criteria_breakdown/revision_hints) | Machine-parseable for revision loop; comparable across techniques for paper |

---

## How to start a new Claude session on this project

In this exact order:

1. **Auto-context** (Claude Code CLI auto-loads, Cowork doesn't):
   - `~/Desktop/CLAUDE.md` — Geng Yue's main context file
2. **Project-specific context**:
   - This file (`vault/01 - Projects/TemplateApp/HANDOFF.md`) — **READ FIRST**
3. **Current plan**:
   - `~/.claude/plans/eager-humming-crown.md` — authoritative work plan
4. **Verify current state**:
   - `ls ~/Desktop/intern/templateapp/` to see what exists on disk
   - `cd ~/Desktop/intern/templateapp/frontend && curl -s -o /dev/null -w "%{http_code}\n" http://localhost:5173` — is dev server running?
   - `ls "~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/research/"` — has W1 finished?
5. **Find todos**: check the conversation's todo list state, or look at "Suggested execution order" in `eager-humming-crown.md`
6. **Sync check**: `cd ~/Desktop/claude-context && git status && git pull` before making changes

---

## How to run things

### Frontend (already exists, scaffold complete)
```bash
cd ~/Desktop/intern/templateapp/frontend
npm install                    # if first time
npm run dev                    # serves on localhost:5173
# OR for background:
./node_modules/.bin/vite --port 5173 --host > /tmp/dev.log 2>&1 &
```

Routes: `/login` `/templates` `/templates/edit` `/schemas` `/schemas/edit` `/datasets` `/runs` `/review` `/rules`. Default redirects from `/` to `/templates`.

### Verify build clean
```bash
cd ~/Desktop/intern/templateapp/frontend
./node_modules/.bin/tsc --noEmit       # should exit 0
./node_modules/.bin/vite build         # should produce 60+ modules
```

### Python agent service (NOT YET EXISTS, build per plan W3a)
```bash
cd ~/Desktop/intern/templateapp/agent-service
python -m venv .venv
source .venv/bin/activate
pip install fastapi uvicorn langgraph langchain crewai anthropic openai google-genai ollama docxtpl pydantic pytest
uvicorn app:app --reload --port 8001   # planned port
```

### Node gateway (NOT YET EXISTS, build per plan W3c)
```bash
cd ~/Desktop/intern/templateapp/api
npm install
npm run dev                            # planned port 3001
```

---

## Conventions established

- **Placeholders**: `{{column_name}}` — text-based, editor-agnostic, works in any docx via docxtpl
- **Color palette**: custom `brand.*` Tailwind tokens (50→900). Muted blue-gray business tool. NOT SaaS-purple. No gradients, no shadows beyond `shadow-sm`, no marketing copy.
- **Severity**: `red-*` error, `amber-*` warn, `blue-*` info, `emerald-*` done
- **Type badges**: `violet-*` numeric, `slate-*` string, `emerald-*` bool, `sky-*` date
- **Layout**: Sidebar w-56 (`bg-brand-900`) + topbar h-12 (white). Main `max-w-4xl p-6`
- **Forms**: inline cards, **never modals**
- **Lists**: white card + `border-brand-200`, hover → `border-brand-400`
- **Tabs**: `border-b-2 -mb-px`, active = `border-brand-700 text-brand-900 font-medium`
- **Frontend imports**: `@/ui/*`, `@/components/*`, `@/pages/*`, `@/store/*` (Vite alias)
- **Code/identifiers**: `font-mono`, sometimes `bg-brand-100 px-1 rounded`

---

## Claude's role on this project (per CLAUDE.md §3)

**Claude is the CTO advisor, not the code generator.** The user (Geng Yue) maintains decision authority. Claude's job:
- Architectural attack/review of proposals (find real failure modes, not stylistic critique)
- Refactor co-pilot when projects mature (give 2-3 paths + trade-offs)
- Context memory across sessions
- Cognitive calibration (when Claude is wrong, user corrects, and the correction enters memory)

**Claude must NOT**:
- Generate code proactively unless asked
- Sprint into solutions before the user has thought through the problem
- Treat product vision as if it were technical architecture (call out the difference)
- Praise things

User pattern: "我先想清楚每个决策，你帮我列出决策空间和 trade-off" — for each decision, surface the option space and the trade-offs; don't preselect or ship a finished plan unprompted.

---

## Open questions

### For next session
- Once W1 research finishes, what technique do we implement first in the Judge agent? (Likely G-Eval style + custom rubric, but verify)
- Should the gold-standard test set be built before or after W3a skeleton? Plan says before, but skeleton could help generate test cases.
- Frontend SSE: confirm Express SSE works through Vite dev proxy for the Agent Timeline live updates

### For Linda when she returns (5/27+)
- Paper target conference/journal + submission deadline?
- Budget for Claude API (especially for multi-tier benchmarking — Opus + Sonnet + Haiku × N cases × multiple revisions adds up)?
- Co-authors? (Geng Yue + Linda + Ms Hu? Or just first two?)
- Who builds the human-labeled gold-standard test set (~20-50 cases)?
- Open-source the implementation alongside the paper?
- ONLYOFFICE dropped — does she agree, or did she want the rich editing UX preserved?
- The 4-27 expansion items (multi-table, reverse Excel, Case B) — still all in scope for the paper, or scoped down to just the agentic story?

---

## How information moves (the file flow you should respect)

```
Live work / WIP                  →  ~/.claude/plans/eager-humming-crown.md   (local working copy)
                                 ↓
                                 mirror to
                                 ↓
Cross-machine, version-controlled →  ~/Desktop/claude-context/shared/projects/templateapp/PLAN.md
                                 ↓
Long-form, polished, frontmatter →  ~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/PLAN.md  (Obsidian)

Detail decisions / research        →  Obsidian vault primarily (this folder + research/)
Light pointers / memory entries    →  ~/Desktop/CLAUDE.md §8

Source code                        →  ~/Desktop/intern/templateapp/  (will go to GitHub when Esther gives access)
Paper                              →  ~/Downloads/Draft Paper - Documentation.docx  (will be in vault eventually)
```

**Rule**: when in doubt, write to Obsidian + claude-context, push the claude-context repo, mention what changed in CLAUDE.md §8.

---

## What NOT to do

- Don't restart the M1-M9 plan from `shimmying-dreaming-naur.md` as written. It predates the pivot. Read `eager-humming-crown.md` first.
- Don't bring ONLYOFFICE back unless Linda explicitly says so on return.
- Don't write code to the existing `frontend/` without first checking what's there — 9 pages are already scaffolded.
- Don't commit to GitHub the templateapp repo until Esther authorizes (claude-context is fine to push, that's user-owned).
- Don't praise the user's choices. Per CLAUDE.md §2, that's a non-negotiable preference.

---

## Quick reference

| What | Where |
|---|---|
| Current plan | `~/.claude/plans/eager-humming-crown.md` |
| Pre-pivot plan (mostly archived) | `~/.claude/plans/shimmying-dreaming-naur.md` |
| Paper draft | `~/Downloads/Draft Paper - Documentation.docx` |
| Vault project root | `~/Documents/YoRHa's Brain/01 - Projects/TemplateApp/` |
| claude-context mirror | `~/Desktop/claude-context/shared/projects/templateapp/` |
| Source code root | `~/Desktop/intern/templateapp/` |
| Frontend dev URL | `http://localhost:5173` |
| Reference codebase (IFSG) | `~/Desktop/ifsg/` (private) |
| Linda audio brief | `~/Downloads/Temasek Polytechnic 6.m4a` (≈58 min, 4-27) |
| Linda brief transcript | `vault/.../transcripts/2026-04-27 brief.md` |

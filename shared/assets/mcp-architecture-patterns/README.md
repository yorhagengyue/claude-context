---
asset: mcp-architecture-patterns
source-project: NAISC Workato · Ripple (archived 2026-05-25)
status: reference · evergreen pattern set
date: 2026-05-25
---

# MCP Architecture Patterns

Distilled architecture + pitch patterns from the NAISC Ripple project (MCP-orchestrated wellness data pipeline). These survived the project's end as reusable thinking for any future MCP / agent / LLM-tool-fronted product.

## Contents

| File | What it is |
|---|---|
| `architecture-diagram.html` | 3-layer reference diagram: ingestion / processing / communication + governance overlay. Macro→micro narrative. Built for the 5/22 NAISC deck. |

## Core patterns

### 1. 3-layer architecture (ingestion / processing / communication + governance)

The diagram in `architecture-diagram.html` is the reference. The point is the narrative shape, not the specific connectors:

- **Layer 1 — Ingestion**: source connectors (wearables / messaging / calendars / activity feeds). Workato recipes in Ripple's case; any iPaaS or custom connectors elsewhere.
- **Layer 2 — Processing**: rule library + LLM pre-processor + ML signals. Where structured-knowledge meets statistical / model output.
- **Layer 3 — Communication**: nudges, alerts, conversational replies. Outbound channels.
- **Governance overlay**: consent, audit log, kill-switch — cuts across all three layers.

Use this shape when pitching any "data-in / decision-out / action-out" agent system. Mentor (TP8) flagged "missing 3-layer diagram" as the #1 deck gap.

### 2. MCP is the natural decoupling layer between model and LLM

LLM never "reads" a model — it reads the model's structured output via tool call. The model is, from the LLM's perspective, just `tool_name + input_schema + output_schema`. Implementation can be a 1KB logistic regression, a 70B fine-tuned LLM, or an if/else block — the LLM doesn't care.

**Consequence**: ML upgrade has **zero migration cost** on the agent side. Today's z-score baseline can become tomorrow's trained model with no changes to prompts, tool definitions, or pitch story. Whether to "go ML" is a business / stage question, not an engineering one.

→ Memory: CLAUDE.md §8 `[2026-05-04] insight: MCP 是 model-LLM 的天然解耦层`

### 3. Pattern D (RAG/MCP) replaces online training in MVP stage

For data-scarce early-stage products: don't train models, expose retrieval + structured rules via MCP tools instead. Prompt + RAG/MCP solves ~95% of cases without the overfitting / brittleness risk of a small-data trained model that breaks under Q&A.

The strongest pitch line — **"We don't train models today. Every recipe is structured data capture by design. The MCP surface is the distribution layer for whatever models we train later. The first 10,000 users we sign up is the model."** — generalizes to any agent product that's MVP-stage but needs a story for "where's the AI moat".

→ Detail: [`../../archive/naisc-workato/ml-strategy-v1.md`](../../archive/naisc-workato/ml-strategy-v1.md)

### 4. Output-schema discipline for ML / statistical tools exposed to LLMs

Bad: `{"score": 0.73}` — information loss, LLM has to guess what to do with it.

Good: `{ score, scale, vs_personal_baseline, key_drivers: [...], confidence_interval, model_version, ... }`

Treat the schema like a report for a smart intern. A well-schema'd logistic regression beats a poorly-schema'd neural net in practice. Apply this to **any** MCP tool that exposes statistical or ML results.

→ Memory: CLAUDE.md §8 `[2026-05-04] insight: 给 ML tool 的 output schema 决定 LLM 用得多好`

### 5. "Cursor analogy" as the why-now pitch line

**"Build the thing before the model is capable. Pipeline ready means the next-gen model just plugs in."**

Cursor existed before GPT-4 was good at code; when GPT-4 landed, Cursor became the obvious frontend. The structural argument: your value is the data pipeline + structured-knowledge backbone, not the current model. When models get smarter, you're the distribution layer.

Reuse whenever a product is data-pipeline-strong but model-weak (the most common shape for non-FAANG AI products).

→ Detail: [`../../archive/naisc-workato/mentor-takeaways-tp7-tp8.md`](../../archive/naisc-workato/mentor-takeaways-tp7-tp8.md)

### 6. Data flywheel as moat ("first 10,000 users is the model")

When asked "what's your moat?" — the answer is the proprietary structured dataset that accumulates from real usage. Not the model, not the prompts. The data nobody else has.

This pairs naturally with pattern 3 (Pattern D — no model today).

### 7. LLM-as-judge multi-agent layering for "what if the AI errors?"

**process → validate → communicate**, three short prompts, each with low temperature, each judging the previous step's output. TP8 mentor confirmed this is what they run in production.

Reuse for any Q&A defense around AI hallucination / safety / liability — pairs well with an RLHF / human-feedback flywheel as the secondary answer.

→ Detail: [`../../archive/naisc-workato/mentor-takeaways-tp7-tp8.md`](../../archive/naisc-workato/mentor-takeaways-tp7-tp8.md)

### 8. "Pre-processed data pipeline" framing (instead of "AI agent")

Reposition the product as **data spine** rather than **agent**: "agents — everyone is building one. Data spine — nobody is." Any agent (Hermes / Cursor / future GPT-N) can plug in.

This was Ripple's late-stage repositioning per mentor feedback. Useful when the product looks like "yet another AI agent" but actually has unusual data plumbing.

## When to reuse

- Designing any MCP-based product / agent system
- Preparing pitch / deck where "AI errors" or "moat" or "why now" Q&A will come up
- Writing architecture docs that need a macro→micro narrative shape
- Deciding whether to invest in ML training at MVP stage (answer is usually no — see pattern 3)

## Cross-references

- `archive/naisc-workato/architecture-diagram.html` (same file as here, kept in archive too for context)
- `archive/naisc-workato/ml-strategy-v1.md` — full Pattern A/B/C/D decision write-up
- `archive/naisc-workato/mentor-takeaways-tp7-tp8.md` — TP7 (Colin) + TP8 mentor distilled takeaways
- CLAUDE.md §8 entries dated 2026-05-04 and 2026-05-08

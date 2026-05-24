---
asset: wellness-rule-library
source-project: NAISC Workato · Ripple (archived 2026-05-25)
status: static · no longer updated
date: 2026-05-25
---

# Wellness Rule Library

53 evidence-based wellness / health detection rules across 11 categories, each annotated with confidence level and academic / clinical source URLs. Lifted out of the archived NAISC Ripple project as a reusable asset for any future wellness / health monitoring product.

## Contents

| File | What it is |
|---|---|
| `ripple_core_rule_library_v2.xlsx` | **Current canonical** — 53 rules / 11 categories, each with confidence + source URLs. Use this. |
| `ripple_core_rule_library_v1.xlsx` | Older 60-rule version. Kept for diff / provenance only. |
| `rule-visualization.html` | Standalone HTML viewer for v2 — open in browser to scan rules without Excel. |

## v1 vs v2

v1 = 60 rules (initial draft from WeChat-shared research collaborator). v2 = 53 rules (consolidation — some merged, some dropped; reorganized into 11 categories with stricter sourcing). Per the original asset index there is an open question whether v2's reduction is "merge of v1" or "fresh framework" — confirm with collaborator before reuse in production.

## Categories (v2)

acute strain (HR/RHR/HRV spikes) · daily recovery (sleep+HRV+RHR composite) · training response · fitness trend (longitudinal VO2max/RHR drift) · sedentary behavior · mobility / fall risk · hearing exposure · circadian rhythm · digital wellbeing (screen time / late-night phone) · multi-signal composite (whole-body shift) · (11th — see xlsx header)

Each row: rule_id, category, signals_used, threshold/logic, confidence (high/med/low), source URLs, demo-readiness flag.

## Current status

**Static.** No longer maintained — the NAISC project that produced it is archived (5/22 Workato Track 3rd place, then wound down). The collaborator who curated the rules is not on a follow-up project. Treat as a snapshot.

## When to reuse

- Any wellness / health monitoring product that wants to **replace gut-feel thresholds with academic-framework citations** (this was the original strategic point — Colin's mentor feedback during NAISC: "borrow existing academic frameworks, don't invent your own")
- "Evidence base" slide content for any health-adjacent pitch
- Starting point for building a personal-baseline ML model — these rules are the labeled-positive heuristics you'd train against

## Provenance

Received via WeChat 2026-05 from team's research collaborator. Sourced from peer-reviewed literature + Apple Heart Study + clinical guidelines.

## Cross-references

- Original asset index (with deeper context on which rules were wired for 5/22 demo): `archive/naisc-workato/rule-library/README.md`
- Memory entry: CLAUDE.md §8 `[2026-05-08] asset: Ripple rule library v2 入库`

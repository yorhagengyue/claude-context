---
project: NAISC Workato · Ripple
type: asset-index
date: 2026-05-08
---

# Ripple Core Rule Library — Index

Evidence-based detection rules powering Ripple's anomaly + nudge logic. **Strategic asset for the 5/22 pitch deck "evidence base" slide** and Q&A defense ("how do you know this isn't snake oil"). Addresses Colin (TP7)'s feedback about borrowing existing academic frameworks instead of inventing thresholds.

## Files

> **2026-09-03 去重**:下表三个文件的本体已从 archive 移除——它们与 `shared/assets/wellness-rule-library/` 里的三份逐字节相同,以那边为准(git 历史仍可取回)。

| File | What it is |
|---|---|
| `ripple_core_rule_library_v2.xlsx` | **Current canonical** — 53 rules across 11 categories, each with confidence + source URLs. Use this. |
| `ripple_core_rule_library_v1.xlsx` | Older 60-rule version. Kept for diff / provenance only. |
| `rule-visualization.html` | Standalone HTML viewer for v2 — open in browser to scan rules without Excel. |

## Categories (v2, 11)

1. Acute strain (HR / RHR / HRV spikes)
2. Daily recovery (sleep + HRV + RHR composites)
3. Training response (workout vs adaptation)
4. Fitness trend (longitudinal VO2max / RHR drift)
5. Sedentary behavior
6. Mobility / fall risk
7. Hearing exposure
8. Circadian rhythm (sleep timing, mid-sleep)
9. Digital wellbeing (screen time / late-night phone)
10. Multi-signal composite (whole-body shift)
11. (one more — see xlsx header for the 11th, depending on file version)

Each rule row has: rule_id, category, signals_used, threshold/logic, confidence (high/med/low), source URLs (papers / clinical guidelines), demo-readiness flag.

## Top 10 demo rules (pre-curated for 5/22)

The xlsx flags ~10 rules as "demo-ready". Within those, the **5/22 wiring decision is**:

| Rule | Status | Why |
|---|---|---|
| **R006** — sleep + HRV + RHR composite recovery | **MUST wire** | 30-second demo, signals already flowing through Workato/Supabase |
| **R043** — late-night phone use degrading next-day sleep | **MUST wire** | Differentiator — ties to Discord listener data, no other team has this signal axis |
| **R048** — 6-signal whole-body shift | **STRETCH** | Depends on wrist temperature data flowing end-to-end. Verify before committing. |
| Other ~50 rules | **Deck content only** | Show breadth/rigor on the evidence-base slide; don't wire all of them — task-budget on Workato trial doesn't allow it |

## How this maps to the deck

- **Evidence-base slide** (new, per TP8 mentor) — show the rule library as a screenshot or summary table; cite "53 rules, 11 categories, sourced from peer-reviewed literature + Apple Heart Study + clinical guidelines"
- **Processing layer slide** (Layer 2 of 3-layer architecture) — rule library is the "ML signals + LLM pre-processor" middle layer
- **Why-now slide** (Cursor analogy) — rule library is the structured-knowledge backbone that lets the next-gen LLM plug straight in

## Provenance

- v1 (60 rules) and v2 (53 rules) received via WeChat 2026-05 from the team's research collaborator
- Original WeChat container path (machine-fragile, do NOT reference from skills/cron):
  `~/Library/Containers/com.tencent.xinWeChat/Data/Documents/xwechat_files/wxid_71dxe8c6d77p22_8ed2/temp/drag/`
- Files in this folder are the **portable copy** — use these paths, not the WeChat container ones

## Open questions

- Does v2's "53 rules" mean the team consolidated v1's 60 rules (some merged, some dropped) or pivoted to a fresh framework? — confirm with collaborator before pitch
- Which rules cite Apple Heart Study vs which cite outside literature? — matters for "moat" Q&A: Apple-published data is public, Ripple's value-add is the **composite + multi-signal fusion**, not the underlying study

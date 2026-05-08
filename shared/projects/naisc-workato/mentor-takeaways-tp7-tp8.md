---
project: NAISC Workato · Ripple
date: 2026-05-08
type: mentor-distilled
sources:
  - "Obsidian: 01 - Projects/Workato NAISC/transcripts/Recording · 2026-05-08 · TP7.md (Colin)"
  - "Obsidian: 01 - Projects/Workato NAISC/transcripts/Recording · 2026-05-08 · TP8.md (Workato/business mentor)"
note: |
  Raw Whisper transcripts are noisy (forced zh detection on bilingual audio,
  ~33 hallucination loops total). This file is a clean distillation, written
  from claude-side synthesis of the TP7 + TP8 sessions on 2026-05-08.
  Do not cite quotes verbatim from this file — re-check transcripts if the
  exact wording matters.
---

# 5/8 Mentor Takeaways · TP7 (Colin) + TP8 (Workato / Business)

Two back-to-back mentor sessions. Distilled action implications below.

---

## TP7 · Colin (~32 min)

**Frame**: focus discipline + scientific rigor + data flywheel as moat.

- **One scenario, one win.** "You only have to do one scenario, you fighting in time." Don't try to demo gaming + fall + meeting + sleep — pick the strongest end-to-end (gaming + Discord + R043) and own it.
- **Borrow academic frameworks, don't invent thresholds.** Colin has a contact at NUS HSS doing social-isolation / loneliness / stress measurement matrices. Cite those instead of "we picked HR > 150 because it felt right". This is the credibility play.
- **Q&A defense for "what if AI is wrong" → RLHF feedback loop.** Thumbs up/down on alerts, user feedback fine-tunes model selection. "Not hard to implement, big companies do this."
- **AI memory limits → sub-agent engineering.** Colin has done this for his father's medical records (split context across narrow agents instead of one giant context window). Useful framing for "how do you avoid context bloat as user history grows".
- **Data curation: 100% raw, 20% useful, 80% wastes tokens.** Only extract what the agent actually needs. Reinforces the rule library approach (53 distilled rules) over "feed everything to the LLM".
- **Why-this-is-your-moat answer = data flywheel.** "As long as we start the system, all users' data come to our system. This gap is what newcomers cannot chase for." First-mover advantage on labelled longitudinal data, not algorithm.
- **7 finalists, 2 polytechs (one is Team YoRHa).** Narrative angle: resource-light, depth-deep. Don't try to out-engineer NUS / NTU teams; out-narrate them.
- **Long-term baseline = the product itself.** "Over a long time this is a pattern of how you live." Personalization compounding becomes the lock-in. Aligns with ML Strategy v1's Pattern D position.

---

## TP8 · Workato / Business mentor (~35 min)

**Frame**: judges grade idea > tech depth; deck needs 3-layer architecture; live demo wins; thin business layer; LLM-as-judge is a stronger Q&A weapon than RLHF.

- **Evaluation reality.** "Judges focus on idea > technology depth. AI agents pre-processing data is already advanced enough at student level." Don't try to look like a senior MLE — look like someone who picked the right problem and shipped it.
- **Biggest deck deliverable currently missing = 3-layer architecture diagram.**
  - **Layer 1 · Ingestion** — Apple Watch + connectors, flow chart of data sources (HAE / direct / future Garmin etc.)
  - **Layer 2 · Processing** — pre-processor → ML signals → LLM. This is where rule library v2 + agent loop live.
  - **Layer 3 · Communication** — WhatsApp / WeChat / Telegram / family-circle / MCP. Multi-channel surface.
  - **Governance overlay** per layer — security, privacy, consent. Mentor specifically called this out as missing.
  - Narrative: macro view first, then drill into each layer.
- **What actually wins judges = end-to-end live demo with real data.** Not architectural slides. "On the spot run: heart rate goes up → signal will tell you." Plan a live demo with a fallback recording in case sandbox flakes.
- **Business value should be a thin layer, not the spine.** TAM (Singapore 6M), GTM (small group → spread via family / social circle), B2C → B2B trajectory, sustainability ($10k/month infra → how to survive). Mentor said evaluation criterion has only "small bit" weight on this. Cover it once; don't dwell.
- **Q&A "AI is wrong" defense — LLM-as-judge / multi-agent layered architecture.** Stronger than Colin's RLHF answer for current state (RLHF needs users; LLM-as-judge ships today).
  - Agent 1 process → Agent 2 validate → Agent 3 communicate
  - Each LLM short, low temperature, low cost
  - Layering reduces hallucination
  - Mentor said he's done this with good results in production
- **"Why now" pitch line — the Cursor analogy.** "Build the thing before the model is capable. When my pipeline is ready, the next-gen model will just plug into it." This is currently the strongest answer to "why doesn't OpenAI just add this to ChatGPT".
- **Ripple positioning — NOT an AI agent, but a pre-processed data pipeline.** Pairs with whatever agent (Hermes / opencloud / future GPT-N). "Agents are what everyone's building. The data spine — that's missing." Aligns with ML Strategy v1's "MCP as model-LLM decoupling layer" insight.
- **Channel diversity (WhatsApp / WeChat / Telegram) is implemented but missing from deck.** Add a slide.
- **B2C → B2B trajectory typical.** Investors come in phases — seed → Series A → IPO exit. Don't pitch "we'll be a billion-dollar healthcare platform" — pitch "we ship to families first, the family-circle social graph is the wedge into B2B EAP".

---

## Action implications (synthesized)

| What | Why | Source |
|---|---|---|
| Build 3-layer architecture diagram (ingestion / processing / communication + governance overlay) | Biggest deck gap | TP8 |
| Add "evidence base" slide showing rule library v2 (53 rules, 11 categories, citations) | Replace "we made up thresholds" with "we cite literature" | TP7 |
| Add channel-diversity slide (WhatsApp/WeChat/Telegram already shipped, MCP for agents) | Currently invisible to judges | TP8 |
| Add "why now" Cursor-analogy slide | Strongest defense vs "OpenAI will eat this" | TP8 |
| Pick ONE demo scenario (R006 + R043 + Discord + gaming) and rehearse end-to-end | "One scenario, you fighting in time" | TP7 |
| Q&A prep: LLM-as-judge multi-agent diagram (primary) + RLHF flywheel (secondary) | Two layered answers depending on judge background | TP7 + TP8 |
| Thin business slide (TAM / GTM / B2C→B2B / sustainability) — one slide, not three | "Small bit weight" | TP8 |
| Plan live-demo fallback (pre-recorded backup if sandbox flakes 5/22) | Live demo wins but is risky | TP8 |
| Reposition pitch line: "Ripple = the pre-processed data spine, not the agent" | Mentor's strongest framing | TP8 |

---

## What is NOT mentor advice (don't conflate)

- "Train ML models" — neither mentor said this. ML Strategy v1's "no model training before 5/22" decision stands.
- "Pivot to community / family-circle product" — this was an early TP8 framing the mentor floated, but the user has not committed. Pitch positioning stays "individual wellness with family-channel optionality" unless user explicitly decides otherwise.
- "Fix Tommy Chen → Chen Yufei in trailer/site/email" — neither mentor commented on this. Still pending user decision.

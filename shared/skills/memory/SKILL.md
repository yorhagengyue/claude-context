---
name: memory
description: "Session memory persistence and context management. Triggers at end of every conversation, when the user says 'save this', 'remember', 'update memory', 'heartbeat', '/memory', or when Claude has learned something significant about the user's projects, preferences, or decisions. Also triggers when a new session starts and Claude needs to load context. Use this skill whenever there's any indication that session context should be preserved or loaded — even if the user doesn't explicitly ask."
---

# Memory Skill

Persist what matters across sessions. Keep it simple, keep it debuggable.

## Core Concept: Hub-and-Spoke Architecture

The memory system uses a hub-and-spoke structure to keep context lean:

**Hub**: `shared/CLAUDE.md` (symlinked to Desktop) — slim index file (~80 lines). Contains conclusions, not full analysis. Has two zones:
1. **Static profile** (sections 1-7): Index-level summaries + pointers to sub-MDs.
2. **Memory append zone** (section 8): Timestamped, tagged, append-only entries.

**Spokes**: Project-specific sub-MDs in `shared/projects/<name>/` (e.g., `shared/projects/moyuan/MOYUAN.md`) — contain full project detail, architecture review history, decision logs. Each sub-MD is self-contained and only loaded when working on that project.

**Rules**:
- CLAUDE.md §5 project table points to each sub-MD with a link
- Project-specific memories go into the sub-MD, not CLAUDE.md §8
- CLAUDE.md §8 is only for cross-project decisions, user preferences, corrections, and meta-level insights
- When a project status changes, update both: sub-MD status section + CLAUDE.md §5 one-liner

## When to Write Memory

Evaluate the current session and write a memory entry when ANY of these are true:

- User explicitly asks ("save this", "remember", "heartbeat", "/memory")
- A significant architectural decision was made or discussed
- User corrected a misunderstanding (this calibrates future sessions)
- A project status changed (started, blocked, pivoted, shipped)
- User revealed a new preference or constraint about how they work
- Session is ending and non-trivial work happened

Do NOT write memory for:
- Pure Q&A with no lasting value
- Things already captured in the static profile sections
- Duplicate of an existing memory entry

## Memory Entry Format

Append to section 8 of CLAUDE.md using this exact format:

```markdown
### [YYYY-MM-DD] tag: one-line summary
body text — 2-5 sentences max. What happened, what was decided, what changed.
If a decision was made, record the options considered and why this one was chosen.
If a correction happened, record what was wrong and what's right.
```

Valid tags: `decision`, `correction`, `status`, `preference`, `insight`, `architecture`

**Example:**
```markdown
### [2026-04-03] decision: MoyuanIdea tech stack chosen as Next.js + Supabase
Evaluated three options: (1) Next.js + Supabase, (2) Express + PostgreSQL, (3) FastAPI + SQLAlchemy.
Chose option 1 because of rapid prototyping speed and built-in auth for three-endpoint system.
Trade-off accepted: less control over backend logic, vendor lock-in on Supabase.
```

## How to Write

1. Read the current CLAUDE.md from the user's workspace
2. Evaluate the session against the "When to Write" criteria
3. Draft the entry or entries (usually 1-2 per session, rarely more than 3)
4. Show the draft to the user: "I want to save this to memory. Does this look right?"
5. On confirmation, append to section 8 of CLAUDE.md using the Edit tool
6. If CLAUDE.md doesn't exist yet, warn the user — don't create it from scratch here

## How to Load (Session Start)

When a new session starts:

1. Read CLAUDE.md from the user's workspace — this gives you the full index
2. Parse both the static profile and all memory entries
3. If the session is about a specific project, also read that project's sub-MD (e.g., `shared/projects/moyuan/MOYUAN.md`)
4. Use this context to inform the session — don't summarize it back to the user unless asked
5. If CLAUDE.md §8 exceeds ~30 entries, suggest running consolidation

## Consolidation (Manual Trigger)

When the memory section exceeds ~30 entries or the user asks to clean up:

1. Read all entries in CLAUDE.md §8 and all sub-MDs
2. Identify entries that are now redundant (superseded by later decisions, captured in static profile, or no longer relevant)
3. Promote project-specific entries from CLAUDE.md §8 into the relevant sub-MD if they belong there
4. Propose removals to the user — never delete without confirmation
5. Update CLAUDE.md §5 project table if sub-MD statuses have changed
6. Archive removed entries to the `archive/` directory so nothing is truly lost

## Cross-Machine Sync

CLAUDE.md and all sub-MDs live in a Git repo: `yorhagengyue/claude-context` (private). Multiple machines (Mac Mini, MacBook, Windows planned) clone this repo on separate branches.

**File locations**:
- Git repo: `~/Desktop/claude-context/`
- Source: `~/Desktop/claude-context/shared/CLAUDE.md`
- Desktop symlinks: `~/Desktop/CLAUDE.md` → `~/Desktop/claude-context/shared/CLAUDE.md`

**After writing memory**, remind the user to sync:
```bash
cd ~/Desktop/claude-context && git add -A && git commit -m "memory: <brief description>" && git push
```

**At session start on a different machine**, pull first:
```bash
cd ~/Desktop/claude-context && git pull
```

If there's a merge conflict (both machines wrote to §8), resolve by keeping both entries sorted by date descending.

## Debugging

Every memory entry has a date and tag. If something seems wrong in Claude's behavior:

- Check CLAUDE.md section 8 for stale or incorrect entries
- Look for `correction` tags — these indicate past misunderstandings
- `git log` on the claude-context repo shows full edit history
- The `archive/` directory shows what was consolidated and when

The user explicitly wants this system to be "可被查出问题，可迭代" (debuggable and iterable). So: keep entries atomic, keep the format consistent, never silently modify existing entries.

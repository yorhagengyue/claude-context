---
asset: whisper-hallucination-cleanup
source-project: NAISC Workato · Ripple mentor recordings (archived 2026-05-25)
status: script LOST · spec-only (rewrite from this README if needed)
date: 2026-05-25
---

# Whisper Hallucination Cleanup

Post-processing logic for collapsing Whisper `small`-model hallucination loops in real noisy-audio transcripts. **Script itself is lost** (was in `/tmp/clean_transcript.py`, didn't survive a reboot). This README is the spec — rewrite from it if/when needed.

## The problem

Whisper `small` (and lower) hallucinates aggressively on silent / low-volume segments. Symptoms:

- The model emits dense repetition of a short phrase or single character ("我认识 我认识 我认识 ..." for 45 consecutive segments was the worst observed instance)
- The feature_extractor concurrently throws `RuntimeWarning: divide by zero / overflow / invalid value in matmul`
- These RuntimeWarnings correlate ~1:1 with repetition-segment output

This makes raw Whisper output unsafe to trust as-is for any real transcript. **Always do post-processing.**

## Cleanup algorithm (dual-criterion fold)

Collapse a segment (or run of segments) when **either**:

1. **Consecutive-segment 2-char ngram dominance**: in a sliding window of consecutive segments, if any 2-character ngram appears in ≥ **30%** of the total characters → fold all those segments into a single annotated marker (e.g. `⚠️ [repetition: "我认识" × 45]`).

2. **Single-segment repetition**: within a single segment, if any 2-to-6-character substring repeats ≥ **3 times** AND those repetitions account for > **50%** of the segment's characters → fold to a single occurrence + annotation.

Thresholds are **deliberately conservative — bias toward false-negative** (miss some hallucination) rather than false-positive (destroy real repeated speech like "对对对" or chant lyrics). Tighten thresholds (lower the percentages, raise the count) if the source audio is known clean and you want more aggressive folding.

## Measured performance

Applied to NAISC mentor recordings (5/22 prep):

- **TP7 (Colin)**: 32 min audio → 1054 raw segments → 994 kept + 12 ⚠️ markers (60 segments folded across 12 hallucination loops)
- **TP8 (Workato/business)**: 35 min audio → 1477 raw segments → 1362 kept + 21 ⚠️ markers (115 segments folded across 21 loops, including the 45-segment "我认识" loop at 15:20–16:08)

Total: 33 distinct hallucination loops detected and folded in 67 minutes of audio.

## When to reuse

- Any Whisper transcription of real-world noisy audio (interview recordings, podcast rips, field recordings) where you don't fully trust the output
- Especially: `whisper small` / `whisper.cpp small` / `faster-whisper small` — bigger models hallucinate less but still do it occasionally

## Recommended upgrades when rewriting

- **Switch model first** — `mlx-whisper large-v3` on Apple Silicon, or `faster-whisper large-v3` elsewhere, dramatically reduces hallucination frequency. Cleanup becomes a safety net rather than the primary defense.
- **Voice activity detection (VAD) pre-pass** (e.g. Silero VAD) — strip silent regions before Whisper sees them. Removes the root cause (Whisper having nothing to transcribe and inventing content). The `--vad_filter` flag in faster-whisper is the easy version.
- **Use the RuntimeWarning signal directly** — capture stderr from feature_extractor, mark those segments as suspect. Cheaper and more precise than the ngram heuristic. Pair with the ngram pass as defense-in-depth.

## Cross-references

- Memory: CLAUDE.md §8 `[2026-05-08] insight: Whisper small 在静音/低音量段会强行造句`
- Original transcripts (post-cleanup) live in Obsidian: `01 - Projects/Workato NAISC/transcripts/` (path may have moved if the project was archived in Obsidian too)
- Related skill (uses different stack, but same problem class): `shared/skills/douyin-transcribe/` — `--clean` flag does similar collapse, but for `mlx-whisper` output. If you need a starting point, that skill's cleanup function is closer to a usable rewrite than starting from scratch.

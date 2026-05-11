#!/usr/bin/env python3
"""Clean Whisper SRT: collapse hallucination loops, emit timestamped Markdown."""
import re
import sys
from pathlib import Path
from collections import Counter


def parse_srt(path):
    blocks = []
    raw = Path(path).read_text(encoding="utf-8").strip()
    for chunk in re.split(r"\n\s*\n", raw):
        lines = chunk.strip().splitlines()
        if len(lines) < 3:
            continue
        m = re.match(r"(\d+:\d+:\d+),(\d+)\s*-->\s*(\d+:\d+:\d+),(\d+)", lines[1])
        if not m:
            continue
        start = lines[1].split(" --> ")[0]
        end = lines[1].split(" --> ")[1]
        text = " ".join(lines[2:]).strip()
        blocks.append((start, end, text))
    return blocks


def to_seconds(ts):
    h, m, s_ms = ts.split(":")
    s, ms = s_ms.split(",")
    return int(h) * 3600 + int(m) * 60 + int(s) + int(ms) / 1000


def fmt_mmss(ts):
    h, m, s_ms = ts.split(":")
    s = s_ms.split(",")[0]
    total_min = int(h) * 60 + int(m)
    return f"{total_min:02d}:{s}"


def is_loopy(text):
    """Heuristic: does this single segment internally repeat a short phrase?"""
    # E.g. "画面的画面的画面" or "打开转换 打开转换 打开转换"
    # Look for any 2-6 char substring repeating 3+ times
    for sub_len in range(2, 7):
        for i in range(len(text) - sub_len * 3 + 1):
            sub = text[i : i + sub_len]
            if sub.strip() == "":
                continue
            count = text.count(sub)
            if count >= 3 and count * sub_len >= len(text) * 0.5:
                return True, sub
    return False, None


def detect_loop_runs(blocks, window=4):
    """Mark indices that belong to hallucination runs.
    Catches: (1) consecutive identical/near-identical segments (works for any language),
    (2) CJK ngram-dominated runs, (3) single segments with internal repetition.
    """
    flagged = [False] * len(blocks)

    # (1) Consecutive identical segments (>= 3 in a row) — language-agnostic.
    i = 0
    while i < len(blocks):
        j = i + 1
        while j < len(blocks) and blocks[j][2].strip() == blocks[i][2].strip():
            j += 1
        if j - i >= 3:
            for k in range(i, j):
                flagged[k] = True
            i = j
        else:
            i += 1

    # (2) CJK ngram dominance across consecutive blocks.
    i = 0
    while i < len(blocks):
        run_end = i
        for j in range(i + 1, min(i + 30, len(blocks))):
            chunk_text = "".join(b[2] for b in blocks[i : j + 1])
            if len(chunk_text) < 10:
                run_end = j
                continue
            cjk = re.findall(r"[一-鿿]{2}", chunk_text)
            if not cjk:
                break
            cnt = Counter(cjk)
            top, top_n = cnt.most_common(1)[0]
            cjk_total = sum(cnt.values())
            if top_n >= 4 and top_n / max(cjk_total, 1) >= 0.30:
                run_end = j
            else:
                break
        if run_end - i >= 2:
            for k in range(i, run_end + 1):
                flagged[k] = True
            i = run_end + 1
        else:
            i += 1

    # (3) Single block with heavy internal repetition.
    for idx, (_, _, t) in enumerate(blocks):
        loopy, _ = is_loopy(t)
        if loopy:
            flagged[idx] = True
    return flagged


def main():
    srt_path = sys.argv[1]
    out_path = sys.argv[2]
    title = sys.argv[3] if len(sys.argv) > 3 else "Recording"

    blocks = parse_srt(srt_path)
    flagged = detect_loop_runs(blocks)

    out_lines = []
    out_lines.append(f"# {title}")
    out_lines.append("")
    out_lines.append(f"- **总时长**：{fmt_mmss(blocks[-1][1])}")
    out_lines.append(f"- **段数**：{len(blocks)}（清理前）")
    flagged_n = sum(flagged)
    out_lines.append(f"- **疑似幻觉段**：{flagged_n}（已折叠）")
    out_lines.append("- **来源**：mlx-whisper（Apple Silicon GPU）· `condition-on-previous-text False`")
    out_lines.append("")
    out_lines.append("---")
    out_lines.append("")

    last_minute = -1
    i = 0
    while i < len(blocks):
        start, end, text = blocks[i]
        cur_min = int(to_seconds(start) // 60)
        if cur_min // 2 != last_minute // 2:
            # Print a 2-minute timestamp marker
            out_lines.append(f"\n**[{fmt_mmss(start)}]**\n")
            last_minute = cur_min

        if flagged[i]:
            # Walk to end of run
            run_start = start
            j = i
            while j < len(blocks) and flagged[j]:
                j += 1
            run_end = blocks[j - 1][1]
            run_text = " | ".join(b[2] for b in blocks[i:j])
            # Get dominant phrase
            cjk = re.findall(r"[一-鿿]{2,4}", run_text)
            dominant = ""
            if cjk:
                dominant = Counter(cjk).most_common(1)[0][0]
            sample = blocks[i][2][:30]
            out_lines.append(
                f"> ⚠️ `[{fmt_mmss(run_start)}–{fmt_mmss(run_end)}]` "
                f"Whisper 幻觉循环（{j - i} 段，主导词 \"{dominant}\"），样本：「{sample}…」"
            )
            i = j
        else:
            out_lines.append(text)
            i += 1

    Path(out_path).write_text("\n".join(out_lines) + "\n", encoding="utf-8")
    print(f"wrote {out_path} · kept {sum(1 for f in flagged if not f)}/{len(blocks)} segments · "
          f"collapsed {flagged_n} hallucinated")


if __name__ == "__main__":
    main()

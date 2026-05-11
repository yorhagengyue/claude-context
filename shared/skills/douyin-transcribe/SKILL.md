# douyin-transcribe

将抖音视频（或任意本地音视频文件）转录为文本。后端 **mlx-whisper**（Apple Silicon GPU/ANE 原生），M 系列 Mac 上比 faster-whisper CPU 快 5-10x。可选自动折叠 Whisper 幻觉循环。

## Claude 解释模式（主要用法）

当用户给你一个抖音链接并要求解释视频内容时，执行以下流程：

**Step 1：转录**

> **前提**：`python3` 必须已在 PATH 中（由 `setup.sh` 通过 pyenv 保证）。

```bash
# macOS — Apple Silicon 才能跑 mlx-whisper
SKILL_DIR="$(cd "$(git rev-parse --show-toplevel 2>/dev/null || echo ~/Desktop/claude-context)/shared/skills/douyin-transcribe" && pwd)"
cd "$SKILL_DIR"

# 自动建 venv + 安装依赖（首次 ~2 分钟，主要是装 torch / mlx）
if [ ! -d .venv ]; then
    echo "首次运行：创建 venv 并安装依赖..."
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
else
    source .venv/bin/activate
fi

python scripts/transcribe_douyin.py "<链接>" -o transcript_tmp.txt
# 首次运行会下载 mlx-community/whisper-small-mlx 模型（约 500 MB）
```

**Step 2：读取转录文本**

读取 `transcript_tmp.txt` 的内容。

**Step 3：用大白话解释**

像朋友聊天一样说这个视频讲了啥。两三句话讲完核心内容，别超过一段。

不要：
- 不要列 bullet points
- 不要加"我的判断"、"值得注意的是"这种 AI 套话
- 不要逐段拆解，说重点就行
- 不要重复转录原文，用自己的话概括

如果 Whisper 识别有明显错误（比如术语识别错），在最后简单提一句就行。

## 长录音模式（会议 / 课程 / mentor 答疑）

录音越长，Whisper 在静音/低音量段堆出 hallucination loop 的概率越高（典型如 "Thank you" × 28 段）。**长录音必须加 `--clean`**：

```bash
python scripts/transcribe_douyin.py "/path/to/recording.m4a" -o /tmp/rec.txt --srt --clean
# 输出三件套：
#   /tmp/rec.txt          原始转录
#   /tmp/rec.srt          带时间戳字幕
#   /tmp/rec.cleaned.md   折叠幻觉循环后的 markdown（每 2 min 时间戳锚点 + ⚠️ 标记被折叠的循环段）
```

`clean_transcript.py` 脚本独立可用：

```bash
python scripts/clean_transcript.py input.srt output.md "Title 标题"
```

判据（保守，会漏不会错杀）：
1. **3+ 段连续完全相同**（任意语种 — 抓 "Thank you" / "OK" 这类英文 loop）
2. **CJK 2-char ngram >= 30% 占比** 跨连续段落（抓 "我认识 我认识..." 这类中文 loop）
3. **单段内 2-6 字短串重复 >= 3 次且占比 > 50%**（抓 "画面的画面的画面" 这种段内自循环）

## 用法

```bash
# 抖音链接
python scripts/transcribe_douyin.py "https://v.douyin.com/xxxxxxx/"

# 本地音视频
python scripts/transcribe_douyin.py recording.m4a

# 同时输出 SRT 字幕
python scripts/transcribe_douyin.py recording.m4a --srt

# 长录音 + 自动折叠幻觉
python scripts/transcribe_douyin.py recording.m4a --clean

# 指定输出路径
python scripts/transcribe_douyin.py recording.m4a -o result.txt

# 大模型（更准但慢；M 系列上 large-v3 仍然舒服跑得动）
python scripts/transcribe_douyin.py recording.m4a --model mlx-community/whisper-large-v3-mlx

# 强制中文（默认自动检测；除非确知单一语种否则不要设——TP7/TP8 历史经验：强制 zh 会让英文段错转）
python scripts/transcribe_douyin.py recording.m4a --language zh

# 受限视频需要浏览器 cookies
python scripts/transcribe_douyin.py "https://v.douyin.com/xxxxxxx/" --cookies-from-browser chrome
```

## 参数

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `--model` | `mlx-community/whisper-small-mlx` | HF 模型仓库名（mlx-community/whisper-{tiny,base,small,medium,large-v3}-mlx） |
| `--language` | `None`（自动检测） | 强制语种代码（zh / en / ja…）。除非确知单一语种否则别设 |
| `--condition-on-previous-text` | `False` | 关闭以避免幻觉级联。改 `True` 上下文连贯性更好但风险高 |
| `--hallucination-silence-threshold` | `1.5` | 静音段（秒）阈值，超过则跳过 |
| `--srt` | 否 | 同时输出 .srt 字幕文件 |
| `--clean` | 否 | 跑完后调用 clean_transcript.py 折叠幻觉，输出 *.cleaned.md |
| `--cookies-from-browser` | 无 | 浏览器 cookies，如 `chrome` 或 `edge` |
| `-o` / `--output` | 自动命名 | 输出 txt 路径 |

## 依赖

- `mlx-whisper>=0.4.0` — Apple Silicon 原生 Whisper 推理
- `yt-dlp>=2025.1.0` — 视频下载/流解析

首次调用时上面的"自动建 venv"块会装好，无需手动。

## 性能基线（2026-05-11 实测）

- 机器：Apple M4，small 模型
- 51 min 中英混合 m4a：mlx-whisper **1:37 推理**（首次跑额外 2:34 下模型）
- 同任务 faster-whisper CPU + int8：~25-30 min
- **加速比 ~15-20x**

## 已知 Whisper 通病（与 backend 无关）

- 静音/低音量段会强行造句，输出短语循环（"Thank you" × 28、"我认识" × 45 等）。`--clean` 是必备
- 双语切换段落是失败重灾区，`--language` 强制锁单一语种会让另一语种段被强转。**默认让它自动检测**
- `feature_extractor` 报 `RuntimeWarning: divide by zero / overflow / invalid value in matmul` 时通常对应输出会出现幻觉

## 平台说明

- **macOS Apple Silicon**：本 skill 的目标平台
- **macOS Intel / Linux x86 / Windows**：mlx-whisper 不支持。如需在这些平台跑，把 backend 换回 faster-whisper（git 历史里有），或用 whisper.cpp / openai-whisper

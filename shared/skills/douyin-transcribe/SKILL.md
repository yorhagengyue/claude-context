# douyin-transcribe

将抖音视频（或本地视频文件）转录为文本，并由 Claude 用大白话解释内容。使用 faster-whisper 本地推理，不依赖外部 API。

## Claude 解释模式（主要用法）

当用户给你一个抖音链接并要求解释视频内容时，执行以下流程：

**Step 1：转录**

> **前提**：`python3` 必须已在 PATH 中（由 `setup.sh` 通过 pyenv 保证）。

```bash
# macOS/Linux
SKILL_DIR="$(cd "$(git rev-parse --show-toplevel 2>/dev/null || echo ~/Desktop/claude-context)/shared/skills/douyin-transcribe" && pwd)"
cd "$SKILL_DIR"

# 自动建 venv + 安装依赖（首次约需 1 分钟）
if [ ! -d .venv ]; then
    echo "首次运行：创建 venv 并安装依赖..."
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
else
    source .venv/bin/activate
fi

# Windows (PowerShell) — 手动执行等价步骤：
# cd "$env:USERPROFILE\Desktop\claude-context\shared\skills\douyin-transcribe"
# if (-not (Test-Path .venv)) { python -m venv .venv; .venv\Scripts\Activate.ps1; pip install -r requirements.txt } else { .venv\Scripts\Activate.ps1 }

python scripts/transcribe_douyin.py "<链接>" -o transcript_tmp.txt
# 注意：首次运行会自动下载 Whisper small 模型（约 500MB），请耐心等待
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

## 用法

```bash
# 抖音链接
python scripts/transcribe_douyin.py "https://v.douyin.com/xxxxxxx/"

# 本地文件
python scripts/transcribe_douyin.py video.mp4

# 同时输出 SRT 字幕
python scripts/transcribe_douyin.py "https://v.douyin.com/xxxxxxx/" --srt

# 指定输出路径
python scripts/transcribe_douyin.py "https://v.douyin.com/xxxxxxx/" -o result.txt

# 更大模型（更准）
python scripts/transcribe_douyin.py "https://v.douyin.com/xxxxxxx/" --model medium

# 受限视频需要浏览器 cookies
python scripts/transcribe_douyin.py "https://v.douyin.com/xxxxxxx/" --cookies-from-browser edge

# GPU 加速
python scripts/transcribe_douyin.py "https://v.douyin.com/xxxxxxx/" --device cuda --compute-type float16
```

## 参数

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `--model` | `small` | Whisper 模型：tiny/base/small/medium/large-v3 |
| `--device` | `cpu` | 运行设备：cpu 或 cuda |
| `--compute-type` | `int8` | CPU 推荐 int8，GPU 可用 float16 |
| `--srt` | 否 | 同时输出 .srt 字幕文件 |
| `--cookies-from-browser` | 无 | 浏览器 cookies，如 `edge` 或 `chrome` |
| `-o` / `--output` | 自动命名 | 输出 txt 路径 |

## 依赖（无需手动安装）

首次调用时 Step 1 会自动创建 venv 并安装依赖，无需手动操作。

前提：`python3` 已在 PATH（由 `machines/*/setup.sh` 通过 pyenv 保证）。

## 依赖包

- `faster-whisper==1.1.1` — 本地 Whisper 推理
- `yt-dlp>=2025.1.0` — 视频下载/流解析

## 说明

- 语言固定为中文（`language=zh`）
- 视频链接不落地保存，直接流式转写
- 抖音链接会自动跟随重定向解析真实流地址
- 首次运行会自动下载 Whisper 模型（small 约 500MB）

import argparse
import datetime as dt
import re
from pathlib import Path
from typing import List, Tuple
from urllib.parse import urlparse

import requests
from faster_whisper import WhisperModel


class QuietYDLLogger:
    def debug(self, msg):
        return

    def warning(self, msg):
        return

    def error(self, msg):
        return


def format_timestamp(seconds: float) -> str:
    ms_total = int(round(seconds * 1000))
    hours = ms_total // 3_600_000
    ms_total %= 3_600_000
    minutes = ms_total // 60_000
    ms_total %= 60_000
    secs = ms_total // 1000
    millis = ms_total % 1000
    return f"{hours:02d}:{minutes:02d}:{secs:02d},{millis:03d}"


def save_txt(path: Path, lines: List[str]) -> None:
    path.write_text("\n".join(lines).strip() + "\n", encoding="utf-8")


def save_srt(path: Path, segments) -> None:
    rows = []
    for idx, seg in enumerate(segments, start=1):
        rows.append(str(idx))
        rows.append(f"{format_timestamp(seg.start)} --> {format_timestamp(seg.end)}")
        rows.append(seg.text.strip())
        rows.append("")
    path.write_text("\n".join(rows).strip() + "\n", encoding="utf-8")


def is_http_url(value: str) -> bool:
    parsed = urlparse(value)
    return parsed.scheme in {"http", "https"} and bool(parsed.netloc)


def sanitize_filename(value: str) -> str:
    value = re.sub(r'[<>:"/\\|?*]+', "_", value)
    value = re.sub(r"\s+", " ", value).strip(" .")
    return value or "transcript"


def resolve_input_source(
    raw_input: str, cookies_from_browser: str | None
) -> Tuple[str, str, bool]:
    if not is_http_url(raw_input):
        input_path = Path(raw_input).expanduser().resolve()
        if not input_path.exists():
            raise FileNotFoundError(f"找不到输入文件: {input_path}")
        return str(input_path), input_path.stem, False

    try:
        import yt_dlp
    except ImportError as exc:
        raise RuntimeError(
            "URL 转写需要安装 yt-dlp，请先执行: pip install yt-dlp"
        ) from exc

    ydl_opts = {
        "quiet": True,
        "no_warnings": True,
        "logger": QuietYDLLogger(),
        "skip_download": True,
        "format": "bestaudio/best",
        "noplaylist": True,
    }
    if cookies_from_browser:
        browser_spec = parse_browser_cookie_spec(cookies_from_browser)
        ydl_opts["cookiesfrombrowser"] = browser_spec

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(raw_input, download=False)
    except Exception:
        fallback = try_resolve_douyin_playwm(raw_input)
        if fallback:
            return fallback, "douyin_video", True
        raise

    if info.get("entries"):
        info = info["entries"][0]

    stream_url = info.get("url")
    if not stream_url:
        requested_formats = info.get("requested_formats") or []
        for item in requested_formats:
            if item.get("url"):
                stream_url = item["url"]
                break
    if not stream_url:
        formats = info.get("formats") or []
        for item in reversed(formats):
            if item.get("url"):
                stream_url = item["url"]
                break
    if not stream_url:
        raise RuntimeError("无法解析该链接的可用音视频流。")

    title = sanitize_filename(info.get("title") or "douyin_video")
    return stream_url, title, True


def try_resolve_douyin_playwm(raw_url: str) -> str | None:
    parsed = urlparse(raw_url)
    host = (parsed.netloc or "").lower()
    if not any(k in host for k in ["douyin.com", "iesdouyin.com"]):
        return None

    headers = {
        "User-Agent": (
            "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) "
            "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 "
            "Mobile/15E148 Safari/604.1"
        )
    }
    try:
        resp = requests.get(raw_url, headers=headers, allow_redirects=True, timeout=20)
        pages = [resp.text]
        final_url = resp.url
    except Exception:
        return None

    # If we can read item id from redirected URL, request the SSR share page explicitly.
    item_id_match = re.search(r"/video/(\d+)", final_url)
    if item_id_match:
        item_id = item_id_match.group(1)
        share_url = f"https://www.iesdouyin.com/share/video/{item_id}/?from_ssr=1&region=SG"
        try:
            share_resp = requests.get(share_url, headers=headers, allow_redirects=True, timeout=20)
            pages.append(share_resp.text)
        except Exception:
            pass

    patterns = [
        r'https://aweme\.snssdk\.com/aweme/v1/playwm/[^"\']+',
        r'https://aweme\.snssdk\.com/aweme/v1/playwm/[^"\']+',
    ]
    for text in pages:
        text = text.replace("\\u002F", "/").replace("\\/", "/")
        for pat in patterns:
            m = re.search(pat, text)
            if m:
                playwm_url = m.group(0)
                direct_url = resolve_redirect_media_url(playwm_url)
                return direct_url or playwm_url
    return None


def resolve_redirect_media_url(url: str) -> str | None:
    headers = {
        "User-Agent": "Mozilla/5.0",
        "Referer": "https://www.iesdouyin.com/",
    }
    try:
        r = requests.get(url, headers=headers, allow_redirects=True, timeout=20, stream=True)
    except Exception:
        return None
    content_type = (r.headers.get("content-type") or "").lower()
    if "video" in content_type and r.url:
        return r.url
    return None


def parse_browser_cookie_spec(spec: str):
    # Expected shape:
    #   browser
    #   browser:profile
    #   browser+keyring
    #   browser+keyring:profile
    browser_part, profile = (spec.split(":", 1) + [None])[:2]
    if "+" in browser_part:
        browser, keyring = browser_part.split("+", 1)
    else:
        browser, keyring = browser_part, None
    browser = browser.strip()
    profile = profile.strip() if profile else None
    keyring = keyring.strip() if keyring else None
    return (browser, profile, keyring, None)


def build_output_path(args: argparse.Namespace, name_hint: str, is_url: bool) -> Path:
    if args.output:
        return Path(args.output).expanduser().resolve()
    if not is_url:
        return Path(args.input).expanduser().resolve().with_suffix(".txt")
    stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    return Path.cwd() / f"{sanitize_filename(name_hint)}_{stamp}.txt"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="简单中文视频转文本工具（支持本地文件/链接）")
    parser.add_argument("input", help="输入本地视频路径或视频链接（如抖音分享链接）")
    parser.add_argument("-o", "--output", help="输出 txt 路径，默认自动命名", default=None)
    parser.add_argument(
        "--model",
        help="Whisper 模型：tiny/base/small/medium/large-v3，默认 small",
        default="small",
    )
    parser.add_argument(
        "--device",
        help="运行设备：cpu 或 cuda，默认 cpu",
        default="cpu",
        choices=["cpu", "cuda"],
    )
    parser.add_argument(
        "--compute-type",
        help="计算类型，CPU 推荐 int8，GPU 可用 float16/int8_float16",
        default="int8",
    )
    parser.add_argument("--srt", help="同时输出字幕 srt 文件", action="store_true")
    parser.add_argument(
        "--cookies-from-browser",
        default=None,
        help="某些受限链接需要浏览器 cookies（可选），如 chrome 或 chrome+basictext",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    source, name_hint, is_url = resolve_input_source(args.input, args.cookies_from_browser)
    txt_path = build_output_path(args, name_hint, is_url)

    print("[1/3] 加载模型中...")
    model = WhisperModel(args.model, device=args.device, compute_type=args.compute_type)

    if is_url:
        print("[2/3] 链接转写中（不落地保存视频）...")
    else:
        print("[2/3] 本地文件转写中...")

    segments, info = model.transcribe(
        source,
        language="zh",
        vad_filter=True,
        beam_size=5,
        condition_on_previous_text=True,
    )
    segments = list(segments)

    txt_lines = [seg.text.strip() for seg in segments if seg.text.strip()]
    save_txt(txt_path, txt_lines)

    print(f"[3/3] 完成。文本已保存: {txt_path}")
    print(f"检测语言: {info.language}，概率: {info.language_probability:.3f}")

    if args.srt:
        srt_path = txt_path.with_suffix(".srt")
        save_srt(srt_path, segments)
        print(f"字幕已保存: {srt_path}")


if __name__ == "__main__":
    main()

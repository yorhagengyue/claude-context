# Windows 机器笔记（yorha / win11 / RTX 5080）

> **状态**：从 2026-05-18 起，**改为 AI 视频本地工作站**（之前是"不使用"）  
> **旧状态**：[archive/windows-todo-retired-20260804.md](../../archive/windows-todo-retired-20260804.md)（2026-08-04 归档）  
> **关联**：[shared/projects/ai-video/AI_VIDEO.md](../../shared/projects/ai-video/AI_VIDEO.md)

---

## 硬件

| 项 | 配置 |
|---|---|
| GPU | NVIDIA RTX 5080 16GB (Blackwell sm_120, CUDA 13.2 driver, PyTorch 2.11+cu128) |
| CPU | AMD Ryzen 7 9800X3D 8C/16T @ 4.7GHz |
| RAM | 47.2 GB |
| 磁盘 | C: 76GB free / 300GB；**D: 738GB free / 1.56TB**（AI 全放 D 盘）|
| OS | Windows 11 Pro |

---

## 关键路径

| 用途 | 路径 |
|---|---|
| AI 工作根目录 | `D:\ai\` — 见该目录 `README.md` |
| Conda | `D:\tools\miniforge3\` — env `comfy` (Python 3.12) |
| ComfyUI | `D:\ai\ComfyUI\` (服务在 http://127.0.0.1:8188) |
| 模型 | `D:\ai\ComfyUI\models\{diffusion_models,unet,vae,text_encoders}\` |
| HF cache | `D:\ai\hf-cache\` (HF_HOME 已写 User env) |
| 实验产物 | `D:\ai\experiments\<timestamp>_<source>\` |
| 本地密钥 | `D:\ai\.env`（**永不入 git**，机器特有） |
| 第三方 SDK | `D:\tools\pippit-skills-inspect\`（小云雀官方 Skill 包检视用）|
| 本仓库 clone | `C:\Users\gengy\Desktop\claude-context\`（即本文件所在仓库；2026-08-04 更正：旧记录 `D:\repos\claude-context\` 已不存在） |
| 项目 repos | 各 repo 平铺在 `C:\Users\gengy\Desktop\` 根（claude-context / ripple-core / ripple-ios / yorha-a2-team / aitv-hollow-knight + ripple-site〔在 toffemoon 账号下〕，2026-08-04 补齐） |
| Agent 入口 | `C:\Users\gengy\Desktop\AGENTS.md` — 指向 `shared/CLAUDE.md` 宪法（Kimi Code CLI 等读 AGENTS.md 的 agent 用，2026-08-04 建） |

---

## 已装

- ✅ git（HTTPS + 已存凭据，私有 repo 可 pull/clone，2026-08-04 实测）；⚠️ gh CLI 2026-08-04 在本机已找不到（PATH/where 均无），与 2026-07-15「已 auth」记录不符，需用 gh 时先重装
- ✅ Python 3.13（系统默认） + miniforge3（env `comfy` = Python 3.12）
- ✅ PyTorch 2.11.0+cu128 (Blackwell support)
- ✅ ComfyUI 0.21.1 + 3 个 custom_nodes (Manager / WanVideoWrapper / GGUF)
- ✅ Wan 2.2 TI2V-5B fp16 (9.3GB)
- ✅ Wan 2.2 T2V-A14B GGUF Q4_K_M 双专家 (8.99GB × 2)
- ✅ Wan 2.1 VAE + Wan 2.2 VAE + umt5_xxl 文本编码器
- ✅ fal-client SDK
- ❌ 未装：conda（已被 miniforge 替代）/ docker / Flux / PuLID / CosyVoice / LatentSync

---

## 启动 ComfyUI

```powershell
Start-Process -FilePath "D:\tools\miniforge3\Scripts\conda.exe" `
  -ArgumentList "run","-n","comfy","--no-capture-output", `
                "--cwd","D:\ai\ComfyUI","python","main.py", `
                "--listen","127.0.0.1","--port","8188" `
  -RedirectStandardOutput "D:\ai\ComfyUI\server.log" `
  -RedirectStandardError "D:\ai\ComfyUI\server.err.log" `
  -WindowStyle Hidden
```

浏览器 http://127.0.0.1:8188 直接拖节点。

---

## 已知本机问题

- **C 盘空间紧**（76GB free）— 所有模型/cache/实验放 D 盘已规避
- **网络**（2026-08-04 owner 确认）— 机器在中国、VPN 质量差：github.com 单次连接约半数 21s 超时、重试可过；git 操作建议一律带重试循环，大 clone 别指望一次过
- **Blackwell 新架构** — sageattention / triton-windows 需要等社区跟上，目前用默认 attention，Wan 速度有 1.5-2× 的提升空间
- **Python 3.13 不兼容大多数 ML 包** — 用 conda env `comfy` (3.12) 绕开
- **HF xet 下载在该机疑似静默卡死** — 已绕过：用 curl 直接下 HF resolve URL
- ~~gh CLI 未 auth~~ — 2026-07-15 已 auth 为 yorhagengyue（keyring），此条作废

---

## 不在本机做的事

- Wan 14B Video LoRA 训练（24GB+ 才行，去租 H100）
- 720p+ 高分辨率视频生成（5080 16GB 临界）
- 长视频生成 SkyReels V2 14B（要 H100 80GB；1.3B 可在 5080 跑）

# Mac Mini — 机器特有上下文

> **机器名**：gengyuedemac-mini-3
> **用途**：主力开发机
> **最后更新**：2026-04-13

---

## 环境信息

- **OS**：macOS Darwin 24.6.0, Apple Silicon arm64
- **主机名**：gengyuedemac-mini-3
- **用户名**：gengyue
- **项目目录**：~/Desktop/ (主力)
- **Claude 使用方式**：Claude Code CLI
- **Node.js**：fnm 管理, v22.22.0 (default) + v24.14.0 (lts)
- **Python**：3.12.12 (via .local/bin)
- **PostgreSQL**：16 (via brew)
- **主力浏览器**：OpenAI Atlas (Chrome 内核)

## 已安装的工具

### AI 工具
| 工具 | 路径/说明 |
|------|-----------|
| Claude Code CLI | 系统全局 |
| OpenAI Codex | @openai/codex@0.114.0 (npm global) |
| ChatGPT Atlas | /Applications/ |
| Hermes Agent | ~/.hermes/ |
| Ollama | 本地 LLM |

### 开发工具
| 工具 | 说明 |
|------|------|
| Cursor | 主力 IDE |
| VS Code | 辅助 (translocated) |
| iTerm2 + Tmux | 终端 |
| Fish shell | 默认 shell |
| Docker | 已安装，按需启动 |
| ripgrep | 搜索 |
| FFmpeg | 多媒体 |

### Brew 关键包
ffmpeg, gh, googleworkspace-cli, node, openssl, postgresql@16, ripgrep, tailscale, tmux, displayplacer, simdjson

## 已安装的 Skills

- memory.skill — 会话结束时自动持久化记忆到 §8
- douyin-transcribe — 抖音视频转录 (faster-whisper)

## 已连接的 MCP

- @modelcontextprotocol/server-github (npm global)

## Google Workspace 配置

| 文件 | 路径 | 说明 |
|------|------|------|
| OAuth token | ~/.hermes/google_token.json | 含 token, refresh_token, client_id, client_secret, scopes |
| Client secret | ~/.hermes/google_client_secret.json | GCP OAuth 客户端凭据 |
| GWS timezone | ~/.config/gws/account_timezone | Asia/Singapore |
| GWS cache | ~/.config/gws/cache/ | API 缓存 |
| API script | ~/.hermes/skills/productivity/google-workspace/scripts/google_api.py | gws_bridge 封装 |
| Setup script | ~/.hermes/skills/productivity/google-workspace/scripts/setup.py | OAuth 认证流程 |

**已认证的 Google 服务**：Gmail ✅, Calendar ✅, Contacts ✅, Sheets ✅, Docs ✅
**未启用**：Google Drive (用户不使用)

**OAuth Scopes**：
- gmail.modify, gmail.send
- calendar, calendar.events
- contacts.readonly
- spreadsheets, documents
- drive (未启用)

**恢复步骤** (新机器/token 过期时):
1. 从 GCP Console 下载 client_secret.json → ~/.hermes/google_client_secret.json
2. 运行: `python ~/.hermes/skills/productivity/google-workspace/scripts/setup.py --client-secret ~/.hermes/google_client_secret.json`
3. 浏览器完成 OAuth 授权
4. 运行: `python ~/.hermes/skills/productivity/google-workspace/scripts/setup.py --auth-code <CODE>`
5. 验证: `python ~/.hermes/skills/productivity/google-workspace/scripts/setup.py --check`

## Hermes 集成

| 配置 | 状态 |
|------|------|
| ~/.hermes/.env OBSIDIAN_VAULT_PATH | ✅ |
| Obsidian Vault | ~/Documents/Obsidian Vault/ |
| Obsidian CLI | /usr/local/bin/obsidian (Mach-O universal) |
| WhatsApp | ~/.hermes/whatsapp/ (已配置) |
| Cron Jobs | ~/.hermes/cron/ (已配置) |

### Hermes Scripts
| 脚本 | 路径 | 说明 |
|------|------|------|
| AI Daily Digest 采集 | ~/.hermes/scripts/ai-daily-collect.py | 每日 08:00 cron, HN/RSS/ArXiv/GH trending |
| 抖音/视频转录 | ~/.hermes/scripts/transcribe.py | faster-whisper, 带时间戳+Speaker |
| 转录 venv | ~/.hermes/scripts/douyin-venv/ | Python 3.12, faster-whisper+yt-dlp+requests |

### Hermes Cron Jobs
Cron Jobs 是 Hermes 实例级别的，不跨机器同步。新机器需要时在本地重新创建。
| Job ID | 名称 | 时间 | 说明 |
|--------|------|------|------|
| 9bb0519ba199 | AI Daily Report | 每天 08:00 | 采集→LLM分析→Obsidian 06-Auto/AI Digest/ |
| 3ad3c3a675c9 | Daily Journal Review | 每天 05:00 | 读前一天日记+GitHub→AI栏追加日终回顾 |

## Tailscale 网络

| IP | 设备 | 系统 |
|----|------|------|
| 100.73.91.25 | gengyuedemac-mini-3 (本机) | macOS |
| 100.113.76.104 | node | Windows |
| 100.120.200.72 | yorha | Windows |

## SSH 配置

- ~/.ssh/config: KeepAlive, ControlMaster 多路复用, 压缩
- 无本地密钥文件 (使用 GitHub PAT / OAuth)

## 备注

- Clash Verge 代理工具在使用
- Docker 已安装但通常不运行
- Xcode 已安装

# MacBook — 机器特有上下文

> **机器名**：macbook (hostname: Geng-YuedeMacBook-Air)
> **用户名**：yorha (不是 gengyue)
> **Tailscale IP**：100.108.243.32
> **SSH**：`ssh yorha@100.108.243.32` (已配置 Mac Mini 免密登录)
> **用途**：便携开发机
> **最后更新**：2026-04-14

---

## 环境信息

- **OS**：macOS (Apple Silicon)
- **项目目录**：~/Projects/
- **Claude 使用方式**：Claude Code CLI

## 需要配置的完整清单

运行 `machines/macbook/setup.sh` 后，对照此清单逐项检查。**全部通过才算配置完成。**

### 基础工具
| # | 组件 | 检查命令 | 缺失时操作 |
|---|------|---------|-----------|
| 1 | Homebrew | `which brew` | `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` |
| 2 | Git | `which git` | `brew install git` |
| 3 | Node.js | `which node` | `brew install fnm && fnm install --lts` |
| 4 | Python 3 | `which python3` | `brew install python` |
| 5 | Codex | `which codex` | `npm install -g @openai/codex` |
| 6 | Claude Code CLI | `which claude` | `npm install -g @anthropic-ai/claude-code` |

### Claude Harness
| # | 组件 | 检查命令 | 缺失时操作 |
|---|------|---------|-----------|
| 7 | 仓库 clone | `ls ~/Desktop/claude-context/SETUP.md` | `git clone https://github.com/yorhagengyue/claude-context.git ~/Desktop/claude-context` |
| 8 | CLAUDE.md symlink | `ls ~/Desktop/CLAUDE.md` | `ln -sf ~/Desktop/claude-context/shared/CLAUDE.md ~/Desktop/CLAUDE.md` |
| 9 | settings.json symlink | `ls ~/.claude/settings.json` | `ln -sf ~/Desktop/claude-context/shared/cowork/settings.json ~/.claude/settings.json` |

### Obsidian 外置大脑
| # | 组件 | 检查命令 | 缺失时操作 |
|---|------|---------|-----------|
| 10 | Obsidian | `ls /Applications/Obsidian.app` | `brew install --cask obsidian` |
| 11 | Obsidian Vault | `ls ~/Documents/Obsidian\ Vault/HOME.md` | 从 Mac Mini 同步 (见下方) |
| 12 | Obsidian CLI | `which obsidian` | 打开 Obsidian → Settings → Community Plugins → CLI |
| 13 | 核心目录完整 | 检查 00-06 + Templates | 从 Mac Mini 同步 |
| 14 | 社区插件 | `obsidian plugins:enabled` | 见下方插件清单 |

### Hermes Agent
| # | 组件 | 检查命令 | 缺失时操作 |
|---|------|---------|-----------|
| 15 | Hermes | `ls ~/.hermes/` | 参考 Hermes 文档安装 |
| 16 | OBSIDIAN_VAULT_PATH | `grep OBSIDIAN ~/.hermes/.env` | `echo 'OBSIDIAN_VAULT_PATH=~/Documents/Obsidian Vault' >> ~/.hermes/.env` |
| 17 | AI Daily Digest 脚本 | `ls ~/.hermes/scripts/ai-daily-collect.py` | 从 Mac Mini 复制 `~/.hermes/scripts/ai-daily-collect.py` |
| 18 | 转录脚本 | `ls ~/.hermes/scripts/transcribe.py` | 从 Mac Mini 复制 `~/.hermes/scripts/transcribe.py` |
| 19 | 转录 venv | `ls ~/.hermes/scripts/douyin-venv/` | `python3 -m venv ~/.hermes/scripts/douyin-venv && source ~/.hermes/scripts/douyin-venv/bin/activate && pip install faster-whisper yt-dlp requests` |

### Google Workspace
| # | 组件 | 检查命令 | 缺失时操作 |
|---|------|---------|-----------|
| 20 | client_secret.json | `ls ~/.hermes/google_client_secret.json` | 从 Mac Mini 复制 |
| 21 | OAuth token | `ls ~/.hermes/google_token.json` | 见下方 OAuth 恢复步骤 |
| 22 | GWS timezone | `cat ~/.config/gws/account_timezone` | `mkdir -p ~/.config/gws && echo 'Asia/Singapore' > ~/.config/gws/account_timezone` |

### 网络
| # | 组件 | 检查命令 | 缺失时操作 |
|---|------|---------|-----------|
| 23 | Tailscale | `tailscale status` | `brew install tailscale` |

---

## Obsidian Vault 同步

Mac Mini 是 Vault 的 **source of truth**。同步方式（选一个）：
```bash
# rsync (推荐，最快)
rsync -av --delete mac-mini:~/Documents/Obsidian\ Vault/ ~/Documents/Obsidian\ Vault/

# 或 AirDrop / USB 手动拷贝
```

同步后检查：
```bash
ls ~/Documents/Obsidian\ Vault/HOME.md           # 入口文件
ls ~/Documents/Obsidian\ Vault/05\ -\ Journal/   # 日记系统
ls ~/Documents/Obsidian\ Vault/06\ -\ Auto/      # Hermes 自动写入
```

## Obsidian 社区插件

以下插件**必须安装**（Mac Mini 已装好，Vault 同步后配置会自动带过来，但插件本身需要重新安装）：

```bash
obsidian plugin:install id=periodic-notes enable    # 日记自动路由 (替代核心 daily-notes)
obsidian plugin:install id=calendar enable           # 侧边栏日历导航
obsidian plugin:install id=dataview enable           # 笔记数据查询聚合 (Mood Dashboard 依赖)
obsidian plugin:install id=templater-obsidian enable # 动态模板引擎
obsidian plugin:disable id=daily-notes              # 禁用核心 daily-notes (被 Periodic Notes 替代)
```

安装后验证：
```bash
obsidian plugins:enabled | grep -E "periodic|calendar|dataview|templater"
```

## Hermes Scripts 同步

从 Mac Mini 复制这些文件：
```bash
# AI Daily Digest 采集脚本
scp mac-mini:~/.hermes/scripts/ai-daily-collect.py ~/.hermes/scripts/

# 抖音/视频转录脚本
scp mac-mini:~/.hermes/scripts/transcribe.py ~/.hermes/scripts/

# 转录 venv (太大不适合 scp，在本地重建)
python3 -m venv ~/.hermes/scripts/douyin-venv
source ~/.hermes/scripts/douyin-venv/bin/activate
pip install faster-whisper==1.1.1 yt-dlp requests
```

## Hermes Cron Jobs

MacBook 上 Hermes Cron 只有自己的设备日志，不重复 Mac Mini 的任务。
| Job ID | 名称 | 时间 | 说明 |
|--------|------|------|------|
| mb_worklog_001 | MacBook Air Work Log | 每天 06:00 | 💻 查 Codex/Claude Code/Hermes 三个工具的会话记录 + GitHub → 追加日记 AI 栏 |

采集脚本：`~/.hermes/scripts/macbook-daily-collect.py`
查询三个来源：
- Codex: `~/.codex/state_5.sqlite` threads 表
- Claude Code: `~/.claude/projects/<path>/*.jsonl` 文件修改时间
- Hermes: `~/.hermes/state.db` sessions 表

Mac Mini 的 cron (Daily Journal Review / AI Daily Report / Mac Mini Work Log) 不在 MacBook 上运行。

## Google OAuth 恢复步骤

和 Mac Mini 共用同一个 GCP project (ID: 733441049399)，但 token 是机器绑定的：

```bash
# 1. 从 Mac Mini 复制 client secret
scp mac-mini:~/.hermes/google_client_secret.json ~/.hermes/

# 2. 运行 OAuth 流程
python ~/.hermes/skills/productivity/google-workspace/scripts/setup.py \
  --client-secret ~/.hermes/google_client_secret.json

# 3. 浏览器完成授权，拿到 auth code

# 4. 完成认证
python ~/.hermes/skills/productivity/google-workspace/scripts/setup.py \
  --auth-code <CODE>

# 5. 验证
python ~/.hermes/skills/productivity/google-workspace/scripts/setup.py --check
```

## 日记系统

日记路径：`05 - Journal/YYYY/MM/W<ISO周号>/YYYY-MM-DD.md`
周号计算：`python3 -c "from datetime import date; print(f'W{date.today().isocalendar()[1]:02d}')"`
例：2026-04-14 → `05 - Journal/2026/04/W16/2026-04-14.md`

日记模板 5 栏：Health (睡眠/饮水/饮食/运动/体重) / Mood (情绪+能量 1-10) / Log / AI / Misc

- frontmatter 必须有 `mood` 和 `energy` 数字字段 (Dataview Mood Dashboard 依赖)
- AI 栏每条带时间戳 `[HH:MM]`
- Hermes 自动写入只到 `06 - Auto/`
- 所有 AI 写入的内容带 `source: hermes` frontmatter

## 备注

- 便携机，可能不会常驻 Hermes/Docker
- 项目目录在 ~/Projects/ 而非 ~/Desktop/ (和 Mac Mini 不同)

# claude-context

Cross-machine context harness for Gengyue (耿越).

Single source of truth for: AI agent memory, project context, skills, machine setup, and the three-layer memory system.

## Quick Start (新机器)

```bash
# 1. Clone
git clone https://github.com/yorhagengyue/claude-context.git ~/Desktop/claude-context

# 2. 运行你的机器初始化脚本
cd ~/Desktop/claude-context
chmod +x machines/<machine-name>/setup.sh
./machines/<machine-name>/setup.sh

# 3. 按 setup.sh 输出补全缺失的配置
```

可用机器名：`mac-mini` (主力), `macbook`

## 两层记忆体系

> 2026-07-25 起由三层降为两层：owner 定「Hermes 的记忆文件不需要了，让他去用 Claude 的记忆」，
> 原 `shared/HERMES.md` 已归档到 `archive/hermes-memory-export-retired-20260725.md`，
> **Hermes 改读本仓 `shared/CLAUDE.md`**。详见 CLAUDE.md §0.7 + §8 [2026-07-25]。

```
CLAUDE.md（本仓 shared/）      ← 轻量指针、偏好、决策摘要
         ↓ 指向
Obsidian Vault (Vault/)       ← 重内容（项目笔记、framework 详细库、
                                 时间线、知识沉淀）
  默认路径: ~/Documents/Obsidian Vault/
  跨机器约定: 文档内引用用 `Vault/` 占位
              实际路径见 CLAUDE.md §0.7
```

| 层 | 存储 | 管理者 |
|----|------|--------|
| CLAUDE.md §8 + sub-MD | 本仓库 shared/ | Claude Code（Hermes 亦读此层） |
| Obsidian Vault | `Vault/`（默认 `~/Documents/Obsidian Vault/`） | 用户 + Hermes (自动写入 `06 - Auto/`) |

## 新机器需要配置的完整清单

| # | 组件 | 检查方式 | 恢复步骤 |
|---|------|---------|----------|
| 1 | brew, git, node, python3 | `which brew git node python3` | setup.sh 步骤 1-2 |
| 2 | Claude Code CLI | `which claude` | npm install |
| 3 | OpenAI Codex CLI | `which codex` | npm install -g @openai/codex |
| 4 | Hermes Agent | `ls ~/.hermes/` | 参考 Hermes 文档 |
| 5 | Obsidian | `ls /Applications/Obsidian.app` | `brew install --cask obsidian` |
| 6 | Obsidian CLI | `which obsidian` | Obsidian Settings → CLI |
| 7 | Obsidian Vault | `ls ~/Documents/Obsidian\ Vault/HOME.md` | 从 Mac Mini 同步 |
| 8 | Obsidian 社区插件 | `obsidian plugins:enabled` | periodic-notes, calendar, dataview, templater-obsidian |
| 9 | OBSIDIAN_VAULT_PATH | `grep OBSIDIAN ~/.hermes/.env` | 添加到 ~/.hermes/.env |
| 10 | Google OAuth token | `ls ~/.hermes/google_token.json` | setup.py --client-secret → --auth-code |
| 11 | Google client secret | `ls ~/.hermes/google_client_secret.json` | 从 GCP Console 下载 |
| 12 | GWS timezone | `cat ~/.config/gws/account_timezone` | `echo 'Asia/Singapore' > ...` |
| 13 | Tailscale | `tailscale status` | `brew install tailscale` |
| 14 | AI Daily Digest 脚本 | `ls ~/.hermes/scripts/ai-daily-collect.py` | 从 Mac Mini 复制 |
| 15 | 转录脚本 + venv | `ls ~/.hermes/scripts/transcribe.py` | 从 Mac Mini 复制脚本，本地重建 venv |
| 16 | Claude harness symlinks | `ls ~/Desktop/CLAUDE.md` | setup.sh |

## Repo Structure

```
claude-context/
├── shared/
│   ├── CLAUDE.md          ← 宪法 + 用户上下文 + 记忆 §8
│   │                        (HERMES.md 已于 2026-07-25 退役 → archive/)
│   ├── cowork/            ← Claude Code 设置（Mac setup.sh symlink）
│   ├── skills/            ← 自建 skills (memory, douyin-transcribe)
│   ├── assets/            ← 跨项目复用资产（wellness-rule-library 等 4 个）
│   └── projects/          ← 项目速报（ripple / yorha-a2 / ai-video / moyuan / templateapp / xinlian）
├── machines/
│   ├── mac-mini/          ← setup.sh + local.md
│   ├── macbook/           ← setup.sh + local.md
│   └── windows/           ← AI 视频本地工作站（2026-05-18 起，见 windows/local.md）
└── archive/               ← 归档（naisc-workato / hermes 快照 / windows-todo）
```

## Sync

所有机器在 `main` branch 工作。

```bash
# 写入后 (push 前先 pull)
cd ~/Desktop/claude-context && git pull && git add -A && git commit -m "<type>: <简述>" && git push

# 换机器前
cd ~/Desktop/claude-context && git pull
```

## Key Files

| 文件 | 给谁看 | 说明 |
|------|--------|------|
| shared/CLAUDE.md | Claude | 宪法 §0 + 用户 profile §1-7 + 记忆 §8 |
| ~~shared/HERMES.md~~ | — | **2026-07-25 退役** → `archive/hermes-memory-export-retired-20260725.md`；Hermes 改读 shared/CLAUDE.md |
| machines/*/local.md | Claude | 机器特有配置 (含 Google/Hermes/Obsidian 路径) |
| machines/*/setup.sh | 用户 | 新机器初始化脚本 (8步检查) |
| SETUP.md | Claude | 操作手册 (新增项目/skill/机器的步骤) |

# claude-context

Cross-machine Claude harness for Geng Yue (耿越).

This repo is the single source of truth for Claude's cross-session memory, project context, skills, MCP configs, and machine-specific setup. Multiple machines share this repo on separate branches.

## Quick Start (新机器)

```bash
# 1. Clone
git clone git@github.com:yorhagengyue/claude-context.git ~/Desktop/claude-context

# 2. 切到你的机器 branch（或创建新的）
cd ~/Desktop/claude-context
git checkout <machine-name>  # mac-mini / macbook / windows

# 3. 运行机器初始化脚本
chmod +x machines/<machine-name>/setup.sh
./machines/<machine-name>/setup.sh

# 4. 打开 Claude，说："读一下 SETUP.md，初始化"
```

## Repo Structure

```
claude-context/
├── SETUP.md               ← 宪法（Claude 必读，规则 > 一切）
├── README.md              ← 本文件（给人看）
├── .gitignore
├── shared/                ← 所有机器共用
│   ├── CLAUDE.md          ← 主上下文 hub（用户 profile + 记忆）
│   ├── credentials.md     ← 可公开存储的凭据
│   ├── skills/            ← 自建 skills
│   ├── mcp/               ← MCP 配置
│   └── projects/          ← 项目速报（每个项目一个子目录）
├── machines/              ← 机器特有
│   ├── mac-mini/
│   ├── macbook/
│   └── windows/           ← 占位
└── archive/               ← 记忆归档
```

## Sync

所有机器直接在 `main` branch 上工作，不使用 per-machine branch。

```bash
# 写入记忆后（push 前先 pull）
cd ~/Desktop/claude-context && git pull && git add -A && git commit -m "<type>: <简述>" && git push

# 换机器前
cd ~/Desktop/claude-context && git pull
```

## Adding a New Project

1. `mkdir shared/projects/<name>/`
2. `cp shared/projects/TEMPLATE.md shared/projects/<name>/<NAME>.md`
3. Edit the new file
4. Add a row to `shared/CLAUDE.md` §5
5. Commit + push

## Design Principles

- **Lean context**: CLAUDE.md stores conclusions and pointers, not analysis
- **Debuggable**: Every memory entry has a date and tag; git log has full history
- **Iterable**: Files can be added, format can evolve, no need to start over
- **Human-readable**: All files are markdown
- **No magic**: All behavior is documented in SETUP.md and SKILL.md

# SETUP.md — 操作手册

> **本文件是详细操作手册，不是宪法。**
> 宪法规则在 `shared/CLAUDE.md` §0（Claude 每次会话自动读取）。
> 本文件用于：新机器初始化、新增项目/skill/MCP/机器的详细步骤、文件清单。
> Claude 在日常会话中不需要读本文件，只在执行新增操作时按需读取。
> **最后更新**：2026-04-13

---

## 第一章：系统定义

### 1.1 这是什么

本仓库 `claude-context` 是 Gengyue（耿越）跨机器 Claude harness 的 **single source of truth**。它管理：

- **上下文记忆**：用户 profile、项目状态、架构决策历史
- **自建 Skills**：Claude 的自定义能力扩展
- **MCP 配置**：Claude 连接的外部服务
- **凭据**：用户愿意存储在私有仓库中的账号密码
- **机器配置**：每台机器的特有上下文和初始化脚本

### 1.2 文件权威层级

```
shared/CLAUDE.md §0（宪法，自动读取）
  ↓ 优先级递减
SETUP.md（本文件，操作手册，按需读取）
  ↓
shared/projects/<name>/*.md（项目速报）
  ↓
machines/<name>/local.md（机器特有上下文）
```

冲突时，上层文件的规则覆盖下层。CLAUDE.md §0 的规则是最终权威。

### 1.3 仓库结构

```
claude-context/
├── README.md              ← 仓库说明（给人看）
├── SETUP.md               ← 本文件（操作手册，按需读取）
├── .gitignore
├── shared/                ← 所有机器共用
│   ├── CLAUDE.md          ← 主上下文 hub（宪法 §0 在这里）
│   ├── credentials.md     ← 凭据
│   ├── cowork/            ← Claude Code / Cowork 设置
│   ├── skills/            ← 自建 skills
│   ├── mcp/               ← MCP 配置
│   └── projects/          ← 项目速报（每个项目一个子目录）
│       ├── TEMPLATE.md    ← 新项目模板
│       └── <name>/        ← 各项目
├── machines/              ← 机器特有
│   ├── <name>/
│   │   ├── setup.sh       ← 初始化脚本
│   │   └── local.md       ← 机器特有上下文
│   └── ...
└── archive/               ← 记忆归档
```

---

## 第二章：Bootstrap 流程

> 当用户说"初始化"、"按 SETUP 配置"、或 Claude 首次在一台机器上运行时，执行此流程。

### Step 0: 确认 CLAUDE.md 已读取

Claude 在会话开始时自动读取 `shared/CLAUDE.md`（通过 Desktop symlink）。§0 包含核心规则。
本文件的 Bootstrap 流程是 §0 规则的**展开版**，用于首次初始化。

### Step 1: 识别机器身份

确定当前运行在哪台机器上：

| 机器名 | 识别方式 | 目录 |
|--------|----------|------|
| mac-mini | `hostname` 包含 mini 或用户确认 | `machines/mac-mini/` |
| macbook | `hostname` 包含 MacBook 或用户确认 | `machines/macbook/` |
| windows | Windows OS 或用户确认 | `machines/windows/` |

如果无法自动识别，**问用户**。不要猜。

### Step 2: 加载共用上下文

按以下顺序读取：

1. `shared/CLAUDE.md` — 用户 profile（§1-7）+ 记忆追加区（§8）
2. `shared/projects/` — 列出所有项目目录，读取每个项目的主文件
3. `shared/credentials.md` — 可用凭据

### Step 3: 加载机器上下文

读取 `machines/<name>/local.md`，获取这台机器的特有配置和上下文。

### Step 4: 加载 Skills

扫描 `shared/skills/` 目录：

1. 列出所有 `.skill` 文件和 `*/SKILL.md`
2. 对每个 skill，检查当前机器是否已安装
3. 未安装的，提示用户安装（macOS：双击 `.skill` 文件）
4. 自建 skill 优先于系统默认 skill

**当前已注册的 Skills：**

| Skill | 文件 | 用途 |
|-------|------|------|
| memory | `shared/skills/memory.skill` | 会话结束时自动持久化记忆到 CLAUDE.md §8 |
| douyin-transcribe | `shared/skills/douyin-transcribe/` | 抖音链接或本地视频转录为文本（faster-whisper 本地推理） |

### Step 5: 加载 MCP 配置

扫描 `shared/mcp/` 目录：

1. 列出所有配置文件
2. 对每个 MCP，检查当前机器是否已连接
3. 未连接的，提示用户配置

**当前已注册的 MCP：**

（暂无）

### ~~Step 5.5: 加载 Hermes Agent 上下文~~ ⛔ 已废除（2026-07-25）

**本步骤不再执行。** owner 定「Hermes 的记忆文件不需要了，让他去用 Claude 的记忆」：
- `shared/HERMES.md` 已归档到 `archive/hermes-memory-export-retired-20260725.md`，**不要读它**（内容大面积过期）。
- **Hermes 不再有独立记忆层**，它跟 Claude 共用 `shared/CLAUDE.md`；仍在活的 Hermes 事实（dad/xirui profile、两个 paused cron）见 CLAUDE.md §8 [2026-07-25] 条。
- ⏸ **仅在 Mac 上**还需 owner 改 `~/.hermes/config.yaml`，把 user profile 注入源指向 clone 的 `claude-context/shared/CLAUDE.md`。
- ⚠️ Claude Code 的 per-machine auto-memory（`~/.claude/projects/<slug>/memory/`）是**本机私有、不跨机、不进 git**，Hermes 读不到——跨工具共享只能走本仓。

### Step 5.6: 加载 Obsidian Vault 上下文

检查 Obsidian Vault 是否可用：

1. 确认 `~/Documents/Obsidian Vault/HOME.md` 存在
2. 如果存在，Vault 可作为详细笔记源使用
3. 如果不存在，提示用户安装 Obsidian 并同步 Vault

Vault 是**两层**记忆体系的底层（见 CLAUDE.md §0.7；2026-07-25 起原 Hermes 层已撤），当需要详细内容时读取。

### Step 5.7: 配置 Cowork 设置

`shared/cowork/` 目录存放跨机器同步的 Claude Code / Cowork 设置。setup.sh 会自动处理 symlink，但手动配置时：

```bash
# 全局设置（plugins, thinking mode）
mkdir -p ~/.claude
ln -sf <REPO_DIR>/shared/cowork/settings.json ~/.claude/settings.json

# Desktop 项目级权限
mkdir -p ~/Desktop/.claude
ln -sf <REPO_DIR>/shared/cowork/settings.local.json ~/Desktop/.claude/settings.local.json

# 将 CLAUDE.md symlink 到项目目录（确保非 Desktop 工作区加载 harness 规则）
ln -sf <REPO_DIR>/shared/CLAUDE.md ~/Projects/<project>/CLAUDE.md
```

**注意**：`settings.json` 控制全局行为（插件、思考模式），`settings.local.json` 控制项目级权限（哪些 Bash 命令允许、哪些需要确认）。修改后需要 git sync。

### Step 6: 执行机器初始化脚本（仅首次）

如果用户明确要求初始化环境：

- macOS: 运行 `machines/<name>/setup.sh`
- Windows: 运行 `machines/windows/` 下的脚本（待实现）

这一步**不是每次会话都执行**，只在新机器首次配置时执行。

### Step 7: 报告状态

向用户报告初始化结果：

```
Claude Harness 初始化完成：
- 机器：<name>
- CLAUDE.md: ✓ (§8 共 N 条记忆，最新: [日期] [tag])
- （HERMES.md 检查项已于 2026-07-25 移除 —— Hermes 无独立记忆层）
- 项目：<列出所有项目及状态>
- Skills: <已安装/未安装>
- MCP: <已连接/未连接>
- 凭据: ✓/✗
- 机器特有上下文: ✓/✗
- Obsidian Vault: ✓/✗ (HOME.md 存在?)
- Hermes Agent: ✓/✗ (~/.hermes/ 存在?)
- Google OAuth: ✓/✗ (google_token.json 存在?)
```

---

## 第三章：读取规则

### 3.1 会话开始时必读

每次新会话开始，Claude **必须**读取：

1. `shared/CLAUDE.md` — 宪法规则（§0）+ 用户 profile（§1-7）+ 记忆（§8）

这是唯一的强制读取文件。本文件（SETUP.md）仅在执行新增操作时按需读取。

### 3.2 按需读取

| 场景 | 读取 |
|------|------|
| 用户提到某个项目 | `shared/projects/<name>/` 下的所有 md |
| 用户提到机器特有的事 | `machines/<name>/local.md` |
| 需要账号密码 | `shared/credentials.md` |
| 需要安装/调试 skill | `shared/skills/<name>/SKILL.md` |
| 需要 MCP 信息 | `shared/mcp/` 下的配置文件 |

### 3.3 读取顺序

当多个文件包含相关信息时，按 §1.2 的权威层级读取：CLAUDE.md §0 → SETUP.md → project sub-MD → local.md。上层覆盖下层。

---

## 第四章：写入规则

### 4.1 写到哪里

| 内容类型 | 写入位置 | 示例 |
|----------|----------|------|
| 跨项目决策、用户偏好、纠正 | `shared/CLAUDE.md` §8 | "用户不喜欢 Claude 给代码方案" |
| 项目特有的架构决策、状态变更 | `shared/projects/<name>/` 下的 sub-MD | "MoyuanIdea 选了 Next.js" |
| 机器特有的配置、路径 | `machines/<name>/local.md` | "Mac Mini 的项目目录在 ~/Projects" |
| 新 skill | `shared/skills/` | 新的 .skill 文件或 SKILL.md |
| 新 MCP 配置 | `shared/mcp/` | 新的配置文件 |
| **跨项目可复用资产**（2026-05-25 新增） | `shared/assets/<asset-name>/` | rule library / listener snapshot / 架构模式 |
| **会话产生的 sediment**（重大决策 / 复盘 / 情绪节点） | Obsidian Vault `05 - Journal/YYYY/MM/YYYY-MM-DD-slug.md` | 见 Vault 内 `05 - Journal/README.md` |
| **模式定义**（Claude harness 5 模式） | Obsidian Vault `02 - Areas/Claude Harness/` | chat / code / architecture-review / content / memory |

**绝对禁止**：

- 不得将项目特有的记忆写入 CLAUDE.md §8
- 不得将机器特有的路径硬编码到 shared/ 下的任何文件
- 不得在没有用户确认的情况下删除或修改已有的记忆条目
- 不得静默修改已有记忆（只能追加新条目或在用户确认后归档旧条目）

### 4.1.1 自动记忆触发（2026-05-25 起）

**Claude 在任何会话、任何模式下，必须主动写入 sediment-worthy 内容，不需要用户提醒。**

完整规则见 CLAUDE.md §0.3.1。简化版：

- 用户做出**重大决策 / 校准 framing** → §8
- 用户**纠正 Claude 判断** → §8 correction
- 跨项目**洞察 / 模式** → §8 insight
- **项目重大节点** → sub-MD + §8 pointer
- 用户**沟通偏好声明** → §8 preference
- **跨会话有价值的复盘** → Obsidian `05 - Journal/`

**回复末尾必须告知**：`📝 已记入 §8 [类型]: 标题` / `[文件路径]`

用户不满意可随时删除（低门槛 ≠ 不可逆）。

### 4.2 写入后的强制动作

**每次写入仓库文件后，Claude 必须：**

1. 告知用户写了什么、写到了哪里
2. 提醒用户同步：
   ```bash
   cd ~/Desktop/claude-context && git pull && git add -A && git commit -m "<type>: <简述>" && git push
   ```
3. commit message 的 `<type>` 使用：`memory`、`skill`、`mcp`、`machine`、`project`、`setup`

### 4.3 记忆条目格式

写入 CLAUDE.md §8 的条目必须使用以下格式：

```markdown
### [YYYY-MM-DD] tag: one-line summary
正文 2-5 句。发生了什么、决定了什么、什么变了。
如果是决策，记录考虑的选项和选择原因。
如果是纠正，记录什么是错的、什么是对的。
```

有效的 tag：`decision`、`correction`、`status`、`preference`、`insight`、`architecture`

### 4.4 注册义务

新增任何资源后，必须在对应位置注册：

| 新增内容 | 注册位置 |
|----------|----------|
| 新项目 | CLAUDE.md §5 项目索引表 + `shared/projects/<name>/` |
| 新 Skill | 本文件 Step 4 的 Skills 注册表 + CLAUDE.md §0.5 |
| 新 MCP | 本文件 Step 5 的 MCP 注册表 + CLAUDE.md §0.6 |
| 新机器 | 本文件 Step 1 的机器识别表 + `machines/<name>/` |
| 新跨项目资产 | `shared/assets/<name>/` + 顶层 `shared/assets/README.md` + CLAUDE.md §0.6.1 |
| 新模式（Claude harness） | Obsidian `02 - Areas/Claude Harness/<mode>.md` + 同目录 `INDEX.md` 表 + CLAUDE.md §9 速查表 |
| 项目归档 | mv `shared/projects/<name>/` → `archive/<name>/` + CLAUDE.md §5 "已归档项目" 表 + §8 终局记忆条 |

---

## 第五章：同步约定

所有机器直接在 `main` branch 上工作。不使用 per-machine branch。

### 5.1 工作流

1. 同一时间只在一台机器上工作（不存在并发写入）
2. 推送前先 pull：`git pull && git add -A && git commit -m "<type>: <简述>" && git push`
3. 换机器前在新机器上 pull：`git pull`

### 5.2 如果 pull 产生冲突

通常发生在忘了先 pull 就开始改文件时：

- CLAUDE.md §8 冲突：保留双方记忆条目，按日期倒序排列
- 其他文件冲突：以最新修改为准
- 不得因为冲突而删除任何记忆

---

## 第六章：新增操作规范

### 6.1 新增项目

```bash
# 1. 创建项目目录
mkdir -p shared/projects/<project-name>/

# 2. 从模板创建项目速报
cp shared/projects/TEMPLATE.md shared/projects/<project-name>/<PROJECT-NAME>.md

# 3. 编辑项目速报，填入项目信息

# 4. 在 shared/CLAUDE.md §5 项目索引表添加一行：
# | **<项目名>** | <状态> | <一句话> | → [<PROJECT>.md](projects/<name>/<PROJECT>.md) |

# 5. 同步
git add -A && git commit -m "project: add <project-name>" && git push
```

### 6.2 新增机器

```bash
# 1. 创建机器目录
mkdir -p machines/<machine-name>/

# 2. 创建 local.md（参考其他机器的 local.md）
# 3. 创建 setup.sh（参考其他机器的 setup.sh）
# 4. 在本文件 Step 1 的机器识别表中注册
# 5. 在第五章 §5.1 分支结构表中注册
# 6. 同步
```

### 6.3 新增 Skill

```bash
# 1. 将 skill 文件放入 shared/skills/
#    - .skill 文件（打包版）
#    - <skill-name>/SKILL.md（源码版）
# 2. 在本文件 Step 4 的 Skills 注册表中添加一行
# 3. 同步
```

### 6.4 新增 MCP

```bash
# 1. 将配置文件放入 shared/mcp/
# 2. 在本文件 Step 5 的 MCP 注册表中添加一行
# 3. 同步
```

### 6.5 新增跨项目资产（2026-05-25 新增）

跨项目可复用的代码 / 文档 / 架构思路（不是项目本体）：

```bash
# 1. 创建 shared/assets/<asset-name>/
# 2. 写 README.md 说明：来源 / 用途 / 状态 / 复用场景 / trade-off
# 3. 复制必要文件（代码用 .snapshot 后缀避免误认为是 source of truth）
# 4. 更新 shared/assets/README.md 索引
# 5. 更新 CLAUDE.md §0.6.1 资产表
# 6. 提交：git add shared/assets/ && git commit -m "project: extract <asset>"
```

参考已有：`shared/assets/wellness-rule-library/` / `shared/assets/discord-presence-listener/`

### 6.6 新增 / 修改 Claude 模式（2026-05-25 新增）

5 模式当前在 Obsidian Vault `02 - Areas/Claude Harness/`：

```bash
# 新增模式：
# 1. 在 02 - Areas/Claude Harness/ 创建 <mode>.md（参照现有 5 个模式）
# 2. 更新同目录 INDEX.md 表格
# 3. 更新 CLAUDE.md §9 速查表
# 4. 在 02 - Areas/Claude Harness/INDEX.md 的 "自动识别表" 加触发词

# 修改现有模式：直接 edit 对应 .md 文件 + 同步 §9 摘要
```

### 6.7 项目归档（2026-05-25 新增）

```bash
mkdir -p archive/<name>
mv shared/projects/<name>/* archive/<name>/
rmdir shared/projects/<name>
# 更新 CLAUDE.md §5 "已归档项目" 表
# 写 §8 终局记忆条目（type: project，含归档原因 + 拆出的资产 + 遗留决策）
# 如有可复用资产，按 §6.5 拆到 shared/assets/
```

---

## 第七章：文件清单

| 文件 | 用途 | 谁维护 | 更新时机 |
|------|------|--------|----------|
| `SETUP.md` | 操作手册（新增/初始化步骤） | 用户 + Claude（需确认） | 新增资源、规则变更时 |
| `shared/CLAUDE.md` | 用户 profile + 记忆 + harness 规则 | Claude（auto-memory default-on） | sediment-worthy 内容、规则变更时 |
| ~~`shared/HERMES.md`~~ | **2026-07-25 退役** → `archive/hermes-memory-export-retired-20260725.md`；Hermes 子系统变更改写 `shared/CLAUDE.md` §8 | — | — |
| `shared/credentials.md` | 账号密码 | 用户 | 新增/变更凭据时 |
| `shared/cowork/settings.json` | 全局设置（plugins, thinking） | 用户 | 插件/设置变更时 |
| `shared/cowork/settings.local.json` | 项目级权限 | 用户 | 权限变更时 |
| `shared/skills/*/SKILL.md` | Skill 源码 | 用户 + Claude | Skill 逻辑变更时 |
| `shared/mcp/*` | MCP 配置 | 用户 + Claude | MCP 新增/变更时 |
| `shared/projects/*/` | 项目速报（active） | Claude | 项目状态变更时 |
| `shared/projects/TEMPLATE.md` | 新项目模板 | 用户 | 模板需要更新时 |
| **`shared/assets/*/`** | 跨项目可复用资产 | Claude | 项目归档 / 提取复用模块时 |
| `machines/*/setup.sh` | 机器初始化脚本 | 用户 | 环境依赖变更时 |
| `machines/*/local.md` | 机器特有上下文 | Claude | 机器配置变更时 |
| `archive/` | 已结束项目归档 | Claude（项目归档时） | 项目完结 |
| `README.md` | 仓库说明（给人看） | 用户 | 结构变更时 |
| `.gitignore` | 排除规则 | 用户 | 需要排除新文件类型时 |

**外部依赖**（不在本仓库但 Claude 必须知道；Vault 路径见 CLAUDE.md §0.7 路径协议）：
| 路径 | 用途 |
|---|---|
| `Vault/02 - Areas/Claude Harness/` | 5 模式定义（chat/code/architecture-review/content/memory） |
| `Vault/05 - Journal/` | 触发式 sediment journal entries (v1, 2026-05-25 起) |
| `Vault/01 - Projects/<name>/` | 项目工作区（framework 详细库 / drafts / metric），如 YoRHa-A2 |
| `~/.hermes/` | Hermes Agent 系统（独立于本仓库） |

---

## 附录：快速参考

### 会话开始检查清单

```
□ 读取 shared/CLAUDE.md（自动，包含 §0 规则）
□ 如果涉及项目，读取 shared/projects/<name>/
□ 如果涉及机器配置，读取 machines/<name>/local.md
□ 如果需要新增操作，读取 SETUP.md（本文件）
```

### 会话结束检查清单

```
□ 评估是否需要写入记忆（参考 memory skill 的触发条件）
□ 如果写了文件，提醒用户 git sync
□ 如果新增了资源，确认已在对应位置注册
```

### 常用同步命令

```bash
# 写入后同步（push 前先 pull）
cd ~/Desktop/claude-context && git pull && git add -A && git commit -m "<type>: <简述>" && git push

# 换机器前拉取
cd ~/Desktop/claude-context && git pull

# 查看记忆历史
cd ~/Desktop/claude-context && git log --oneline shared/CLAUDE.md
```

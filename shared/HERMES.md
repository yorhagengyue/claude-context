# HERMES.md — Hermes Agent 记忆导出

> **用途**：Hermes（非 Claude Code）的记忆系统快照，供用户审阅和编辑。
> **来源**：Hermes user profile + memory store
> **导出时间**：2026-04-13
> **说明**：这是 Hermes 的独立记忆系统，和 CLAUDE.md 是两套体系。Hermes 通过 config.yaml 的 user profile 字段注入，不走 CLAUDE.md。

---

## 1. User Profile（用户画像）

> Hermes 系统每次会话自动注入的内容。

### 1.1 联系方式
- 邮箱：gengyue081@gmail.com（私人）、2403880d@tp.edu.sg（学校）、tommychen030607@gmail.com

### 1.2 技术栈
- **前端**：React（主力）、Next.js、Angular、Vue、Flutter/Dart、Three.js
- **后端**：Express/Node.js、FastAPI/Python、基础 Prisma/Sequelize ORM
- **AI/ML**：PPO 强化学习、基础 ML pipeline、LLM prompt engineering、agent 架构设计
- **DevOps**：基础 Nix、Docker/Arion、Cloudflare Pages
- **弱项**：数据库设计（schema 决策）、系统级架构、重构实践

### 1.3 沟通偏好
- 中文为主，技术术语英文可
- 不要夸他的东西，要真实判断
- 不要假设意图，说过的才算
- 不急着给方案，先确认理解了问题
- 平等沟通，可以质疑和讨论
- 重视过程不是速度
- 对"AI 生成的漂亮但空洞的输出"警觉

### 1.4 开发工具
- 主力代码生产：OpenAI Codex (GPT-5.4)
- **主力 agent 系统：Hermes Agent**（替代 YoRHa/Moltbot/Clawdbot）
- Claude Code CLI：CTO 顾问角色（架构审查/记忆维护）
- claude-context 仓库：跨机器 Claude 上下文管理（~/Desktop/claude-context/）
- Agent 演进路线：YoRHa（搁置）→ Moltbot/Clawdbot（停用）→ **Hermes**（当前）

### 1.5 活跃项目
- **IFSG**：企业财务报表生成器，Angular+Nix+PostgreSQL，4人团队（TP Researcher 工作内容）
- **SBS Transit**：多仓库项目，Phase2+Webapp+WhisperAPI+GenAI（TP Researcher 工作内容，当前最活跃）
- **MoyuanIdea**：AI 文化教育系统，V2 愿景→架构阶段
- **NAISC Workato**：NUS AI Innovation & Social Challenge，截止 2026-04-24

### 1.6 当前身份
- **TP Researcher**（不是 A*STAR 实习），工作内容是 IFSG 和 SBS Transit
- 日历里 A*STAR 条目属于同事 Dylan

### 1.7 核心成长目标
- 架构判断力（不是产出能力）

---

## 2. Memory Store（记忆存储）

> Hermes 的持久化记忆条目。以下同步自 Hermes memory tool 的当前状态。

### 环境
- macOS Darwin 24.6.0, arm64, 用户名 gengyue, home /Users/gengyue
- Gmail OAuth 已认证，可用于读取 Gmail/Calendar/Contacts
- 用户授权了大规模 Gmail 读取/分析

### 项目状态
- MoltbotDev 已停用，迁移到 Hermes
- MLDP-Project 课程已结束
- chen-yu-fei.com 非本人网站，仅挂载杂用
- 不使用 Google Drive

### Obsidian 外置大脑
- Obsidian Vault = 外置大脑（重内容），路径 ~/Documents/Obsidian Vault/
- 三层记忆：CLAUDE.md/Hermes memory（轻量指针）→ Obsidian（详细笔记）
- 自动写入到 06 - Auto/，frontmatter 带 source: hermes
- OBSIDIAN_VAULT_PATH 已配置在 .env

### 偏好
- Gmail 分析时关注竞赛/重要里程碑，不要 billing 摘要

---

## 3. 三层记忆体系

| 层级 | 存储 | 内容类型 | 管理者 |
|------|------|----------|--------|
| CLAUDE.md §8 / sub-MD | claude-context 仓库 | 轻量指针、决策摘要、纠正 | Claude Code |
| Hermes memory | ~/.hermes/config (注入) | 轻量指针、偏好、环境 | Hermes Agent |
| **Obsidian Vault** | ~/Documents/Obsidian Vault/ | 详细笔记、项目记录、时间线、知识沉淀 | 用户 + Hermes (06-Auto) |

### Hermes 与 Obsidian 的关系
- Hermes 可以读写 Obsidian Vault
- 自动写入**只能**写到 `06 - Auto/` 子目录
- 所有自动笔记 frontmatter 必须带 `source: hermes`
- 不覆盖用户已有笔记

### Hermes 当前集成
| 服务 | 状态 |
|------|------|
| Google OAuth (Gmail/Calendar/Contacts) | ✅ |
| GitHub (gh CLI) | ✅ |
| Obsidian Vault | ✅ |
| WhatsApp | ✅ (配置存在) |
| Cron Jobs | ✅ |

---

## 4. 如何同步编辑

如果你编辑了本文件的 §1 部分（User Profile），需要同步更新到 Hermes 的配置：
- Hermes 的 user profile 存在 `~/.hermes/config.yaml`（或对应配置路径）
- 修改 config.yaml 中的 user profile 字段后，下次 Hermes 会话会自动读取新内容

如果你编辑了 §2 部分（Memory Store），那是 Hermes 运行时通过 memory tool 管理的，手动编辑后需要确认 Hermes 侧已同步。

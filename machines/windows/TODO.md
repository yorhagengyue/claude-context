# Windows — 待实现

> **状态**：占位
> **设备**：两台 (Tailscale: "node" 100.113.76.104, "yorha" 100.120.200.72)
> **创建日期**：2026-04-05
> **更新**：2026-04-13

---

## 新机器需要做的（一旦启用）

### 必装组件
| # | 组件 | 说明 |
|---|------|------|
| 1 | Git | git-scm.com 或 winget |
| 2 | Node.js | fnm 或 nvm-windows |
| 3 | Python | python.org 或 winget |
| 4 | Claude Code CLI | npm install (需要 WSL 或 Windows terminal) |
| 5 | OpenAI Codex | npm install -g @openai/codex |
| 6 | Hermes Agent | 主力 agent 系统，安装到 %USERPROFILE%\.hermes\ |
| 7 | Obsidian | obsidian.md 下载安装 |
| 8 | Tailscale | tailscale.com 下载 |

### Obsidian Vault 同步
- 创建 Vault 在 `~/Documents/Obsidian Vault/`
- 从 Mac Mini 同步内容 (OneDrive / Syncthing / 手动拷贝)
- 确保 HOME.md 和目录结构完整

### Google OAuth
- 和 Mac Mini 共用同一个 GCP project (project ID: 733441049399)
- 需要在 Windows 上重新走一遍 OAuth 流程 (token 是机器绑定的)
- client_secret.json 可以从 Mac Mini 复制

### Hermes .env
- 添加 `OBSIDIAN_VAULT_PATH=C:\Users\gengyue\Documents\Obsidian Vault` (或对应路径)

---

## 待解决的问题

- [ ] 确定 Windows 上使用的 Claude 客户端（CLI via WSL? Desktop?）
- [ ] 路径约定（`%USERPROFILE%` vs WSL `~/`）
- [ ] Shell 脚本替代方案（PowerShell? batch?）
- [ ] symlink 方案（Windows symlink 需要管理员权限，或用 junction）

## 启用步骤

1. 创建 `setup.ps1` 或 `setup.sh`（WSL）
2. 创建 `local.md`
3. 运行 setup 脚本完成配置
4. `git pull && git add -A && git commit -m "machine: activate windows" && git push`

# MacBook — 机器特有上下文

> **机器名**：macbook
> **用途**：便携开发机
> **最后更新**：2026-04-13

---

## 环境信息

- **OS**：macOS (Apple Silicon)
- **项目目录**：~/Projects/
- **Claude 使用方式**：Claude Code CLI

## 需要配置的完整清单

运行 `machines/macbook/setup.sh` 后，对照此清单检查：

| # | 组件 | 状态 | 恢复步骤 |
|---|------|------|----------|
| 1 | brew, git, node, python3 | 待确认 | setup.sh 步骤 1-4 |
| 2 | Codex | 待确认 | setup.sh 步骤 5 |
| 3 | Claude harness symlinks | 待确认 | setup.sh 步骤 7-8 |
| 4 | Obsidian | 待确认 | `brew install --cask obsidian` |
| 5 | Obsidian Vault | 待确认 | 从 Mac Mini 同步到 ~/Documents/Obsidian Vault/ |
| 6 | Hermes Agent | 待确认 | 参考 Hermes 文档 |
| 7 | OBSIDIAN_VAULT_PATH | 待确认 | 添加到 ~/.hermes/.env |
| 8 | Google OAuth | 待确认 | setup.py --client-secret → --auth-code |
| 9 | Google client secret | 待确认 | 从 Mac Mini 复制 ~/.hermes/google_client_secret.json |
| 10 | GWS timezone | 待确认 | `echo 'Asia/Singapore' > ~/.config/gws/account_timezone` |
| 11 | Tailscale | 待确认 | `brew install tailscale` |

## Google OAuth 恢复步骤

和 Mac Mini 共用同一个 GCP project，但 token 是机器绑定的，需要重新认证：

1. 从 Mac Mini 复制 `~/.hermes/google_client_secret.json`
2. `python ~/.hermes/skills/productivity/google-workspace/scripts/setup.py --client-secret ~/.hermes/google_client_secret.json`
3. 浏览器完成 OAuth 授权
4. `python setup.py --auth-code <CODE>`
5. 验证: `python setup.py --check`

## Obsidian Vault 同步

Mac Mini 是 Vault 的 source of truth。同步方式（选一个）：
- **rsync**: `rsync -av mac-mini:~/Documents/Obsidian\ Vault/ ~/Documents/Obsidian\ Vault/`
- **iCloud**: 如果两台机器都登录同一个 iCloud，可以把 Vault 放 iCloud Drive
- **手动拷贝**: USB / AirDrop

## 已安装的 Skills

（待确认——运行 setup.sh 后更新）

## 已连接的 MCP

（待确认）

## 特有配置

（待用户添加）

## 备注

- 便携机，可能不会常驻 Hermes/Docker 等重服务
- 项目目录在 ~/Projects/ 而非 ~/Desktop/ (和 Mac Mini 不同)

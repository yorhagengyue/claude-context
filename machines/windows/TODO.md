# Windows — 待实现

> **状态**：占位，暂不实现
> **创建日期**：2026-04-05

---

## 待解决的问题

- [ ] 确定 Windows 上使用的 Claude 客户端（CLI via WSL? Desktop? 浏览器?）
- [ ] 路径约定（`%USERPROFILE%` vs WSL `~/`）
- [ ] Shell 脚本替代方案（PowerShell? batch?）
- [ ] symlink 方案（Windows symlink 需要管理员权限，或用 junction）

## 启用时需要做的

1. 创建 `setup.ps1` 或 `setup.sh`（WSL）
2. 创建 `local.md`
3. 在 `SETUP.md` Step 1 的机器识别表中更新识别方式
4. 在 `SETUP.md` §5.1 分支表中激活 `windows` branch

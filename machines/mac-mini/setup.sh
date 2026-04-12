#!/bin/bash
# ============================================================
# Mac Mini Setup Script — Geng Yue (耿越)
# 运行方式：chmod +x setup.sh && ./setup.sh
# ============================================================

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
MACHINE="mac-mini"

echo "========================================="
echo "  $MACHINE Setup — 开始配置"
echo "  仓库目录: $REPO_DIR"
echo "========================================="

# ----- 1. 环境检查（只报告，不安装）-----
echo ""
echo "[1/4] 检查开发环境..."

check_tool() {
  if command -v "$1" &> /dev/null; then
    echo "  ✓ $1: $($1 --version 2>&1 | head -1)"
  else
    echo "  ✗ $1: 未安装"
  fi
}

check_tool brew
check_tool git
check_tool node
check_tool python3
check_tool codex

# Obsidian 检查
if [ -d "/Applications/Obsidian.app" ]; then
  echo "  ✓ Obsidian: 已安装"
else
  echo "  ✗ Obsidian: 未安装"
  echo "    → 安装: brew install --cask obsidian"
  echo "    ⚠️  Obsidian 是外置大脑的核心，必须安装。"
  read -p "    是否现在安装 Obsidian？(y/n) " install_obsidian
  if [ "$install_obsidian" = "y" ]; then
    brew install --cask obsidian
    echo "  ✓ Obsidian: 安装完成"
  fi
fi

# Hermes 检查
if [ -d "$HOME/.hermes" ]; then
  echo "  ✓ Hermes Agent: ~/.hermes/ 存在"
else
  echo "  ✗ Hermes Agent: 未找到 ~/.hermes/"
  echo "    → Hermes 是主力 agent 系统，请参考 Hermes 文档安装"
fi

# ----- 2. 项目仓库检查 -----
echo ""
echo "[2/4] 检查项目仓库..."

check_repo() {
  if [ -d "$1" ]; then
    echo "  ✓ $(basename "$1"): $1"
  else
    echo "  ✗ $(basename "$1"): 未找到 ($1)"
  fi
}

check_repo ~/Desktop/claude-context
check_repo ~/Projects/MoyuanIdea

# ----- 3. Claude Harness 配置 -----
echo ""
echo "[3/7] 配置 Claude Harness..."

# 软链接 CLAUDE.md 到 Desktop
ln -sf "$REPO_DIR/shared/CLAUDE.md" ~/Desktop/CLAUDE.md
echo "  CLAUDE.md → Desktop ✓"

# 软链接所有项目速报到 Desktop
for project_dir in "$REPO_DIR"/shared/projects/*/; do
  if [ -d "$project_dir" ]; then
    for md_file in "$project_dir"/*.md; do
      if [ -f "$md_file" ] && [ "$(basename "$md_file")" != "TEMPLATE.md" ]; then
        ln -sf "$md_file" ~/Desktop/"$(basename "$md_file")"
        echo "  $(basename "$md_file") → Desktop ✓"
      fi
    done
  fi
done

# ----- 4. Cowork 设置 -----
echo ""
echo "[4/7] 配置 Cowork..."

# 全局设置
if [ -f "$REPO_DIR/shared/cowork/settings.json" ]; then
    mkdir -p ~/.claude
    ln -sf "$REPO_DIR/shared/cowork/settings.json" ~/.claude/settings.json
    echo "  settings.json → ~/.claude/ ✓"
fi

# Desktop 项目级权限
if [ -f "$REPO_DIR/shared/cowork/settings.local.json" ]; then
    mkdir -p ~/Desktop/.claude
    ln -sf "$REPO_DIR/shared/cowork/settings.local.json" ~/Desktop/.claude/settings.local.json
    echo "  settings.local.json → ~/Desktop/.claude/ ✓"
fi

# 将 CLAUDE.md symlink 到各项目目录（确保非 Desktop 工作区也能加载 harness 规则）
if [ -d ~/Projects ]; then
    for project in ~/Projects/*/; do
      if [ -d "$project" ] && [ "$(basename "$project")" != "claude-context" ]; then
        ln -sf "$REPO_DIR/shared/CLAUDE.md" "$project/CLAUDE.md"
        echo "  CLAUDE.md → $(basename "$project")/ ✓"
      fi
    done
fi

# ----- 5. Skills 检查 -----
echo ""
echo "[5/7] 检查 Skills..."

for skill_file in "$REPO_DIR"/shared/skills/*.skill; do
  if [ -f "$skill_file" ]; then
    echo "  发现: $(basename "$skill_file") → 请双击安装: $skill_file"
  fi
done

# ----- 6. Obsidian Vault 检查 -----
echo ""
echo "[6/7] 检查 Obsidian Vault..."

VAULT_PATH="$HOME/Documents/Obsidian Vault"
if [ -d "$VAULT_PATH" ] && [ -f "$VAULT_PATH/HOME.md" ]; then
  echo "  ✓ Vault 已存在: $VAULT_PATH"
  echo "  ✓ HOME.md 存在"
  # 检查核心目录
  for dir in "00 - Inbox" "01 - Projects" "02 - Areas" "05 - Journal" "06 - Auto"; do
    if [ -d "$VAULT_PATH/$dir" ]; then
      echo "  ✓ $dir/"
    else
      echo "  ✗ $dir/ 缺失 — 请从其他机器同步 Vault"
    fi
  done
elif [ -d "$VAULT_PATH" ]; then
  echo "  ⚠️  Vault 目录存在但缺少 HOME.md"
  echo "     这可能是空 Vault。请从其他机器同步或通过 Hermes 重建。"
else
  echo "  ✗ Vault 不存在: $VAULT_PATH"
  echo "    → 请先打开 Obsidian，创建 Vault 在 ~/Documents/Obsidian Vault"
  echo "    → 然后从其他机器同步内容，或通过 Hermes 初始化"
fi

# ----- 7. Hermes Obsidian 集成检查 -----
echo ""
echo "[7/8] 检查 Hermes-Obsidian 集成..."

if [ -f "$HOME/.hermes/.env" ]; then
  if grep -q "OBSIDIAN_VAULT_PATH" "$HOME/.hermes/.env"; then
    echo "  ✓ OBSIDIAN_VAULT_PATH 已配置在 ~/.hermes/.env"
  else
    echo "  ✗ OBSIDIAN_VAULT_PATH 未配置"
    echo "    → 添加到 ~/.hermes/.env: OBSIDIAN_VAULT_PATH=$VAULT_PATH"
  fi
else
  echo "  ⚠️  ~/.hermes/.env 不存在（Hermes 可能未安装）"
fi

# ----- 8. Google Workspace / 凭据检查 -----
echo ""
echo "[8/8] 检查 Google Workspace 集成..."

# Google OAuth token
if [ -f "$HOME/.hermes/google_token.json" ]; then
  echo "  ✓ Google OAuth token: ~/.hermes/google_token.json"
else
  echo "  ✗ Google OAuth token 不存在"
  echo "    → 需要通过 Hermes Google Workspace skill 完成 OAuth 认证"
  echo "    → 步骤: 准备 GCP OAuth client_secret.json → 运行 setup.py --client-secret → --auth-code"
fi

# Google client secret
if [ -f "$HOME/.hermes/google_client_secret.json" ]; then
  echo "  ✓ Google OAuth client secret: ~/.hermes/google_client_secret.json"
else
  echo "  ✗ Google OAuth client secret 不存在"
  echo "    → 从 https://console.cloud.google.com/apis/credentials 下载"
  echo "    → 保存为 ~/.hermes/google_client_secret.json"
fi

# gws CLI timezone
if [ -f "$HOME/.config/gws/account_timezone" ]; then
  TZ_VAL=$(cat "$HOME/.config/gws/account_timezone")
  echo "  ✓ GWS timezone: $TZ_VAL"
else
  echo "  ✗ GWS timezone 未配置"
  echo "    → 运行: mkdir -p ~/.config/gws && echo 'Asia/Singapore' > ~/.config/gws/account_timezone"
fi

echo ""
echo "========================================="
echo "  配置完成！"
echo "========================================="
echo ""
echo "如果是首次配置，还需要："
echo "1. 双击安装 shared/skills/ 下的 .skill 文件"
echo "2. 打开 Claude，说：'读一下 SETUP.md，初始化'"
echo ""
echo "Done."

#!/bin/bash
# ============================================================
# MacBook Setup Script — Geng Yue (耿越)
# 新机器从零规范化配置（主力开发机）
# 运行方式：chmod +x setup.sh && ./setup.sh
# ============================================================

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
MACHINE="macbook"

echo "========================================="
echo "  $MACHINE Setup — 开始配置"
echo "  仓库目录: $REPO_DIR"
echo "========================================="

# ----- 1. Homebrew -----
echo ""
echo "[1/7] 检查 Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon path
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew 已安装，跳过"
fi

# ----- 2. Git 配置 -----
echo ""
echo "[2/7] 配置 Git..."
git config --global user.name "yorhagengyue"
git config --global user.email "gengyue081@gmail.com"
git config --global init.defaultBranch main
git config --global pull.rebase false

# SSH key
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "生成 SSH key..."
    ssh-keygen -t ed25519 -C "gengyue081@gmail.com" -f ~/.ssh/id_ed25519 -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo ""
    echo "============================================"
    echo "  SSH 公钥（复制到 GitHub Settings > SSH Keys）："
    echo "============================================"
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "打开 GitHub SSH 设置页面..."
    open "https://github.com/settings/ssh/new"
    echo ""
    read -p "SSH key 添加到 GitHub 后按 Enter 继续..."
else
    echo "SSH key 已存在，跳过"
fi

# 验证 GitHub 连接
echo "验证 GitHub SSH 连接..."
ssh -T git@github.com 2>&1 || true

# ----- 3. Node.js (nvm) -----
echo ""
echo "[3/7] 安装 nvm + Node.js..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
    echo "Node $(node -v) 安装完成"
else
    echo "nvm 已安装，跳过"
fi

# ----- 4. Python (pyenv) -----
echo ""
echo "[4/7] 安装 pyenv + Python..."
if ! command -v pyenv &> /dev/null; then
    brew install pyenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    pyenv install 3.12
    pyenv global 3.12
    echo "Python $(python --version) 安装完成"
else
    echo "pyenv 已安装，跳过"
fi

# ----- 5. Codex（裸装，不带 YoRHa）-----
echo ""
echo "[5/7] 安装 OpenAI Codex..."
if ! command -v codex &> /dev/null; then
    echo "请手动安装 Codex（需要从 OpenAI 官方渠道获取）"
    echo "安装后 Codex 为裸配置——不迁移 YoRHa，不复制 ~/.codex/skills/"
    echo ""
    read -p "Codex 安装完成后按 Enter 继续..."
else
    echo "Codex 已安装"
fi

# ----- 6. Clone 项目仓库 -----
echo ""
echo "[6/7] Clone 项目仓库到 ~/Projects/..."
mkdir -p ~/Projects

# MoyuanIdea
if [ ! -d ~/Projects/MoyuanIdea ]; then
    git clone git@github.com:yorhagengyue/MoyuanIdea.git ~/Projects/MoyuanIdea
    echo "MoyuanIdea cloned"
else
    echo "MoyuanIdea 已存在，跳过"
fi

# IFSG（私有仓库，需要权限）
echo ""
echo "IFSG 仓库需要手动 clone（私有仓库，确认你有访问权限）："
echo "  git clone git@github.com:<org>/ifsg.git ~/Projects/ifsg"

# ----- 7. Claude Harness 配置 -----
echo ""
echo "[7/8] 配置 Claude Harness..."

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

# ----- 8. Cowork 设置 -----
echo ""
echo "[8/8] 配置 Cowork..."

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

# 检查 Skills
echo ""
echo "  Skills:"
for skill_file in "$REPO_DIR"/shared/skills/*.skill; do
  if [ -f "$skill_file" ]; then
    echo "    发现: $(basename "$skill_file") → 请双击安装: $skill_file"
  fi
done

# ----- 9. Obsidian 检查 -----
echo ""
echo "[9/11] 检查 Obsidian..."

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

# Obsidian Vault 检查
VAULT_PATH="$HOME/Documents/Obsidian Vault"
if [ -d "$VAULT_PATH" ] && [ -f "$VAULT_PATH/HOME.md" ]; then
  echo "  ✓ Vault 已存在: $VAULT_PATH"
  for dir in "00 - Inbox" "01 - Projects" "02 - Areas" "05 - Journal" "06 - Auto"; do
    if [ -d "$VAULT_PATH/$dir" ]; then
      echo "  ✓ $dir/"
    else
      echo "  ✗ $dir/ 缺失 — 请从 Mac Mini 同步 Vault 或通过 Hermes 重建"
    fi
  done
elif [ -d "$VAULT_PATH" ]; then
  echo "  ⚠️  Vault 目录存在但缺少 HOME.md — 需要从 Mac Mini 同步内容"
else
  echo "  ✗ Vault 不存在"
  echo "    → 打开 Obsidian, 创建 Vault 在 ~/Documents/Obsidian Vault"
  echo "    → 然后从 Mac Mini 同步内容 (rsync/iCloud/手动拷贝)"
fi

# ----- 10. Hermes 检查 -----
echo ""
echo "[10/11] 检查 Hermes Agent..."

if [ -d "$HOME/.hermes" ]; then
  echo "  ✓ Hermes Agent: ~/.hermes/ 存在"
  # Check OBSIDIAN_VAULT_PATH
  if [ -f "$HOME/.hermes/.env" ] && grep -q "OBSIDIAN_VAULT_PATH" "$HOME/.hermes/.env"; then
    echo "  ✓ OBSIDIAN_VAULT_PATH 已配置"
  else
    echo "  ✗ OBSIDIAN_VAULT_PATH 未配置 — 添加到 ~/.hermes/.env"
  fi
else
  echo "  ✗ Hermes Agent 未找到"
  echo "    → Hermes 是主力 agent 系统，参考文档安装"
fi

# ----- 11. Google Workspace 检查 -----
echo ""
echo "[11/11] 检查 Google Workspace..."

if [ -f "$HOME/.hermes/google_token.json" ]; then
  echo "  ✓ Google OAuth token"
else
  echo "  ✗ Google OAuth token — 需要完成 OAuth 认证"
  echo "    步骤:"
  echo "    1. 从 GCP Console 下载 client_secret.json → ~/.hermes/google_client_secret.json"
  echo "    2. python setup.py --client-secret ~/.hermes/google_client_secret.json"
  echo "    3. 浏览器完成授权"
  echo "    4. python setup.py --auth-code <CODE>"
fi

if [ -f "$HOME/.config/gws/account_timezone" ]; then
  echo "  ✓ GWS timezone: $(cat "$HOME/.config/gws/account_timezone")"
else
  echo "  ✗ GWS timezone — 运行: mkdir -p ~/.config/gws && echo 'Asia/Singapore' > ~/.config/gws/account_timezone"
fi

echo ""
echo "========================================="
echo "  配置完成！剩余手动步骤："
echo "========================================="
echo ""
echo "1. 确保 Obsidian 已安装并打开 Vault (~/Documents/Obsidian Vault)"
echo "   如果 Vault 内容为空 → 从 Mac Mini 同步"
echo ""
echo "2. 确保 Hermes Agent 已安装 (~/.hermes/)"
echo "   OBSIDIAN_VAULT_PATH 已写入 ~/.hermes/.env"
echo ""
echo "3. 完成 Google OAuth 认证 (如果 token 缺失)"
echo "   详见上方 [11/11] 的步骤"
echo ""
echo "4. 双击安装 shared/skills/ 下的 .skill 文件"
echo ""
echo "5. 打开 Claude，说：'读一下 SETUP.md，初始化'"
echo ""
echo "Done."

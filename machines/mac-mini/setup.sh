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

check_repo ~/Projects/claude-context
check_repo ~/Projects/MoyuanIdea

# ----- 3. Claude Harness 配置 -----
echo ""
echo "[3/5] 配置 Claude Harness..."

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
echo "[4/5] 配置 Cowork..."

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
echo "[5/5] 检查 Skills..."

for skill_file in "$REPO_DIR"/shared/skills/*.skill; do
  if [ -f "$skill_file" ]; then
    echo "  发现: $(basename "$skill_file") → 请双击安装: $skill_file"
  fi
done

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

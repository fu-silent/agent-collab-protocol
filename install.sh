#!/usr/bin/env bash
# 安装 / 更新用户级技能 agent-collab-protocol 到 DSH 技能目录。
# 用法：./install.sh            （默认 ~/.dsh/skills）
#       DSH_HOME=/path ./install.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DSH_ROOT="${DSH_HOME:-$HOME/.dsh}"
DEST="$DSH_ROOT/skills/agent-collab-protocol"
SRC_SKILL="$DIR/skill/agent-collab-protocol/SKILL.md"
SRC_TPL="$DIR/templates"

# 先把仓库 templates 同步进技能包，避免两处副本漂移
mkdir -p "$DIR/skill/agent-collab-protocol/templates"
cp "$SRC_TPL"/*.md "$DIR/skill/agent-collab-protocol/templates/"

if [ ! -f "$SRC_SKILL" ]; then
  echo "找不到技能源文件：$SRC_SKILL" >&2
  exit 1
fi

mkdir -p "$DSH_ROOT/skills"
rm -rf "$DEST"
mkdir -p "$DEST/templates"
cp "$SRC_SKILL" "$DEST/SKILL.md"
cp "$SRC_TPL"/*.md "$DEST/templates/"

echo "已安装：$DEST"
echo "包含：SKILL.md + $(ls "$DEST/templates" | wc -l | tr -d ' ') 个模板"
echo "校验："
echo "  head -5 \"$DEST/SKILL.md\""
echo "  ls \"$DEST/templates\""
echo
echo "提示：DSH 会在下一次会话/技能目录刷新后识别；也可在技能中心查看。"
echo "更新：修改本仓库 templates/ 或 skill/ 后重新运行本脚本即可。"

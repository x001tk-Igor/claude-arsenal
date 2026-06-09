#!/usr/bin/env bash
# uninstall.sh — удалить всё, что поставил install.sh.
# НЕ удаляет: ~/claude-arsenal/ (репо), karpathy-guidelines из plugin marketplace.
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✅ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
fail() { echo -e "${RED}❌ $*${NC}" >&2; exit 1; }

ARSENAL_DIR="${ARSENAL_DIR:-$HOME/claude-arsenal}"

warn "Это удалит skills/агенты из ~/.claude/, НЕ удаляя сам репо."
read -p "Продолжить? [y/N] " -n 1 -r
echo
if ! [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "отменено"
  exit 0
fi

REMOVED=0
for skill in karpathy-guidelines claude-api google-sheets mcp-builder pdf docx xlsx pptx; do
  target="$HOME/.claude/skills/$skill"
  if [[ -d "$target" ]]; then
    rm -rf "$target"
    ok "skill удалён: $skill"
    REMOVED=$((REMOVED+1))
  fi
done

for agent in deep-research doc-analyzer meeting-notes news-digest parser report-generator router youtube-analyzer; do
  target="$HOME/.claude/agents/$agent.md"
  if [[ -f "$target" ]]; then
    rm -f "$target"
    ok "agent удалён: $agent"
    REMOVED=$((REMOVED+1))
  fi
done

if [[ -d "$HOME/claude-arsenal-runtime" ]]; then
  rm -rf "$HOME/claude-arsenal-runtime"
  ok "runtime удалён: ~/claude-arsenal-runtime"
fi

echo ""
ok "Удалено $REMOVED элементов. Репо $ARSENAL_DIR оставлено на месте."
info "Чтобы убрать репо тоже: rm -rf $ARSENAL_DIR"

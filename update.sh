#!/usr/bin/env bash
# update.sh — обновить skills/агенты из локального репо claude-arsenal.
# Использование: ./update.sh   (или FORCE=1 ./update.sh — перезаписать всё)
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok()    { echo -e "${GREEN}✅ $*${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $*${NC}"; }
fail()  { echo -e "${RED}❌ $*${NC}" >&2; exit 1; }

ARSENAL_DIR="${ARSENAL_DIR:-$HOME/claude-arsenal}"
[[ -d "$ARSENAL_DIR" ]] || fail "репо не найдено: $ARSENAL_DIR (запусти install.sh)"

info "обновляю из $ARSENAL_DIR"
FORCE="${FORCE:-0}"
[[ "$FORCE" == "1" ]] && warn "FORCE=1 — перезаписываю существующие skills/агенты"

SKILLS_NEW=0; SKILLS_SKIP=0
for skill_dir in "$ARSENAL_DIR/skills/"*/; do
  [[ ! -d "$skill_dir" ]] && continue
  name=$(basename "$skill_dir")
  target="$HOME/.claude/skills/$name"
  if [[ -e "$target" && "$FORCE" != "1" ]]; then
    SKILLS_SKIP=$((SKILLS_SKIP+1))
  else
    rm -rf "$target"
    cp -R "$skill_dir" "$target"
    ok "skill: $name"
    SKILLS_NEW=$((SKILLS_NEW+1))
  fi
done

AGENTS_NEW=0; AGENTS_SKIP=0
for agent_file in "$ARSENAL_DIR/agents/"*.md; do
  [[ ! -f "$agent_file" ]] && continue
  name=$(basename "$agent_file")
  target="$HOME/.claude/agents/$name"
  if [[ -e "$target" && "$FORCE" != "1" ]]; then
    AGENTS_SKIP=$((AGENTS_SKIP+1))
  else
    rm -f "$target"
    cp "$agent_file" "$target"
    ok "agent: $name"
    AGENTS_NEW=$((AGENTS_NEW+1))
  fi
done

if [[ -d "$ARSENAL_DIR/runtime" ]]; then
  RUNTIME_TARGET="$HOME/claude-arsenal-runtime"
  cp -R "$ARSENAL_DIR/runtime/." "$RUNTIME_TARGET/" 2>/dev/null || true
  ok "runtime → $RUNTIME_TARGET"
fi

# --- workflows ---
if [[ -d "$ARSENAL_DIR/workflows" ]]; then
  mkdir -p "$HOME/.claude/workflows"
  WORKFLOWS_NEW=0; WORKFLOWS_SKIP=0
  for wf_file in "$ARSENAL_DIR/workflows/"*.js; do
    [[ ! -f "$wf_file" ]] && continue
    name=$(basename "$wf_file")
    target="$HOME/.claude/workflows/$name"
    if [[ -e "$target" && "$FORCE" != "1" ]]; then
      WORKFLOWS_SKIP=$((WORKFLOWS_SKIP+1))
    else
      rm -f "$target"
      cp "$wf_file" "$target"
      ok "workflow: $name"
      WORKFLOWS_NEW=$((WORKFLOWS_NEW+1))
    fi
  done
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ok "Update завершён"
echo "  Skills:    $SKILLS_NEW обновлено, $SKILLS_SKIP пропущено"
echo "  Agents:    $AGENTS_NEW обновлено, $AGENTS_SKIP пропущено"
echo "  Workflows: ${WORKFLOWS_NEW:-0} обновлено, ${WORKFLOWS_SKIP:-0} пропущено"
echo "  (FORCE=1 чтобы перезаписать пропущенные)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ok "Перезапусти Claude Code чтобы изменения подхватились"

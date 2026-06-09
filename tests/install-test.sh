#!/usr/bin/env bash
# install-test.sh — smoke-тест: проверяет, что install.sh не сломал установку
# Запускать после install.sh. В dry-run режиме (DRY_RUN=1) — не трогает ~/.claude/.
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✅ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
fail() { echo -e "${RED}❌ $*${NC}" >&2; }

ARSENAL_DIR="${ARSENAL_DIR:-$HOME/claude-arsenal}"
PASS=0; FAIL=0
check() {
  if eval "$2" >/dev/null 2>&1; then
    ok "$1"; PASS=$((PASS+1))
  else
    fail "$1 — $3"; FAIL=$((FAIL+1))
  fi
}

# --- 1. структура репо ---
check "репо существует" "[[ -d '$ARSENAL_DIR' ]]" "$ARSENAL_DIR не найдено"
check "CLAUDE.md на месте" "[[ -f '$ARSENAL_DIR/CLAUDE.md' ]]" "нет master CLAUDE.md"
check "install.sh на месте" "[[ -f '$ARSENAL_DIR/install.sh' ]]" "нет install.sh"
check "runtime/ скелет" "[[ -d '$ARSENAL_DIR/runtime/shared' && -d '$ARSENAL_DIR/runtime/outputs' && -d '$ARSENAL_DIR/runtime/state' && -d '$ARSENAL_DIR/runtime/messages' ]]" "runtime/ неполный"
check "SKILL_INDEX.md" "[[ -f '$ARSENAL_DIR/docs/SKILL_INDEX.md' ]]" "нет docs/SKILL_INDEX.md"

# --- 2. ожидаемое количество skills/агентов ---
EXPECTED_SKILLS=8
ACTUAL_SKILLS=$(find "$ARSENAL_DIR/skills" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')
check "skills = $EXPECTED_SKILLS" "[[ $ACTUAL_SKILLS -eq $EXPECTED_SKILLS ]]" "найдено $ACTUAL_SKILLS, ожидалось $EXPECTED_SKILLS"

EXPECTED_AGENTS=8
ACTUAL_AGENTS=$(find "$ARSENAL_DIR/agents" -maxdepth 1 -mindepth 1 -type f -name '*.md' | wc -l | tr -d ' ')
check "agents = $EXPECTED_AGENTS" "[[ $ACTUAL_AGENTS -eq $EXPECTED_AGENTS ]]" "найдено $ACTUAL_AGENTS, ожидалось $EXPECTED_AGENTS"

# --- 2.5. workflows (Dynamic Workflows) ---
EXPECTED_WFS=6
ACTUAL_WFS=$(find "$ARSENAL_DIR/workflows" -maxdepth 1 -mindepth 1 -type f -name '*.js' 2>/dev/null | wc -l | tr -d ' ')
[[ "$ACTUAL_WFS" -gt 0 ]] && check "workflows = $EXPECTED_WFS" "[[ $ACTUAL_WFS -eq $EXPECTED_WFS ]]" "найдено $ACTUAL_WFS, ожидалось $EXPECTED_WFS"

# --- 2.6. docs/ ---
check "docs/MODEL_TIERS.md"  "[[ -f '$ARSENAL_DIR/docs/MODEL_TIERS.md' ]]"  "нет docs/MODEL_TIERS.md"
check "docs/PATTERNS.md"     "[[ -f '$ARSENAL_DIR/docs/PATTERNS.md' ]]"     "нет docs/PATTERNS.md"
check "workflows/README.md"  "[[ -f '$ARSENAL_DIR/workflows/README.md' ]]"  "нет workflows/README.md"
check "SKILL_REPORT"         "[[ -f '$ARSENAL_DIR/SKILL_REPORT_2026-06-09.md' ]]" "нет SKILL_REPORT_2026-06-09.md"
check "tools/fetch-references.sh" "[[ -x '$ARSENAL_DIR/tools/fetch-references.sh' ]]" "нет/не исполняемый tools/fetch-references.sh"
check ".gitignore правит reference/" "grep -q '^reference/' '$ARSENAL_DIR/.gitignore'" "reference/ не игнорируется"

# --- 3. каждый skill имеет SKILL.md ---
for skill_dir in "$ARSENAL_DIR/skills/"*/; do
  name=$(basename "$skill_dir")
  check "skill/$name/SKILL.md" "[[ -f '${skill_dir}SKILL.md' ]]" "нет SKILL.md"
done

# --- 4. каждый agent-файл валидный (YAML frontmatter с name/description) ---
for agent_file in "$ARSENAL_DIR/agents/"*.md; do
  name=$(basename "$agent_file")
  has_name=$(head -5 "$agent_file" | grep -c '^name:')
  has_desc=$(head -10 "$agent_file" | grep -c '^description:')
  check "agent/$name — frontmatter" "[[ $has_name -ge 1 && $has_desc -ge 1 ]]" "нет name/description"
done

# --- 5. install.sh валиден (bash -n) ---
check "install.sh синтаксис" "bash -n '$ARSENAL_DIR/install.sh'" "синтаксическая ошибка"
check "update.sh синтаксис"  "bash -n '$ARSENAL_DIR/update.sh'"  "синтаксическая ошибка"
check "uninstall.sh синтаксис" "bash -n '$ARSENAL_DIR/uninstall.sh'" "синтаксическая ошибка"

# --- 5.5. каждый workflow .js — валидный JS (node --check) ---
if command -v node >/dev/null 2>&1; then
  for wf_file in "$ARSENAL_DIR/workflows/"*.js; do
    [[ ! -f "$wf_file" ]] && continue
    name=$(basename "$wf_file")
    check "workflow/$name — JS valid" "node --check '$wf_file'" "синтаксическая ошибка JS"
  done
else
  warn "node не найден — пропускаю JS-валидацию workflow'ов"
fi

# --- 6. master CLAUDE.md содержит ключевые правила ---
check "CLAUDE.md упоминает skills" "grep -q 'скилл' '$ARSENAL_DIR/CLAUDE.md'" "нет упоминания skills"
check "CLAUDE.md упоминает runtime" "grep -q 'runtime' '$ARSENAL_DIR/CLAUDE.md'" "нет упоминания runtime"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ok "Passed: $PASS"
[[ $FAIL -gt 0 ]] && fail "Failed: $FAIL" || ok "Failed: $FAIL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
exit $FAIL
</content>
</invoke>
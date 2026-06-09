#!/usr/bin/env bash
# install.sh — ставит всё из claude-arsenal одной командой
# Использование: curl -fsSL https://raw.githubusercontent.com/x001tk-Igor/claude-arsenal/main/install.sh | bash
# Или: ./install.sh
set -euo pipefail

# --- цвета и утилиты ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok()    { echo -e "${GREEN}✅ $*${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $*${NC}"; }
fail()  { echo -e "${RED}❌ $*${NC}" >&2; exit 1; }

# --- определяем где мы ---
# Если скрипт скачан curl-ом — $0 не указывает на локальный файл, поэтому качаем заново если надо
ARSENAL_DIR="${ARSENAL_DIR:-$HOME/claude-arsenal}"

# --- выбор: локальная установка или из GitHub ---
if [[ -d "$ARSENAL_DIR" && -f "$ARSENAL_DIR/install.sh" ]]; then
  info "использую локальный $ARSENAL_DIR"
else
  info "клонирую x001tk-Igor/claude-arsenal в $ARSENAL_DIR"
  command -v git >/dev/null 2>&1 || fail "git не установлен"
  if [[ -d "$ARSENAL_DIR" ]]; then
    warn "$ARSENAL_DIR уже существует, обновляю..."
    cd "$ARSENAL_DIR" && git pull --quiet || warn "git pull не удался, продолжаю с локальной копией"
  else
    git clone --depth 1 https://github.com/x001tk-Igor/claude-arsenal.git "$ARSENAL_DIR" \
      || fail "не удалось склонировать репо"
  fi
  cd "$ARSENAL_DIR"
fi

# --- проверяем что Claude Code установлен ---
command -v claude >/dev/null 2>&1 || warn "claude CLI не найден в PATH. Установи Claude Code: https://claude.com/claude-code"
mkdir -p ~/.claude/agents ~/.claude/skills ~/.claude/rules

# --- 1. skills ---
info "устанавливаю skills в ~/.claude/skills/"
SKILLS_INSTALLED=0
SKILLS_SKIPPED=0
for skill_dir in "$ARSENAL_DIR/skills/"*/; do
  [[ ! -d "$skill_dir" ]] && continue
  name=$(basename "$skill_dir")
  target="$HOME/.claude/skills/$name"
  if [[ -e "$target" && ! "${FORCE:-}" == "1" ]]; then
    warn "skill '$name' уже есть — пропускаю (FORCE=1 перезапишет)"
    SKILLS_SKIPPED=$((SKILLS_SKIPPED+1))
  else
    rm -rf "$target"
    cp -R "$skill_dir" "$target"
    ok "skill: $name"
    SKILLS_INSTALLED=$((SKILLS_INSTALLED+1))
  fi
done

# --- 2. agents ---
info "устанавливаю agents в ~/.claude/agents/"
AGENTS_INSTALLED=0
for agent_file in "$ARSENAL_DIR/agents/"*.md; do
  [[ ! -f "$agent_file" ]] && continue
  name=$(basename "$agent_file")
  target="$HOME/.claude/agents/$name"
  if [[ -e "$target" && ! "${FORCE:-}" == "1" ]]; then
    warn "agent '$name' уже есть — пропускаю"
  else
    rm -f "$target"
    cp "$agent_file" "$target"
    ok "agent: $name"
    AGENTS_INSTALLED=$((AGENTS_INSTALLED+1))
  fi
done

# --- 3. master CLAUDE.md (опционально, не перезаписывает существующий) ---
if [[ -f "$ARSENAL_DIR/CLAUDE.md" ]]; then
  target="$HOME/.claude/CLAUDE.arsenal.md"
  cp "$ARSENAL_DIR/CLAUDE.md" "$target"
  ok "master CLAUDE.md → ~/.claude/CLAUDE.arsenal.md (подключи вручную если надо)"
fi

# --- 4. runtime-папка для цепочек агентов ---
if [[ -d "$ARSENAL_DIR/runtime" ]]; then
  RUNTIME_TARGET="$HOME/claude-arsenal-runtime"
  if [[ ! -d "$RUNTIME_TARGET" ]]; then
    cp -R "$ARSENAL_DIR/runtime" "$RUNTIME_TARGET"
    ok "runtime → $RUNTIME_TARGET"
  else
    warn "runtime уже есть в $RUNTIME_TARGET — пропускаю"
  fi
fi

# --- 5. karpathy-guidelines через plugin marketplace (если Claude Code поддерживает) ---
if command -v claude >/dev/null 2>&1; then
  info "проверяю Claude Code plugin marketplace для karpathy-guidelines"
  if claude plugin marketplace list 2>/dev/null | grep -q "karpathy-skills"; then
    ok "karpathy marketplace уже добавлен"
  else
    claude plugin marketplace add forrestchang/andrej-karpathy-skills 2>/dev/null \
      && ok "karpathy marketplace добавлен" \
      || warn "не удалось добавить karpathy marketplace (не критично, skill уже в ~/.claude/skills/)"
  fi
fi

# --- итоги ---
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ok "Установка завершена"
echo "  Skills:   $SKILLS_INSTALLED новых, $SKILLS_SKIPPED пропущено"
echo "  Agents:   $AGENTS_INSTALLED новых"
echo "  Repo:     $ARSENAL_DIR"
echo "  Runtime:  $HOME/claude-arsenal-runtime"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
info "Следующие шаги:"
echo "  1. Перезапусти Claude Code чтобы skills/agents подхватились"
echo "  2. Опционально: подключи ~/.claude/CLAUDE.arsenal.md через include в settings.json"
echo "  3. Опционально: для Agent Teams — раскомментируй teammateMode в settings/settings.json"
echo ""

# --- 6. permissions (опционально, через SET_PERMISSIONS=1) ---
if [[ "${SET_PERMISSIONS:-}" == "1" ]]; then
  if [[ -f "$ARSENAL_DIR/settings/settings.template.json" ]]; then
    # бэкап текущего
    [[ -f "$HOME/.claude/settings.json" ]] && cp "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.bak-$(date +%s)"
    cp "$ARSENAL_DIR/settings/settings.template.json" "$HOME/.claude/settings.json"
    ok "permissions обновлены (бэкап: settings.json.bak-*)"
    warn "перезапусти Claude Code чтобы permissions применились"
  fi
fi
echo ""
ok "Готово."

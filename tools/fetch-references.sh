#!/usr/bin/env bash
# fetch-references.sh — скачивает внешние репозитории в reference/ (НЕ для git)
# Использование: ./tools/fetch-references.sh
# Требует: GITHUB_TOKEN с правом read public repos (или ничего — GitHub API лимит 60/ч анонимно).
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLUE}ℹ️  $*${NC}"; }
ok()    { echo -e "${GREEN}✅ $*${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $*${NC}"; }
fail()  { echo -e "${RED}❌ $*${NC}" >&2; exit 1; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# repo -> local_dir
declare -A REPOS=(
  [skill-seekers]="yusufkaraaslan/Skill_Seekers"
  [superpowers]="obra/superpowers"
  [repomix]="yamadashy/repomix"
  [autoresearch]="uditgoenka/autoresearch"
  [context-builder]="glebis/claude-skills"
)

AUTH_HEADER=()
if [[ -n "${GITHUB_TOKEN:-}${GH_TOKEN:-}" ]]; then
  AUTH_HEADER=(-H "Authorization: token ${GITHUB_TOKEN:-${GH_TOKEN:-}}")
fi

for dir in "${!REPOS[@]}"; do
  repo="${REPOS[$dir]}"
  target="$ROOT/reference/$dir"
  if [[ -d "$target" ]] && [[ -n "$(ls -A "$target" 2>/dev/null)" ]]; then
    warn "reference/$dir уже скачан — пропускаю (rm -rf reference/$dir чтобы перекачать)"
    continue
  fi
  mkdir -p "$target"
  info "скачиваю $repo → reference/$dir"
  if ! curl -sL "${AUTH_HEADER[@]}" \
      "https://api.github.com/repos/$repo/tarball" \
      -o /tmp/_ref.tar.gz; then
    fail "curl не смог скачать $repo"
  fi
  if ! tar -xzf /tmp/_ref.tar.gz -C "$target" --strip-components=1; then
    fail "tar не смог распаковать $repo"
  fi
  rm /tmp/_ref.tar.gz
  ok "$dir"
done

echo ""
ok "Готово. Содержимое в reference/ (НЕ коммитится — добавлено в .gitignore)."
info "См. SKILL_REPORT_2026-06-09.md для сводки по каждому."

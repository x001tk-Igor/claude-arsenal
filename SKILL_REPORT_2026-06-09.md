# SKILL_REPORT — анализ 42 скиллов из PDF

**Дата:** 2026-06-09
**Источник:** `/Users/parma/Downloads/42 Claude Skills Prompts.pdf` (45 URL в тексте, 42 категоризированных скилла)
**Критерий отбора:** скиллы для архитекторов/разработчиков AI-агентов и автоматизации бизнес-процессов. Всё про маркетинг/дизайн/SMM/видео-креатив/модерацию/хьюманайзеры/академическое письмо — отброшено на уровне категории PDF, без открытия GitHub.

## Итоги (5 взято из 42)

| # | Skill | GitHub | ⭐ | Берём? | Почему |
|---|-------|--------|------|--------|--------|
| 1 | **Skill Seekers** | [yusufkaraaslan/Skill_Seekers](https://github.com/yusufkaraaslan/Skill_Seekers) | 14k | ✅ **В arsenale** | 18 входных форматов → 12+ AI-платформ одной командой. Превращает наш `~/claude-arsenal` в skill автоматически. 3 445 тестов, MIT, MCP-сервер на 40 инструментов. v3.7.0 |
| 2 | **Superpowers** | [obra/superpowers](https://github.com/obra/superpowers) | 222k | ✅ **В arsenale** | 7-фазный engineering workflow (brainstorm → TDD → review), 14 sub-skills, TDD + systematic-debugging + dispatching-parallel-agents. **Дополняет karpathy-guidelines (принципы) конкретным workflow** |
| 3 | **Repomix** | [yamadashy/repomix](https://github.com/yamadashy/repomix) | 26.1k | ✅ **В arsenale** | CLI/VSCode/MCP/Plugin — пакует репо в 1 AI-friendly файл. Secretlint, .repomixignore, --skill-generate. **Реально нужно для code-review трейдинг-бота** |
| 4 | **Autoresearch** | [uditgoenka/autoresearch](https://github.com/uditgoenka/autoresearch) | 4.9k | ✅ **В arsenale** | Autonomous iteration с метрикой + 9 safety hooks + auto-revert + simplify-gate. **Прямо для оптимизации стратегий трейдинг-бота** (winrate, Sharpe, drawdown). 13 команд |
| 5 | **Context Builder** (glebis) | [glebis/claude-skills/context-builder](https://github.com/glebis/claude-skills) | — | ✅ **В arsenale** | 5-фазный discovery для AI-консалтинга → выдаёт CLAUDE.md context file. 15 секций, Express/Deep Dive режимы, frameworks (BCG 10/20/70, Ng, Deloitte). Полезен для онбординга клиентов |

## Что отброшено на уровне PDF (без открытия GitHub)

| Категория PDF | Примеры | Причина |
|---|---|---|
| 1. DESIGN / UI / VISUAL DESIGN (8) | frontend-design, canvas-design, algorithmic-art, Color Expert, Hand-Drawn Diagrams, claudedesignskills, Nothing Design, Design Auditor | Дизайн, не наш профиль |
| 2. SOCIAL MEDIA / CONTENT (9) | Charlie Hills OS, voice-builder, reels-scripting, post-scorer, youtube-thumbnail, hook-generator, tweetclaw, X Article Publisher, Twitter Algorithm Optimizer | SMM/контент, не наш профиль |
| 3. MARKETING / GROWTH / SEO (8) | Kim Barrett, wondelai, Marketing Module, Marketing Skills, Email Bible, Competitive Ads, GEO/SEO, Social Media Research | Маркетинг/SEO/email, не наш профиль |
| 4. WRITING / RESEARCH / частично (3) | Daydream (knowledge mining), Humanizer (явно), Beautiful Prose, Academic Research, Evidence-Based Dialogue, Anything to NotebookLM | Хьюманайзер, prose, академия — не наше |
| 5. VIDEO / IMAGE / AUDIO / частично (4) | Remotion, GPT Image 2, AI Video Toolkit, AI Music Album, Generative Media, | Креатив-медиа, не наше |
| 6. PRODUCT / PM / Health (4) | PM Skills Marketplace, JTBD Interview, Personal Health, DNA Analysis | Продуктовый discovery / здоровье, не наше |

## Что отброшено ПОСЛЕ открытия GitHub (сомнительные)

| Skill | GitHub | Причина отказа |
|-------|--------|----------------|
| Deep Research Engine | [199-biotechnologies](https://github.com/199-biotechnologies/claude-deep-research-skill) | У нас уже есть `workflows/deep-research.js` (fan-out + 3-judge panel + opus) — другой архитектуры не нужно |
| Vexor Semantic Search | [scarletkc/vexor](https://github.com/scarletkc/vexor) | У нас уже есть grep/find, RAG по кодбазе — нишево |
| Dev Browser | (jqueryscript awesome-claude-code) | У нас есть parser.md, browser automation — overkill |
| Web Scraper | [yfe404/web-scraper](https://github.com/yfe404/web-scraper) | У нас уже parser.md, browser fallback не критичен |
| antfu/skills | [antfu/skills](https://github.com/antfu/skills) | Уже есть karpathy-guidelines + свой набор, пересечение минимальное |

## Что под сомнением (голосовали — НЕ взято в этот раз)

| Skill | Почему отказали |
|-------|-----------------|
| AI Transformation Discovery (glebis) | Прямой продажей AI-консалтинга не занимаемся, discovery делаем руками |

**Внимание:** после захода на GitHub у `glebis/claude-skills` обнаружено **88 под-скиллов**, из которых релевантны нашему фильтру **17 штук** (помимо самого context-builder). Они не форкаются отдельно — лежат в `reference/context-builder/` локально. Если какой-то из них понадобится в работе — копируется индивидуально.

## Что в arsenale из 5 взятых (локально)

Все 5 репозиториев скачаны в `reference/` для изучения (НЕ коммитятся — игнорируются через `.gitignore`, скрипт `tools/fetch-references.sh` восстанавливает):

```
reference/
├── skill-seekers/    41M   (Python, 3 445 тестов, MCP-сервер)
├── superpowers/      1.2M  (14 sub-skills, 7-фазный workflow)
├── repomix/          10M   (TypeScript, CLI/MCP/plugin, 96 релизов)
├── autoresearch/     1.2M  (13 команд, 9 safety hooks)
└── context-builder/  4.3M  (18 sub-skills glebis, отфильтровано из 88)
                       ────
                       58M
```

## План интеграции (что и куда)

| Skill | Где должен жить | Что копируем | Действие |
|-------|-----------------|--------------|----------|
| **Skill Seekers** | `claude-arsenal` (а не как `~/.claude/skill`) | Сам CLI через `pip install skill-seekers`, конфиги для нашего репо | Документируем в `docs/SKILL_REPORT.md` как «генератор скиллов из arsenale», не копируем (он сам всё генерит) |
| **Superpowers** | `~/.claude/skills/superpowers/` | Все 14 sub-skills + meta-инструкции | Копируем в arsenale, обновляем install.sh, ставим глобально |
| **Repomix** | `~/.claude/skills/repomix/` (если есть SKILL.md) ИЛИ как external tool | `SKILL.md` + краткая обёртка + `tools/wrap-repo.sh` (генератор skill из репо) | Копируем SKILL.md, делаем обёртку в `tools/` |
| **Autoresearch** | `~/.claude/skills/autoresearch/` | Все 13 команд + safety hooks | Копируем как есть, исследуем кастомизацию под трейдинг |
| **Context Builder** | `~/.claude/skills/context-builder/` | Скилл + секции + frameworks | Копируем скилл, тестируем на реальном клиентском онбординге |

## Дальнейшие шаги (TODO)

- [ ] **Прочитать исходники 5 репозиториев** (по 1-2 часа каждый) перед копированием
- [ ] **Superpowers**: решить конфликт с `karpathy-guidelines` — оставить оба, развести по фазам
- [ ] **Repomix**: проверить, есть ли готовый `SKILL.md` в репо или это только CLI
- [ ] **Autoresearch**: попробовать на trading-боте (Tasks 39-52 из trading-core-progress)
- [ ] **Context Builder**: проверить 5-фазный discovery на реальном кейсе (придёт клиент)
- [ ] **Skill Seekers**: запустить `skill-seekers create ~/claude-arsenal` и посмотреть, что сгенерит
- [ ] Решить, добавлять ли это всё в **третий коммит** или подождать review
- [ ] Обновить `docs/SKILL_INDEX.md` (когда решим что именно берём в arsenale)

## Мета-вывод

**Фильтр на уровне PDF (а не GitHub) сработал отлично**: 30 из 42 отсеяны за 30 секунд без открытия репозиториев. 6 сомнительных решили голосованием. 5 берём — все попадают в наш профиль «архитектура + автоматизация + AI-агенты».

**Главное открытие:** `glebis/claude-skills` — это не «один скилл», а **курированная библиотека из 88 скиллов** в одном репо. Из них 17 релевантны. В arsenale это пока представлено одним (`context-builder`), но в `reference/` лежит всё на случай если что-то понадобится.

---

## Update 2026-06-10: +1 reference-репо и +5 skills в arsenale

**Источник:** `victorbuto-claude-skills` (5 маркетинговых/исследовательских skills). Не из PDF, найден отдельно.

**Что взяли в arsenale** (все 5, в `skills/`):

| # | Skill | ⭐ | Решение |
|---|-------|------|---------|
| 1 | **`brand-analysis`** | — | ✅ В arsenale. 3 параллельных агента → синтез по 12 блокам. Триггеры: «разбери бренд», «ToV», «анализ позиционирования». |
| 2 | **`research-design`** | — | ✅ В arsenale. SPICE-контекст, цель/задачи/гипотезы. |
| 3 | **`qual-research-design`** | — | ✅ В arsenale. Дизайн полевого: сегменты, метод (глубинки/ФГ/экспертные), количество. |
| 4 | **`segmentation-hypotheses`** | — | ✅ В arsenale. 28 методов Gopractice с оценками Ч/Р/Д. |
| 5 | **`Deep-web-search`** | — | ⚠️ **В arsenale, но с caveat.** Slice-метод (SPICE → 3 параллельных search-подагента) без fact-check. Пересекается по триггерам с `deep-research` workflow. Разделение зафиксировано в README/SKILL_INDEX: skill = лёгкий search, workflow = полноценный research с verify. |

**Изменения в репо:**
- `skills/`: 8 → 13
- `reference/`: 5 → 6 репо (victorbuto добавлен в gitignored reference)
- `CLAUDE.md`, `README.md`, `docs/SKILL_INDEX.md` — обновлены счётчики и описания

**Критерий отбора, который применили:** заполняют пробел в arsenale по маркетинговой/исследовательской вертикали. Все 4 из 5 не пересекаются по триггерам ни с базовыми скиллами, ни друг с другом. 5-й (Deep-web-search) пересекается с workflow, но решаемо через явное разграничение в документации.

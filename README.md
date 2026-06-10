# claude-arsenal

> Куратированный набор skills, агентов и Dynamic Workflows для Claude Code. Одна команда — и всё стоит.

[![Stars](https://img.shields.io/github/stars/x001tk-Igor/claude-arsenal)](https://github.com/x001tk-Igor/claude-arsenal/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-2.1.154%2B-blue)](https://claude.com/claude-code)
[![Tests](https://img.shields.io/badge/tests-41%2F41_passing-brightgreen)](tests/install-test.sh)

**claude-arsenal** — это не «ещё один форк anthropics/skills». Это **тщательно подобранная** под боевые задачи коллекция из:

- **13 skills** — для работы с документами, таблицами, API, кодом (8 базовых + 5 маркетинговых/исследовательских)
- **8 агентов** — для типовых задач (парсинг, отчёты, ресёрч, YouTube, заметки)
- **6 Dynamic Workflows** — оркестрация поверх агентов (fan-out, 3-judge panel, opus synthesis)
- **6 reference-репозиториев** — для будущей интеграции (superpowers, repomix, autoresearch, skill-seekers, context-builder, victorbuto)

## 🚀 Установка одной командой

```bash
curl -fsSL https://raw.githubusercontent.com/x001tk-Igor/claude-arsenal/main/install.sh | bash
```

После установки **перезапусти Claude Code**. Все 27 компонентов подхватятся автоматически:

- Skills → `~/.claude/skills/`
- Agents → `~/.claude/agents/`
- Workflows → `~/.claude/workflows/`

### Альтернативно: вручную

```bash
git clone https://github.com/x001tk-Igor/claude-arsenal.git ~/claude-arsenal
cd ~/claude-arsenal
./install.sh          # стандартная установка
FORCE=1 ./install.sh  # перезаписать существующие
SET_PERMISSIONS=1 ./install.sh  # дополнительно применить permissions из settings/

./update.sh           # обновить из локального репо
FORCE=1 ./update.sh   # с перезаписью
```

### Удаление

```bash
~/claude-arsenal/uninstall.sh   # удалит всё кроме самого репо
```

## 📦 Что входит

### Skills (13) — для Claude Code

Скилл = переиспользуемый workflow, активируется автоматически по `description` в YAML-шапке. Или явно: «используй skill `pdf` для этого».

| Skill | Когда брать | Установка |
|-------|-------------|-----------|
| **`karpathy-guidelines`** | Писать/ревьюить/рефакторить код. 4 принципа: думай → просто → хирургически → goal-driven. | automatic |
| **`claude-api`** | Код импортирует `anthropic` / `@anthropic-ai/sdk` / `claude_agent_sdk`. НЕ брать если OpenAI/Gemini. | automatic |
| **`pdf`** | Создать / прочитать / заполнить / merge / split / OCR. | automatic |
| **`docx`** | Создать / редактировать Word (.docx) с трекингом изменений, комментариями. | automatic |
| **`xlsx`** | Excel-таблицы с формулами, графиками, форматированием. | automatic |
| **`pptx`** | PowerPoint-презентации (программно, через python-pptx). | automatic |
| **`google-sheets`** | Работа с Google Sheets через API — формулы, графики, форматирование. | automatic |
| **`mcp-builder`** | Создать новый MCP-сервер (Python FastMCP или Node/TS SDK). | automatic |

#### Маркетинговые / исследовательские (5) — victorbuto

| Skill | Когда брать | Триггеры |
|-------|-------------|----------|
| **`brand-analysis`** | Глубокий разбор бренда: позиционирование, ToV, ЦА, RTB, коммуникация. 3 параллельных агента + синтез. | «разбери бренд», «ToV», «анализ позиционирования», «brand analysis» |
| **`research-design`** | Постановка задач исследования: SPICE-контекст, цель/задачи/гипотезы, фидбэк по критериям. | «помоги поставить задачи исследования», «проверь гипотезы», «research questions» |
| **`qual-research-design`** | Дизайн качественного полевого: сегменты, метод (глубинки/ФГ/экспертные), расчёт количества. | «дизайн исследования», «сколько интервью», «fieldwork design» |
| **`segmentation-hypotheses`** | Выбор метода сегментации (28 методов Gopractice) + гипотезы сегментов. | «сегментация», «гипотезы сегментов», «audience segments» |
| **`Deep-web-search`** ⚠️ | Slice-метод поиска с 3 параллельными подагентами. Только search execution, без fact-check. | «search keywords», «find information», «research» |

⚠️ **Пересечение:** `Deep-web-search` skill и `deep-research` workflow оба триггерятся на «research» / «найди информацию». Разделение:
- `deep-research` workflow — **полноценный research** со scope → fan-out → 3-judge verify → opus synthesis (тяжёлый, для финальных отчётов)
- `Deep-web-search` skill — **лёгкий search** по Slice-методу, без verify (быстро пробить коммерческий шум)

**Ключевой дизайн-принцип:** каждый skill — это **3 слоя** (description → instructions → tools). Skills без `tools/` — это просто промты, и они дают на 90% меньше пользы. Все наши skills заполнены.

### Агенты (8) — для Agent Teams

Агент = специализированный subagent, вызывается через `Agent(name, prompt)`. Требует Agent Teams (tmux).

| Агент | Что делает | Пример вызова |
|-------|-----------|---------------|
| **`router`** | Lead-агент. Маршрутизирует запросы к специализированным агентам, строит цепочки. | «спарси вакансии HH и сделай отчёт» |
| **`deep-research`** | Глубокий ресёрч темы с выдачей структурированного отчёта. | «исследуй состояние рынка AI-агентов в 2026» |
| **`news-digest`** | Топ-10 новостей по теме за период. | «дайджест новостей про трейдинг за неделю» |
| **`parser`** | Парсит веб-страницы в Google Sheets / CSV / XLSX. | «спарси вакансии Python-разработчика с HH» |
| **`report-generator`** | Сырые данные → PDF / XLSX отчёт с визуализацией. | «сделай отчёт по продажам за Q1» |
| **`doc-analyzer`** | PDF / DOCX / изображения / код → структурированный анализ. | «проанализируй этот PDF» |
| **`youtube-analyzer`** | YouTube-видео → транскрипт + саммари. | «выжимка этого видео на 30 мин» |
| **`meeting-notes`** | Транскрипт встречи → саммари, решения, action items. | «заметки по встрече с клиентом» |

### Dynamic Workflows (6) — оркестрация поверх агентов

Требует Claude Code **v2.1.154+** (Dynamic Workflows — research preview). Воркфлоу = JS-скрипт, запускаемый через `Workflow({script: ...})`. Делает fan-out агентов, состязательную проверку, финальный synthesis.

Доступны как команды `/<name>` после установки.

| Команда | Фазы | Что делает | Модели |
|---------|------|-----------|--------|
| **`/analyze-competitors`** | 2 | Конкуренты → таблица + пробелы рынка | sonnet → opus |
| **`/deep-research`** | 4 | Scope → fan-out search → **3-judge verify** → отчёт | haiku → sonnet → sonnet → opus |
| **`/data-analytics`** | 2 | Массив записей (отзывы/заявки) → темы, тональность, инсайты | haiku → opus |
| **`/content-angles`** | 3 | Тема → 6 линз → 3-judge panel → топ-3 идеи | sonnet → sonnet → opus |
| **`/audience-insights`** | 2 | Кастдевы / комменты / анкеты → боли / сегменты / цитаты | haiku → opus |
| **`/codebase-audit`** | 3 | Find per file → **adversarial verify** → подтверждённые проблемы | sonnet → sonnet → opus |

**Архитектурный паттерн** (одинаковый для всех 6):

```
fan-out (parallel, дешёвая модель)
    ↓
[опционально] состязательная проверка (3-judge panel, sonnet)
    ↓
финальный synthesis (opus, ОДИН вызов в самом конце)
```

Подробнее — [`docs/PATTERNS.md`](docs/PATTERNS.md) и [`docs/MODEL_TIERS.md`](docs/MODEL_TIERS.md).

### Reference (5 репозиториев, НЕ ставятся автоматически)

В `reference/` лежат локальные клоны 5 репозиториев, отобранных после анализа 42 скиллов из PDF «42 Claude Skills Prompts». Эти **кандидаты на включение** в arsenale — изучены, но не форкнуты. Если какой-то нужен — скачай через `tools/fetch-references.sh`.

| Репо | ⭐ | Зачем может пригодиться |
|------|------|--------------------------|
| **`superpowers`** | 222k | 7-фазный engineering workflow + 14 sub-skills (TDD, debugging, code review) |
| **`repomix`** | 26.1k | Пакует репо в 1 файл для code review / AI-context (с secretlint) |
| **`skill-seekers`** | 14k | 18 форматов → 12+ AI-платформ одной командой |
| **`autoresearch`** | 4.9k | Autonomous iteration с метрикой + 9 safety hooks |
| **`context-builder`** | — | 5-фазный discovery для AI-консалтинга → выдаёт CLAUDE.md |
| **`victorbuto-claude-skills`** | — | 5 маркетинговых/исследовательских skills (brand-analysis, research-design, qual-research-design, segmentation-hypotheses, Deep-web-search) — **уже включены в arsenale** |

Полный отчёт с обоснованиями — [`SKILL_REPORT_2026-06-09.md`](SKILL_REPORT_2026-06-09.md).

## 🏗 Архитектура

```
┌─────────────────────────────────────────────────────┐
│  Claude Code (CLI)                                  │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌────────────────┐    │
│  │ Skills   │  │ Agents   │  │ Workflows      │    │
│  │ (13)     │  │ (8)      │  │ (6)            │    │
│  │ auto-    │  │ tmux +   │  │ v2.1.154+      │    │
│  │ trigger  │  │ Agent    │  │ JS scripts     │    │
│  │          │  │ Teams    │  │                │    │
│  └────┬─────┘  └────┬─────┘  └────────┬───────┘    │
│       │             │                │            │
│       └─────────────┴────────────────┘            │
│                     ↓                              │
│       ┌─────────────────────────┐                 │
│       │ runtime/ (shared/outputs│                 │
│       │  /state/messages)       │                 │
│       │  — контракт для цепочек │                 │
│       └─────────────────────────┘                 │
└─────────────────────────────────────────────────────┘
```

**Три слоя:**
1. **Skills** — самая нижняя абстракция, триггерятся автоматически
2. **Agents** — subagent-обёртки, требуют Agent Teams (tmux)
3. **Workflows** — JS-скрипты с явной оркестрацией, требуют Dynamic Workflows

**Когда что использовать:**
- Skill подошёл → используй
- Skill триггерится нечётко / задача комплексная → Agent
- Задача требует N параллельных вызовов, верификации, synthesis → Workflow

## 📋 Требования

- **Claude Code v2.1.154+** (для Dynamic Workflows)
- **Тариф Max / Team / API** для Workflows (на Pro — включи тумблер в `/config`)
- **WebSearch** (для `/deep-research`)
- **tmux** (опционально, для Agent Teams)

Проверить версию: `claude --version`

## 📚 Документация

| Файл | Что внутри |
|------|-----------|
| [**CLAUDE.md**](CLAUDE.md) | Master-инструкция arsenale: правила, runtime-контракт, чек-листы |
| [**CONTRIBUTING.md**](CONTRIBUTING.md) | Как создавать skills и агентов в arsenale |
| [**docs/SKILL_INDEX.md**](docs/SKILL_INDEX.md) | Полный каталог с описаниями всех 27 компонентов |
| [**docs/MODEL_TIERS.md**](docs/MODEL_TIERS.md) | Когда использовать haiku / sonnet / opus |
| [**docs/PATTERNS.md**](docs/PATTERNS.md) | 3 ключевых паттерна: fan-out, 3-judge panel, pipeline без барьера |
| [**docs/PERMISSIONS.md**](docs/PERMISSIONS.md) | Объяснение `acceptEdits` режима и allow/deny списков |
| [**SKILL_REPORT_2026-06-09.md**](SKILL_REPORT_2026-06-09.md) | Аудит 42 скиллов из PDF, отбор 5 референсных |
| [**workflows/README.md**](workflows/README.md) | Полная документация по Dynamic Workflows |

## 🔬 Тестирование

```bash
cd ~/claude-arsenal
bash tests/install-test.sh
```

Текущий статус: **41/41 проверок passing** (структура репо, валидность JS, синтаксис shell, frontmatter).

## 🛣 Roadmap

- [ ] Интегрировать `superpowers` (7-фазный engineering workflow) — после глубокого изучения
- [ ] Попробовать `autoresearch` на trading-стратегиях (Tasks 39-52 trading-core)
- [ ] Запустить `skill-seekers` на самом arsenale — что сгенерит?
- [ ] CI через GitHub Actions (запуск `tests/install-test.sh` на push)
- [ ] Release v1.0.0 (tag + release notes)
- [ ] Больше workflows: `code-review`, `data-pipeline`, `test-generator`

## 🤝 Контрибьюция

См. [CONTRIBUTING.md](CONTRIBUTING.md). Главный принцип:

> **Skill = 3 слоя. Description → Instructions → Tools. Без tools — это не skill, а промт.**

## 📜 Лицензия

MIT — см. [LICENSE](LICENSE).

## ⚠️ Дисклеймер

claude-arsenal — набор инструментов. Используй на свой страх и риск. Автор не несёт ответственности за результаты торговли, парсинга, и прочих автоматизированных действий.

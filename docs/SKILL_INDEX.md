# SKILL_INDEX — что входит в claude-arsenal

Полный список куратированных skills и агентов. Установка: `./install.sh`.

## Skills (13)

### Базовые (8) — anthropics/skills + karpathy

| Skill | Когда брать | Источник |
|-------|-------------|----------|
| `karpathy-guidelines` | Писать/ревьюить/рефакторить код. 4 принципа: думай → просто → хирургически → goal-driven. | forrestchang/andrej-karpathy-skills |
| `claude-api` | Код импортирует `anthropic`/`@anthropic-ai/sdk`/`claude_agent_sdk`. НЕ трогать если OpenAI/Gemini. | anthropics/skills |
| `pdf` | Создать/прочитать/заполнить PDF. `reportlab`, `pypdf`, `pdftk`. | anthropics/skills |
| `docx` | Создать/редактировать Word (.docx) с трекингом изменений, комментариями. | anthropics/skills |
| `xlsx` | Excel-таблицы с формулами, графиками, форматированием. | anthropics/skills |
| `pptx` | PowerPoint-презентации. | anthropics/skills |
| `google-sheets` | Работа с Google Sheets через API — формулы, графики, форматирование. | anthropics/skills |
| `mcp-builder` | Создать новый MCP-сервер. | anthropics/skills |

### Маркетинговые / исследовательские (5) — victorbuto

| Skill | Когда брать | Триггеры |
|-------|-------------|----------|
| `brand-analysis` | Глубокий разбор бренда: позиционирование, ToV, ЦА, RTB, коммуникация. 3 параллельных агента + синтез. | «разбери бренд», «ToV», «анализ позиционирования», «brand analysis» |
| `research-design` | Постановка задач исследования: SPICE-контекст, цель/задачи/гипотезы, фидбэк по критериям. | «помоги поставить задачи исследования», «проверь гипотезы», «research questions» |
| `qual-research-design` | Дизайн качественного полевого исследования: сегменты, метод (глубинки/ФГ/экспертные), расчёт количества. | «дизайн исследования», «сколько интервью», «fieldwork design» |
| `segmentation-hypotheses` | Выбор метода сегментации (28 методов Gopractice) + гипотезы сегментов. | «сегментация», «гипотезы сегментов», «audience segments» |
| `Deep-web-search` | ⚠️ **Slice-метод поиска** с 3 параллельными подагентами. Только search execution, без fact-check. | «search keywords», «find information», «research» |

⚠️ **Пересечение с `deep-research` workflow:** оба триггерятся на «research» / «найди информацию». Разделение:
- **`deep-research` workflow** — полноценный research: scope → fan-out search → **3-judge verify → opus synthesis** (тяжёлый, для финальных отчётов)
- **`Deep-web-search` skill** — лёгкий search по Slice-методу: только генерация ключевых слов + 3 параллельных поиска (для быстрого пробивания коммерческого шума)

## Агенты (8)

| Агент | Что делает | Когда вызывать |
|-------|-----------|----------------|
| `router` | Маршрутизирует задачи → цепочки агентов | «сделай цепочку для X» (нужен tmux + Agent Teams) |
| `deep-research` | Глубокий ресёрч: поиск + adversarial verify | «Исследуй тему X с фактчекингом» |
| `news-digest` | Топ-10 новостей по теме за период | «Дайджест новостей про X за неделю» |
| `parser` | Парсит веб-страницы в таблицы/CSV/XLSX | «Спарси вакансии HH» |
| `report-generator` | Сырые данные → PDF/XLSX отчёт с визуализацией | «Сделай отчёт по продажам за Q1» |
| `doc-analyzer` | PDF/DOCX/изображения/код → структурированный анализ | «Проанализируй этот PDF» |
| `youtube-analyzer` | YouTube-видео → транскрипт + саммари | «Сделай выжимку этого видео» |
| `meeting-notes` | Транскрипт встречи → саммари, решения, action items | «Сделай заметки по встрече» |

## Workflows (6, Dynamic Workflows v2.1.154+)

Это **слой оркестрации поверх агентов**: один JS-скрипт запускает веер агентов, состязательную проверку и финальный synthesis. Подробнее — `workflows/README.md`, `docs/PATTERNS.md`.

| Workflow | Команда | Что делает |
|----------|---------|------------|
| `analyze-competitors.js` | `/analyze-competitors` | Конкуренты → таблица + пробелы рынка |
| `deep-research.js` | `/deep-research` | Scope → fan-out search → 3-judge verify → отчёт |
| `data-analytics.js` | `/data-analytics` | Аналитика массива записей (отзывы/заявки) |
| `content-angles.js` | `/content-angles` | 6 линз → 3-judge panel → топ-3 идеи |
| `audience-insights.js` | `/audience-insights` | Кастдевы/комменты → боли/сегменты/цитаты |
| `codebase-audit.js` | `/codebase-audit` | Find per file → adversarial verify → подтверждённые проблемы |

## Reference (5 репозиториев, не в arsenale)

Подробный отчёт — [`SKILL_REPORT_2026-06-09.md`](../SKILL_REPORT_2026-06-09.md). Это **кандидаты на включение** в следующие версии arsenale. Локально скачиваются через `./tools/fetch-references.sh` (НЕ коммитятся).

| Skill | ⭐ | Зачем нам |
|-------|------|-----------|
| `Skill Seekers` | 14k | Генерирует скиллы из 18 форматов → 12+ AI-платформ одной командой |
| `Superpowers` | 222k | 7-фазный engineering workflow + 14 sub-skills (TDD, debugging, code review) |
| `Repomix` | 26.1k | Пакует репо в 1 файл для code-review, secretlint из коробки |
| `Autoresearch` | 4.9k | Autonomous iteration с метрикой + safety hooks (для оптимизации трейдинг-стратегий) |
| `Context Builder` (glebis) | — | 5-фазный discovery для AI-консалтинга → выдаёт CLAUDE.md |

## Что НЕ вошло (и почему)

Удалено из `anthropics/skills` после аудита:

- `algorithmic-art`, `canvas-design`, `web-artifacts-builder` — узкие креативные задачи
- `brand-guidelines` — корпоративный брендинг, нишево
- `theme-factory` — пересекается с frontend-design
- `slack-gif-creator` — слишком нишево

## Как добавить свой

1. Скопируй `templates/skill-structure.md` → `skills/<my-skill>/SKILL.md`
2. Заполни все 3 слоя (description / instructions / tools)
3. `./install.sh` или `./update.sh`
4. Добавь строку в этот файл

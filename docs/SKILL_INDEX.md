# SKILL_INDEX — что входит в claude-arsenal

Полный список куратированных skills и агентов. Установка: `./install.sh`.

## Skills (8)

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

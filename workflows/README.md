# workflows/ — Dynamic Workflows (Claude Code v2.1.154+)

6 готовых воркфлоу от Никиты Велса, бонус к ролику про Dynamic Workflows. Каждый — JS-скрипт, который Claude Code запускает через `Workflow({script: ...})`. Один входной аргумент → веер агентов → один Markdown-отчёт на выходе.

## Установка

`install.sh` ставит их в `~/.claude/workflows/` (глобально) или `~/.claude/projects/<project>/workflows/` (per-project). После перезапуска Claude Code они появляются как команды `/<name>` (имя берётся из поля `name:` в `meta`).

## Требования

- Claude Code **v2.1.154+** (Dynamic Workflows — research preview)
- Тариф **Max / Team / API** (Pro — включить в `/config`)
- Для `deep-research` — доступ к `WebSearch`

## Воркфлоу

| Файл | Команда | Что делает | Фазы | Модели |
|---|---|---|---|---|
| `analyze-competitors.js` | `/analyze-competitors` | Конкуренты: по агенту на конкурента → таблица + пробелы рынка | 2 | sonnet → opus |
| `deep-research.js` | `/deep-research` | Ресёрч: scope → fan-out search → 3-judge verify → отчёт | 4 | haiku → sonnet → sonnet → opus |
| `data-analytics.js` | `/data-analytics` | Аналитика массива записей (отзывы/заявки): темы, тональность, инсайты | 2 | haiku → opus |
| `content-angles.js` | `/content-angles` | Контент-идеи: 6 линз → 3-judge panel → топ-3 | 3 | sonnet → sonnet → opus |
| `audience-insights.js` | `/audience-insights` | Аудитория: кастдевы/комменты/анкеты → боли/возражения/сегменты/цитаты | 2 | haiku → opus |
| `codebase-audit.js` | `/codebase-audit` | Аудит кода: find per file → adversarial verify → подтверждённые проблемы | 3 | sonnet → sonnet → opus |

## Как вызвать

```
/deep-research куда пойдёт курс рубля к доллару в ближайший квартал
/analyze-competitors Cursor vs Copilot vs Windsurf в нише AI-редакторов
/codebase-audit paths=src/api,src/auth.ts focus=security
```

Прогресс виден в `/workflows`. Любой запуск можно остановить — сделанное не пропадёт.

## Структурированный ввод (args)

Каждый воркфлоу понимает `args`. Можно передать явно:

| Воркфлоу | Пример args |
|---|---|
| analyze-competitors | `{ niche: "AI-курсы", competitors: ["A","B","C"] }` |
| deep-research | `"Твой вопрос целиком"` или `{ question: "..." }` |
| data-analytics | `{ goal: "выдели боли", items: ["отзыв1","отзыв2"] }` |
| content-angles | `{ topic: "AI для бизнеса", format: "YouTube" }` |
| audience-insights | `{ sources: ["кастдев...","комменты...","анкета..."] }` |
| codebase-audit | `{ paths: ["src/api/","src/auth.ts"], focus: "security" }` |

## Архитектура (общая для всех 6)

```
fan-out (parallel, дешёвая модель)
  ↓
[опционально] состязательная проверка (3-judge panel, sonnet)
  ↓
финальный synthesis (opus, один вызов)
```

Подробнее — в `docs/PATTERNS.md` (fan-out, 3-judge, pipeline без барьера) и `docs/MODEL_TIERS.md` (почему haiku/sonnet/opus именно так).

## Как поправить под себя

Файлы — обычный JS. Можно открыть и поменять:

- **Линзы/углы** — массив `LENSES` в `content-angles.js`
- **Модели по фазам** — `model: 'haiku' | 'sonnet' | 'opus'`
- **Потолки на объём** — `MAX`, `CHUNK`, `MAX_CHUNKS`

Или попросить Claude: «открой `content-angles.js` и добавь линзу про FOMO».

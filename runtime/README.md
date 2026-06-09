# runtime/ — контракт для цепочек агентов

Агенты в цепочке общаются через файлы, а не через SendMessage. Это экономит токены и переживает падения.

## Структура

```
runtime/
├── shared/     # промежуточные данные между агентами
├── outputs/    # финальные результаты
├── state/      # статус pipeline (pipeline-status.json)
└── messages/   # handoff-сообщения между агентами
```

## Контракт

Каждый агент при завершении:

1. Сохраняет результат в `outputs/<agent-name>-<timestamp>.`
2. Если работает в цепочке — кладёт JSON-манифест в `shared/<agent-name>.json` со схемой:
   ```json
   { "agent": "...", "status": "ok|error", "output_files": [...], "next": "..." }
   ```
3. Обновляет `state/pipeline-status.json` (см. schema в `state/SCHEMA.md`).

## Переменные окружения

Агент получает пути через env (install.sh создаёт в `~/claude-arsenal-runtime/symlinks`):

- `ARSENAL_RUNTIME_SHARED` → `shared/`
- `ARSENAL_RUNTIME_OUTPUTS` → `outputs/`
- `ARSENAL_RUNTIME_STATE` → `state/`
- `ARSENAL_RUNTIME_MESSAGES` → `messages/`


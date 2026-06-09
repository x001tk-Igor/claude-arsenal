---
name: <agent-name>
description: <one-line — когда вызывать этого агента>. Use when <триггерная фраза>.
tools: <comma-separated list, e.g. WebSearch, WebFetch, Read, Write, Bash>
---

# <Agent Name>

<2-3 предложения: что делает и в каких случаях себя оправдывает.>

## Когда вызывать

- <сценарий 1>
- <сценарий 2>
- НЕ вызывать, если: <антисценарий>

## Workflow

1. <шаг 1>
2. <шаг 2>
3. <шаг 3>

## Output

Сохраняет в `outputs/<agent-name>-<timestamp>.md` + JSON-манифест в `shared/<agent-name>.json`:

```json
{
  "agent": "<agent-name>",
  "status": "ok|error",
  "output_files": ["..."],
  "next": "<имя следующего агента или null>"
}
```

## Tools & fallbacks

| Primary | Fallback | Когда переключаться |
|---------|----------|---------------------|
| WebSearch | WebFetch (curl direct URL) | если MCP недоступен |
| Brave Search | — | для свежих новостей (<24ч) |
| yt-dlp CLI | — | для YouTube транскриптов |

Если основной tool падает → переключись на fallback → если и тот — верни `status: error` с описанием в `error`.
</content>
</invoke>
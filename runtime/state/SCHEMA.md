# pipeline-status.json schema

```json
{
  "pipeline": "<string-id, kebab-case>",
  "last_update": "<ISO8601 timestamp>",
  "stages": [
    {
      "name": "<agent-name>",
      "status": "pending|running|ok|error|skipped",
      "started_at": "<ISO8601>",
      "finished_at": "<ISO8601|null>",
      "output_files": ["<relpath>", ...],
      "error": "<string|null>"
    }
  ]
}
```

Router пишет сюда при старте цепочки. Агенты обновляют свою секцию при завершении.

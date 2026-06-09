# PATTERNS — три ключевых паттерна из bonus-workflows

Эти паттерны уже работают в production-ворофлоу Никиты Велса. Берём как референс.

## 1. Fan-out: `parallel()` по объектам

**Когда:** N однотипных задач, каждая про свой объект (конкурент, файл, источник, угол).

**Зачем:** 5 минут вместо 25 — агенты параллельны и независимы, не ждут друг друга.

```js
const cards = await parallel(competitors.map(c => () =>
  agent(`...промпт с переменной ${c}...`, {
    model: 'sonnet',
    schema: CARD,            // структура выхода
  })
)).then(r => r.filter(Boolean))
```

**Правила:**
- Каждый агент должен быть **самодостаточен** — не зависеть от соседа
- `label: \`research:${c}\`.slice(0, 40)` — короткий лейбл для `/workflows`
- `model: 'sonnet'` (или haiku для рутины) — opus тут избыточен
- `.filter(Boolean)` — на случай если один из агентов упал

## 2. 3-judge panel / adversarial verify

**Когда:** нужно отсеять ложные срабатывания, фактчек, выбрать лучшее из N.

**Зачем:** один агент — одна перспектива, и он ошибается. 3 независимых судьи → консенсус.

```js
const verified = await parallel(found.map(f => () =>
  parallel([0, 1, 2].map(i => () =>
    agent(`...промпт с фактом ${f}...`, {
      model: 'sonnet',
      schema: VERDICT,        // { refuted: bool, note: string }
    })
  )).then(votes => {
    const passed = votes.filter(Boolean).filter(v => !v.refuted).length
    return passed >= 2 ? f : null   // ≥2 из 3 не опровергли
  })
)).then(r => r.filter(Boolean))
```

**Варианты применения:**
- **Adversarial fact-check** (deep-research): судья пытается **опровергнуть** факт
- **3-judge panel** (content-angles): судья оценивает по 3 критериям **независимо**
- **Состязательная верификация** (codebase-audit): после поиска проблем — перепроверка

**Правила:**
- Судьи должны быть **независимы** (не видят оценок друг друга — `parallel` решает это)
- Консенсус — `≥2 из 3`, не единогласие (иначе слишком жёстко)
- Промпт судьи явно говорит «твоя задача — **опровергнуть/оценить строго**», не подтвердить

## 3. Pipeline без барьера: каждый объект идёт «поиск → проверка» независимо

**Когда:** большие массивы, разная скорость обработки. Если делать через `parallel → parallel` — все ждут самого медленного на каждом шаге.

**Зачем:** pipeline прогоняет каждый объект через все стадии **сразу**, без глобального барьера.

```js
// pipeline: каждая находка сразу верифицируется, без ожидания всех находок
const results = await pipeline(
  findings,
  f => agent(`...поиск...`, { model: 'sonnet', schema: FIND }),
  (res, f) => parallel(res.findings.map(x => () =>
    agent(`...проверка x...`, { model: 'sonnet', schema: VERD })
  )).then(arr => arr.filter(Boolean))
)
```

**Когда НЕ использовать pipeline:** если на стадии 2 нужно **сравнить** результаты стадии 1 между собой (дедупликация, общая картина, "ничего не нашлось → стоп"). Тогда — `parallel()` с барьером.

## Связь с правилами claude-arsenal

| Паттерн | Где лежит в arsenale |
|---|---|
| Fan-out | `agents/parser.md`, `agents/deep-research.md` — оба используют параллельный сбор |
| Adversarial verify | Только в `workflows/deep-research.js` (пока нет в md-агенте — стоит добавить) |
| Pipeline без барьера | `workflows/codebase-audit.js` — единственный пример в репо |
| Стратегия моделей | `docs/MODEL_TIERS.md` — шпаргалка haiku/sonnet/opus |
| 5-частная структура промпта | `templates/agent-with-mcp-fallback.md` (нужно расширить) |

# Component Patterns

Not a full component library. A set of patterns to reuse when generating frontends with AI. These patterns apply across surfaces: web, CLI, Telegram.

## Card — The Universal Container

```
┌─────────────────────────────────────┐
│ [Status]           [Type]  [Action] │
│                                     │
│ Title                               │
│ Subtitle / metadata                 │
│                                     │
│ Key metric or summary               │
│                                     │
│ [Secondary action]    [Primary CTA] │
└─────────────────────────────────────┘
```

Use for: Deal summaries, agent status, tool output, any single-object view.

## Data Table — For Lists of Objects

```
┌──────────┬──────────┬─────────┬────────┐
│ Name ↕   │ Status   │ Value   │ Action │
├──────────┼──────────┼─────────┼────────┤
│ Row      │ ● Active │ $1.2M   │ View → │
│ Row      │ ○ Pending│ $800K   │ View → │
└──────────┴──────────┴─────────┴────────┘
```

Use for: Deal pipeline list, task boards, agent registry, candidate lists.

## Status Badge — Consistent Everywhere

- `● Active` — green (`--color-status-active`)
- `◐ Pending` — amber (`--color-status-pending`)
- `✕ Error` — red (`--color-status-error`)
- `○ Inactive` — gray (`--color-status-inactive`)

Same indicators in web UI, CLI output, Telegram messages. No variations.

## CLI Output — Structured for Scanning

```
[2026-02-28 14:30] ✓ Deal sourced: Acme Testing Labs
  Revenue: $1.2M | Profit: $380K | Ask: $1.5M
  Source: BizBuySell | Confidence: 0.82
  → Run: openclaw evaluate --deal acme-testing-labs
```

Pattern: timestamp + status icon + object name, then indented key-value pairs, then actionable next command.

## Telegram Bot — Concise, Actionable

```
🔍 New Deal Found

Acme Testing Labs
Revenue: $1.2M | Profit: $380K
Ask: $1.5M | Conf: 82%

/evaluate acme-testing-labs
/skip acme-testing-labs
/details acme-testing-labs
```

Pattern: emoji status + object name, key metrics on one line, slash commands for actions.

## AI Frontend Generation Prompt Pattern

When generating a new UI with Claude or another LLM:

```
"Build a [thing]. Next.js + TypeScript + Tailwind + shadcn/ui.
Use design tokens from platform-docs/design/design-tokens.css.
[Component pattern] for [object]. [Design principle] emphasis.
Reference the object model: [relevant objects]."
```

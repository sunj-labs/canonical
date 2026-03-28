# Usability Check — Post-Build Gate for UI Changes

## Purpose
Every user-facing change gets a usability check before merge. This catches
jargon, accessibility failures, layout issues, and consistency drift that
automated tests cannot detect.

## When to run
- After any commit touching page routes (`src/app/**/page.tsx`) or
  components (`src/components/**/*.tsx`)
- The pre-commit hook reminds you, but you are responsible for running it
- For significant UI changes, screenshot each surface and attach to PR

## Checklist

### 1. Role check
Sign in as the least-privileged role (VIEWER/COLLABORATOR). Every page
must make sense without operator/admin context. If the user sees operator
jargon, internal state labels, or debugging information, it fails.

### 2. Scanning distance
No label...........value patterns wider than ~150px. Financial data
should use labels-above-values (vertical scanning), not label-left
value-right (horizontal scanning). Reference: Lupton, Thinking with Type —
vertical eye movement is natural for comparison; horizontal is fatiguing.

### 3. Typography hierarchy
- Key numbers (price, score, SDE): 14px+ font, bold weight
- Labels: smaller than values, muted color, above or beside the value
- No text smaller than 11px on any production surface
- Score/status badges use icon treatment (filled shapes), not plain text

### 4. Jargon & copy
- No database enums visible to users (BIZBUYSELL → BizBuySell)
- No operator/engineering terms without context (enrichment, canonical, funnel gate)
- Financial terms are industry-standard, not simplified per persona (SDE stays SDE)
- All user-facing labels flow through externalized resource bundles (copy system)
- Labels are multi-tenant ready (no hardcoded tenant names)

### 5. Attribution
- Family/team feedback shows WHO (names), not just aggregate counts
- Members who haven't responded shown as "Not yet reviewed" (social proof)
- Author's own contributions visually distinct from others' feedback

### 6. Accessibility
- Tap targets: 44px minimum on interactive elements (WCAG 2.5.5)
- Color contrast: solid colors for badges and status indicators
- No translucent/semi-transparent backgrounds on text-bearing elements
- Mobile: content stacks vertically, no horizontal scroll
- Text: sufficient contrast ratio (4.5:1 minimum for body text)

### 7. Consistency
- Same badge/score treatment on all surfaces (list rows, cards, detail pages)
- Same financial layout across all detail views
- Same status/type badges (SBA Eligible, 1031 Exchange, Operating) everywhere
- Navigation labels match page headings

## Implementation in repos

### Hook (pre-commit)
When UI files are staged, the pre-commit hook should print a reminder to
run this checklist. It does NOT block the commit — it's a reminder.

```bash
# In pre-commit hook:
STAGED_UI=$(git diff --cached --name-only -- 'src/app/**/page.tsx' 'src/components/**/*.tsx')
if [ -n "$STAGED_UI" ]; then
  echo "📋 UI change detected — run usability checklist"
fi
```

### Rule file
Copy this checklist to `.claude/rules/usability-check.md` in each repo
with a user-facing surface.

## Failure patterns (from real incidents)

| Pattern | Example | Caught by |
|---------|---------|-----------|
| Horizontal scanning | `Asking Price...........$4.5M` | #2 Scanning distance |
| DB enum leak | Showing "FRANCHISE_RESALE" to family | #4 Jargon |
| Translucent badges | Light purple on white background | #6 Accessibility |
| Count without names | "Family: 2 👍 1 👎" (who?) | #5 Attribution |
| Operator landing page | Showing pipeline ops to VIEWER | #1 Role check |
| Score as plain text | "Score: 62" without visual weight | #3 Typography |

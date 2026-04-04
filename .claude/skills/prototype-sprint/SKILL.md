---
name: prototype-sprint
description: "Produce 2-3 lightweight visual prototypes with different dominant luminaries. Operator compares locally and selects a direction before Construction."
user_invocable: true
disable_model_invocation: false
---

# Prototype Sprint — Visual Variants Before Construction

Produce 2-3 lightweight static prototypes, each driven by a different
primary luminary's perspective. The operator views them locally and
selects a direction before committing to a full build.

## When to use

- At the start of Elaboration (step 0), after Inception passes
- When the iteration bet's phase is Elaboration or Construction
- When UI/UX direction is uncertain and the operator wants to see options
- When `/autonomous start` detects phase=Elaboration and asks about prototypes

Can also be invoked standalone at any time.

## What a prototype IS

- Static HTML + CSS + Tailwind in `docs/prototypes/YYYY-MM-DD-variant-N/`
- Stubbed data (hardcoded JSON in a `<script>` tag or inline, no API calls)
- 1-3 pages showing the key interaction (list, detail, form — whatever the scope demands)
- Viewable via `npx serve docs/prototypes/variant-N/` or `open docs/prototypes/variant-N/index.html`
- Built in minutes, not hours
- Screenshotted by the agent using Playwright MCP (if available)

## What a prototype IS NOT

- Not a full Next.js app — no routing framework, no app directory
- Not connected to any database — no Prisma, no API routes
- Not deployed anywhere — local only
- Not tested — this is throwaway. Construction builds the real thing.
- Not production code — it's a visual sketch in HTML

## Procedure

### 1. Read the Inception artifacts

- Product canvas (scope, what survived, what was killed)
- Risk register (what UX/tech risks exist)
- Iteration bet (what value/lovability we're proving)

### 2. Propose 2-3 luminary variants

Based on the scope, propose variants driven by different aesthetic/UX
philosophies. Present to the operator:

> **Prototype Sprint — proposed variants:**
>
> | Variant | Primary luminary | Aesthetic direction |
> |---------|-----------------|-------------------|
> | A | Don Norman (Design of Everyday Things) | Affordance-first: minimal chrome, obvious actions, every interaction self-explaining |
> | B | Ellen Lupton (Design is Storytelling) | Narrative hierarchy: the page tells a story, visual weight guides the eye through a sequence |
> | C | Sophia Prater (Object-Oriented UX) | Entity-derived: navigation mirrors the domain model, screens derive from objects not features |
>
> Adjust, add, remove, or confirm.

The luminary choice depends on the scope:
- **Data-heavy tools** → Norman (affordance) vs Prater (entity-derived) vs Wurman (LATCH)
- **Storytelling/narrative** → Lupton (storytelling) vs Apple HIG (restraint) vs Cooper (goal-directed)
- **Dashboard/overview** → Tufte (data-ink ratio) vs Morville (IA) vs Google Material (systematic)
- **Forms/input** → Norman (affordance) vs Tidwell (interaction patterns) vs Cooper (goal-directed)

### 3. Build each variant

For each confirmed variant:

1. Create `docs/prototypes/YYYY-MM-DD-variant-N/index.html`
2. Include Tailwind via CDN: `<script src="https://cdn.tailwindcss.com"></script>`
3. Use the project's design tokens if they exist (read `design/design-tokens.css`)
4. Hardcode 5-10 realistic data records inline (use names/patterns from the domain)
5. Build the key pages: typically a list view + detail view + primary action
6. Each variant should feel *distinctly different* — not three shades of the same thing
7. State at the top of each HTML file which luminary drives it and what principle dominates

Example structure:
```
docs/prototypes/2026-04-04-variant-a-norman/
  index.html          ← list view (affordance-first)
  detail.html         ← detail view with primary action
  README.md           ← which luminary, what principle, what to look for

docs/prototypes/2026-04-04-variant-b-lupton/
  index.html
  detail.html
  README.md

docs/prototypes/2026-04-04-variant-c-prater/
  index.html
  detail.html
  README.md
```

### 4. Screenshot each variant (if Playwright MCP available)

After building each variant:
1. Serve it: `npx serve docs/prototypes/variant-N/ -l 3333`
2. Screenshot with Playwright MCP: navigate to localhost:3333, capture
3. Agent reviews the screenshot: does it match the intended aesthetic?
4. Kill the server after screenshots

If Playwright MCP is not available, skip screenshots — the operator
will view locally.

### 5. Commit the prototypes

```bash
git add docs/prototypes/
git commit -m "docs: prototype sprint — N variants for [scope]"
```

### 6. Present to operator

> **Prototype Sprint complete. View locally:**
>
> ```bash
> npx serve docs/prototypes/2026-04-04-variant-a-norman/ -l 3001
> npx serve docs/prototypes/2026-04-04-variant-b-lupton/ -l 3002
> npx serve docs/prototypes/2026-04-04-variant-c-prater/ -l 3003
> ```
>
> Each variant has a README explaining the dominant luminary and what to look for.
>
> Which direction? You can pick one, combine elements, or reject all.

### 7. Operator selects → feeds into Elaboration

The operator's selection:
- Sets the iteration bet's `primary_luminary:` field
- Informs the Designer's Elaboration work (JTBD → HTA → IA → interaction design)
- Guides the Builder during Construction
- The prototype is NOT the spec — it's the aesthetic reference. The real spec
  comes from the Designer's Elaboration artifacts.

## Rules

- Prototypes are throwaway — never reference them as the implementation spec
- Each variant must be *distinctly different* in approach, not just color swaps
- Hardcoded data must be realistic (domain-appropriate names, values, patterns)
- Keep it simple: vanilla HTML + Tailwind CDN. No frameworks. No build steps.
- If the operator rejects all variants, that's data — ask what's missing and iterate
- Maximum 3 variants per sprint. More than 3 creates decision fatigue.

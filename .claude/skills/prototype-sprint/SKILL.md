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

### 2. Operator picks up to 3 luminaries

Use AskUserQuestion to let the operator pick which luminary perspectives
to prototype against. Present the full menu organized by discipline:

> **Pick up to 3 luminaries for your prototype variants.**
> Each variant will be built through that thinker's dominant lens.
>
> **UX / Interaction:**
> - Don Norman — affordance-first, minimal chrome, obvious actions
> - Jakob Nielsen — 10 usability heuristics, discount usability
> - Alan Cooper — goal-directed, start from user goals, work backward
> - Steve Krug — "Don't Make Me Think", intuitive navigation
> - Sophia Prater — entity-derived, navigation mirrors the domain model
> - Jenifer Tidwell — proven interaction patterns for common UI problems
> - Luke Wroblewski — mobile-first, touch-first interaction
> - Golden Krishna — no-interface thinking, beyond screens
>
> **Visual / Typography / Color:**
> - Ellen Lupton — storytelling hierarchy, the page tells a narrative
> - Josef Albers — color as context, relative not absolute, test combinations
> - Eva Heller — color psychology, emotional associations across cultures
> - Johannes Itten — seven types of color contrast, color harmonics
> - Edward Tufte — data-ink ratio, maximum information, minimum decoration
> - Apple HIG — progressive disclosure, clarity, restraint
> - Google Material — systematic visual language, tokens over ad-hoc
>
> **Information Architecture:**
> - Peter Morville — how content is organized, labeled, navigated
> - Abby Covert — sense-making, structure from complexity
> - Richard Saul Wurman — LATCH (Location, Alphabet, Time, Category, Hierarchy)
> - Jesse James Garrett — multi-layered UX structure (strategy → surface)
>
> **Psychology / Persuasion / Emotion:**
> - BJ Fogg — behavior design, motivation × ability × trigger
> - Robert Cialdini — persuasion principles (social proof, scarcity, authority)
> - Aarron Walter — emotional design hierarchy (functional → reliable → usable → pleasurable)
> - Susan Weinschenk — "The Brain Lady", cognitive science behind user behavior

If the operator doesn't pick, propose 3 based on the scope:
- **Data-heavy tools** → Norman, Prater, Tufte
- **Storytelling/narrative** → Lupton, Apple HIG, Cooper
- **Dashboard/overview** → Tufte, Morville, Material
- **Forms/input** → Norman, Tidwell, Cooper
- **Emotional/consumer** → Walter, Fogg, Lupton

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

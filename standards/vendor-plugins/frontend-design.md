# Vendor Plugin: Frontend Design Skill

## Source
Anthropic community skill — `FRONTEND-DESIGN-SKILL.md`

## Purpose
Design quality layer for frontend work. Ensures components are
production-grade and visually intentional, not generic "AI slop."

## How it fits our SDLC

```
Usability check (floor)  →  Design quality (ceiling)
  - Correct                   - Distinctive
  - Accessible                - Intentional typography
  - Consistent                - Spatial composition
  - No jargon                 - Motion & delight
```

Usability check must pass first. Design quality applies on top.

## Guardrails for our context

The raw skill optimizes for "unforgettable" and "bold." Our family app
optimizes for "trustworthy" and "readable." Apply with these filters:

### DO apply to:
- Dashboard landing page (first impression, emotional job)
- Call Prep brief (the family artifact — this IS the product)
- Rubric/scoring explanation (educational, trust-building)
- Marketing surfaces (if/when we have them)

### DO NOT apply to:
- Data tables and deal lists (predictable layout > distinctive layout)
- Ops dashboard (utilitarian, operator-only)
- Form inputs and filters (standard patterns win)

### Adapt these principles:
| Skill says | Our context |
|-----------|-------------|
| Avoid Inter, system fonts | Keep system fonts for body text (readability). Distinctive fonts OK for headings on landing/brief surfaces. |
| Asymmetry, overlap, diagonal flow | Not for data layouts. OK for dashboard hero sections and empty states. |
| Bold maximalism OR refined minimalism | We are "refined minimalism" — Lupton, not Sagmeister. Mom is 76. |
| Unexpected, characterful choices | Channel into: card borders, score badges, chart styling, section dividers. Not into layout structure. |
| Motion and micro-interactions | Subtle: hover states, transition-colors, page load fade-in. Not: parallax, staggered reveals, scroll-triggered. |
| Gradient meshes, noise textures | Not for a data app. Clean backgrounds, solid badge colors, high contrast. |

### Typography hierarchy (adapted)
- Display/headings: Can be distinctive (brief title, dashboard welcome)
- Body text: System fonts, 14px+, high contrast
- Data values: Monospace or tabular numerals, bold, 16px+
- Labels: Uppercase tracking, muted, 10-11px

## When to invoke
After the usability check passes and before final review of a
family-facing surface. The designer (Claude) should ask:

1. Is there a clear aesthetic direction for this surface?
2. Does the typography serve the hierarchy?
3. Is there one distinctive element someone will remember?
4. Does it feel *designed* or *generated*?

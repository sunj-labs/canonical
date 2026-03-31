---
name: canvas
description: Create new product canvas — three-stage template (Thesis → Shape → Build Sequence).
user_invocable: true
disable_model_invocation: false
---

# Canvas — Create Product Canvas

Create a new product canvas following the three-stage template.

## Steps

1. Ask the user for the initiative name (or infer from context)
2. Read `strategy/templates/product-canvas.md` for the template structure
3. Read the most recent canvas in `strategy/canvases/` for style reference
4. Walk through each stage with the user:
   - **Stage 1: Thesis** (5 min) — one-sentence value proposition, audience scope, the problem, the bet
   - **Stage 2: Shape** (30 min) — detailed design of the approach, data sources, architecture
   - **Stage 3: Build Sequence** — phased implementation plan with checkboxes

## Output

Write to `strategy/canvases/{YYYY-MM-DD}-{slug}.md`

## Rules

- Do not skip stages — each forces a different kind of clarity
- Value proposition must be one sentence
- The Bet section must be concrete enough to falsify
- Build Sequence must have phased checkboxes
- If the user hasn't thought through a stage, help them — don't fill in assumptions silently

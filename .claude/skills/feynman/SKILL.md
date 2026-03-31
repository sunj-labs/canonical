---
name: feynman
description: Explain a technical concept in plain English — Feynman style. For CTO-vettable sidebars in LinkedIn posts or standalone micro-posts.
user_invocable: true
disable_model_invocation: false
---

# Feynman — Plain-English Technical Explanation

Explain a technical concept so that:
- A PE operating partner understands why it matters economically
- A CTO confirms it's technically precise
- A board member can repeat the core idea in their own words

Named after Richard Feynman's principle: if you can't explain it simply,
you don't understand it well enough.

## When to use

- Flagged by /linkedin as `[FEYNMAN: concept]`
- User asks "explain X simply" or "feynman this"
- A post references a technical concept that needs unpacking for
  non-technical senior leaders while remaining CTO-credible

## Method

### Step 1: State what it does in one sentence

No jargon. No analogies yet. Just the function.

"Temperance is a mandatory pause that forces the system to justify
its approach before executing."

### Step 2: Explain why it exists — the failure it prevents

Connect to a real failure mode that the audience recognizes.

"It exists because autonomous systems optimize for throughput. Without
a pause, the system will retry failed approaches faster rather than
understanding why they failed — the same pattern that causes large
engineering organizations to ship broken features faster instead of
fixing the root cause."

### Step 3: Give the analogy (optional — only if it clarifies)

Pick an analogy from the audience's world:

- PE: "It's the investment committee memo before deploying capital"
- Enterprise: "It's the pre-flight checklist — not bureaucracy, but
  the minimum discipline that prevents expensive mistakes"
- Board: "It's the governance gate between strategy approval and execution"

### Step 4: State the technical precision (for the CTO)

One sentence that a technical reviewer would nod at.

"Implemented as a pre-execution checklist that evaluates five dimensions:
simplicity, blast radius, verification cost, reversibility, and whether
the system is treating symptoms or root causes."

## Output format

```markdown
### [Concept Name]

**What it does**: [one sentence, no jargon]

**Why it exists**: [the failure it prevents, in operating terms]

**Analogy**: [from the audience's world — PE, enterprise, or board]

**Technical precision**: [one sentence a CTO would verify]
```

## Rules

- Never more than 4 sentences total for the core explanation
- The analogy must come from enterprise/PE/board — not academia, not startups
- If the concept doesn't need all 4 parts, drop the analogy
- The explanation must be accurate enough that a CTO wouldn't correct it
- Avoid "it's like..." phrasing — state what it IS, then use analogy only to illuminate

---
name: linkedin
description: Draft LinkedIn posts from session work — calibrated to PE/search/board audience per writing guide and brand questionnaire.
user_invocable: true
disable_model_invocation: false
---

# LinkedIn — Draft Posts from Session Work

Draft 3 LinkedIn posts from the current session's work, calibrated to
Sanjay's target audience and brand positioning.

## Before writing

1. Read `standards/writing-guide.md` — the LinkedIn style guide
2. Read the brand questionnaire from memory (reference_brand_questionnaire.md)
   for audience, tone, topics, and positioning
3. Read the current session's chronicle entry for raw material

## Audience (every post must land for these)

- **PE senior partners** — evaluating operating talent, backing transformations
- **Executive search leaders** — placing CEO/COO/CPTO into complex environments
- **Board-level decision-makers** — responsible for enterprise transformation mandates
- **CTOs asked to vet** — they'll check technical credibility

## Rules

- **Name concepts, not implementations.** "Governance primitive" not "SKILL.md file."
  See the vocabulary table in the writing guide.
- **Connect to enterprise economics.** Every post must touch EBITDA, capital
  efficiency, governance, operating model, or scale.
- **Bezos/Jassy/Collison tone.** Calm, analytical, operator-grade. No AI hype.
- **Structure**: Hook → Setup → Body (with → arrows) → Takeaway
- **600-1200 words** per post
- **3 posts per session** — different angles on the same work

## When a concept needs technical explanation

Flag it for the /feynman skill. In the draft, mark it:

```
[FEYNMAN: concept name — for CTO sidebar]
```

After drafting all 3 posts, run /feynman on each flagged concept.
Weave the Feynman explanation into the post or note it as a comment-thread follow-up.

## Output

1. Write drafts to `docs/linkedin-drafts/YYYY-MM-DD.md`
2. Push to Google Doc:
   ```bash
   cd ~/src/sunj-labs/poa && GDOC_LINKEDIN_ID="1b1Gs8CDfOVF5D0ZaIswMWfW9JqQEgx0Zk409I9YfY7I" npx tsx scripts/push-to-gdoc.ts --file ~/src/sunj-labs/platform-docs/docs/linkedin-drafts/YYYY-MM-DD.md
   ```
3. Note in the chronicle that posts were drafted and pushed

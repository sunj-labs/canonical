---
name: release-notes
description: Draft release notes for the least technical stakeholder. Plain language, per-feature format.
user_invocable: true
disable_model_invocation: false
---

# Release Notes

Draft release notes after any user-facing changes are deployed.

## When to use

- Session-end protocol: if user-facing changes shipped today
- After a deploy that changes what users see or do
- Skip if the session only touched backend, infrastructure, or internal tooling

## Audience

Write for the **least technical stakeholder** who uses the product.
They may be on a phone. They don't know what an API is. They care about
what they can do now that they couldn't before.

## Format

For each user-facing change:

```markdown
### [Feature name in plain language]

**What you can do now**: [one sentence — what's new or different]

**Why it matters**: [one sentence — what problem this solves for them]

**How to try it**: [one sentence — where to go, what to tap/click]
```

## Procedure

1. Review commits since last release notes (`git log --oneline`)
2. Filter to user-facing changes only (pages, UI components, user flows)
3. Skip: refactors, test changes, CI, infrastructure, internal tooling
4. For each user-facing change, write the three-line format above
5. Write to `docs/release-notes/YYYY-MM-DD.md`
6. If no user-facing changes: write "No user-facing changes today" and skip

## Rules

- No technical jargon. "We improved the scoring algorithm" → "Deal scores are now more accurate"
- No implementation details. "Added pagination" → "You can now browse all deals, not just the first page"
- No feature names that aren't visible in the UI. "Added DealScore dimension" → don't mention it
- Test: could the least technical person in the organization read this on their phone and understand it?

## App-Specific Override

Your project's release notes may add:
- Distribution mechanism (email digest, Slack, in-app notification)
- Specific audience description (family members, clients, operators)
- Cadence (daily, weekly, per-deploy)
- Tone guidance specific to the audience

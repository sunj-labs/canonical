---
name: promote
description: Propose promoting an app-level standard to canonical. Creates a GitHub issue on canonical with the "canonical-evolution" label.
user_invocable: true
disable_model_invocation: false
---

# Promote — Propose Standard for Canonical

When working in any app repo and you discover a skill, rule, hook, or
workflow pattern that should be a shared standard, run /promote to
create a proposal on canonical.

## When to use

- You just wrote a new skill, rule, or hook in an app repo's .claude/
- You extended or improved a canonical standard locally
- You discovered a workflow pattern that would benefit all repos
- The sdlc-gates checkpoint flagged: "Is this general or app-specific?"

## Procedure

1. **Identify what to promote**: which file(s) and why they're general
2. **Classify the change**:
   - **New**: skill/rule/hook that doesn't exist in canonical yet
   - **Extension**: improvement to an existing canonical standard
   - **Pattern**: workflow insight, not a specific file
3. **Create the issue** on canonical:

```bash
gh issue create --repo sunj-labs/canonical \
  --label "canonical-evolution" \
  --title "Promote: [brief description]" \
  --body "## What
[What should be promoted — file name, content summary]

## From
[Which repo, which file path]

## Why general
[Why this isn't app-specific — what makes it reusable]

## Type
[New | Extension | Pattern]

## Content
[Paste the relevant content or reference the file]"
```

4. **Note in the current session's chronicle**: "Proposed promotion: [description] → canonical#NNN"

## Rules

- Everything goes as an issue, never a direct PR from an app repo
- Use the `canonical-evolution` label consistently
- The canonical session is where promotion decisions are made, not the app session
- Don't block app work on the promotion — log it and move on

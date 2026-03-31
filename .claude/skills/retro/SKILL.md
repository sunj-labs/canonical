---
name: retro
description: Session retrospective — reflect on what worked, what didn't, what to change.
user_invocable: true
disable_model_invocation: false
---

# Retro — Session Retrospective

Reflect on the current session and capture learnings.

## Steps

1. Review what was accomplished this session:
   - `git log --oneline --since="today"` for commits
   - Check for modified files and new artifacts
2. Identify:
   - What went well (approaches that worked, decisions validated)
   - What was harder than expected (and why)
   - What should change for next session
3. Check for open threads that need to carry forward

## Output

If a chronicle entry exists for today, append a `## Retrospective` section to it.
If no chronicle exists, create one first (use /chronicle format), then add the retro.

```markdown
## Retrospective

### Went well
- ...

### Harder than expected
- ...

### Change for next time
- ...

### Open threads for next session
- ...
```

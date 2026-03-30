# /diagnose — Root Cause Analysis Before Fix

Run the three-step diagnosis standard before writing any fix code.

## Steps

1. **Is/Is Not table**: Determine what is failing and what similar thing is NOT failing. Write the table:

| IS (failing) | IS NOT (working) |
|---|---|
| The specific thing that fails | The adjacent things that don't |

2. **Five Whys**: Starting from the symptom, ask "why" five times. Stop when you reach something changeable that prevents the class of failure — not just this instance.

3. **Hypothesis + Test**: Write a one-sentence hypothesis. Identify the minimum falsifiable check (a test, a log, a query) that would confirm or refute it.

## Output

Write a diagnosis block:

```markdown
### Diagnosis

**Is/Is Not**
| IS (failing) | IS NOT (working) |
|---|---|
| ... | ... |

**Root cause chain**
1. Why? → ...
2. Why? → ...
3. Why? → ...
4. Why? → ...
5. Why? → ... ← root cause

**Hypothesis**: [one sentence]
**Test**: [minimum falsifiable check]
```

Post this as a comment on the ticket BEFORE opening a fix PR. Only after completing diagnosis, proceed to write the fix.

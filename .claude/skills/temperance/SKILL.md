---
name: temperance
description: Pause-and-think gate. Counteracts the bias toward throughput over quality. Ask whether the approach is the simplest correct one before building.
user_invocable: true
disable_model_invocation: false
---

# Temperance

A deliberate pause before implementation. Counteracts the natural tendency to brute-force toward making the user happy vs. building well-architected solutions.

## When to Invoke

- Before starting any non-trivial task
- When you feel the urge to "just ship it"
- When the approach has more than 3 steps
- When you're about to touch auth, middleware, data pipeline, or external services
- When the user says "just do it" or "go fast" — that's exactly when to slow down

## The Temperance Checklist

Before writing code, answer these questions honestly:

### 1. Simplicity Check
- Is this the **simplest correct approach**?
- Am I adding complexity to handle hypothetical scenarios?
- Could I solve this with configuration instead of code?
- Would a senior engineer look at this and say "why didn't you just..."?

### 2. Brute Force Check
- Am I **brute-forcing to satisfy the objective** (make user happy) vs. architecting properly?
- Am I trying N approaches hoping one works, instead of understanding the problem first?
- Did I run `/diagnose` before jumping to a fix?
- Am I treating symptoms or root causes?

### 3. Blast Radius Check
- What else does this change affect?
- What existing functionality could break?
- Have I verified the "before" state (what works now) so I can confirm "after"?

### 4. Verification Check
- How will I **know** this works — not just that it compiles?
- What's the smallest possible test I can run?
- Can I verify in under 2 minutes? If not, my approach may be too complex.

### 5. Reversibility Check
- If this is wrong, how hard is it to undo?
- Am I about to do something destructive (force push, schema change, delete data)?
- Should I commit what I have first, before making this change?

## The Decision

After the checklist, state:
- **Approach**: [what you're going to do]
- **Why this is the simplest correct approach**: [one sentence]
- **What you're NOT doing**: [temptations you're resisting]
- **Verification plan**: [how you'll know it works]

Then proceed.

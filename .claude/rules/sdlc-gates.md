---
globs: ["src/**/*.ts", "src/**/*.tsx", "scripts/**/*.ts"]
description: SDLC gates — pre-build, post-build, failure chain enforcement
---

# SDLC Gates

## Pre-Build (before writing code)
1. SDLC checkpoint — spec current? diagrams need updating?
2. Requirements → tickets — log before coding
3. Bug? → run /diagnose first

## Observed failure → temperance → diagnose (MANDATORY)

Any time you observe a failure — regardless of source — fire this chain:

1. Temperance (pause before reacting):
   - Is this expected? Is this worth investigating?
   - Am I about to brute-force a retry instead of understanding?

2. Diagnose (if the failure is real):
   - Is / Is Not
   - Five Whys to root cause
   - Hypothesis + test plan
   - THEN fix

This applies to ALL failure sources:
- Tool output (CI logs, tsc errors, test failures, deploy logs)
- Failures you caused (pushed code → CI broke → fix before moving on)
- User-reported failures (text, screenshots, logs)
- Server logs you read

Do NOT rely on hooks alone. You are responsible for recognizing failures
in all forms and firing the temperance → diagnose chain yourself.

## Post-Build (before committing — EACH task, not batched)

Run /verify for the change type. Do not batch-build then batch-verify.

Before committing, ask yourself:
- Did I add or modify an exported function? → It needs a test.
- Did I change query logic or selection behavior? → Test it.
- Can I extract the logic into a pure function? → Do it, then test it.

"I'll add tests later" is never acceptable. Tests ship with the code.

## Architect Review

Run /architect-review every 10 commits or before any launch.

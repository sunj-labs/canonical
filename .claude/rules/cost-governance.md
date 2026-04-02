---
globs: ["*"]
description: Cost governance — token budgets, session limits, cost tracking for autonomous agents
---

# Cost Governance

Autonomous agents consume API tokens without human oversight. This rule
prevents unbounded cost accumulation.

## Session budget
- Track token usage throughout the session
- At 50% of context window: warn and consider compacting
- At 70%: compact mandatory
- At 90%: save state and end session gracefully

## Per-iteration budget
- Each iteration bet must declare an appetite (time constraint)
- Agent work within an iteration must fit the appetite
- If appetite is exhausted: stop, save state, report what's done and what's not
- Never expand appetite unilaterally — escalate to Orchestrator

## Cost tracking
- At session end, note approximate token usage in the chronicle
- Flag sessions that consumed significantly more than prior sessions
- If cost tracking tools are available, log per-session cost

## Autonomous session limits
- Unsupervised agents must have a maximum session duration
- If no human interaction for 30 minutes in an autonomous session: save state, end
- All autonomous work must be on a feature branch — never main

## Rules
- No unbounded loops (retry forever, poll indefinitely)
- No recursive agent spawning without depth limits
- Prefer single-pass solutions over iterative refinement loops
- If a task is taking 3x longer than expected: stop, diagnose, escalate

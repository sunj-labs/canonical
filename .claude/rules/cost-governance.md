---
globs: ["*"]
description: Cost governance — budget enforcement from substrate.config.md manifest
---

# Cost Governance

Budget and model routing are defined in the project's `substrate.config.md`.
This rule applies at ALL process levels (core, standard, full).

## Budget behavior (Orchestrator enforces at standard + full)

| Event | Action |
|---|---|
| Session start | Read session_ceiling and iteration_ceiling from manifest. If iteration_ceiling missing, ask operator. |
| 75% of iteration ceiling | Surface status: spend to date, remaining, work completed vs scope. Continue unless operator says stop. |
| Iteration ceiling hit | Pause. Report state. Propose descoped continuation that fits remaining budget. Never hard-stop silently. |
| Session ceiling approached | Warn operator. Complete current atomic unit of work. Do not start a new iteration. |
| Replenish floor hit | Surface. Recommend deferring remaining iterations to next session. |

## At core level (supervised sessions)

Cost tracking is advisory, not enforced. The rules below still apply:
- No unbounded loops (retry forever, poll indefinitely)
- No recursive agent spawning without depth limits
- Prefer single-pass solutions over iterative refinement loops
- If a task is taking 3x longer than expected: stop, diagnose, escalate
- At session end, note approximate scope of work in the chronicle

## Model routing (standard + full)

Defined per-agent in manifest. Default routing:

| Agent | Model | Rationale |
|---|---|---|
| Orchestrator | haiku | Routing — no deep reasoning needed |
| Shaper | opus (Inception only) | Problem framing is highest-leverage thinking. Revert to sonnet after. |
| PM | sonnet | Viability hypotheses require judgment |
| Creative Director | sonnet | Brief and token work — nuanced but not architecturally complex |
| Architect | sonnet | ADRs and C4 require real reasoning |
| Designer | sonnet | UX judgment |
| Builder | sonnet | Code quality matters; haiku produces more rework |
| Reviewer | haiku | Checklist evaluation — mechanical |
| Deployer | haiku | Pipeline execution — deterministic |
| Closer | haiku | Gate checklist — administrative |

Opus escalation: Shaper may request Opus outside Inception if problem framing is genuinely novel and high-stakes. Orchestrator logs escalation and cost delta. Operator notified.

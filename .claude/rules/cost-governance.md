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

## Cost tracking (all levels)

Track cost at phase boundaries. The operator should never have to ask
"what did this cost?" — the system tells them proactively.

### At phase start (estimate)

Before activating agents for a phase, estimate:
- Number of subagent spawns planned (0 for sequential mode)
- Estimated turns per agent based on phase and scope
- Total estimated phase cost (burst + Pro plan time)
- Remaining budget after this phase

### At phase end (actuals)

After a phase completes, report in phase-state.md:

```markdown
## Cost tracking
| Phase | Agents | Turns | Burst cost | Duration | Notes |
|-------|--------|-------|-----------|----------|-------|
| Inception | Shaper, PM | 12 | $0 | 8m | Sequential — no burst |
| Elaboration | Architect, Designer | 18 | $0 | 14m | Sequential |
| Construction | Builder, Reviewer | 35 | $0 | 25m | 3 branches |
| **Total** | | **65** | **$0** | **47m** | |

Budget: $0 ceiling / $0 spent / on track
```

### At session end

Include in the chronicle:
- Total turns used
- Total duration (approximate)
- Cost per artifact produced (turns / artifacts)
- Budget utilization (% of ceiling used, or "sequential — $0 burst")
- Scope completed vs planned

### Sequential mode

Burst cost is $0 but Pro plan time still matters. Track:
- Turn count per phase
- Duration per phase (approximate)
- These help calibrate future appetite estimates

### Where to get cost data

- Turn count: count conversation turns per phase
- Duration: note timestamps at phase boundaries
- Burst cost: relevant only in parallel mode (subagent spawns)
- If exact data isn't available, estimate and note the method

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

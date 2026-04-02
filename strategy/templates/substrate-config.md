# substrate.config.md — Project Manifest Template

Every project using Canonical declares this file at the repo root.
The Orchestrator (and session-start hooks) read it before activating
any agents, loading any ceremony, or scheduling any iteration.

Nothing fires that the manifest doesn't authorize.

```markdown
# substrate.config.md

## Process
level: core | standard | full

## Active agents
agents: [Builder, Reviewer]
# core: [Builder, Reviewer]
# standard: [Builder, Reviewer, Architect, PM, Designer]
# full: [Shaper, PM, Designer, CreativeDirector, Architect,
#        Builder, Reviewer, Deployer, Closer, Orchestrator]

## Phases
phases: [Build, Deploy]
# core: [Build, Deploy] — skip Inception/Elaboration/Transition ceremony
# standard: [Inception, Elaboration, Construction, Transition]
# full: [Inception, Elaboration, Construction, Transition]

## Iteration planning
iterations: light | formal
# light = one-liner bet (retiring X, proving Y, ceiling $Z)
# formal = full 4-signal bet with balance rationale

## Risk register
risk-register: yes | no

## Budget
budget:
  session_ceiling: $20
  iteration_ceiling: $8        # Orchestrator asks if not set
  warning_threshold: 75%
  replenish_floor: $10
  model_routing:
    orchestrator: haiku
    shaper: opus               # Inception only
    pm: sonnet
    creative_director: sonnet
    architect: sonnet
    designer: sonnet
    builder: sonnet
    reviewer: haiku
    deployer: haiku
    closer: haiku
```

## Process levels explained

| Level | Who | What activates | What doesn't |
|---|---|---|---|
| core | Solo, supervised | Rules, hooks, skills, Builder + Reviewer. Light iterations. | No phase gates, no risk register, no Orchestrator routing, no 4-signal bet. |
| standard | Solo going autonomous, or 2-person | Adds Architect, PM, Designer. Formal iterations (lightweight). Phase gates. Risk register. | No Creative Director, no Deployer/Closer ceremony, no full Orchestrator routing. |
| full | Multi-agent autonomous, 3+ | All 10 agents. Full ceremony. Orchestrator routing. 4-signal bet. All gates enforced. | Nothing skipped. |

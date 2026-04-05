# substrate.config.md

## Process
level: standard

## Active agents
agents: Shaper, PM, Designer, Architect, Builder, Reviewer
# core: Builder, Reviewer
# standard: Shaper, PM, Designer, Architect, Builder, Reviewer
# full: all 10

## Phases
phases: [Inception, Elaboration, Construction, Transition]

## Iteration planning
iterations: formal

## Risk register
risk-register: yes

## Budget
#
# Context: The Max plan covers all interactive Pro usage (conversations
# in Claude Code). The budget below governs API burst usage — tokens
# consumed when the Orchestrator spawns subagents, runs headless agents
# (claude -p), or fans out worktree agents.
#
# Sequential mode = $0 burst. Parallel mode = burst tokens per spawn.
# The API burst pool ($25) replenishes when it drops to $10.
#
budget:
  session_ceiling: $0          # sequential mode — no burst usage
  iteration_ceiling: $0        # sequential mode — no burst usage
  warning_threshold: 75%       # Orchestrator surfaces status at this %

## Deployment targets
#
# Canonical is a documentation repo. No application to deploy.
# Local-only: build, test, verify locally.
#
deploy_targets:
  local: true
  staging: false
  prod: false

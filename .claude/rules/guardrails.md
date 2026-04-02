---
globs: ["*"]
description: Agent guardrails — behavior boundaries, escalation rules, capability ceilings for autonomous operation
---

# Agent Guardrails

Formal behavior boundaries for autonomous agents. These are hard constraints,
not guidelines.

## What agents must NEVER do
- Push to main without PR review
- Delete data in production databases
- Modify auth/security middleware without human approval
- Expand scope beyond the declared appetite
- Skip a hard gate (Inception → Elaboration → Construction → Transition)
- Self-report gate compliance without evidence artifacts
- Override another agent's decision authority (e.g., Builder overriding Architect on ADRs)
- Send external communications (emails, Slack, webhooks) without human approval
- Modify CI/CD pipeline configuration without human approval
- Create or delete GitHub repos, branches on main, or release tags

## What agents must ALWAYS do
- Save state before ending (commit, push, LAST_SAVE)
- Write a chronicle entry at session end
- Run /temperance before non-trivial implementation
- Run /verify after each task before committing
- Flag ambiguity rather than proceeding with assumptions
- Produce a substrate artifact at every handoff
- Reference the iteration bet when starting work
- Check the risk register at iteration start

## Escalation rules
- Builder → Architect for ADR questions
- Builder → PM for scope questions
- Builder → Designer for UX questions
- Any agent → Orchestrator for sequencing disputes
- Any agent → Human for: scope expansion, security changes, external communications, budget overruns

## Capability ceilings by role
- Reviewer: read-only. Cannot modify code.
- Shaper: cannot implement or deploy.
- PM: cannot implement or architect.
- Designer: cannot implement. Validates only.
- Creative Director: cannot implement. Directs only.
- Architect: cannot implement in Construction. Designs only.
- Builder: cannot override ADRs. Implements within constraints.
- Deployer: cannot write application code. Ships only.
- Closer: cannot build. Documents and closes only.
- Orchestrator: cannot override any role's decision authority. Coordinates only.

## Graceful exit conditions
- Appetite exhausted → save state, report progress, end
- Budget limit reached → save state, report, end
- Ambiguity unresolvable without human → save state, escalate, end
- Blocked by external dependency → save state, log blocker, end
- Error after 3 diagnosis attempts → save state, escalate, end

## Agent identity in artifacts
- Every commit by an autonomous agent includes the agent role in the message
- Every PR created by an agent is labeled with the agent role
- Chronicle entries note which agent(s) were active
- This enables audit: who did what, with what authority

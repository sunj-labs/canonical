# Multi-Agent Autonomous SDLC — Product Canvas

## Stage 1: Thesis

### Value Proposition (one sentence)

For **one human with a day job supervising AI-built software across multiple repos**, the multi-agent SDLC enables autonomous development sessions that produce PR-ready work while the human is away — with specification quality, not human availability, as the throughput bottleneck.

### Audience Scope

Scope: **Operator** (Sanjay + sunj-labs repos), progressing to **Platform** (extractable methodology for any solo founder running agent teams)

### The Problem

Today's workflow is single-threaded: one human, one agent, one repo, one session. Sanjay has a day job and a dozen app ideas beyond POA. The constraint isn't code generation speed — it's that nothing happens when the human isn't in the chair.

Current pain points:
- **Idle time**: ~16 hours/day where no development happens
- **Context fragmentation**: Each session starts cold — the agent re-reads the codebase, re-discovers conventions, re-learns what was decided
- **No parallel execution**: Two repos that need work means two sequential sessions
- **Governance gap**: No systematic gate between "agent wrote code" and "code is safe to merge"

### The Bet

Three capabilities, stacked, turn one human into a team lead supervising autonomous agents:

```
Layer 1: SPECIFICATION INFRASTRUCTURE (what to build)
  Artifact chains, templates, CLAUDE.md layers → agents stop guessing

Layer 2: AUTONOMOUS EXECUTION (build without human)
  Scheduled agents, worktree parallelism, cross-repo access → work happens 24/7

Layer 3: GOVERNANCE & REVIEW (safe to ship)
  PR-based output, quality gates, cost controls → human reviews results, not sessions
```

---

## Stage 2: Shape

### Layer 1: Specification Infrastructure — Stop the Guessing

**Core insight** (from Barry Hurd / BHIL): "The bottleneck in AI-assisted development isn't code generation. It's specification quality. Every time Claude Code asks you a clarifying question, your spec failed."

**What we need**:

| Artifact | Purpose | Current State |
|----------|---------|---------------|
| CLAUDE.md per repo | Agent instruction manual — conventions, architecture, gotchas | Exists in POA, needs extraction to importable fragments |
| rules/ directory | Split concerns — code-style.md, testing.md, api-conventions.md | Not yet implemented |
| Artifact chain | PRD → SPEC → TASK → CODE → REVIEW → DEPLOY | Partially exists (canvases → issues → PRs), not formalized |
| ADR templates | Decision records for model selection, prompt strategy, agent orchestration | Not yet implemented |
| Skills & commands | Repeatable workflows as slash commands and auto-triggered packages | Exists in sdlc-portable/, not yet wired to agents |

**Architecture** (from Eduardo Ordax):
```
repo/
├── CLAUDE.md              ← under 200 lines, highest-leverage file
├── .claude/
│   ├── settings.json      ← permissions: what's free, what needs ask, what's blocked
│   ├── commands/           ← slash commands (review, deploy, issue-fix)
│   ├── skills/             ← auto-triggered packages (loaded on relevance)
│   ├── agents/             ← isolated subagent personas with restricted tools
│   └── rules/              ← path-scoped rules (only load when relevant)
└── ...
```

Key principle: **The .claude folder is infrastructure. Treat it like one.**

### Layer 2: Autonomous Execution — Work Happens While Human Is Away

**Execution modes** (from Boris Cherny / Anthropic):

| Mode | Mechanism | Use Case |
|------|-----------|----------|
| Scheduled agents | `claude` triggers via cron / GitHub Actions | Nightly backlog grooming, dependency updates |
| Worktree parallelism | `claude -w` for isolated branches in same repo | Multiple features in parallel, no merge conflicts |
| Batch fan-out | `/batch` to spin up dozens of worktree agents | Large migrations, cross-file refactors |
| Cross-repo access | `--add-dir` to give agent visibility into other repos | Agent in POA reads standards from platform-docs |
| Custom agents | `--agent=<name>` with `.claude/agents/` definitions | Read-only auditor, security reviewer, spec-writer |
| Headless SDK | `claude -p "task" --bare --output-format=stream-json` | Programmatic agent invocation from scripts/CI |

**Proposed agent roster for sunj-labs**:

| Agent | Persona | Tools | Trigger |
|-------|---------|-------|---------|
| spec-writer | Generates PRDs and specs from canvas/issue | Read, Write, WebSearch | Manual or scheduled |
| implementer | Executes tasks from spec → PR | All (sandboxed) | Scheduled or manual |
| code-reviewer | Reviews PRs against standards | Read, Grep, Glob only | PR hook (GitHub Actions) |
| security-auditor | OWASP check on changed files | Read, Grep only | Pre-merge gate |
| session-retro | Summarizes what happened, updates chronicle | Read, Write | Post-session hook |

### Layer 3: Governance & Review — Human Reviews PRs, Not Sessions

**The governance model**: Agents output PRs. Human reviews PRs. That's the entire interface.

**Quality gates before human review**:
1. **Tests pass** — CI runs automatically
2. **Usability check** — 7-point standard (already exists in standards/)
3. **Security audit** — automated OWASP scan via security-auditor agent
4. **Spec traceability** — PR links back to issue, issue links back to spec
5. **Cost report** — token usage and API cost per agent session

**Cost control mechanisms**:
- Token budget per agent session (MAX_THINKING_TOKENS in settings.json)
- Automatic context compaction at 70% usage, mandatory /clear at 90%
- Daily cost dashboard (aggregate across all agent sessions)
- Kill switch: agent sessions auto-terminate after budget exceeded

---

## Stage 3: Build Sequence

### Phase 1: Foundation (this week)
- [ ] Extract CLAUDE.md fragments from POA into platform-docs/sdlc-portable/claude/
- [ ] Create importable rules/ directory (code-style, testing, api-conventions)
- [ ] Wire POA's CLAUDE.md to import from platform-docs via `--add-dir`
- [ ] Define first two agents: code-reviewer.md, session-retro.md

### Phase 2: Scheduled Autonomy (next week)
- [ ] Set up GitHub Actions workflow that runs `claude -p` on open issues tagged `agent-ready`
- [ ] Implement session handoff protocol (state.json + transitions/ directory)
- [ ] First autonomous overnight session: agent picks up an issue, produces a PR
- [ ] Chronicle the result — what worked, what broke

### Phase 3: Parallel & Multi-Repo (week after)
- [ ] Worktree parallelism: two agents working on different POA features simultaneously
- [ ] Cross-repo: agent in POA consumes standards from platform-docs
- [ ] Cost tracking: per-session token/cost report written to chronicle
- [ ] Second app repo: apply the same CLAUDE.md import pattern

### Phase 4: Scale & Refine (ongoing)
- [ ] Batch fan-out for large refactors
- [ ] Spec-driven workflow: canvas → spec → tasks → agent execution → PR
- [ ] DORA metrics: measure deployment frequency, lead time across autonomous sessions
- [ ] Publish sdlc-portable as a standalone toolkit others can fork

---

## Research Notes & Reflections — What We Might Be Missing

### From Barry Hurd (BHIL AI-First Development Toolkit)

**What he solved that we haven't yet**: Hurd's artifact chain (PRD → SPEC → ADR → TASK → CODE → REVIEW → DEPLOY) is fully traceable — every artifact feeds the next one in a machine-actionable way, and GitHub Actions CI validates the traceability chain. We have canvases and issues but no formal spec layer between them. An agent picking up a GitHub Issue today has to infer the spec from the issue description, which is lossy.

**Specific gap — EARS-format requirements**: Hurd uses the EARS notation (Easy Approach to Requirements Syntax — the format NASA/Airbus uses for unambiguous requirements) adapted for AI agents. Our canvases are narrative; they don't produce machine-parseable requirements. An agent reading a canvas has to interpret prose — exactly the kind of ambiguity that causes "almost right but not quite" output.

**Specific gap — AI-native ADR types**: Hurd defines three ADR types we don't have: Model Selection (which LLM for which task), Prompt Strategy (how to structure prompts for a feature), and Agent Orchestration (how agents coordinate). As we scale to multi-agent, these decisions need to be recorded somewhere or every session re-discovers them.

**Specific gap — Probabilistic acceptance criteria**: "Works correctly" is not a test for a non-deterministic system. Hurd uses probabilistic acceptance criteria templates. We have no framework for testing agent-generated output beyond "CI passes."

**Reported leverage**: 20-30x on human hours. One documented case: ~35 hours of human effort producing what would have taken ~800 hours without AI. That's the scale we're targeting.

### From Eduardo Ordax (.claude Folder Anatomy)

**What he solved that we haven't yet**: The distinction between project-level `.claude/` (committed, shared with team) and user-level `~/.claude/` (personal, global across repos). We're currently mixing concerns — platform-docs has memory and project config in the same `.claude/` tree. As we scale to multi-repo, we need a clear separation: what's shared infrastructure vs. what's personal agent memory.

**Specific gap — rules/ scoping**: Ordax emphasizes path-scoped rules with YAML frontmatter so they only load when relevant. Our current CLAUDE.md is monolithic. A 200-line CLAUDE.md is fine for one repo; when an agent uses `--add-dir` to see platform-docs + POA simultaneously, the combined context needs to be layered, not concatenated.

**Specific gap — settings.json as permission control**: We haven't defined what agents can do freely vs. what requires human approval. Right now it's implicit (human is always watching). For autonomous agents, this must be explicit: "git commit is allowed, git push requires approval, rm -rf is blocked."

### From Boris Cherny (Anthropic Engineer, Claude Code Power User)

**What he solved that we haven't yet**: Cherny runs "dozens of Claudes" simultaneously using git worktrees. His workflow — `claude -w` for parallel isolated work, `/batch` for fan-out — is the practical mechanics of multi-agent that we've been theorizing about. He also uses `--add-dir` for cross-repo access, which is exactly our "agent in POA reads standards from platform-docs" pattern.

**Specific gap — worktree lifecycle management**: When you have dozens of agents producing worktrees, who cleans up? Merged branches, abandoned experiments, failed runs — worktree sprawl is the "zombie process" problem of multi-agent development. We need a garbage collection strategy.

**Specific gap — --agent for restricted personas**: Cherny's example of a ReadOnly agent (tools: Read only) is the simplest version of agent safety. We haven't defined our agent personas or their tool restrictions yet. A code-reviewer that can also Write is a code-reviewer that can silently "fix" what it finds — that's a different trust model.

### From GitHub Spec Kit (Specify → Plan → Tasks → Implement)

**What they solved**: GitHub's spec-kit formalizes "intent is the source of truth" — specifications as living, executable artifacts that AI agents consume directly. Their four-phase process (Specify → Plan → Tasks → Implement) maps cleanly to our reflect → plan → execute → measure loop but with a crucial difference: they generate multiple plan variations to compare and contrast approaches before committing to one.

**Specific gap — plan comparison**: Our current workflow picks one approach and runs with it. Spec-kit's pattern of generating alternative plans and letting the human choose could prevent the "agent confidently builds the wrong thing" failure mode that's expensive in autonomous contexts.

### From Uniswap AI Toolkit (Plugin Marketplace)

**What they solved**: Distribution and reuse of AI development patterns across teams. Their Nx monorepo produces installable plugins that any Uniswap developer can add to their Claude Code setup. This is the mature version of what our `sdlc-portable/` is trying to be.

**Specific gap — plugin packaging**: We're currently thinking about CLAUDE.md fragments and importable files. Uniswap packages agents, skills, commands, and MCP configs as versioned npm packages with `@latest` and `@next` channels. That's a much more robust distribution model than "copy this file into your repo."

### From Applied AI Claude Code Toolkit (Session Handoffs)

**What they solved**: The context window reset problem. Their transition plugin saves critical context to `.claude/transitions/` with timestamps before switching sessions, and a continue command restores state. Combined with `state.json` for structured progress tracking, agents can resume work across session boundaries.

**Specific gap — handoff protocol**: Our chronicle system records what happened, but it's narrative — a human reads it. An agent resuming work needs structured state: what tasks are done, what's in progress, what's blocked, what files were modified. We need both narrative (chronicle for human) and structured (state.json for agent).

**Specific gap — MCP graceful degradation**: Their toolkit works without MCP servers but gains capabilities when available. We haven't thought about MCP at all yet — Postgres direct queries, GitHub PR access, Slack notifications. These become important for autonomous agents that need to interact with external systems without human mediation.

### Open Questions We Haven't Answered

1. **Conflict resolution**: Two autonomous agents modify the same file in different worktrees. Who wins? Git will catch the conflict, but who resolves it — a third agent? The human? A merge-resolution agent?

2. **Agent identity & audit trail**: When three agents produce three PRs overnight, the human needs to know which agent did what, with what instructions, at what cost. Git author metadata? PR labels? A dashboard?

3. **Failure cascading**: Agent A produces a PR that breaks Agent B's assumptions. In a human team, someone notices in standup. What's the equivalent for agents? Do we need an "integration agent" that watches for cross-PR conflicts?

4. **Specification drift**: The spec says one thing, the agent builds something slightly different (it's an LLM, not a compiler). Over many autonomous sessions, small drifts compound. How do we detect and correct drift before it becomes technical debt?

5. **Human re-entry cost**: The whole point is the human reviews PRs, not sessions. But if an agent makes a surprising architectural choice buried in a large PR, the human review becomes expensive. How do we keep PRs small and decisions visible?

6. **Trust escalation**: New agents should start with minimal permissions and earn broader access as they prove reliable. We have no framework for this — it's all-or-nothing today.

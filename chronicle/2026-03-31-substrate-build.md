---
session_id: 2026-03-31-1200
project: canonical
agent: personal
status: completed
tags: [substrate, infrastructure, research, practitioner-analysis, skills, hooks, rules, writing-guide, linkedin, session-continuity]
---

# Session: Substrate Build — From Practitioner Research to Production Infrastructure

## Entry State
- Platform-docs had standards as prose documentation, not agent infrastructure
- Previous session (2026-03-30) built initial .claude/ with 6 rules, 5 commands, 3 agents, 1 skill
- settings.json had wrong hook format (matchers as objects, not strings)
- No session-start hooks, no session-end hooks, no failure detection hooks
- POA had 30 .claude/ files, most duplicating what should be canonical standards

## Work Done

### Fixed settings.json hook format
- Matchers must be strings ("Edit|Write"), not objects
- Events without matchers need `matcher: ""` + `hooks: []` wrapper
- Consolidated Edit and Write pre-build-gate into single matcher

### Migrated commands → skills (canonical format)
- Anthropic deprecated `commands/` in favor of `skills/*/SKILL.md`
- Migrated 5 commands: diagnose, chronicle, canvas, spec, retro
- Removed `.claude/commands/` directory

### Promoted 9 skills from POA
- temperance, verify, architect-review, principal-engineer, frontend-design
- jtbd-tasks, task-scenarios, ia-model, interaction-design
- Each generalized: stripped POA-specific paths, examples, SSH commands

### Promoted 7 hooks from POA
- session-reflection.sh (SessionStart): reflect→plan, abrupt stop detection, missing chronicle/danger-mode recovery, architect review cadence
- session-end.sh (Stop): chronicle, memory, LinkedIn, release notes, save-state
- bug-diagnosis.sh (UserPromptSubmit): keyword detection → /diagnose reminder
- tool-failure-diagnosis.sh (PostToolUse): tool error → temperance → diagnose
- pre-build-gate.sh (PreToolUse Edit/Write): SDLC checkpoint + contextual diagram loading
- pre-commit-gate.sh (PreToolUse Bash): test coverage + verification gate
- trace-helper.sh: SDLC trace log utility sourced by all hooks

### Promoted 3 rules from POA
- new-dependency-check.md: 5-point checklist before npm install
- schema-management.md: never db push, always migrate dev
- sdlc-gates.md: pre-build, post-build, failure chain enforcement

### Created writing guide + /linkedin + /feynman skills
- Writing guide (standards/writing-guide.md): two registers — chronicles (technical) vs LinkedIn (enterprise)
- Technical vocabulary rule: name the concept, explain in operating model terms, skip implementation
- /linkedin: drafts 3 posts per session calibrated to PE/search/board audience
- /feynman: plain-English technical explanation for CTO-vettable sidebars

### Wrote + rewrote LinkedIn posts (3 rounds)
- Round 1: too developer-focused, no "so what" for PE audience
- Round 2: good enterprise framing but too vague — missing named technical concepts
- Round 3: named concepts (temperance, quality gates, diagnostic chains, capability restriction) explained in operating model terms. 3 posts pushed to Google Doc.

### Rewrote session-continuity.md
- Comprehensive standard covering session start/run/end protocols
- Parallel agent safety: SESSION_LOCK, worktree isolation, stale lock detection
- Required project setup: docs/ directory structure, LinkedIn doc config, --add-dir
- Artifact inventory: what gets written when and where

### Built save-state infrastructure
- save-state.sh: commits, pushes, writes LAST_SAVE (timestamp + machine + branch)
- Session-end auto-calls save-state
- Session-start shows LAST SAVE STATE
- macOS launchd auto-save every 15 minutes for idle sessions

### Full POA audit
- Audited all 30 .claude/ files (8 rules, 13 skills, 9 hooks)
- Classified each as: duplicate (promote to canonical), app-specific (keep), or promotion candidate
- Identified 12 skills, 7 hooks, 3 rules to promote

### Gap analysis against practitioners
- Created 5 gap tickets (#29-#33): agents, hooks, skills, rules+settings, CLAUDE.md
- Created 6 TODO tickets (#23-#28): chronicles, danger mode, traces, LinkedIn workflow, Google auth, POA cross-reference

### Established terminology
- Substrate = .claude/* (infrastructure layer)
- HUD = UX built on top for end users

## Decisions Made
- Commands deprecated → all skills in canonical SKILL.md format
- Writing guide: name concepts in operating model terms, not implementation
- LinkedIn audience: PE partners, executive search leaders, board-level operators
- Bezos/Jassy/Collison tone — no AI hype, no coding tutorials
- /feynman for CTO-vettable sidebars (4 parts: what, why, analogy, precision)
- Trace logs deferred (causing operational issues, delivering no value yet)

## Key Files Changed
- `.claude/settings.json` — fixed hook format, wired all 7 hooks
- `.claude/skills/` — 14→17 skills (5 migrated + 9 promoted + /linkedin + /feynman + /promote)
- `.claude/hooks/` — 7 hooks promoted from POA
- `.claude/rules/` — 6→9 rules (3 promoted from POA)
- `standards/writing-guide.md` — NEW
- `strategy/session-continuity.md` — REWRITTEN
- `chronicle/2026-03-30-claude-infrastructure.md` — updated
- `docs/linkedin-drafts/2026-03-30.md` — 3 rounds of rewrites

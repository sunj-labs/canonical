# .claude/ Infrastructure Draft — Platform-Docs as Agent OS

## Overview

This is the proposed `.claude/` structure for **platform-docs** (the shared standard) and the pattern that **app repos** (POA, future apps) would import via `--add-dir`.

Platform-docs is a documentation repo, not an app repo. Its `.claude/` infrastructure serves two purposes:
1. **Govern agents working in this repo** (editing standards, writing canvases, chronicling)
2. **Export reusable rules/commands/agents** that app repos inherit via `--add-dir`

---

## Proposed Structure

```
platform-docs/
├── CLAUDE.md                          ← Agent instruction manual (under 200 lines)
├── .claude/
│   ├── settings.json                  ← Permission tiers for autonomous operation
│   ├── rules/
│   │   ├── commit-conventions.md      ← From standards/commit-conventions.md
│   │   ├── testing.md                 ← From standards/testing-strategy.md
│   │   ├── security.md               ← From standards/security-scanning.md
│   │   ├── diagnosis.md              ← From standards/diagnosis.md
│   │   ├── usability.md              ← From standards/usability-check.md (path-scoped)
│   │   └── branching.md              ← From standards/branching-strategy.md
│   ├── commands/
│   │   ├── diagnose.md               ← /diagnose — run 3-step diagnosis before fixing
│   │   ├── chronicle.md              ← /chronicle — write session chronicle entry
│   │   ├── canvas.md                 ← /canvas — create new product canvas from template
│   │   ├── spec.md                   ← /spec — generate structured spec from canvas/issue
│   │   └── retro.md                  ← /retro — session retrospective + open threads
│   ├── agents/
│   │   ├── code-reviewer.md          ← Read-only reviewer against standards
│   │   ├── spec-writer.md            ← Generates specs from canvases/issues
│   │   └── session-retro.md          ← Summarizes session, writes chronicle
│   └── skills/
│       └── sdlc-checkpoint/
│           ├── SKILL.md              ← Pre-build gate: have you done canvas → spec → design?
│           └── references/
│               └── sdlc-flow.md      ← Loaded on demand from strategy/
```

---

## File Contents

### CLAUDE.md (root)

```markdown
# sunj-labs / platform-docs

## What this repo is
Strategy, design system, architecture decisions, and engineering standards
for sunj-labs. This is the shared methodology — app repos import from here.

## Tech context
- Pure documentation (Markdown, no application code)
- Standards in standards/, strategy in strategy/, design in design/
- Canvases in strategy/canvases/ (product thinking artifacts)
- Chronicles in chronicle/ (session records)
- ADRs in architecture/decisions/

## Conventions
- Conventional commits: type: description (see .claude/rules/commit-conventions.md)
- Canvases follow the three-stage template: Thesis → Shape → Build Sequence
- Chronicles use frontmatter: session_id, project, agent, status, tags
- New standards go in standards/, not inline in other docs
- Object model changes require updating design/object-model.md

## Current state
- 7 canvases, 18 chronicles, 11 ADRs, 7 standards
- sdlc-portable/ = extractable subset for any platform
- Active initiative: multi-agent autonomous SDLC (see latest canvas)

## What NOT to do
- Don't create new top-level directories without discussion
- Don't duplicate content across sdlc-portable/ and standards/ — one is the source
- Don't write canvases without running through all three stages (Thesis → Shape → Build)
- Don't skip the diagnosis standard when investigating failures
```

### .claude/settings.json

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Write",
      "Edit",
      "Bash(git status*)",
      "Bash(git diff*)",
      "Bash(git log*)",
      "Bash(git add*)",
      "Bash(git commit*)",
      "Bash(ls*)"
    ],
    "deny": [
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Bash(rm -rf*)",
      "Bash(git checkout -- .)"
    ]
  },
  "env": {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50"
  }
}
```

### .claude/rules/commit-conventions.md

```markdown
---
globs: ["*"]
description: Commit message format — applies to all files
---

Use Conventional Commits format:

  <type>: <description>

Types: feat, fix, docs, refactor, test, ci, chore, security
Rules:
- Imperative mood, lowercase, no period, max 72 chars
- Body: explain WHY, not what (the diff shows what)
- Footer: Closes #NNN or Ref #NNN
- PR titles become squash commit messages
```

### .claude/rules/testing.md

```markdown
---
globs: ["**/*.ts", "**/*.tsx", "**/*.test.*", "**/*.spec.*"]
description: Testing requirements — loads when touching source or test files
---

Three-layer test strategy:
1. Unit (vitest) — pure function logic, pre-commit WARN if new source has no test
2. Integration — pipeline wiring, Docker Compose test DB
3. E2E (playwright) — critical user paths only, smoke tests post-deploy

Coverage policy:
- 100% branch coverage for safety rules
- ≥80% line coverage for business logic
- Skip glue code, trivial getters, third-party internals, LLM output content

Naming: test_{what}_{scenario}_{expected_outcome}
Fixtures: factories not hardcoded data, mock external APIs only
```

### .claude/rules/security.md

```markdown
---
globs: ["**/*.ts", "**/*.tsx", "**/*.json", ".env*", "Dockerfile*"]
description: Security scanning requirements — loads when touching source, config, or infra files
---

Three-layer security pipeline:
1. Secret detection (gitleaks) — pre-commit + CI
2. Dependency vulnerabilities (npm audit, audit-ci) — CI
3. SAST (ESLint security plugins, TypeScript compiler) — CI

Rules:
- Never commit .env files, credentials, or API keys
- All user input must be validated at system boundaries
- Use parameterized queries (Prisma handles this)
- No secrets in code or logs — use environment variables
- OWASP top 10 awareness: XSS, injection, broken auth, SSRF
```

### .claude/rules/diagnosis.md

```markdown
---
globs: ["*"]
description: Diagnosis before fix — triggers when working on bug fixes
---

When a failure's cause is not immediately obvious, run diagnosis BEFORE writing any fix:

Step 1 — Is/Is Not: Fill in the table. What fails? What similar thing works?
Step 2 — Five Whys: Trace to something changeable that prevents the class of failure.
Step 3 — Hypothesis + Test: One sentence hypothesis, minimum falsifiable check.

Output: diagnosis comment on the ticket BEFORE opening a fix PR.

Skip ONLY when cause is immediately obvious and reproducible (typo, missing env var, trivial off-by-one).
When in doubt, run it. Step 1 takes two minutes.
```

### .claude/rules/usability.md

```markdown
---
globs: ["src/app/**/page.tsx", "src/components/**/*.tsx", "**/*.css"]
description: Usability check — loads only when touching UI files
---

Post-build gate for UI changes. Run before merge:

1. Role check — sign in as least-privileged role, no operator jargon visible
2. Scanning distance — no label...value patterns wider than ~150px
3. Typography hierarchy — key numbers 14px+ bold, no text <11px
4. Jargon & copy — no database enums, externalized labels, multi-tenant ready
5. Attribution — show WHO not just aggregates
6. Accessibility — 44px tap targets, 4.5:1 contrast, no translucent text backgrounds
7. Consistency — same badge treatment for same status everywhere

For significant UI changes: screenshot each surface and attach to PR.
```

### .claude/rules/branching.md

```markdown
---
globs: ["*"]
description: Branching strategy — trunk-based development
---

Trunk-based development (solo variant):
- main is always deployable
- Branch naming: feature/ISSUE-NNN-short-description
- Flow: issue → branch → PR → CI → squash merge → delete branch
- No long-lived branches (>5 days)
- Force push forbidden on main
- Semantic versioning tags for releases
```

### .claude/commands/diagnose.md

```markdown
# /diagnose — Root Cause Analysis Before Fix

Run the three-step diagnosis standard before writing any fix code.

## Steps

1. **Is/Is Not table**: Ask the user (or determine from context) what is failing and what similar thing is NOT failing. Write the table.

2. **Five Whys**: Starting from the symptom, ask "why" five times. Stop when you reach something changeable that prevents the class of failure.

3. **Hypothesis + Test**: Write a one-sentence hypothesis. Identify the minimum falsifiable check (a test, a log, a query) that would confirm or refute it.

## Output

Write a diagnosis comment as a markdown block:

```
### Diagnosis

**Is/Is Not**
| IS (failing) | IS NOT (working) |
|---|---|
| ... | ... |

**Root cause chain**
1. Why? → ...
2. Why? → ...
3. Why? → ...
4. Why? → ...
5. Why? → ... ← root cause

**Hypothesis**: [one sentence]
**Test**: [minimum falsifiable check]
```

Only after completing this, proceed to write the fix.
```

### .claude/commands/chronicle.md

```markdown
# /chronicle — Write Session Chronicle Entry

Create a timestamped chronicle entry for the current session.

## Steps

1. Check `chronicle/` for the latest entry to understand the format and sequence
2. Determine today's date and a descriptive title for the session's work
3. Summarize what was accomplished, decisions made, and open threads

## Output format

Write to `chronicle/{date}-{slug}.md`:

```markdown
---
session_id: {date}-{time}
project: platform-docs (or the active project)
agent: personal
status: completed
tags: [relevant, tags]
---

# Session: {Title}

## Entry State
- State before this session

## Work Done
- Bullet points of accomplishments

## Decisions Made
- Key decisions with rationale

## Open Threads
- What's unfinished or needs follow-up

## Key Files Changed
- List of files created or modified
```
```

### .claude/commands/canvas.md

```markdown
# /canvas — Create Product Canvas

Create a new product canvas following the three-stage template.

## Steps

1. Ask the user for the initiative name (or infer from context)
2. Read `strategy/templates/product-canvas.md` for the template
3. Read the most recent canvas in `strategy/canvases/` for style reference
4. Walk through each stage with the user:
   - **Stage 1: Thesis** (5 min) — value proposition, audience, problem, bet
   - **Stage 2: Shape** (30 min) — detailed design of the approach
   - **Stage 3: Build Sequence** — phased implementation plan

## Output

Write to `strategy/canvases/{date}-{slug}.md`

## Rules
- Do not skip stages — each one forces a different kind of clarity
- Value proposition must be one sentence
- The Bet section must be concrete enough to falsify
- Build Sequence must have phased checkboxes
```

### .claude/commands/spec.md

```markdown
# /spec — Generate Structured Spec from Canvas or Issue

Bridge the gap between a canvas (product thinking) and GitHub Issues (work items).

## Input

The user provides either:
- A canvas filename from `strategy/canvases/`
- A GitHub Issue number
- A verbal description of what needs to be specified

## Steps

1. Read the source material (canvas, issue, or user description)
2. Read `strategy/templates/spec-template.md` for the format
3. Generate a structured spec with:
   - **Context**: link back to canvas/issue
   - **Requirements**: Must Have / Should Have / Won't Have (this round)
   - **Acceptance criteria**: specific, testable conditions (not "works correctly")
   - **Design**: user flow, object model impact, interface contract
   - **Technical approach**: how to implement, key files affected
   - **Open questions**: anything that needs human decision before building

## Output

Write to `specs/{date}-{slug}.md` (create specs/ directory if needed)

## Rules
- Every requirement must have at least one testable acceptance criterion
- If a canvas doesn't have enough detail for a spec, say so — don't invent requirements
- Link back to the source canvas or issue in the Context section
```

### .claude/commands/retro.md

```markdown
# /retro — Session Retrospective

Reflect on the current session and capture learnings.

## Steps

1. Review what was accomplished in this session (git log, files changed)
2. Identify:
   - What went well (approaches that worked, decisions validated)
   - What was harder than expected (and why)
   - What should change for next session
3. Check for open threads that need to carry forward

## Output

Append to the current session's chronicle entry, or create one if it doesn't exist (use /chronicle format).

Add a `## Retrospective` section:

```markdown
## Retrospective

### Went well
- ...

### Harder than expected
- ...

### Change for next time
- ...
```
```

### .claude/agents/code-reviewer.md

```markdown
---
name: CodeReviewer
description: Read-only code reviewer that checks against sunj-labs standards
tools: Read, Glob, Grep
---

You are a code reviewer for sunj-labs projects. You can ONLY read — you cannot edit, write, or execute code.

Your job:
1. Read the changed files (from git diff or PR)
2. Check against the standards in this repo's standards/ directory
3. Flag violations with specific file:line references and the standard being violated

Review dimensions:
- Commit message format (standards/commit-conventions.md)
- Test coverage expectations (standards/testing-strategy.md)
- Security concerns (standards/security-scanning.md)
- UI usability (standards/usability-check.md) — only if UI files changed
- Diagnosis evidence (standards/diagnosis.md) — only if this is a bug fix

Output format:
- Start with a one-line summary: APPROVE / REQUEST CHANGES / COMMENT
- List findings grouped by severity: BLOCK (must fix) / WARN (should fix) / NOTE (consider)
- Reference the specific standard for each finding

You do NOT suggest refactors, style preferences, or "improvements" beyond what the standards require.
```

### .claude/agents/spec-writer.md

```markdown
---
name: SpecWriter
description: Generates structured specs from canvases and issues
tools: Read, Write, Glob, Grep, WebSearch
---

You are a specification writer for sunj-labs. Your job is to bridge the gap between product thinking (canvases) and engineering work (GitHub Issues).

Process:
1. Read the source material — canvas, issue, or conversation
2. Read strategy/templates/spec-template.md for the format
3. Read design/object-model.md to understand existing domain objects
4. Generate a spec with structured requirements and testable acceptance criteria

Rules:
- Every Must Have requirement needs at least one acceptance criterion
- Acceptance criteria must be testable — not "works correctly" but "returns HTTP 200 with JSON body containing dealId when given valid input"
- If the canvas is too vague for a spec, list what questions need answering first
- Reference existing objects from the object model; flag when new objects are needed
- Link back to the source canvas/issue

You do NOT implement. You specify.
```

### .claude/agents/session-retro.md

```markdown
---
name: SessionRetro
description: Summarizes a session and writes the chronicle entry
tools: Read, Write, Glob, Grep
---

You are the session chronicler for sunj-labs. After a working session, you:

1. Read git log for recent commits in the session timeframe
2. Read any files created or modified
3. Identify decisions made, work completed, and open threads
4. Write a chronicle entry to chronicle/{date}-{slug}.md

Follow the chronicle format from strategy/session-continuity.md:
- Frontmatter with session_id, project, agent, status, tags
- Entry State / Work Done / Decisions Made / Open Threads / Key Files Changed

Be factual, not promotional. Record what happened, not how great it was.
```

### .claude/skills/sdlc-checkpoint/SKILL.md

```markdown
---
name: SDLC Checkpoint
description: Pre-build gate — verifies the SDLC flow was followed before implementation starts
triggers:
  - "start implementing"
  - "begin coding"
  - "write the code"
  - "build this"
---

# SDLC Checkpoint

Before writing implementation code, verify the SDLC flow was followed:

## Checklist

1. **Canvas exists?** — Is there a canvas in strategy/canvases/ for this initiative?
   - If no: STOP. Run /canvas first. Don't build without a thesis.

2. **Spec exists?** — Is there a structured spec with acceptance criteria?
   - If no and scope is non-trivial: WARN. Run /spec first.
   - If scope is trivial (typo fix, config change): proceed.

3. **Issue exists?** — Is there a GitHub Issue tracking this work?
   - If no: WARN. Create one for traceability.

4. **Design artifacts?** — For UI changes: do wireframes or state diagrams exist?
   - If touching UI and no design artifacts: WARN. Consider UX translation chain.

5. **Branch created?** — Is work happening on a feature branch, not main?
   - If on main: BLOCK. Create a branch first.

## Output

Print the checklist with pass/fail/skip for each item.
If any BLOCK: refuse to proceed until resolved.
If any WARN: note the risk and ask the user whether to proceed.
```

---

## How App Repos Import This

An app repo (e.g., POA) would:

1. **Not duplicate** any of this — no copying rules or commands
2. **Run with**: `claude --add-dir ~/src/sunj-labs/platform-docs`
3. **Have its own CLAUDE.md** with app-specific context (stack, architecture, current state)
4. **Have its own .claude/settings.json** with app-specific permissions (e.g., allow `Bash(npm run*)`)
5. **Optionally add app-specific rules** in its own `.claude/rules/` that layer on top

The agent sees both repos. Platform-docs rules apply globally; app-specific rules apply locally.

---

## What This Changes

| Before | After |
|--------|-------|
| Standards exist as docs a human reads | Standards load into agent context automatically |
| Agent discovers conventions by reading CLAUDE.md prose | Agent gets scoped rules that load only when relevant |
| No way to run diagnosis/chronicle/canvas without remembering the format | Slash commands encode the workflow |
| All agents have all permissions | Named agents with restricted tool sets |
| Human must be present for every session | settings.json defines what's safe to do unsupervised |
| App repos duplicate conventions | App repos inherit via --add-dir |

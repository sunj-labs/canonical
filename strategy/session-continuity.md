# Session Continuity Standard

## Principle

The repo is the state. Any device — mobile, Mac, cloud, CI — can pick up
work after `git pull`. No platform-specific memory. No external state.
No conversation history needed.

This standard governs how sessions start, run, and end so that context
is never lost between sessions, machines, or agents.

---

## Three Layers of Memory

1. **Git is the ground truth.** Specs, ADRs, canvases, chronicles, SDLC
   traces — durable, versioned, searchable. If a decision matters, it's
   in git. If it's not in git, it didn't happen.

2. **CLAUDE.md + .claude/ per repo.** The agent's operating system.
   CLAUDE.md is the instruction manual. `.claude/rules/` loads standards
   contextually. `.claude/commands/` and `.claude/skills/` encode workflows.
   App repos inherit shared standards from platform-docs via `--add-dir`.

3. **Structured session artifacts.** Written every session, committed to
   the repo. These are what the next session reads to pick up where the
   last one left off.

---

## Session Artifacts — What Gets Written When

### Every session (non-negotiable)

| Artifact | Location | Purpose |
|----------|----------|---------|
| Chronicle entry | `chronicle/YYYY-MM-DD-slug.md` (platform-docs) or `docs/chronicle/YYYY-MM-DD-slug.md` (app repos) | Narrative record: what happened, decisions made, open threads |
| Memory update | `.claude/` project memory | What was learned, what's open, what changed about the user/project |
| SDLC trace log | `docs/sdlc-traces/YYYY-MM-DD.log` | Mechanical log from hooks: which gates fired, what triggered them |

### When applicable

| Artifact | Location | Trigger |
|----------|----------|---------|
| Danger mode summary | `docs/danger-mode-summaries/YYYY-MM-DD.md` | Session used auto-complete / dangerously-skip-permissions |
| Release notes | `docs/release-notes/YYYY-MM-DD.md` | User-facing changes deployed to production |
| LinkedIn post draft | Configured Google Doc (see Project Setup below) | Any session that ships something worth sharing |

### Design artifacts (persist across sessions, updated when stale)

| Artifact | Location | Updated when |
|----------|----------|-------------|
| Canvases | `strategy/canvases/` or `docs/strategy/` | New initiative or major pivot |
| Specs | `specs/` or `docs/specs/` | Canvas → spec transition |
| Task analysis (HTA) | `docs/design/ux/task-analysis.md` | New user-facing feature or "confusing" feedback |
| IA model | `docs/design/ux/ia-model.md` | New entities, nav changes, 10+ UI commits |
| Interaction design | `docs/design/ux/interaction-design.md` | New pages, flow changes, edge case discovery |
| User stories | `docs/design/ux/user-stories.md` | New HTA → story mapping |
| Architect review | `docs/architecture/reviews/YYYY-MM-DD.md` | Every 10 commits or before launch |

---

## Session Start Protocol

Every session begins with this sequence. Hooks enforce it automatically
but the agent is responsible for doing it regardless of hook availability.

### 1. Detect parallel sessions (CRITICAL)

Before doing any work, check for signs of another active session:

```bash
# Check for uncommitted changes not made by this session
git status --porcelain

# Check for stale dev processes
lsof -i :3000 -i :3001 -t 2>/dev/null

# Check for lock files or in-progress markers
ls .claude/SESSION_LOCK 2>/dev/null
```

**If uncommitted changes or stale processes are found:**
- Do NOT proceed with work
- Ask the user: "It looks like another session was active or ended
  abruptly. Uncommitted changes: [list]. Stale processes: [list].
  Should I commit these, stash, or discard?"
- Do NOT overwrite another session's work

**Session lock protocol (for autonomous/parallel agents):**
- On session start: write `.claude/SESSION_LOCK` with agent ID + timestamp
- If lock exists and is < 2 hours old: STOP. Another agent may be active.
  Ask the user before proceeding.
- If lock exists and is > 2 hours old: stale lock. Proceed but warn.
- On session end: remove `.claude/SESSION_LOCK`
- Add `.claude/SESSION_LOCK` to `.gitignore` — it's local state, not committed.

### 2. Read memory

Read project memory from `.claude/` to recall context from prior sessions.

### 3. Check for missing session artifacts

- **Chronicle**: Are there commits since the last chronicle entry? If ≥3
  commits with no chronicle, the previous session skipped its wrap-up.
  Write the missing chronicle before starting new work.
- **Danger mode summary**: Were there commits made in auto-complete mode
  without a corresponding summary? Write it.
- **Architect review**: Are there ≥10 commits since the last review?
  This is the FIRST task, before any other work.

### 4. Reflect on current state

- Recent commits (`git log --oneline -10`)
- Open GitHub Issues (`gh issue list --limit 10`)
- Open threads from last chronicle entry
- Current branch and working tree status

### 5. Propose work, wait for human confirmation

Summarize what was done last, what's open, and propose 1-3 items.
**Do not start work until the human confirms.**

---

## Session Run Protocol

### Before writing code

1. **Temperance** — pause and think. Is this the simplest correct approach?
   Am I guessing instead of understanding? What's the blast radius?
2. **SDLC Checkpoint** — canvas exists? spec exists? issue exists? design
   artifacts exist? branch created? (See `.claude/skills/sdlc-checkpoint/`)
3. **Contextual diagram loading** — if touching schema, load ERD. If
   touching workers, load sequence diagrams. If touching UI, load state
   diagrams + IA model. The relevant design artifact should be in working
   memory before implementation starts.

### After each task (not batched)

4. **Verify** — run the verification appropriate to the change type:
   pure function → test passes, API route → hit endpoint, schema → column
   exists + Prisma regenerated, UI → usability check.
5. **Commit** — one logical change per commit, conventional commit format.

### On any failure

6. **Temperance → Diagnose** — mandatory chain. Do not retry without
   understanding. Do not brute-force. Is/Is Not → Five Whys → Hypothesis
   → Test → then fix.

---

## Session End Protocol

Every session ends with this sequence. The session-end hook reminds you,
but you are responsible for completing it.

### 1. Clean working tree

All changes committed or stashed. No orphaned work.

### 2. Chronicle entry

Write to the chronicle directory. Include:
- Entry state (what was true at session start)
- Work done (with commit refs)
- Decisions made (with rationale)
- Open threads (what's unfinished — this is the most important section)
- Key files changed

### 3. Memory update

Save anything learned this session that future sessions need.

### 4. SDLC trace

Hooks append mechanical traces automatically. If hooks aren't available,
manually note which gates fired and what happened.

### 5. Danger mode summary (if applicable)

If the session used auto-complete or elevated permissions, write the
compact audit trail: what was done autonomously, what decisions were
made without human confirmation, any risks introduced.

### 6. LinkedIn post draft (if applicable)

If the session shipped something worth sharing — a new feature, an
architecture decision, a lesson learned — draft a LinkedIn post to the
configured Google Doc. Format: hook → insight → takeaway → CTA.

### 7. Release notes (if applicable)

If user-facing changes were deployed, write release notes in plain
language for the least technical user (family member on a phone).

### 8. Remove session lock

Remove `.claude/SESSION_LOCK` if it exists.

### 9. Next session guidance

1-2 sentences on what to pick up next. This goes in the chronicle's
Open Threads section and in memory.

---

## Parallel Agent Safety

When multiple agents may operate on the same repo (e.g., human on Mac,
scheduled agent via CI, cloud session on mobile):

### Rules

1. **One writer per repo at a time.** The session lock protocol (above)
   enforces this. Two agents writing to the same branch will conflict.

2. **Worktrees for parallel work.** If genuine parallelism is needed,
   use `claude -w` to create isolated git worktrees. Each agent gets
   its own branch. Conflicts surface at PR time, where they belong.

3. **Cross-repo is safe.** Agent A in POA and Agent B in platform-docs
   can run simultaneously — different repos, no conflict.

4. **Lock before write, check before start.** Every session checks for
   the lock file on start. If another session is active, the new session
   should either:
   - Wait (if autonomous/scheduled)
   - Ask the user (if interactive)
   - Use a worktree (if the work is independent)

5. **Stale lock recovery.** Locks older than 2 hours are assumed stale
   (the previous session crashed or the user forgot to end it). The new
   session should warn the user, check for uncommitted changes, and
   proceed carefully.

### What can go wrong

| Scenario | Detection | Recovery |
|----------|-----------|----------|
| Two sessions on same branch | SESSION_LOCK exists | Stop, ask user |
| Previous session crashed | Dirty working tree + stale lock | Commit/stash, warn user |
| Mobile session started, Mac session started | Lock file present | Stop, wait, or use worktree |
| Scheduled agent and human session overlap | Lock file present | Scheduled agent backs off |

---

## Project Setup — Required Configuration

When a new app repo adopts this standard, the following must be configured
at project initialization:

### 1. Directory structure

```
docs/
├── chronicle/              ← session records
├── danger-mode-summaries/  ← auto-complete audit trail
├── sdlc-traces/            ← hook trace logs
├── release-notes/          ← user-facing change notes
├── design/
│   └── ux/                 ← HTA, IA, interaction design, user stories
├── specs/                  ← structured specs from canvases
└── architecture/
    └── reviews/            ← architect review reports
```

### 2. .gitignore additions

```
.claude/SESSION_LOCK
```

### 3. LinkedIn post destination

Each repo configures its own Google Doc ID for LinkedIn drafts in
`substrate.config.md` under the `linkedin_doc_id` field. This prevents
cross-repo contamination (canonical drafts going to POA's doc, etc.).

```markdown
# In substrate.config.md:
linkedin_doc_id: <google-doc-id>
```

If `linkedin_doc_id` is not set, drafts stay local in
`docs/linkedin-drafts/YYYY-MM-DD.md`. The push-to-gdoc script reads
the doc ID from substrate.config.md, not from hardcoded values in rules.

The standard path for LinkedIn drafts is `docs/linkedin-drafts/` (not
`docs/linkedin/`). All repos should use this path for consistency.

### 4. Platform-docs inheritance

```bash
claude --add-dir ~/src/sunj-labs/platform-docs
```

This gives the agent access to all shared standards, rules, commands,
and skills without duplicating them in the app repo.

---

## The Rule

The repo is the handoff. `git pull` is the onboarding.

If you follow the session protocol (start → reflect → plan → execute →
verify → chronicle → end), continuity is automatic. If context is lost
between sessions, one of these steps was skipped — go back and fill the
gap before starting new work.

Documentation writes itself when you follow the process. If you find
yourself writing a standalone "documentation doc," something is wrong
with the flow.

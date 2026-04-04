# Branch Stacking Standard

## When to use

Autonomous or multi-step sessions where work spans multiple logical units
that should be independently reviewable and revertable. This extends the
trunk-based model in `.claude/rules/branching.md` for multi-branch work.

Use this standard when:
- An agent (or agents) will produce more than one PR in a session
- Work has a natural decomposition into independent or sequenced units
- You want the ability to accept some branches and reject others

---

## Core principle

**Each branch = one intent.** A branch does one thing: "Add the data model"
or "Build the list view" — not "Add data model and list view and API routes."

If you can't describe a branch's intent in one sentence, split it.

---

## Stack manifest

Before building, the agent writes a manifest declaring the planned stack.
This is the iteration's work breakdown and the Orchestrator's routing map.

**Location**: `docs/branch-stacks/YYYY-MM-DD-slug.md` in the working repo.

### Format

```markdown
# Branch Stack: [name]

**Issue**: #NNN
**Iteration bet**: [path to iteration bet]
**Execution mode**: sequential | parallel | mixed
**Date**: YYYY-MM-DD

## Branches

| # | Branch | Intent | Depends on | Parallel-safe |
|---|--------|--------|-----------|---------------|
| 1 | feature/NNN-stack-1-data-model | CRM schema + migration | none | yes |
| 2 | feature/NNN-stack-2-api-routes | CRUD API for entities | stack-1 | no |
| 3 | feature/NNN-stack-3-list-view  | List page UI | stack-1 | yes |
| 4 | feature/NNN-stack-4-detail-view | Detail page UI | stack-3 | no |

## Parallel groups

- Group A (no dependencies): stack-1
- Group B (after stack-1 merged): stack-2, stack-3 (parallel)
- Group C (after stack-3 merged): stack-4

## Acceptance criteria per branch

### stack-1: data-model
- [ ] Prisma schema with migration file
- [ ] prisma generate succeeds
- [ ] Seed script if needed

### stack-2: api-routes
- [ ] CRUD endpoints with tests
- [ ] Auth middleware applied

[... etc]
```

---

## Execution modes

### Sequential (supervised sessions)

One agent, one branch at a time. Human checkpoint between branches.

```
Agent builds stack-1
  → PR opened → human reviews → approved → merge to main
Agent builds stack-2
  → PR opened → human reviews → approved → merge to main
[...]
```

**Branch base**: Each branch is based on `main` (after the previous branch
is merged). This means each branch includes the accumulated work of prior
branches but is independently reviewable as a PR.

**Human checkpoint**: After each branch, the agent opens a PR and stops.
Human reviews. Approved → merge → agent proceeds. Rejected → agent adjusts
or the branch is discarded.

### Parallel (Cherny's worktree model)

Multiple agents in git worktrees (`claude -w`), each on its own branch,
building simultaneously. No dirty tree conflicts — each worktree is an
isolated copy of the repo.

```
Orchestrator reads stack manifest
  → Independent branches fan out to parallel worktree agents
  → Dependent branches queue behind prerequisites

Agent A (worktree 1): stack-2-api-routes
Agent B (worktree 2): stack-3-list-view
  [building simultaneously, no conflicts]

Each agent opens its own PR when done
Human reviews PRs after session (or Reviewer agent evaluates)
```

**Branch base for parallel work**: Independent branches base off `main`.
When a branch depends on another (stack-4 depends on stack-3), it bases
off the dependency branch. The manifest makes this explicit.

**Worktree lifecycle**:
- Created by Orchestrator (or human) when fanning out parallel work
- Each worktree gets one branch, one agent
- On completion: agent opens PR, worktree is available for cleanup
- Merged worktrees: deleted automatically after merge
- Abandoned worktrees (no commits after 2 hours): flagged for cleanup
- Worktree cleanup command: `git worktree prune`

**Conflict detection**: If two parallel agents modify the same file,
the Orchestrator flags this to the human. Do not attempt auto-resolution —
file-level conflicts in parallel branches indicate a decomposition problem
(the branches weren't truly independent). Fix the manifest, not the merge.

### Mixed (common in practice)

Some branches are independent (parallelize), some are dependent (sequence).
The manifest's dependency graph determines which is which.

```
Group A: stack-1 (alone, must complete first)
Group B: stack-2 + stack-3 (parallel, both depend on stack-1)
Group C: stack-4 (sequential, depends on stack-3)
```

The Orchestrator executes Group A, waits for merge, fans out Group B in
parallel worktrees, waits for Group B merges, then executes Group C.

---

## Graceful unwind

If branch N is rejected:
- **Branches that depend on N** (per manifest): also discarded
- **Branches independent of N**: survive untouched
- **Agent never needs to untangle** — independence is designed in, not retrofitted

The dependency graph in the manifest makes this mechanical:
1. Look up what depends on N (transitively)
2. Discard N and all its dependents
3. Everything else is unaffected

This is why independence is the default and dependencies are the exception.

---

## Squash merge + rebase cascade

When merging stacked PRs with squash merge (the default), each merge
rewrites history on main. This invalidates downstream PRs because their
base branch no longer matches.

### The protocol

After squash-merging PR N in a stack:

1. **Pull updated main**: `git checkout main && git pull`
2. **Rebase the next branch**: `git checkout feature/next && git rebase main`
3. **Force push with lease**: `git push --force-with-lease`
   (safe force push — fails if someone else pushed to the branch)
4. **If GitHub auto-closed downstream PRs** (this happens when the base
   branch is deleted): merge locally instead:
   ```bash
   git checkout main
   git merge --squash feature/next
   git commit -m "feat: description"
   ```
5. **Repeat** for remaining branches in stack order

### Why this happens

Squash merge creates a single new commit on main that replaces all
commits from the branch. The next branch's base commits no longer exist
on main — they were squashed into one. GitHub sees a conflict because
the branch history diverged from main.

### Auto-save checkpoint conflicts

If the auto-save launchd timer committed checkpoint files (e.g.,
`.test-baseline`) on feature branches during construction, these
checkpoints will conflict during rebase. Use `git rebase --skip` to
drop the checkpoint commits — they're not part of the real work.

The auto-save timer should be paused during autonomous sessions
(SESSION_LOCK check, see #62).

### Alternative: regular merge commits

Using regular merge commits (no squash) preserves branch relationships
and avoids the rebase cascade. Trade-off: messier main history with
merge commits. Squash is still preferred for a clean main, but the
rebase step is the cost.

---

## Naming convention

```
feature/ISSUE-NNN-stack-N-short-description
```

Examples:
- `feature/47-stack-1-crm-data-model`
- `feature/47-stack-2-crm-api-routes`
- `feature/47-stack-3-crm-list-view`

The `stack-N` segment makes merge ordering obvious in `git branch` output
and GitHub's PR list.

---

## Per-branch verification

Each branch passes `/verify` independently before the PR is opened.
CI must pass on each branch in isolation. A branch that only works when
combined with another branch is not atomic — fix the decomposition.

Exception: Dependent branches (stack-4 depends on stack-3) are verified
against their base branch, not against main alone.

---

## Integration with process framework

| Concept | Maps to |
|---------|---------|
| Branch stack | Iteration |
| Stack manifest | Iteration work breakdown |
| Individual branch | Task within iteration |
| Iteration bet | Governs the whole stack |
| Parallel groups | Orchestrator routing |

Individual branches do not need their own iteration bets. The stack-level
bet covers appetite, risk, and value for the entire body of work.

---

## Relation to existing branching rules

This standard extends `.claude/rules/branching.md`. All existing rules
still apply:
- `main` is always deployable
- Every branch ties to a GitHub Issue (stack branches share the parent issue)
- Squash merge to main
- No branches older than 5 days
- Force push on feature branches is fine, never on main

The addition: branches can now be explicitly sequenced and parallelized
via a stack manifest, with graceful unwind as a first-class property.

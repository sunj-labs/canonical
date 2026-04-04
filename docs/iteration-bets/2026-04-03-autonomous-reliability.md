## Iteration Bet: Autonomous Reliability — Fix Failures from First Live Run

**Phase**: Construction
**Subsystem**: Autonomous infrastructure (choreography, skills, agent definitions, standards)

**Scope**:
- Fix the 7 issues that caused real failures in the first autonomous run in POA
- All are documentation + small code fixes in canonical
- No new features — pure reliability improvements

**Risk being retired**:
- R-RELIABILITY: Will the next autonomous run in POA complete without the
  same failures? Every fix addresses a specific observed failure.

**Business value being proven**:
- An operator can run `/autonomous start` and trust the output — review
  gate works, merges clean, artifacts land in the right places, data
  is verified with real records, not empty state.

**Lovability signal**:
- Would I trust this system to run overnight unattended after these fixes?

**Viability signal**:
- Run `/autonomous dry-run` in POA after fixes ship. All 8 boot steps pass.
  Then run a second autonomous iteration — observe whether the same
  failures recur.

**Appetite**:
- Cost ceiling: $0 (sequential, human-gated, Max plan)
- Turn limit: 50
- Warning threshold: 75%

**Reference material**:
- POA screenshots from 2026-04-03 session (~/Photos/Screenshots/2026-04-03/)
- Canonical issues #49-65

---

## Branch Stack

| # | Branch | Issue | Intent | Depends on |
|---|--------|-------|--------|-----------|
| 1 | feature/58-reviewer-reads-pr-diffs | #58 | Reviewer reads PR diffs, not working directory | none |
| 2 | feature/62-auto-save-session-lock | #62 | Auto-save pauses when SESSION_LOCK exists | none |
| 3 | feature/61-stacked-pr-merge-protocol | #61 | Document rebase-after-squash in branch-stacking.md | none |
| 4 | feature/64-prisma-generate-must-gate | #64 | Add prisma generate to post-merge MUST gates | none |
| 5 | feature/63-tailwind-symlink-exclusion | #63 | Sync script adds @source exclusion for Tailwind v4 | none |
| 6 | feature/50-prompt-fidelity | #50 | Strengthen verbatim prompt directives | none |
| 7 | feature/65-data-management-protocol | #65 | Seed data + verify with data in Construction | none |

All branches are independent — parallel-safe. But we're running sequential
for this iteration (canonical is a docs repo, no worktree benefit).

## Acceptance criteria per branch

### 1. Reviewer reads PR diffs (#58)
- [ ] Choreography Section 3 updated: Reviewer spawned with PR number, reads `gh pr diff`
- [ ] Reviewer agent definition updated: "Read the PR diff, not the working directory"
- [ ] Construction choreography: Reviewer step explicitly says "after Builder opens PR"

### 2. Auto-save pauses on SESSION_LOCK (#62)
- [ ] auto-save-idle.sh checks for SESSION_LOCK, skips repo if present
- [ ] Comment in script explains why

### 3. Stacked PR merge protocol (#61)
- [ ] standards/branch-stacking.md: new section on squash merge + rebase cascade
- [ ] Document: after each squash merge, rebase remaining branches, force-push with lease
- [ ] Document: if GitHub auto-closes downstream PRs, merge locally with git merge --squash

### 4. Prisma generate MUST gate (#64)
- [ ] Choreography Section 9: add "prisma generate after schema merge" to MUST gates
- [ ] standards/schema-management.md: add post-merge section
- [ ] Builder agent: add to checkpointing (after merge, before declaring done)

### 5. Tailwind v4 symlink exclusion (#63)
- [ ] Document the issue and fix in standards/ or CLAUDE.md
- [ ] If canonical-sync.sh exists in canonical, add post-sync Tailwind check

### 6. Prompt fidelity (#50)
- [ ] Review CRITICAL EXECUTION RULES — strengthen if needed
- [ ] Add: "If you are tempted to summarize a prompt, STOP. Present it exactly."
- [ ] Add: "Use AskUserQuestion tool for structured input, not free-text"

### 7. Data management protocol (#65)
- [ ] New standard: standards/data-management.md
- [ ] Covers: snapshot, migrate, seed, run, test, verify with data
- [ ] Builder agent: add "seed test data" to schema migration checklist
- [ ] /verify update: schema changes must include data verification

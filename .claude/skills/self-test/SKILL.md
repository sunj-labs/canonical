---
name: self-test
description: "Validate substrate wiring — symlinks, skills, hooks, CLIs, git remote, CLAUDE.md, session artifact dirs. Run before autonomous sessions or in new environments."
user_invocable: true
disable_model_invocation: false
---

# Substrate Self-Test

A 30-second diagnostic that validates the full substrate chain. Run this
before autonomous sessions, after setting up a new environment, or when
something feels broken.

## When to invoke

- Before `/autonomous start` in a new environment
- After `boot-canonical.sh` or manual substrate setup
- When a skill, hook, or symlink fails unexpectedly
- As part of `/autonomous dry-run` (automatically)

## Procedure

Run each check in order. Report PASS / WARN / FAIL for each.

### 1. Symlinks

Check that all `.claude/skills/` and `.claude/rules/` entries resolve:

```bash
# For each symlink in .claude/skills/ and .claude/rules/
# Check: does the target exist?
for link in .claude/skills/*/SKILL.md .claude/rules/*.md; do
  if [ -L "$link" ] && [ ! -e "$link" ]; then
    echo "FAIL: broken symlink: $link"
  fi
done
```

- PASS: all symlinks resolve
- WARN: untracked symlinks (expected from canonical-sync, not a problem)
- FAIL: broken symlinks (target deleted or moved)

### 2. Skills

Validate all SKILL.md files:

```
For each .claude/skills/*/SKILL.md:
  - Does it have valid YAML frontmatter? (name, description required)
  - Is user_invocable set? (informational, not a failure)
```

- PASS: all skills parse correctly
- WARN: skill missing optional fields
- FAIL: skill with missing/broken frontmatter

### 3. Hooks

Check that hooks referenced in settings.json exist and are executable:

```
Read .claude/settings.json (project) and ~/.claude/settings.json (user)
For each hook command:
  - Does the script file exist?
  - Does it have execute permission?
  - Is the hook type valid? (PreToolUse, PostToolUse, Stop, etc.)
```

- PASS: all hooks exist and are executable
- WARN: hook script exists but not executable (chmod +x needed)
- FAIL: hook references a script that doesn't exist

### 4. CLIs

Check for required command-line tools:

```
Required: git, gh, node, npx
Optional: claude (for headless agent spawning)
```

For each:
- PASS: command exists and responds to --version
- WARN: optional command missing
- FAIL: required command missing

### 5. Git remote

```
git remote -v           # can we see origin?
gh auth status          # is GitHub auth working?
```

- PASS: remote configured and auth working
- WARN: auth expired or not configured (push will fail)
- FAIL: no remote configured

### 6. CLAUDE.md

```
Does CLAUDE.md exist at project root?
Does it reference the correct directories?
Does the skills count match actual .claude/skills/ entries?
```

- PASS: CLAUDE.md exists and is consistent
- WARN: skills count mismatch (CLAUDE.md says N, actual is M)
- FAIL: CLAUDE.md missing

### 7. Session artifact directories

Check that required directories exist (or can be created):

```
Required:
  - chronicle/ or docs/chronicle/    (session records)
  - docs/linkedin-drafts/            (LinkedIn post drafts)
  - docs/sdlc-traces/                (hook trace logs)

Conditional (standard/full level):
  - docs/iteration-bets/             (iteration bets)
  - docs/risk-register.md            (risk register — file, not dir)
  - docs/phase-state.md              (phase state — file, not dir)
```

- PASS: all required directories exist
- WARN: directory missing but can be created
- FAIL: parent directory doesn't exist (unusual)

### 8. Hook idempotency spot-check

Check for common non-idempotent patterns in hook scripts:

```
For each hook script:
  - Does it write a file then immediately check for that file?
    (SESSION_LOCK write-then-detect pattern)
  - Does it append without checking if content already exists?
  - Does it use >> without dedup?
```

- PASS: no obvious idempotency issues
- WARN: potential non-idempotent pattern detected (list them)
- FAIL: (not used — idempotency issues are warnings, not blockers)

## Output format

```
## Substrate Self-Test Report

**Date**: YYYY-MM-DD
**Repo**: [repo name]
**Branch**: [current branch]

| Check | Status | Detail |
|-------|--------|--------|
| 1. Symlinks | PASS | 25 skills, 12 rules — all resolve |
| 2. Skills | PASS | 25 skills parsed, all valid frontmatter |
| 3. Hooks | PASS | 5 hooks registered, all executable |
| 4. CLIs | PASS | git 2.x, gh 2.x, node 22.x, npx 10.x |
| 5. Git remote | PASS | origin configured, gh auth valid |
| 6. CLAUDE.md | WARN | Skills table says 23, actual is 25 |
| 7. Artifact dirs | PASS | All directories present |
| 8. Hook idempotency | WARN | session-start: writes SESSION_LOCK then detects it |

**Overall: PASS** (2 warnings)

### Warnings
- CLAUDE.md skills count mismatch: update the skills table
- session-start hook: SESSION_LOCK write-then-detect pattern may cause
  false "another session active" warnings on restart
```

## Rules

- Read-only. Do not create, modify, or delete any files.
- Report findings clearly. Do not fix issues — just identify them.
- If the operator wants to fix warnings, they can run the appropriate
  tool (e.g., update CLAUDE.md, chmod +x a hook script).
- This skill can be integrated into `/autonomous dry-run` as an
  additional validation layer.

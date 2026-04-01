---
name: deploy-prod
description: Production deployment procedure — test, build, push, CI, verify. Template for any project.
user_invocable: true
disable_model_invocation: false
---

# Deploy to Production

Standard deployment procedure. Run after code is reviewed and ready to ship.

## Procedure

### Step 1: Pre-flight

- Working tree clean? (`git status`)
- All tests pass? (`npm run test` or project equivalent)
- Build succeeds? (`npm run build` or project equivalent)
- On the correct branch? (feature branch → merge to main, or main directly)

### Step 2: Push and CI

- Push to remote: `git push`
- Wait for CI pipeline to complete
- Verify all checks pass: secret scan → lint → typecheck → SAST → audit → test → build → deploy

### Step 3: Post-deploy Verification

Run `/test-e2e` against production:

1. **Health check** — API health endpoint returns healthy
2. **Auth flow** — sign-in/sign-out cycle works
3. **Core pages** — main pages load with data
4. **API contracts** — key endpoints return expected shapes
5. **Pipeline** — background jobs running, recent jobs successful

### Step 4: Rollback (if verification fails)

- Revert the merge commit: `git revert <commit> && git push`
- CI redeploys previous version
- Run `/diagnose` on the failure before attempting again

## Pass Criteria

All post-deploy checks pass. If any fail, rollback and diagnose.

## App-Specific Override

Your project's deploy-prod skill should specify:
- Production URL and health endpoint
- SSH/access commands for server verification
- CI job names and expected durations
- Worker/queue verification commands
- Rollback-specific steps for your infrastructure

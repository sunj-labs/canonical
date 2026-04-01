---
name: test-e2e
description: End-to-end smoke test — automated + manual verification of user-facing pages and API routes.
user_invocable: true
disable_model_invocation: false
---

# End-to-End Smoke Test

Two-layer verification: automated tests first, then manual checks for what
automation can't cover (visual rendering, interactive flows, auth completion).

## Procedure

### Step 0: Automated Smoke Tests (ALWAYS run first)

Run the project's E2E test suite against local or production:

```bash
# Against local dev server (must be running)
npx vitest run src/__tests__/e2e-smoke.test.ts

# Against production (set base URL)
E2E_BASE_URL=<production-url> npx vitest run src/__tests__/e2e-smoke.test.ts
```

If any fail → run `/diagnose` before proceeding to manual checks.

### Step 1: Health Check

```bash
curl -s <app-url>/api/health | python3 -m json.tool
```

Expected: healthy status with all dependency checks passing.

### Step 2: Auth Flow (requires browser)

- Unauthenticated request → redirects to sign-in
- Sign-in page renders correctly
- After sign-in → redirects to main page (not stuck on spinner)
- User identity visible (name, role)
- Sign out → returns to sign-in
- Re-sign-in works without errors

### Step 3: Core Pages (requires auth)

For each user-facing page:
- Page loads without console errors
- Data renders (not empty state when data exists)
- Interactive elements respond (filters, pagination, navigation)
- Click-through paths work (list → detail → back)

### Step 4: API Routes

For each API endpoint:
- Protected routes require auth (401/403 without session)
- Response shape matches expected contract
- Pagination works if applicable

### Step 5: Data Pipeline Verification

Verify the backend pipeline is producing current data:
- Check record counts by source/type
- Check recent job runs and their status
- Verify no stuck or failed jobs

## Pass Criteria

- Step 0 (automated): all tests pass
- Steps 1-5 (manual): all checks pass

Any failure → run `/diagnose` before fixing.

## Maintenance

When adding a new page or API route, update the E2E smoke test file:
- New page → add auth redirect test
- New API route → add auth gate test + response shape test
- New public route → add 200 status test

The pre-build hook reminds you; the pre-commit hook warns if you forget.

## App-Specific Override

If your project has a `.claude/skills/test-e2e.md` (or `test-e2e/SKILL.md`),
it should extend this template with:
- Specific URLs (production, staging, local)
- Specific pages and their expected content
- Specific API endpoints and response shapes
- Specific pipeline verification commands (SSH, DB queries)

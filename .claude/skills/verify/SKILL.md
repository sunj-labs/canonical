---
name: verify
description: Post-build verification gate — run after each task before committing. Matches change type to appropriate verification.
user_invocable: true
disable_model_invocation: false
---

# Verify

Post-build verification gate. Run this after completing each task, BEFORE committing.

## Procedure

### Step 1: Identify Change Type

What did you just change? Pick the matching row:

| Change type | Minimum verification |
|---|---|
| Pure function (scoring, parsing) | Unit test passes for that function |
| Worker / agent / queue | Boot the worker + process at least one real job |
| API route | Hit the endpoint, verify response shape |
| Schema migration | Verify column exists in DB, Prisma client regenerated |
| Refactor (same logic, new files) | Run the code path end-to-end |
| Middleware / auth | Verify protected routes redirect AND existing routes still work |
| Scraper / data source | Trigger one real scrape, verify data lands in DB |
| Config / env var | Verify the service picks up the new value |
| Docs / config only | N/A — state "docs/config only" |

### Step 2: Run Verification

Execute the appropriate verification from the table above. Show the command and output.

### Step 3: Test Check

- **New pure function?** → Unit test exists and passes. State the test file.
- **Modified tested code?** → Test suite passes. State the count.
- **No testable logic?** → State why (docs, config, UI-only).

### Step 4: Build Check

Run the project's build command — must compile without errors.

### Step 5: Write Verification Summary

```
## Post-Build Verification
- **Change type**: [from table]
- **Verification performed**: [exact commands + output summary]
- **Tests**: [file + count, or "no testable logic"]
- **Build**: [passes / fails]
- **Result**: [PASS / FAIL — if FAIL, do not commit]
```

## Anti-patterns

- "Unit tests pass" as sufficient for workers/routes/scrapers
- Batch-verifying 5+ tasks at once
- Skipping verification because "it's a small change"
- Treating compilation as verification

---
name: test-integration
description: System integration test — verify the full data pipeline works end-to-end without mocking.
user_invocable: true
disable_model_invocation: false
---

# System Integration Test

Verify the full pipeline works end-to-end. No mocking — real services, real data.

## Procedure

### Step 1: Identify the Pipeline

Map the system's data flow. Every pipeline follows a pattern:

```
Ingest → Transform → Enrich → Process → Store → Display → Notify
```

Not every system has all stages. Identify which stages your app has.

### Step 2: Test Each Stage

For each stage in the pipeline, verify:

1. **Input**: Does the stage receive data from the previous stage?
2. **Processing**: Does it transform/enrich/process correctly?
3. **Output**: Does the result land where the next stage expects it?
4. **Error handling**: What happens when the stage fails?

#### Test pattern per stage:

```bash
# Trigger the stage
<trigger command — API call, queue job, cron, manual>

# Wait for processing
<appropriate wait — seconds for sync, minutes for async>

# Verify output
<query DB, check API response, inspect logs>
```

**Pass**: Expected output present, no errors in logs.

### Step 3: End-to-End Flow

Trigger the first stage and verify data flows all the way through to the final output:

- First stage produces raw data
- Middle stages transform and enrich it
- Final stage displays or delivers the result
- No gaps — every record that enters should exit (or be explicitly filtered with reason)

### Step 4: Cross-Source Consistency

If the system ingests from multiple sources:
- All sources have recent data
- All sources are processed equivalently
- No source is silently failing

### Step 5: API Response Contracts

For each API that serves processed data:

```bash
curl -s "<api-url>" | python3 -c "
import sys, json
d = json.load(sys.stdin)
# Assert expected fields exist
# Assert data types are correct
# Assert relationships are intact
print('OK')
"
```

## Pass Criteria

All stages produce expected output. Pipeline is healthy when data flows from ingestion through to delivery with no gaps.

Any failure → run `/diagnose` before fixing.

## App-Specific Override

If your project has a `.claude/skills/test-integration.md` (or `test-integration/SKILL.md`),
it should extend this template with:
- Specific pipeline stages (scrape→score→display, ingest→classify→route, etc.)
- Specific trigger commands (API endpoints, queue jobs, SSH commands)
- Specific verification queries (DB queries, log checks)
- Specific pass criteria per stage

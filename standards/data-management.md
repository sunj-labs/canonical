# Data Management Standard

## Principle

Verify with data, not empty state. An empty page that renders is not
verification — it proves the template works, not the feature.

---

## Schema Migration Workflow

When a branch adds or modifies Prisma schema:

### Before migration (SHOULD)

1. **Snapshot the local dev DB** — rollback point
   ```bash
   pg_dump -Fc $DATABASE_URL > docs/db-snapshots/YYYY-MM-DD-pre-{name}.dump
   ```
   Store in `docs/db-snapshots/` (create if missing). Not committed to git
   (add to `.gitignore`) — too large. Just a local safety net.

### Apply migration (MUST)

2. **Run migration**
   ```bash
   npx prisma migrate dev --name descriptive_name
   ```
   This creates the migration file AND applies it locally.

3. **Regenerate client** (MUST — see schema-management.md)
   ```bash
   npx prisma generate
   ```
   Then restart the dev server. The cached Prisma client won't pick up
   new models without a restart.

4. **Commit the migration file** with the schema change.

### After migration — seed test data (MUST for new entities)

5. **Write a seed script for new entities**
   - Location: `prisma/seeds/` or `scripts/seed-{entity}.ts`
   - Use factories, not hardcoded data (per testing.md)
   - Each new entity gets a seed file
   - Seeds are idempotent (safe to re-run, use upsert)
   - Seeds create realistic data:
     - Real-looking names, emails, phone numbers
     - Realistic distributions (not all the same value)
     - Time-spread data (some recent, some old) for testing
       time-based queries like "needs attention"
   - Minimum: 5-10 records per new entity
   - Link to existing entities where relationships exist

6. **Run the seed**
   ```bash
   npx tsx prisma/seeds/seed-{entity}.ts
   ```

### Verify with data (MUST)

7. **Verify the feature works with seeded data**
   - UI renders data, not just empty state
   - API returns seeded records
   - Queries that filter/sort/group work correctly
   - Time-based logic (e.g., "needs attention after 7 days") has
     both qualifying and non-qualifying records to test

---

## Restoring from Production (for realistic local testing)

When you need real data patterns (not just seed data):

1. **Snapshot prod** (read-only):
   ```bash
   pg_dump -Fc $PROD_DATABASE_URL > docs/db-snapshots/YYYY-MM-DD-prod.dump
   ```

2. **Restore to local dev**:
   ```bash
   pg_restore --clean --no-owner -d $DATABASE_URL docs/db-snapshots/YYYY-MM-DD-prod.dump
   ```

3. **Apply pending migrations** (prod may be behind local schema):
   ```bash
   npx prisma migrate dev
   npx prisma generate
   ```

4. **Seed new entities** that don't exist in prod yet:
   ```bash
   npx tsx prisma/seeds/seed-{new-entity}.ts
   ```

5. **Restart dev server** and verify.

**Rules**:
- NEVER modify production data. Read-only access to prod.
- All writes are to local dev only.
- Prod snapshots are NOT committed to git (add to `.gitignore`).

---

## Verify Gate Update

The `/verify` gate for schema changes must include:

| Check | What | Why |
|-------|------|-----|
| Migration applies | `prisma migrate dev` succeeds | Schema is valid |
| Client regenerates | `prisma generate` succeeds | Client knows new models |
| Seed runs | Seed script creates data | New entities have test data |
| App renders with data | UI shows seeded records | Not just empty state |
| API returns data | Endpoints return seeded records | Queries work |
| Tests pass | `vitest run` passes | No regressions |

An empty-state screenshot is NOT verification for a schema change.

---

## Seed Data Conventions

- **Factories over hardcoded data** — per testing.md
- **Naming**: `test_{what}_{scenario}` for test data factory functions
- **Realistic**: use `faker` or realistic patterns, not "test1", "test2"
- **Idempotent**: use `upsert` or check-before-create
- **Minimal**: 5-10 records per entity is enough for dev verification
- **Time-aware**: spread records across time for testing recency queries
- **Relational**: link to existing entities (deals, users) where applicable

---
globs: ["prisma/**", "**/schema.prisma", "**/migration*"]
description: Schema management — always use prisma migrate dev, never db push
---

Rule: NEVER use `prisma db push`. Always use `prisma migrate dev`.

`db push` applies changes without creating migration files — this causes schema
drift where prod and local databases diverge silently. When the local DB is
reset, unmigrated changes are lost, breaking functionality.

Workflow:
1. Edit prisma/schema.prisma
2. Run `npx prisma migrate dev --name descriptive_name`
3. This creates a migration file AND applies it locally
4. Commit the migration file with the schema change
5. On deploy, CI runs `npx prisma migrate deploy`

After DB reset:
- `npx prisma generate` — regenerate client
- Run any seed scripts
- Test auth by signing in

The session-start hook checks for schema drift. If detected, create the
missing migration before writing code.

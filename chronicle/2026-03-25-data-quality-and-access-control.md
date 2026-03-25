---
session_id: 2026-03-25-data-quality-and-access-control
date: 2026-03-25
duration: ~4 hours (across 2026-03-24 and recovery)
repos: [sunj-labs/poa]
tags: [data-quality, access-control, backups, privacy, digest, scoring, security]
---

# Session: Data Quality and Access Control

## What Shipped

### 1. Digest Data Bug Fixes — 8 bugs from screenshot review (PR #162)
- `parseCurrency` sanity cap ($10B) catches garbled numbers like "$48M EBITDA" on a laundromat
- Digest deal dedup after per-track query merge — family was seeing the same deal twice
- BBS parser filters placeholder text ("Please select your State/Country") from industry fields
- NAICS classifier: title-first matching with compound keywords for roofing, assisted living
- New ontology categories: assisted living, land development, real estate services, finance/lending
- 10 new tests, 396/396 passing

### 2. Email Allowlist — Family-Only Access (PR #168)
- `ALLOWED_EMAILS` array in auth config — only approved family members can sign in
- Google OAuth still handles identity, but sign-in rejects emails not on the list
- Operator + family emails pre-populated
- Mirror test in `api-routes.test.ts` for the allowlist
- Closes the "anyone with a Google account can sign in" gap

### 3. Database Backup and Restore Scripts (#160)
- S3 bucket `poa-backups` (us-east-1) with lifecycle rules: daily/7d, weekly/30d, monthly/90d
- IAM role `poa_ec2_backup_role` with scoped S3 policy
- Backup script: pg_dump → gzip → S3 upload with daily/weekly/monthly rotation
- Restore script: S3 download → gunzip → pg_restore with confirmation prompts
- First automated backup confirmed at 02:00 UTC
- Env var `POA_BACKUP_S3_BUCKET=poa-backups` on EC2

### 4. Privacy Policy Page (#130)
- `/privacy` route with family-scoped data handling disclosure
- Public route (no auth required) — needed for Google OAuth consent screen
- Google OAuth verification unblocked: Chrome warning resolved

### 5. DetailRow Prop Fix
- `boldlabel` → `bold label` — React was swallowing the camelCase prop silently

### 6. LinkedIn Content Pipeline
- 15-post series (v3) polished with screenshot specs and publishing cadence
- Leadership playbook (v4) and technical playbook (v1) written
- `push-to-gdoc.ts` script: markdown → Google Docs with formatting via service account
- Google Doc shared brand doc wired for append-only publishing

### 7. Session Artifacts
- SDLC trace logs for 2026-03-24 and 2026-03-25
- Test baseline snapshot committed

## What Was Learned

**Screenshot-driven QA catches what tests can't.** The 8 digest bugs (#162) were all found by reading the actual email a family member would receive. Garbled prices, duplicate deals, placeholder text — none of these would fail a unit test because the test inputs were clean. The bug was in the real data, not the logic. Lesson: periodically read your own output as a user.

**Access control has a spectrum.** The email allowlist (#168) is intentionally simple — a hardcoded array. Not a database table, not an admin UI, not RBAC. For a 6-person family, a deploy to change the list is the right ceremony. The epic (#169) for an operator interface exists for when scale demands it, but shipping the gate now was more important than shipping the UI.

**Backups are table stakes, not a feature.** The backup scripts (#160) should have shipped weeks ago. The trigger was the S3 bucket already existing from a Sanjay setup session. The lesson: infrastructure that protects data should ship before features that generate data. We got lucky that nothing broke before backups were in place.

**Content is a flywheel too.** The chronicle → LinkedIn → Google Docs pipeline creates a second flywheel: build → reflect → publish → audience → signal → build. The push-to-gdoc script closes the loop from markdown to a shareable, branded doc. The content isn't marketing — it's operational reflection that happens to be publishable.

## Post Ideas

1. **"We Found 8 Bugs by Reading Our Own Email"** — Every unit test passed. CI was green. Then we opened the actual email the family receives and found garbled prices, duplicate deals, and placeholder text where industry names should be. The bugs weren't in the logic — they were in the data. Three concepts: **production data vs test data**, **screenshot-driven QA**, **the gap between "tests pass" and "it works."**

2. **"Six People. One Array. Zero UI."** — The access control for our family platform is a hardcoded list of 6 email addresses. Not a database table. Not an admin panel. Not RBAC. A deploy to change the list is the right amount of ceremony for 6 people. The epic for a proper UI exists — but shipping the gate mattered more than shipping the interface. Three concepts: **right-sizing security**, **ceremony as a feature**, **the courage to ship simple.**

3. **"We Backed Up the Database on Day 12. We Should Have Done It on Day 1."** — The backup scripts shipped after the platform already had 2,000+ deals, family votes, and scoring history. Nothing had gone wrong yet. But "nothing has gone wrong yet" is the most dangerous state in operations — it's indistinguishable from "we haven't noticed yet." Three concepts: **survivorship bias in infrastructure**, **backups before features**, **the cost of luck running out.**

4. **"The Content Flywheel Nobody Talks About"** — Build → reflect → chronicle → publish → audience → signal → build. Every engineering session produces two outputs: the code and the story. The chronicle isn't documentation — it's operational reflection. The LinkedIn post isn't marketing — it's thinking in public. The Google Doc isn't a deliverable — it's a forcing function for clarity. Three concepts: **reflection as engineering practice**, **building in public as accountability**, **the compound returns of writing about what you build.**

5. **"React Swallowed My Prop and Said Nothing"** — `boldlabel` vs `bold label` on a React component. No error. No warning. The prop just vanished. The component rendered without the formatting. In a 2,000-line diff, a silent prop mismatch is invisible. Three concepts: **silent failures in component APIs**, **the cost of convention violations**, **why strict typing matters more at velocity.**

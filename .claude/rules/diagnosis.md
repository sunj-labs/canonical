---
globs: ["*"]
description: Three-step diagnosis before writing any fix
---

When a failure's cause is not immediately obvious, run diagnosis BEFORE writing any fix.

Step 1 — Is/Is Not (2 min):
  Fill the table. What specific thing fails? What similar thing works?
  This constrains the hypothesis space before touching code.

Step 2 — Five Whys:
  Trace to something changeable that prevents the CLASS of failure, not just this instance.
  A timeout is a symptom. Missing observability is a root cause.

Step 3 — Hypothesis + Test:
  One sentence hypothesis. Minimum falsifiable check (a test, a log, a query).

Output: diagnosis comment on the ticket BEFORE opening a fix PR.

Skip ONLY when: cause is immediately obvious and reproducible (typo, missing env var, off-by-one).
When in doubt, run it.

---
session_id: 2026-03-22-enrichment-resilience
date: 2026-03-22
duration: ~2 hours (overnight autonomous session)
repos: [sunj-labs/poa, sunj-labs/platform-docs]
tags: [enrichment, scrape-do, error-handling, email-fixes, architect-review]
---

# Session: Enrichment Resilience + Email Fixes

## What Shipped

### Scrape.do Fallback Provider (#113)
- New `scrape-do.ts` client: `api.scrape.do/?token=KEY&url=ENCODED`
- `scraper-fallback.ts`: tries ScraperAPI first, scrape.do on failure
- Enricher now uses `fetchWithFallback()` — logs which provider succeeded
- Error categorization: timeout, server_500, blocked_403, rate_limited, tls_error, circuit_open
- Per-cycle logging: "ScraperAPI: N, scrape.do: M" + error breakdown

### Email Formatting Fixes (#129)
- **Logo broken**: middleware was redirecting `/five-pandas-logo.png` to sign-in (307). Fixed by excluding `.png/.jpg/.svg/.ico` from middleware matcher.
- **Subject encoding**: em dash → ASCII dash (Gmail API double-encoded UTF-8)
- **Metrics spacing**: flex gap → inline spans with margin (email clients don't support CSS gap)
- **Role badge**: removed COLLABORATOR badge — internal jargon hidden from family

### Architect Review (33 commits)
- Verdict: READY. No blockers.
- All security, correctness, performance checks pass
- 3 test gaps closed (welcome email, scraper fallback, digest formatting)

### Tests: 235 → 253 (+18)
- 10 welcome email tests (all roles, null name, URLs)
- 8 error categorization tests (all error types)

## What Was Learned

- **Email clients don't support CSS `gap` on flexbox.** The summary metrics ("86 new today72 on your shortlist") ran together because `display: flex; gap: 16px` doesn't work in Gmail. Use inline spans with `margin-right` instead.
- **Next.js middleware catches static assets.** The matcher `/((?!_next/static|_next/image|favicon.ico).*)` doesn't exclude custom public files like `/five-pandas-logo.png`. Email clients loading the image got a 307 redirect to sign-in.
- **UTF-8 em dashes break in Gmail API subject lines.** The `—` character gets double-encoded to `Ã¢Â€Â"`. Use ASCII `-` in email subjects.
- **The enricher's ~50% failure rate isn't a regression** — it's the expected baseline. ScraperAPI standard proxies work on ~50% of BBS detail pages. The other 50% need premium proxies or an alternative provider. Scrape.do as fallback should push success rate to 70-80%+.

---

## Post Ideas

### 1. "Your Email Template Works in Your Browser and Nowhere Else"

We built a digest email with colored borders, flexbox layouts, and a logo from our own domain. It looked perfect in the browser preview. In Gmail: the logo was broken, the metrics ran together, and the subject line had encoding artifacts. Three separate bugs, three separate root causes — all invisible in browser testing.

The logo broke because our auth middleware redirected the image URL. Email clients don't send cookies, so the middleware saw an unauthenticated request and sent a 307 to the sign-in page. The metrics ran together because Gmail strips CSS `gap` from flex containers. The subject line corrupted because the Gmail API double-encoded our UTF-8 em dash. None of these are visible in a browser preview because browsers support modern CSS, send cookies, and handle Unicode natively. Three concepts: **email HTML is a different language from web HTML** (test in actual email clients, not browsers), **auth middleware must exclude static assets** (images served publicly need public paths), and **ASCII is safer than Unicode in email headers** (headers are the most restricted part of the email spec).

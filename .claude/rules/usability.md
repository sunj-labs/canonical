---
globs: ["src/app/**/page.tsx", "src/components/**/*.tsx", "**/*.css"]
description: Usability check — loads only when touching UI files
---

Post-build gate for UI changes. Run before merge.

1. Role check — sign in as least-privileged role (VIEWER/COLLABORATOR). No operator jargon visible.
2. Scanning distance — no label...value patterns wider than ~150px. Use labels-above-values for financial data.
3. Typography hierarchy — key numbers 14px+ bold, labels smaller + muted, no text <11px.
4. Jargon & copy — no database enums (BIZBUYSELL → BizBuySell), externalized labels, multi-tenant ready.
5. Attribution — show WHO performed actions, not just aggregate counts.
6. Accessibility — 44px tap targets, 4.5:1 contrast, no translucent text backgrounds.
7. Consistency — same badge treatment for same status everywhere.

For significant UI changes: screenshot each surface and attach to PR.

8. Visual verification — when Playwright MCP is available, screenshot the
   page and verify programmatically: tap target sizes via DOM inspection,
   contrast ratios, text sizes, badge consistency. Don't rely on code review
   alone for visual correctness — see what the user sees.

---
globs: ["package.json", "package-lock.json", "*.json"]
description: New dependency check — verify before adding any package
---

Before running `npm install <package>`, verify:

1. Stack compatibility — does it work with the project's framework, TypeScript strict, and container build?
2. Bundle impact — check bundlephobia.com. Client-side packages affect load time.
3. SSR compatibility — does it use window/document/localStorage? Client-only libs need "use client" + lazy loading.
4. Maintenance risk — last publish date, open issues, bus factor. Prefer packages from known orgs.
5. Alternatives — can you do this without a dependency? CSS-only, SVG, native HTML?

Process:
1. State the package name and why
2. Run the 5 checks
3. If red flags, propose alternative
4. If clear, install and add to project's Approved Dependencies list

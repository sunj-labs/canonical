# sunj-labs — SDLC Strategy & Design System Foundations

**Version:** 0.1
**Date:** 2026-02-28
**Status:** Draft

---

## Part 1: SDLC Strategy

### Philosophy

Build less. Ship what matters. Measure outcomes, not output.

Every initiative — OpenClaw, PruneGuice, deal pipeline, POA acquisitions — runs through the same lightweight process. The process exists to force clarity before code, not to create ceremony.

### The Canvas: One-Pager Before Anything Gets Built

Before a single spec is written, every initiative or major feature gets a **Lean Product Canvas** — a one-page artifact that lives in the repo and answers six questions:

```markdown
# [Initiative Name] — Product Canvas

## Problem
What pain exists? Who has it? How do they cope today?

## Solution Hypothesis
What do we believe will solve it? (One sentence.)

## Key Outcomes
What changes in the world if this works?
- Outcome 1 (measurable)
- Outcome 2 (measurable)

## Users / Personas
Who specifically benefits? (Name real types, not abstractions.)

## Risks & Assumptions
What must be true for this to work? What could kill it?

## Constraints
Budget, timeline, technical, regulatory.
```

This is not a business plan. It's a forcing function. If you can't fill this out in 30 minutes, you don't understand the problem yet.

### The PR/FAQ: For Larger Initiatives

For anything that spans multiple specs or involves external users (e.g., PruneGuice as a public tool, OpenClaw's tool marketplace), write an **Amazon-style PR/FAQ**:

```markdown
# [Initiative Name] — Press Release / FAQ

## Press Release (Written as if launching today)

### Headline
One sentence. What did we ship and why does anyone care?

### Subheadline
Who is this for and what do they get?

### Problem Paragraph
The world before this existed. Pain. Friction. Cost.

### Solution Paragraph
What we built. How it works. What changes.

### Quote (You)
Why you built it. What you believe.

### How It Works
Three steps. Maximum.

### Quote (Customer)
A fictional but realistic customer reaction.

### Call to Action
What the reader does next.

---

## FAQ

### Customer FAQ
Q: What does this cost?
Q: How is my data handled?
Q: What if it breaks something?

### Internal FAQ
Q: How long will this take to build?
Q: What's the biggest technical risk?
Q: What do we explicitly NOT build in v1?
```

The discipline is writing this **before** building. If the press release doesn't excite you, the feature isn't worth shipping.

### Lifecycle Mapping: From Canvas to Done

```
Canvas / PR-FAQ
  → User Stories (GitHub Issues)
    → Spec (markdown in /specs, linked from issue)
      → Design Review (PR on the spec)
        → Implementation (feature branch)
          → Code Review (PR)
            → CI/CD (GitHub Actions)
              → Deploy (EC2 via Tailscale)
                → Observe (Langfuse traces, logs)
                  → Retrospect (ADR if architectural)
```

**Rules:**

1. Nothing gets built without an issue.
2. No issue over size:M ships without a spec.
3. Specs are reviewed before code starts.
4. Every merge to main is deployable.
5. Outcomes are measured, not just shipped.

### Specs: The Contract Between Thinking and Building

Specs live in each repo's `/specs` directory. They are the single source of truth for what gets built and why.

```markdown
# SPEC-NNN: [Feature Name]

## Canvas Reference
Link to product canvas or PR/FAQ.

## Context
Why now? What triggered this work?

## Requirements
### Must Have
- ...
### Should Have
- ...
### Won't Have (this version)
- ...

## Design
### User Flow
Step-by-step, what the user (or system) does.

### Object Model
What are the core objects? How do they relate?
(This is Intercom's "full stack" concept — define objects, not screens.)

### Interface
Wireframe, CLI spec, API contract — whatever's appropriate.

## Technical Approach
Architecture, dependencies, risks.

## Acceptance Criteria
How we know it's done. Testable statements.

## Open Questions
Things we don't know yet.
```

### Cadence: No Sprints, Just Flow

You're a solo operator. Sprints create overhead without accountability partners. Instead:

- **Weekly review:** Sunday evening. Look at the Project board. What shipped? What's stuck? What's next?
- **Milestones:** Time-boxed goals (e.g., "PruneGuice v0.3 — Batch Actions by March 15"). Not deadlines — forcing functions for scope.
- **ADRs:** Written when you make a decision you'll forget in 3 months.

### Security Scanning: Three Layers in CI

Linting catches style. Security scanning catches threats. These are separate
concerns and all three run in GitHub Actions, blocking merge on failure.

**Layer 1: Secret Detection (pre-commit + CI)**
```yaml
# .github/workflows/security.yml
- name: Detect secrets
  uses: gitleaks/gitleaks-action@v2
  # Catches: API keys, OAuth tokens, AWS creds, passwords
  # Critical for: Anthropic keys, Gmail OAuth, Apollo.io, AWS
```
Also install as a local pre-commit hook so secrets never reach the remote:
```bash
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    hooks:
      - id: gitleaks
```

**Layer 2: Dependency Vulnerabilities (CI)**
```yaml
- name: Python dependency audit
  run: pip-audit --strict
  # Catches: Known CVEs in installed packages

- name: Node dependency audit
  run: npm audit --audit-level=high
  # If repo uses Node (e.g., docx generation)
```

**Layer 3: Static Analysis / SAST (CI)**
```yaml
- name: Python security scan
  run: bandit -r src/ -ll
  # Catches: SQL injection, hardcoded passwords,
  #          unsafe deserialization, shell injection
```

**The pipeline order matters:**
```
push → secret scan → lint → SAST → dependency audit → test → build → deploy
       ^^^^^^^^^^^^                 ^^^^^^^^^^^^^^^^^
       Fail fast on                 Fail on known
       leaked creds                 vulnerabilities
```

### Documentation: A Byproduct, Not a Project

Documentation is distributed across the system. Every artifact in the SDLC
flow produces documentation as a side effect. The only manual discipline is
updating CLAUDE.md at session exit.

| Layer | What | Where | When Updated |
|-------|------|-------|--------------|
| **ADRs** | Why decisions were made | `platform-docs/architecture/decisions/` | When you make a decision |
| **Specs** | What gets built and why | `{repo}/specs/` | Before implementation |
| **CLAUDE.md** | Current state for AI sessions | `{repo}/CLAUDE.md` | Every session exit |
| **Session logs** | What happened each session | `{repo}/sessions/` | Every session |
| **CHANGELOG** | What shipped, per release | `{repo}/CHANGELOG.md` | Every merge to main |
| **README** | What this repo is, how to run it | `{repo}/README.md` | When setup changes |
| **Runbooks** | How to operate in production | `platform-docs/runbooks/` | When ops change |
| **Design docs** | Principles, tokens, patterns | `platform-docs/design/` | When design evolves |
| **Code comments** | Why, not what | Inline | During implementation |

**The rule:** If you follow the SDLC flow (canvas → spec → session log →
CHANGELOG), documentation writes itself. If you find yourself writing a
standalone "documentation doc," something is wrong with the process.

**CHANGELOG convention** (Keep a Changelog format):
```markdown
# Changelog

## [Unreleased]
### Added
- Tool registry for OpenClaw agent subsystems

## [0.2.0] - 2026-03-15
### Added
- GitHub Actions CI/CD pipeline
### Changed
- Switched from ECR to GitHub Container Registry (ADR-004)
```

---

## Part 2: Design System Foundations

### Design Philosophy

Inspired by Intercom's full-stack design system, adapted for the age of AI.

**Core principle:** Design is not decoration. It's the structure of how things work. Every tool in the sunj-labs ecosystem should feel like it belongs to the same family — whether it's a CLI output, a web dashboard, or a Telegram bot response.

### The Full-Stack Approach (Adapted from Intercom)

Intercom's insight: a design system isn't a pattern library. It's a shared conceptual model realized at every level — from whiteboard to code to documentation.

For sunj-labs, that means:

**1. Shared Object Model**

Define the core objects across your ecosystem. These aren't UI components — they're the nouns of your business:

| Object | Description | Appears In |
|--------|-------------|------------|
| **Deal** | A potential acquisition target | OpenClaw, Deal Pipeline, POA |
| **Agent** | An AI agent with a role and tools | OpenClaw |
| **Tool** | A callable capability (PruneGuice, scraper, etc.) | OpenClaw, individual repos |
| **Task** | A unit of work tracked on the board | GitHub Projects, all repos |
| **Trace** | An observed LLM interaction | Langfuse |
| **Candidate** | An SBA 7a business listing | POA-ops, Deal Pipeline |
| **Rule** | A safety/business constraint | PruneGuice, OpenClaw |

When you build a new feature, ask: *Can I express this using objects that already exist?* New objects are expensive. Reuse is cheap.

**2. Shared Language**

Same word everywhere. A "Deal" in the Telegram bot is the same "Deal" in GitHub Issues, in Langfuse traces, in the database schema. No synonyms. No abbreviations that diverge across contexts.

**3. Shared Visual Language**

Even across different interfaces (web, CLI, Telegram), maintain:

- Consistent information hierarchy
- Consistent status indicators
- Consistent tone of voice

### NNG Principles for the AI Age

Nielsen Norman Group's research, synthesized into actionable rules for sunj-labs:

**1. AI as assistant, not autopilot.**
Your tools augment human judgment. PruneGuice suggests deletions — you confirm. OpenClaw surfaces deals — you evaluate. The human is always the strategist. The AI handles throughput.

**2. Design the seams, not just the surfaces.**
NNG emphasizes that AI shifts design work from tactical to strategic. For your tools: spend more time on the decision architecture (what information does the user need to make a good call?) and less on pixel perfection.

**3. Conservative automation, progressive disclosure.**
Start every AI-powered feature in "suggest" mode. Graduate to "auto-execute" only after trust is established through observed accuracy. This is your PruneGuice safety philosophy, generalized.

**4. Trace everything.**
NNG's research agenda emphasizes that AI systems need observability. Langfuse isn't optional — it's how you maintain taste and quality as automation scales.

**5. The generalist advantage.**
NNG argues that AI makes UX generalists more valuable than specialists. You are that generalist. Your design system should enable you to move fast across contexts without specialist tooling.

### Visual Design Tokens

A minimal set of design decisions that propagate everywhere. Not a full design system — a seed.

```
/* sunj-labs design tokens */

/* Typography */
--font-primary: "Inter", -apple-system, sans-serif;
--font-mono: "JetBrains Mono", "Fira Code", monospace;
--font-size-base: 16px;
--font-size-sm: 14px;
--font-size-lg: 20px;
--font-size-xl: 28px;
--font-size-2xl: 36px;
--line-height-tight: 1.25;
--line-height-normal: 1.5;
--line-height-relaxed: 1.75;

/* Color — Neutral-first, accent sparingly */
--color-bg: #FFFFFF;
--color-bg-subtle: #F7F8FA;
--color-bg-muted: #EBEDF0;
--color-text: #1A1A1A;
--color-text-secondary: #6B7280;
--color-text-muted: #9CA3AF;
--color-border: #E5E7EB;
--color-border-strong: #D1D5DB;

/* Accent — One primary, one for danger. That's it. */
--color-accent: #2563EB;        /* Blue — actions, links */
--color-accent-hover: #1D4ED8;
--color-success: #059669;       /* Green — confirmations */
--color-warning: #D97706;       /* Amber — caution */
--color-danger: #DC2626;        /* Red — destructive, errors */

/* Status indicators — consistent everywhere */
--color-status-active: #059669;
--color-status-pending: #D97706;
--color-status-error: #DC2626;
--color-status-inactive: #9CA3AF;

/* Spacing — 4px base grid */
--space-1: 4px;
--space-2: 8px;
--space-3: 12px;
--space-4: 16px;
--space-6: 24px;
--space-8: 32px;
--space-12: 48px;
--space-16: 64px;

/* Radius */
--radius-sm: 4px;
--radius-md: 8px;
--radius-lg: 12px;
--radius-full: 9999px;

/* Shadows — minimal */
--shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
--shadow-md: 0 4px 6px rgba(0,0,0,0.07);
--shadow-lg: 0 10px 15px rgba(0,0,0,0.1);

/* Dark mode overrides */
--color-bg-dark: #0F1117;
--color-bg-subtle-dark: #1A1D27;
--color-text-dark: #F0F0F0;
--color-text-secondary-dark: #A0A7B5;
--color-border-dark: #2D3140;
```

### Design Principles (The Five Rules)

These live in `platform-docs/standards/design-principles.md` and guide every UI decision:

**1. Clarity over cleverness.**
Every screen, every CLI output, every bot message answers one question: *What should I do next?* If the answer isn't obvious, the design failed. (Apple, Intercom)

**2. Show the work.**
AI systems should expose their reasoning. Show confidence levels. Show sources. Show what was considered and rejected. Trust is built through transparency, not magic. (NNG, IDEO)

**3. Progressive density.**
Start sparse. Add information as the user asks for it. A deal summary starts as three lines. Drill down for financials. Drill deeper for source data. (Google Material, Apple HIG)

**4. Consistent objects, flexible surfaces.**
A "Deal" looks different in Telegram than in a web dashboard, but it always contains the same core information in the same hierarchy. The object model is fixed. The rendering adapts. (Intercom full-stack)

**5. Respect the operator.**
You are the user. Don't patronize with unnecessary confirmations on safe actions. Do demand confirmation on destructive ones. Match the tool to the operator's skill level — expert-friendly defaults with safety rails on the dangerous stuff. (IDEO human-centered)

### Component Patterns (Starter Kit)

Not a full component library. A set of patterns to reuse when generating frontends with AI.

**Card — The universal container:**
```
┌─────────────────────────────────────┐
│ [Status]           [Type]  [Action] │
│                                     │
│ Title                               │
│ Subtitle / metadata                 │
│                                     │
│ Key metric or summary               │
│                                     │
│ [Secondary action]    [Primary CTA] │
└─────────────────────────────────────┘
```

**Data Table — For lists of objects:**
```
┌──────────┬──────────┬─────────┬────────┐
│ Name ↕   │ Status   │ Value   │ Action │
├──────────┼──────────┼─────────┼────────┤
│ Row      │ ●Active  │ $1.2M   │ View → │
│ Row      │ ○Pending │ $800K   │ View → │
└──────────┴──────────┴─────────┴────────┘
```

**Status Badge — Consistent everywhere:**
- `● Active` (green)
- `◐ Pending` (amber)
- `✕ Error` (red)
- `○ Inactive` (gray)

**CLI Output — Structured for scanning:**
```
[2026-02-28 14:30] ✓ Deal sourced: Acme Testing Labs
  Revenue: $1.2M | Profit: $380K | Ask: $1.5M
  Source: BizBuySell | Confidence: 0.82
  → Run: openclaw evaluate --deal acme-testing-labs
```

**Telegram Bot — Concise, actionable:**
```
🔍 New Deal Found

Acme Testing Labs
Revenue: $1.2M | Profit: $380K
Ask: $1.5M | Conf: 82%

/evaluate acme-testing-labs
/skip acme-testing-labs
/details acme-testing-labs
```

---

## Part 3: Integration with GitHub

### Where These Documents Live

```
platform-docs/
├── strategy/
│   ├── sdlc-process.md          ← This document (Part 1)
│   ├── templates/
│   │   ├── product-canvas.md
│   │   ├── pr-faq.md
│   │   └── spec-template.md
│   └── canvases/                ← Filled-in canvases per initiative
│       ├── openclaw.md
│       ├── pruneguice.md
│       ├── deal-pipeline.md
│       └── poa-ops.md
├── design/
│   ├── design-principles.md     ← The Seven Rules
│   ├── design-tokens.css        ← CSS custom properties
│   ├── object-model.md          ← Shared object definitions
│   ├── component-patterns.md    ← Card, table, status, CLI patterns
│   └── ai-design-guidelines.md  ← NNG-informed AI UX rules
├── architecture/
│   ├── system-context.md
│   ├── container-diagram.md
│   └── decisions/               ← ADRs
├── standards/
│   ├── branching-strategy.md
│   ├── commit-conventions.md
│   ├── frontend-stack.md        ← Next.js + TypeScript + Tailwind + shadcn/ui
│   ├── security-scanning.md     ← gitleaks, bandit, pip-audit
│   └── testing-requirements.md
└── runbooks/
```

### GitHub Issue Templates Reference Design Docs

Every user story template links back:

```yaml
# .github/ISSUE_TEMPLATE/user-story.yml
name: User Story
description: A user-facing capability
body:
  - type: markdown
    attributes:
      value: |
        **Before writing this story, ensure a [Product Canvas](../platform-docs/strategy/templates/product-canvas.md) exists for this initiative.**
        **Reference the [Design Principles](../platform-docs/design/design-principles.md) when specifying acceptance criteria.**
  - type: textarea
    id: story
    attributes:
      label: User Story
      placeholder: "As a [persona], I want [capability], so that [outcome]."
  - type: textarea
    id: acceptance
    attributes:
      label: Acceptance Criteria
      placeholder: "Given... When... Then..."
  - type: textarea
    id: design-notes
    attributes:
      label: Design Notes
      description: "Reference objects from the object model. Note which component patterns apply."
  - type: dropdown
    id: size
    attributes:
      label: Size
      options: ["S", "M", "L", "XL"]
  - type: input
    id: spec-link
    attributes:
      label: Spec Link
      placeholder: "/specs/SPEC-NNN-feature-name.md"
```

### AI-Assisted Frontend Generation

When you need a new UI, the design tokens and component patterns become your prompt context:

```
Prompt to Claude (or OpenClaw):

"Build a React dashboard for viewing deal pipeline status.
Use the design tokens from platform-docs/design/design-tokens.css.
Follow the component patterns: Card for deal summaries, Data Table
for the list view, Status Badges for deal stage.
Follow the Five Rules — especially 'show the work' (expose
confidence scores) and 'progressive density' (summary first,
drill-down on click)."
```

The design system becomes a **prompt library** — not rigid templates, but shared vocabulary that produces consistent results across AI-generated frontends.

### Frontend Stack Standard

**Decision:** Next.js + TypeScript + Tailwind CSS + shadcn/ui

```
Next.js 14+ (App Router)
├── TypeScript         — type safety for real-money decisions
├── Tailwind CSS       — design tokens map directly to utilities
├── shadcn/ui          — copy-paste components you own and customize
└── Deploy via:
    ├── Vercel          — free tier, zero-config (default for standalone apps)
    └── Docker on EC2   — when colocated with backend services
```

**Why this stack:**
- Next.js gives you static, server-rendered, and API routes in one framework
- Anthropic built claude.ai on Next.js — AI code generation quality is highest here
- Tailwind maps 1:1 to design tokens (`--color-accent` → `text-blue-600`)
- shadcn/ui is components you copy into your project, not a dependency that updates and breaks

**Why not alternatives:**
- Plain React/Vite: no routing, no SSR, no API routes — you'd rebuild Next.js
- Vue/Svelte: great frameworks, worse AI generation quality (smaller training corpus)
- Streamlit/Gradio: ugly, non-customizable, violates every design principle above
- HTMX: cool pattern, weak AI code generation support

**shadcn/ui convention:** Components live in `/src/components/ui/`. They're modified
to use your design tokens. They don't auto-update. You own them.

**Frontend prompt pattern:**
```
"Build a [thing]. Next.js + TypeScript + Tailwind + shadcn/ui.
Use design tokens from platform-docs/design/design-tokens.css.
[Component pattern] for [object]. [Design principle] emphasis.
Reference the object model: [relevant objects]."
```

**When to build a frontend vs. stay CLI:**
- CLI: tools OpenClaw calls, developer workflows, automation scripts
- Frontend: anything a non-technical user touches (TwoDo), anything
  benefiting from visual data density (deal pipeline dashboard), anything
  you want to share with someone who won't open a terminal

---

## Part 7: Implementation Task List — Standing Up sunj-labs

Everything above is strategy. Below is the ordered task list to make it real.
Each task is sized (S/M/L) and grouped into phases. Later tasks depend on
earlier ones. Total estimated time: 2-3 focused days.

### Phase 0: GitHub Org Foundation (Day 1 Morning)

```
[ ] S  Create GitHub org: sunj-labs
[ ] S  Create .github repo (org-level defaults)
       ├── ISSUE_TEMPLATE/user-story.yml
       ├── ISSUE_TEMPLATE/bug.yml
       ├── ISSUE_TEMPLATE/spec.yml
       ├── ISSUE_TEMPLATE/task.yml
       ├── PULL_REQUEST_TEMPLATE.md
       └── workflows/
           ├── python-ci.yml        (reusable: lint + SAST + audit + test)
           ├── docker-build.yml     (reusable: build + push to GHCR)
           └── deploy-ec2.yml       (reusable: SSH via Tailscale)
[ ] S  Create label set across org:
       project:{openclaw,pruneguice,deal-pipeline,poa}
       type:{user-story,spec,bug,task,spike}
       stage:{backlog,speccing,in-progress,review,done}
       priority:{critical,high,medium,low}
       size:{S,M,L,XL}
[ ] S  Create GitHub Project (v2) — "sunj-labs Board"
       Views: Backlog | In Flight | By Project | POA Tracker | Roadmap
```

### Phase 1: Platform Docs (Day 1 Afternoon)

```
[ ] M  Create platform-docs repo with full directory structure:
       strategy/ design/ architecture/ standards/ runbooks/
[ ] S  Commit this document as platform-docs/strategy/sdlc-process.md
[ ] S  Create platform-docs/design/design-principles.md (The Seven Rules)
[ ] S  Create platform-docs/design/design-tokens.css
[ ] S  Create platform-docs/design/object-model.md
[ ] S  Create platform-docs/design/component-patterns.md
[ ] S  Create platform-docs/standards/branching-strategy.md
[ ] S  Create platform-docs/standards/commit-conventions.md
[ ] S  Create platform-docs/standards/frontend-stack.md
[ ] S  Create platform-docs/standards/security-scanning.md
[ ] S  Create platform-docs/architecture/decisions/ADR-001-github-as-idp.md
[ ] S  Create platform-docs/architecture/decisions/ADR-002-langfuse-observability.md
[ ] S  Create platform-docs/architecture/decisions/ADR-003-titans-deferred.md
[ ] S  Create platform-docs/architecture/decisions/ADR-004-frontend-stack.md
[ ] S  Create platform-docs/architecture/decisions/template.md
```

### Phase 2: Migrate Existing Repos (Day 2 Morning)

```
[ ] M  Fork/transfer openclaw to sunj-labs org
       ├── Add CLAUDE.md
       ├── Add /sessions/ directory
       ├── Add /specs/ directory (migrate existing specs)
       ├── Add .github/workflows/ci.yml (calls org reusable workflow)
       └── Add .pre-commit-config.yaml (gitleaks)
[ ] M  Fork/transfer pruneguice to sunj-labs org
       ├── Add CLAUDE.md
       ├── Add /sessions/ directory
       ├── Confirm /specs/ exists and is populated
       └── Add .github/workflows/ci.yml
[ ] S  Create deal-pipeline repo (skeleton)
       ├── CLAUDE.md, README.md, /specs/, /sessions/, /src/
       └── .github/workflows/ci.yml
[ ] S  Create poa-ops repo
       ├── CLAUDE.md, README.md
       ├── /sba-7a/criteria.md
       ├── /checklists/
       └── /candidates/
[ ] S  Create infra repo
       ├── docker-compose.yml (full stack)
       ├── scripts/bootstrap-ec2.sh
       ├── scripts/backup.sh
       └── .env.example
```

### Phase 3: CI/CD Pipeline (Day 2 Afternoon)

```
[ ] M  Build and test the reusable python-ci.yml workflow:
       secret scan → lint (ruff) → SAST (bandit) → audit (pip-audit) → test (pytest)
[ ] M  Build and test docker-build.yml:
       build → push to GitHub Container Registry
[ ] M  Build and test deploy-ec2.yml:
       SSH via Tailscale → docker-compose pull → docker-compose up -d
[ ] S  Test full pipeline: push to openclaw → CI passes → image built → deployed to EC2
[ ] S  Install pre-commit hooks locally:
       pip install pre-commit && pre-commit install
       (gitleaks runs on every commit before push)
```

### Phase 4: Backlog Population (Day 3 Morning)

```
[ ] M  Create GitHub Issues for known OpenClaw work
       (tool registry, circuit breakers, cost optimization)
[ ] M  Create GitHub Issues for PruneGuice Phase 3 remaining work
[ ] S  Create GitHub Issues for deal-pipeline MVP
[ ] S  Create GitHub Issues for POA tracking items
[ ] S  Create milestone: "OpenClaw v0.2 — Tool Registry"
[ ] S  Create milestone: "PruneGuice v0.3 — Batch Actions"
[ ] S  Create milestone: "Deal Pipeline v0.1 — MVP Scraper"
[ ] S  Triage all issues into Project board views
```

### Phase 5: Langfuse + Observability (Day 3 Afternoon)

```
[ ] M  Add Langfuse + Postgres to docker-compose.yml in infra repo
[ ] S  Deploy to EC2, verify Langfuse UI accessible via Tailscale
[ ] M  Add Langfuse Python SDK wrapper to OpenClaw
       (trace every Claude API call with model, tokens, cost, latency)
[ ] S  Verify traces visible in Langfuse dashboard
```

### Phase 6: First Session Log (Day 3 Close)

```
[ ] S  Write the first real session log using the template
[ ] S  Update CLAUDE.md in every repo with current state
[ ] S  Commit everything, verify all CI pipelines green
[ ] S  Sunday weekly review: look at the board, celebrate
```

### Not Now (Parked)

```
[ ] —  TwoDo frontend (Next.js + shadcn/ui) — separate initiative, needs canvas first
[ ] —  Titans/ChromaDB memory layer — trigger: 100+ deal evaluations
[ ] —  Custom GitHub Action for auto-CHANGELOG generation
[ ] —  Terraform for EC2 provisioning (manual is fine for one box)
```

---

## Part 4: Upgraded Design Principles — Gold Standard Sources

### Anthropic's Three Product Design Principles (Boris Cherny)

Anthropic's head of Claude Code distilled the philosophy behind Claude into three principles that are directly applicable to any AI-adjacent product you build:

**1. Understand intent, not just input.**
A good system interprets what the user is trying to accomplish, not just the literal request. For OpenClaw: when an agent receives a command, it should clarify ambiguity rather than guess. For PruneGuice: "delete old emails" means different things to different people — surface the interpretation before acting.

**2. Be honest about knowledge limits.**
Confidence without accuracy is dangerous. Your tools should say "I don't know" or "confidence: 62%" rather than hallucinate certainty. This is especially critical in deal sourcing — a false positive on a $3M acquisition target wastes months.

**3. Respect user autonomy.**
Provide information and analysis without being paternalistic. Don't hide options. Don't make decisions for the user. Present the data, surface the tradeoffs, let the operator decide. This maps directly to your "Respect the operator" principle — but Anthropic's framing is sharper.

### Anthropic's Process Principles (Catherine Wu / Boris Cherny)

How Anthropic actually builds products — and why it matters for a solo operator:

**Prototype first.** Skip the spec when you can build a working version faster. The prototype becomes the spec. Internal usage becomes the research. Feedback becomes the roadmap. This is how Cowork shipped in 10 days.

**Build for the model six months from now.** Don't optimize for current limitations. Build the architecture that will work when the models improve. This is why your Titans exploration matters.

**Underfund on purpose.** Small teams (or solo operators) forced to rely on AI tools ship faster than large teams doing it manually. You're already living this.

**Everyone codes.** At Anthropic, PMs, designers, finance, data scientists — everyone writes code. Roles blur. The generalist wins. NNG says the same thing. You are that generalist.

### Updated Design Principles (The Seven Rules)

Merging Intercom's structural thinking, NNG's AI-age research, and Anthropic's product philosophy:

**1. Clarity over cleverness.** (Apple, Intercom)
Every interaction answers: *What should I do next?*

**2. Understand intent, not just input.** (Anthropic)
Interpret what the user is trying to accomplish. Clarify before acting.

**3. Show the work.** (NNG, Anthropic)
Expose reasoning, confidence, sources. Trust is built through transparency.

**4. Be honest about limits.** (Anthropic)
Say "I don't know." Show confidence scores. Never hallucinate certainty.

**5. Progressive density.** (Apple, Google Material)
Start sparse. Add information as requested. Summary first, detail on demand.

**6. Consistent objects, flexible surfaces.** (Intercom)
The object model is fixed. The rendering adapts to context.

**7. Respect the operator.** (Anthropic, IDEO)
Present data and tradeoffs. Don't make decisions for the user. Don't patronize on safe actions. Demand confirmation on destructive ones.

---

## Part 5: Memory & Session Continuity

### The Real Memory Problem

The problem isn't architectural — it's operational. Context gets lost between
sessions with AI assistants, between agent runs, and between work days. The
fix is discipline + structure, not new infrastructure.

**Three layers of memory, simplest first:**

1. **Git is the ground truth.** Specs, ADRs, canvases, CHANGELOG.md — these
   are durable, versioned, searchable. If a decision matters, it's in git.

2. **CLAUDE.md per repo.** Borrowed from Anthropic's own practice. A file
   at the root of each repo that tells any AI assistant the project context,
   conventions, current state, and gotchas. Every session starts by reading it.

3. **Structured session logs.** Timestamped records of every working session
   with frontmatter that captures state transitions.

### Session Log Template

Lives in each repo at `/sessions/` or in the checkpoint system at
`~/openclaw-checkpoints/`:

```markdown
---
session_id: 2026-02-28-1430
project: openclaw
agent: personal
entry_time: 2026-02-28T14:30:00-08:00
exit_time: 2026-02-28T16:45:00-08:00
status: completed
tags: [ci-cd, github-actions, deployment]
---

# Session: GitHub Actions CI/CD Setup

## Entry State
- OpenClaw running on EC2 via manual docker-compose
- No automated build/deploy pipeline
- Specs exist for tool registry (SPEC-002)

## Work Done
- Created .github/workflows/ci.yml (Python lint + test)
- Created .github/workflows/deploy.yml (Docker build → ECR → EC2)
- Tested deploy via Tailscale SSH to EC2
- Updated CLAUDE.md with new deploy process

## Exit State
- CI/CD pipeline operational on push to main
- Deploy takes ~3 minutes end-to-end
- Manual rollback documented in runbooks/ec2-deploy.md

## Decisions Made
- Chose GitHub Container Registry over ECR (free, simpler)
- Skipped blue/green deploy (overkill for solo operator)

## Open Threads
- [ ] Add Langfuse container to docker-compose
- [ ] Set up circuit breaker for API spend (see ADR-004 draft)

## Next Session Should Start With
Read CLAUDE.md. Review the open threads above. Check if
GitHub Actions run succeeded overnight.
```

### CLAUDE.md Template

```markdown
# CLAUDE.md — [Project Name]

## What This Is
[One sentence description]

## Current State
[What's deployed, what's in progress, what's blocked]

## Architecture
[Key components, how they connect, where they run]

## Conventions
- Branch naming: feature/ISSUE-NNN-description
- Commit messages: conventional commits (feat:, fix:, docs:)
- Tests: pytest, run with `make test`
- Deploy: push to main triggers GitHub Actions

## Known Gotchas
- [Thing that will bite you if you don't know about it]

## Recent Changes
- [Date]: [What changed and why]

## Key Files
- /specs/ — Feature specifications
- /sessions/ — Session logs with structured frontmatter
- /src/ — Source code
- CHANGELOG.md — Release history
```

### ADR-003: Titans Memory Layer

```markdown
# ADR-003: Titans-Inspired Memory Layer for OpenClaw

## Status: DEFERRED
## Date: 2026-02-28
## Revisit: When deal pipeline hits 100-200 evaluated deals

## Context

Google's Titans architecture introduces surprise-based neural memory —
a compelling model for long-term agent context. However, the current
memory problem is session continuity, not architectural memory limits.

The three-layer approach (git + CLAUDE.md + session logs) solves the
immediate problem with zero new infrastructure.

## What Titans Would Give Us (When We Need It)

Titans combines short-term memory (attention), long-term memory
(neural memory module with surprise-based storage), and persistent
memory (fixed task knowledge). The MAC variant retrieves from
long-term memory before attention runs, letting the model decide
relevance. lucidrains/titans-pytorch is MIT-licensed, 1.9k stars,
actively maintained (last release Feb 8 2026).

## Trigger Conditions for Revisiting

1. Deal pipeline is processing 100+ deals and agents need to
   learn patterns across evaluations
2. Session logs become unwieldy (50+ sessions per project)
3. Agent-to-agent context sharing becomes a bottleneck
4. You have GPU budget to spare for training

## When Triggered, the Path Is:

Option A: ChromaDB vector store + surprise scoring as an
approximation layer. Ships in 1-2 weeks.

Option B: Train a small Titans model on accumulated deal
evaluation data using lucidrains/titans-pytorch. The Option A
vector store becomes the training dataset.

## Decision

DEFERRED. Current memory needs are met by git + CLAUDE.md +
structured session logs. Revisit when trigger conditions are met.
```

---

## Part 6: Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                      SUNJ-LABS ENTERPRISE STACK                     │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    GITHUB  (sunj-labs org)                   │    │
│  │                    ═══════════════════════                   │    │
│  │                                                             │    │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐   │    │
│  │  │ openclaw │ │pruneguice│ │  deal-   │ │   poa-ops    │   │    │
│  │  │          │ │          │ │ pipeline │ │              │   │    │
│  │  │ /specs   │ │ /specs   │ │ /specs   │ │ /sba-7a     │   │    │
│  │  │ /src     │ │ /src     │ │ /src     │ │ /checklists │   │    │
│  │  │ /sessions│ │ /sessions│ │ /sessions│ │ /candidates │   │    │
│  │  │ CLAUDE.md│ │ CLAUDE.md│ │ CLAUDE.md│ │ CLAUDE.md   │   │    │
│  │  └────┬─────┘ └────┬─────┘ └────┬─────┘ └──────┬───────┘   │    │
│  │       │             │            │              │           │    │
│  │  ┌────┴─────────────┴────────────┴──────────────┴───────┐   │    │
│  │  │              platform-docs  +  infra                  │   │    │
│  │  │  strategy/ design/ architecture/ standards/ runbooks/ │   │    │
│  │  └──────────────────────────────────────────────────────┘   │    │
│  │                                                             │    │
│  │  ┌──────────────────────────────────────────────────────┐   │    │
│  │  │           GitHub Projects v2  (cross-repo)           │   │    │
│  │  │  ┌─────────┐ ┌─────────┐ ┌──────┐ ┌────────────┐    │   │    │
│  │  │  │ Backlog │ │In Flight│ │Review│ │    Done    │    │   │    │
│  │  │  └─────────┘ └─────────┘ └──────┘ └────────────┘    │   │    │
│  │  │  Views: By Project │ Sprint │ POA Tracker │ Roadmap  │   │    │
│  │  └──────────────────────────────────────────────────────┘   │    │
│  │                                                             │    │
│  │  ┌──────────────────────────────────────────────────────┐   │    │
│  │  │              GitHub Actions  (CI/CD)                  │   │    │
│  │  │  push → secrets → lint → SAST → audit → test → build │   │    │
│  │  │         (gitleaks) (ruff) (bandit)(pip)  (pytest)     │   │    │
│  │  │                                           ↓           │   │    │
│  │  │                                    deploy to EC2      │   │    │
│  │  └──────────────────────┬───────────────────────────────┘   │    │
│  └─────────────────────────┼───────────────────────────────────┘    │
│                            │                                        │
│                            │  Docker image + SSH via Tailscale       │
│                            ▼                                        │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                  AWS EC2  (us-east-1)                        │    │
│  │                  ════════════════════                        │    │
│  │                                                             │    │
│  │  ┌─────────────────── docker-compose ───────────────────┐   │    │
│  │  │                                                       │   │    │
│  │  │  ┌─────────────────────────────────────────────────┐  │   │    │
│  │  │  │              OPENCLAW  (orchestrator)            │  │   │    │
│  │  │  │                                                 │  │   │    │
│  │  │  │  ┌──────────┐ ┌──────────┐ ┌──────────────┐    │  │   │    │
│  │  │  │  │ Personal │ │   ETA    │ │     POA      │    │  │   │    │
│  │  │  │  │  Agent   │ │  Agent   │ │    Agent     │    │  │   │    │
│  │  │  │  └────┬─────┘ └────┬─────┘ └──────┬───────┘    │  │   │    │
│  │  │  │       │             │              │            │  │   │    │
│  │  │  │       └──────┬──────┴──────────────┘            │  │   │    │
│  │  │  │              │                                  │  │   │    │
│  │  │  │              ▼  Tool Registry                   │  │   │    │
│  │  │  │  ┌──────────────────────────────────────────┐   │  │   │    │
│  │  │  │  │  CLI calls to tools (subprocess / import) │   │  │   │    │
│  │  │  │  └──────┬──────────────┬────────────────────┘   │  │   │    │
│  │  │  └─────────┼──────────────┼────────────────────────┘  │   │    │
│  │  │            │              │                            │   │    │
│  │  │            ▼              ▼                            │   │    │
│  │  │  ┌──────────────┐ ┌──────────────┐                    │   │    │
│  │  │  │  PruneGuice  │ │ Deal Pipeline│                    │   │    │
│  │  │  │  (Gmail tool)│ │  (scraper)   │                    │   │    │
│  │  │  └──────────────┘ └──────────────┘                    │   │    │
│  │  │                                                       │   │    │
│  │  │  ┌──────────────┐ ┌──────────────┐                    │   │    │
│  │  │  │   Langfuse   │ │   Postgres   │                    │   │    │
│  │  │  │ (observ/eval)│ │  (Langfuse   │                    │   │    │
│  │  │  │  :3000       │ │   backend)   │                    │   │    │
│  │  │  └──────────────┘ └──────────────┘                    │   │    │
│  │  │                                                       │   │    │
│  │  └───────────────────────────────────────────────────────┘   │    │
│  │                                                             │    │
│  │  ┌─────────────────────────────────────────────────────┐    │    │
│  │  │  Tailscale mesh  ←→  NordVPN  ←→  Signal/Telegram  │    │    │
│  │  └─────────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │              FRONTENDS  (when needed)                        │    │
│  │              ═══════════════════════                         │    │
│  │  Next.js + TypeScript + Tailwind + shadcn/ui                │    │
│  │  ┌────────────┐ ┌────────────┐ ┌──────────────────────┐    │    │
│  │  │   TwoDo    │ │ Deal Dash  │ │  [future projects]   │    │    │
│  │  │  (Vercel)  │ │ (EC2/Docker)│ │                      │    │    │
│  │  └────────────┘ └────────────┘ └──────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│                            ▲  ▲  ▲                                  │
│                            │  │  │                                  │
│  ┌─────────────────────────┼──┼──┼─────────────────────────────┐    │
│  │                 EXTERNAL APIS                                │    │
│  │  ┌────────────┐ ┌──────┐ ┌──────────┐ ┌──────────────────┐  │    │
│  │  │ Anthropic  │ │Brave │ │Apollo.io │ │  BizBuySell etc. │  │    │
│  │  │ Claude API │ │Search│ │(enrich)  │ │  (deal sources)  │  │    │
│  │  └────────────┘ └──────┘ └──────────┘ └──────────────────┘  │    │
│  └──────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐    │
│  │                    MEMORY LAYERS                              │    │
│  │                                                              │    │
│  │  Layer 1: Git             ← decisions, specs, ADRs           │    │
│  │  Layer 2: CLAUDE.md       ← per-repo context for AI sessions │    │
│  │  Layer 3: Session Logs    ← structured entry/exit state      │    │
│  │  Layer 4: [DEFERRED]      ← Titans/ChromaDB when deal vol    │    │
│  │                              hits 100-200 evaluations         │    │
│  └──────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐    │
│  │                  DESIGN SYSTEM                                │    │
│  │                                                              │    │
│  │  7 Principles → Design Tokens (CSS) → Component Patterns     │    │
│  │  Object Model: Deal│Agent│Tool│Task│Trace│Candidate│Rule     │    │
│  │  Same language from code to customer to CLI to Telegram       │    │
│  └──────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐    │
│  │                    SDLC FLOW                                  │    │
│  │                                                              │    │
│  │  Canvas → PR/FAQ → Issue → Spec → Branch → PR → CI → Deploy  │    │
│  │                     ↑                        ↑      │         │    │
│  │                     │            security scan┘      │         │    │
│  │                     └──── Observe (Langfuse) ────────┘         │    │
│  │                                                              │    │
│  │  Docs auto-generated: spec│session log│CHANGELOG│CLAUDE.md    │    │
│  └──────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Appendix: Key References

| Source | Key Takeaway | Applied Where |
|--------|-------------|---------------|
| **Anthropic — Boris Cherny's 3 Principles** | Intent > input. Honesty about limits. Respect autonomy. | Design Principles #2, #4, #7 |
| **Anthropic — Catherine Wu / Process** | Prototype first. Build for future models. Underfund on purpose. | SDLC cadence, solo operator philosophy |
| **Anthropic — Constitutional AI** | Explicit, auditable values. Make the system's principles visible. | "Show the work" principle |
| **Google — Titans Architecture** | Surprise-based memory. Short-term + long-term + persistent. MAC variant. | ADR-003, OpenClaw memory layer |
| **lucidrains/titans-pytorch** | MIT license, 1.9k stars, actively maintained. Upgrade path for Option C. | Future Titans model training |
| Intercom Full-Stack Design System | Design objects, not screens. Shared model from concept to code. | Object model, shared language |
| NNG — AI for UX | AI as assistant, not replacement. Human judgment curates AI output. | Conservative automation principle |
| NNG — Future-Proof Designer | Strategy > pixels. Storytelling. Systems thinking. Generalist advantage. | Canvas/PR-FAQ before code |
| Amazon PR/FAQ | Write the press release first. If it doesn't excite, don't build. | PR/FAQ template |
| Lean Product Canvas | Force clarity in 30 minutes or less. | Product canvas template |
| IDEO Human-Centered Design | Respect the user. Design for real contexts. | Design Principle #7 |
| Apple HIG | Progressive disclosure. Clarity. Restraint. | Design Principle #5 |
| Google Material | Systematic visual language. Tokens over ad-hoc decisions. | Design tokens |

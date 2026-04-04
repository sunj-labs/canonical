# LinkedIn Post Drafts — Consolidated (April 2-3, 2026)

## Master Audience Recommendations

| # | Date | Title | Primary audience | Hook | Priority |
|---|------|-------|-----------------|------|----------|
| 1 | 04-02 | Standards inherit up, not push down | Eng leaders, platform teams | Strong | Standalone |
| 2 | 04-02 | Three sources of process improvement | CPTOs, process leaders | Medium | After #1 |
| 3 | 04-03 | The agent killed six features | PE partners, CPTOs | Very strong | **Publish 1st** |
| 4 | 04-03 | The right thing vs. the right way | Technical founders, board | Strong | **Publish 2nd** |
| 5 | 04-03 | What broke (12 failures) | Eng leaders, CTOs | Very strong | **Publish 3rd** |
| 6 | 04-03 | Luminaries, not instructions | Board-level, PE partners | Strongest | **Publish 4th** |
| 7 | 04-03 | From napkin to working CRM | PE partners, CPTOs | Strong | Hold — overlaps #3 (use as article) |
| 8 | 04-03 | Everything that broke (expanded) | Engineering leaders, CTOs | Very strong | Hold — overlaps #5 (use as article) |
| 9 | 04-03 | The artifact verification problem | Technical founders, eng managers | Medium | Pair with #12 |
| 10 | 04-03 | Agents need to commit their work | Eng managers, DevOps leads | Medium | Standalone |
| 11 | 04-03 | Three axes of autonomous development | CPTOs, technical PMs | Strong | **Publish 5th** |
| 12 | 04-03 | The Reviewer that reviewed the wrong thing | CTOs, QA leads | Very strong | Pair with #9 |
| 13 | 04-03 | Boot agents with Christensen, Fowler, Lupton | Board-level, PE partners | Strongest | Hold — overlaps #6 (deeper cut) |

**Recommended publish sequence**: 3 → 4 → 5 → 6 → 11 → 1 → 2 → 9+12 → 10
(Contrarian hook → framework → honesty → thought leadership → configurability → governance → trust failures → process)

**Hold for articles**: 7 (longer proof point), 8 (expanded failure list), 13 (deeper luminaries angle)

**Target audiences**: PE partners, executive search leaders, board-level operators, CPTOs, technical founders, eng leaders/managers.

---

## POST 1 (04-02): Standards should inherit up, not push down

We hit a wall during a cloud Claude Code session. The agent discovered three process improvements but couldn't push them to our canonical standards repo — no CLI, no auth token, no write access.

The pattern we'd built was "push to canonical": when you find a general improvement in an app repo, create an issue directly on the standards repo. Clean in theory. Breaks in every environment that isn't your fully-configured laptop.

The fix was obvious once we stopped thinking about it as a tooling problem: **proposals stay where they're discovered.** The app repo creates a ticket with a `to-canonical:` prefix and a `canonical-evolution` label. The standards repo scans for these during its next session. Adoption happens in canonical. The app repo never needs write access to canonical.

This is the quarantine pattern. Proposals live next to the code that motivated them. The standards repo pulls candidates; app repos never push.

Why this matters beyond our niche setup: every multi-repo architecture has this problem. Shared standards evolve from practice, not from a central committee. The feedback loop needs to be frictionless — one command, one label, zero cross-repo auth.

Five proposals from one cloud session. All five have full context because they were written where the problem was fresh, not translated into a separate repo's issue tracker hours later.

---

## POST 2 (04-02): The three sources of process improvement

We identified three distinct ways an AI development process improves itself:

**User-proposed** — The human explicitly says "this should be standard." Highest confidence. Deliberate judgment.

**Hook-driven** — An automated check detects you changed a process file and flags it. Medium confidence. Mechanical detection, might be app-specific.

**Agent-proposed** — The AI agent reflects mid-session: "What I just built or learned could generalize beyond this repo." Variable confidence. Needs human review.

The first two exist in most mature engineering orgs (RFCs and linters). The third is new — and it's the one that changes the economics of process evolution.

In a traditional team, process improvements come from retrospectives, incident reviews, and senior engineers noticing patterns. All of these require human attention, which is scarce.

An agent that asks "is what I just learned bigger than this repo?" at every checkpoint turns every session into a potential process improvement. Not because the agent's judgment is better, but because its attention is unlimited.

The key constraint: agent-proposed improvements are tagged with their source and confidence level. They enter the same review pipeline as human proposals. The agent proposes; the human (or the canonical session) decides.

We haven't built this yet. But the design is clear: three sources, one pipeline, explicit confidence tags. The canonical session triages all three the same way.

---

## POST 3 (04-03): The agent killed six features in ten minutes

We pointed an AI agent at a CRM module and said: "Shape this."

It came back with a canvas that killed six of nine proposed features. Multi-tenancy — killed. Advisor collaboration — killed. Document sharing, automated outreach, multi-party spidering, analytics — all killed.

What survived: Contact as a first-class entity. A threaded interaction timeline per deal. A "Needs Attention" follow-up queue. That's it.

The agent didn't do this randomly. It was operating as a "Shaper" — a role in our SDLC whose job is to kill bad ideas early, set scope boundaries, and never gold-plate. Its conviction check asked: "Would you use this this week?" The six killed features failed that test.

Here's what's interesting: this is exactly what a good product leader does. They don't add features — they remove them until what remains is inevitable. The question isn't "can an AI generate code?" It's "can an AI develop taste?"

This was our first test. The answer so far: yes, if you give it the right constraints.

The constraint wasn't "use AI to be creative." It was "you have a fixed appetite. Scope DOWN to fit. Kill what doesn't pass conviction."

Temperance, not capability, is what makes AI useful for product decisions.

---

## POST 4 (04-03): The right thing vs. the right way

Every AI coding tool solves the same problem: "Build this faster."

None of them solve the harder problem: "Should we build this at all?"

We've been building a methodology that separates these two concerns:

**The right thing** = product thinking. Canvas, scope boundary, conviction check, viability hypothesis. Does this deserve to exist?

**The right way** = engineering discipline. Specs, ADRs, tests, conventional commits, verification gates. Is this built correctly?

Most AI development collapses these into one. An agent gets "build a CRM" and starts generating code. No canvas. No conviction check. No scope boundary. No question of whether a CRM is even the right abstraction.

Our system runs them sequentially. A Shaper agent does product thinking first — it reads the codebase, studies the domain, and shapes what should be built. Only after Inception passes (vision doc, risk register, viability hypothesis, build/buy/defer decision) does a Builder agent ever touch code.

The result: our first autonomous Inception phase completed in under 5 minutes. Three parallel agents — Architect reviewing the existing system, Shaper producing the canvas, PM validating viability. The Shaper killed 6 of 9 features. The PM wrote 4 viability hypotheses. The Architect flagged 3 decisions that need ADRs before construction starts.

No code was written. That's the point.

---

## POST 5 (04-03): We ran an autonomous SDLC phase. Here's what broke.

The system worked. And the system failed. Both are useful.

What worked:
- Three parallel agents completed Inception in under 5 minutes
- The Shaper developed genuine product taste (killed 6/9 features)
- Phase gates enforced: all 5 Inception criteria met before advancing
- Handoff protocol fired: artifacts at known paths, phase-state updated

What broke:
- Chronicle written to wrong directory (agent assumed canonical's path structure inside the app repo)
- LinkedIn drafts completely skipped despite being a SHOULD gate at every handoff
- Appetite prompt asked for cost ceiling twice (once in manifest, once in iteration bet)
- About screen implied /temperance is core-level only (it's a MUST gate at all levels)
- Prompts were compressed instead of presented verbatim

Every failure is a specification gap. The choreography document said what to produce but not where to verify it was produced. The transition hierarchy said LinkedIn drafts are SHOULD but nothing enforced the check. The prompts were detailed in the skill file but the agent summarized instead of copying.

The fix for all of them is the same principle: **never claim without verifying.** We added a new MUST gate: after claiming to produce any artifact, verify the file exists at the claimed path. Read the first few lines. If it's not there, fix it before reporting completion.

12 issues filed from one session. Each one makes the next autonomous run more reliable. This is how you build trust in autonomous systems — not by assuming they work, but by instrumenting every failure mode you observe.

---

## POST 6 (04-03): Your AI agent needs luminaries, not just instructions

Every AI agent definition I've seen looks the same: a system prompt describing what the agent does. "You are a code reviewer. Check for bugs. Flag issues."

We tried something different. Each of our 10 agent roles now boots with a "Luminaries" section — the specific thinkers whose work informs that discipline:

- The **Architect** boots knowing Simon Brown (C4), Michael Nygard (ADRs), Eric Evans (DDD), Robert Martin (SOLID)
- The **Designer** boots knowing Don Norman, Sophia Prater (OOUX), Peter Morville (IA), Alan Cooper (Goal-Directed Design)
- The **Creative Director** boots knowing Ellen Lupton (typography, storytelling), Josef Albers (color theory), Apple HIG, Google Material
- The **Builder** boots knowing Gang of Four, Martin Fowler, Kent Beck (TDD), Taiichi Ohno (Five Whys)

This isn't decoration. When the Shaper killed six features from our CRM canvas, it was applying Christensen's Jobs-to-be-Done framework: "People don't buy products, they hire them to do a job." The six killed features failed the job test.

When the Architect flagged that three decisions need ADRs, it was applying Nygard's principle: capture the "why," not just the "what."

Instructions tell an agent what to do. Luminaries tell it how to think. The difference shows up in the quality of judgment calls — the decisions that can't be reduced to a checklist.

We sourced our luminaries from a reference document mapping 25+ experts to specific process steps. Each one is grounded in a real skill file, a real gate, a real workflow. Nothing speculative.

The question for anyone building agent systems: are your agents instructed, or are they educated?

---

## POST 7 (04-03): From napkin to working CRM in one session

This morning I showed an AI agent some screenshots and said: "Build a CRM module for tracking broker contacts alongside our deal pipeline."

By tonight:
- An Outreach page with a "Needs Attention" queue showing 6 deals waiting for follow-up
- A Log Interaction form with contact selection, direction, channel, subject, message, and follow-up date
- Interaction timeline on every deal detail page
- Nav badge showing the count of stale outreach
- ~103 new tests
- 5 feature branches, all merged

The agent didn't just write code. It ran the full SDLC:
1. **Inception** — Shaper wrote a canvas, killed 6 of 9 features, PM wrote 4 viability hypotheses
2. **Elaboration** — Architect produced ERD + 4 ADRs, Designer ran the full UX chain (JTBD → task analysis → IA → interaction design)
3. **Construction** — Builder on 5 stacked branches, Reviewer caught accessibility violations and missing tests
4. Each phase produced a chronicle and updated phase-state

Total human input: one paragraph of intent, three confirmations at phase gates, and a few course corrections.

The question I started with: "Can an AI develop taste?" The answer after today: taste is a function of constraints, not creativity. Give the agent a fixed appetite, a conviction check, and a scope boundary — and it cuts what doesn't pass. That's taste.

---

## POST 8 (04-03): Everything that broke (and how we fixed it in 4 hours)

We ran our first autonomous SDLC session today. The agent built a CRM module from screenshots to working code. It worked. And it broke in 12 specific ways.

Here's the real list:

1. Reviewer audited specs instead of code (worktree paths)
2. Auto-save timer created merge conflicts on feature branches
3. Squash merge cascade invalidated downstream PRs
4. Prisma client not regenerated after schema merge
5. Tailwind v4 crashed on canonical symlinks
6. Chronicle written to wrong directory
7. LinkedIn drafts not written at handoffs
8. Prompts compressed instead of presented verbatim
9. No data seeding — features verified against empty state
10. No cost tracking — three phases completed with zero visibility
11. Appetite asked for cost ceiling twice
12. About screen implied temperance is core-only

Every single failure is a specification gap, not a capability gap. The agent *can* do all of these things. It just wasn't told to, or was told ambiguously. Twelve issues filed, seven fixed same-day. The rest are in the backlog.

This is the real insight about autonomous AI development: the first run surfaces the spec failures. The system doesn't get better by making the AI smarter. It gets better by making the specifications more precise.

We're treating every failure as a test case for the methodology, not a bug in the agent. The methodology is the product. The agent is the runtime.

---

## POST 9 (04-03): The artifact verification problem

We built a MUST gate today that shouldn't need to exist: "After claiming to produce any artifact, verify the file exists at the claimed path."

Why? Because our agent reported a chronicle in its completion summary — right path name, right format, right content description. But when we checked, the file was in the wrong directory. The agent wrote `canonical/chronicle/` instead of `docs/design/chronicle/` (the app repo's pattern).

The agent wasn't lying. It wrote the file. It just wrote it to the wrong place because it assumed canonical's directory structure instead of checking the app repo's existing pattern.

This is a class of problem that will define trust in autonomous systems: **the agent does the work but misplaces the output.** The work is real. The artifact exists. But it's not where anyone will look for it.

The fix is mechanical: verify after write. But the principle is deeper. In autonomous systems, "done" doesn't mean "I did it." It means "I did it, it's where it should be, and I confirmed it's there." Self-verification is a MUST gate, not a nice-to-have.

Every time you trust an agent's self-report without verification, you're accepting the risk that the work exists but is unreachable. That's worse than not doing it at all — because you think it's done.

---

## POST 10 (04-03): Your agents need to commit their work (and they won't unless you make them)

At the end of our first autonomous session, the agent produced 15+ artifacts: chronicles, ADRs, design documents, LinkedIn drafts, a risk register. All written to disk. None committed to git.

The code was committed. The five feature branches had clean conventional commits, linked to issues, with test coverage. But the *thinking artifacts* — the documents that explain why the code exists — were left as uncommitted files.

This is the documentation version of "I'll add tests later." The agent treats substrate artifacts as secondary to code. Ship the code, leave the docs. Except in our system, the docs are the instructions for the next session. Without them committed, the next session starts cold.

The fix: checkpointing. Every agent commits each artifact as it's written, not in a batch at session end. The chronicle gets committed when the phase transitions. The ADR gets committed when the Architect accepts it. The design artifacts get committed when the Designer finishes them.

"Session end" is a fiction in autonomous systems. Sessions crash, context compacts, timeouts kill processes. If the artifact isn't committed, it doesn't exist. Treat uncommitted work the way you'd treat unsaved work in 1995 — it's one power failure away from gone.

---

## POST 11 (04-03): The three axes of autonomous AI development

Every AI coding tool has one mode: you tell it what to build, it builds it. We found you need three independent choices:

**Agent level** — how many roles are active:
- Core (2 agents): Builder + Reviewer. You drive everything.
- Standard (6 agents): + Shaper, PM, Designer, Architect. Structured product thinking before code.
- Full (10 agents): + Creative Director, Deployer, Closer, Orchestrator. Full ceremony.

**Execution mode** — how work runs:
- Sequential: one session, persona switches between roles. Zero burst cost on a Max plan.
- Parallel: subagents spawned per role, worktrees for branches. Costs tokens but faster.

**Gating** — who approves handoffs:
- Human-gated: agent pauses between phases for your approval.
- Orchestrator-gated: agent chains through everything. You review PRs after.

Any combination works. Our first run: standard + parallel + orchestrator-gated. Inception to working code in one session, no human intervention during execution.

The insight: "autonomous" isn't a binary. It's a 3D configuration space. The right setting depends on the work, the trust level, and whether you plan to sleep through it.

---

## POST 12 (04-03): The Reviewer that reviewed the wrong thing

Our code reviewer agent audited specs instead of code.

Five feature branches. Five PRs. One Reviewer agent. It raised three blockers — all reasonable findings about scope, measurement, and API shape. All three were already addressed. Not a single line of code was evaluated.

Why? The Builder built in git worktrees (isolated copies of the repo). The Reviewer was spawned in the main working directory. The code was on the branches. The Reviewer couldn't see it. So it reviewed what it could see — the spec artifacts in the main directory.

The agent didn't report an error. It didn't say "I can't find the code." It produced a professional-looking review with severity levels and recommendations. It looked exactly like a real code review. It just wasn't one.

This is the trust problem with autonomous systems: **confident output from wrong input.** The agent will always produce something. The question is whether it produced something from the right source material.

The fix: the Reviewer now reads PR diffs explicitly (`gh pr diff NNN`), not the working directory. If it can't access the diff, it STOPS and escalates instead of falling back to reviewing whatever files are available.

The principle: an agent that can't do its job correctly should fail loudly, not succeed quietly on the wrong data.

---

## POST 13 (04-03): Why we boot our agents with Christensen, Fowler, and Lupton

"You are a code reviewer. Check for bugs."

That's how most agent definitions read. Here's ours:

"You are the Builder. Your luminaries: Gang of Four (Design Patterns), Martin Fowler (Enterprise Patterns), Robert C. Martin (SOLID), Kent Beck (TDD), Taiichi Ohno (Five Whys)."

Different result? Dramatically.

When our Shaper agent killed six features from the CRM canvas, it wasn't following a "kill features" instruction. It was applying Christensen's Jobs-to-be-Done: "People don't buy products, they hire them to do a job." The six features that died failed the job test — nobody would hire the CRM to do document sharing or analytics dashboards.

When our Architect chose additive migration over a risky schema rewrite, that's Nygard's ADR pattern: document the *why*, not just the *what*. The ADR captured the trade-off, so the next session understands the constraint.

When our Reviewer caught translucent badge backgrounds, that's Albers' Interaction of Color: color is relative, test in context. The Creative Director's luminaries drove the design token constraints that the Reviewer enforced.

We mapped 25+ thinkers to specific process steps. Each one is grounded in a real skill, a real gate, a real workflow. The agent doesn't just know *what* to do — it knows *how to think about* what to do.

Instructions produce compliance. Luminaries produce judgment.

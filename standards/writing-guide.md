# Writing Guide — Chronicles & LinkedIn

## Two audiences, two registers

### Chronicles (internal)

Technical. Direct. For the next agent or session picking up the work.

- Name files, functions, skills, hooks by their actual names
- Include commit refs, issue numbers, file paths
- Be factual, not promotional — record what happened
- Open Threads is the most important section

### LinkedIn (external)

Enterprise operating language. For PE partners, executive search leaders,
board-level decision-makers — and the CTOs they ask to vet you.

---

## LinkedIn Style Guide

### Voice & Tone

Calm, analytical, economically grounded. Operator-grade.

Model after: Bezos (structured strategic clarity), Jassy (primitives and
modular thinking), Collison (infrastructure reasoning), Nadella (measured
enterprise transformation), Buffett (plain capital allocation language).

**Never**: AI hype, startup hustle, generic motivation, political
commentary, tactical coding tutorials, tool-specific jargon.

### The Technical Vocabulary Rule

Name the concept. Explain its significance in operating model terms.
Skip the implementation.

| Do this | Not this |
|---------|----------|
| "a governance primitive we call *temperance* — a mandatory pause that forces the system to justify its approach before executing" | "a skill called /temperance in .claude/skills/" |
| "self-enforcing quality gates that block progress until evidence is produced" | "pre-commit hooks in settings.json" |
| "capability restriction by role — a reviewer can read but not modify" | "agents with tools: Read, Glob, Grep" |
| "a specification layer that eliminates ambiguity before execution begins" | "EARS-format PRD templates" |
| "the substrate — the governance infrastructure that makes autonomous work auditable" | "the .claude/ directory with 14 SKILL.md files" |

**The test**: Would a PE operating partner nod at this sentence? Would a
Fortune 100 CTO understand the architectural principle? If yes, the
vocabulary is right.

### Technical concepts that earn their name

Some terms are worth introducing by name because they carry meaning
your audience will remember and repeat:

- **Substrate** — the self-enforcing governance layer beneath autonomous
  systems. Use it. Define it once per post.
- **Temperance** — mandatory pause before action. Resonates with anyone
  who's seen organizations move fast and break things at scale.
- **Quality gates** — self-explanatory to any enterprise operator.
- **Specification quality** — the insight that execution bottlenecks are
  usually clarity bottlenecks. Lands immediately with PE sponsors who've
  seen post-acquisition integration fail.
- **Governance substrate** — the combination that signals "I think about
  AI at the operating model level, not the feature level."

### Structure

Every post follows:

1. **Hook** (1-2 lines) — a tension, question, or counterintuitive claim
2. **Setup** (2-3 lines) — why this matters, framed as an operating challenge
3. **Body** — concrete details. Use → arrows for lists. Keep paragraphs
   to 2-3 sentences max. LinkedIn rewards white space.
4. **Takeaway** — one sentence that connects to enterprise economics
   (EBITDA, capital efficiency, governance, scale)

### What to include from each session

Not every session produces a LinkedIn post. But when it does:

- **What was built** — in operating model terms, not file names
- **Why it matters** — connect to enterprise challenges your audience faces
- **The pattern** — what's transferable beyond your specific context
- **The "so what" for the audience** — what should a PE partner, search
  leader, or board member take away?

### Length

600-1200 words. LinkedIn rewards substance over brevity in long-form.
But every paragraph must earn its place. Cut ruthlessly.

### Feynman Sidebar Convention

When a post references a technical concept that a CTO reviewer would
want to understand precisely, add a Feynman sidebar (see the /feynman
skill). In the Google Doc draft, these appear as indented explanatory
blocks. In the final LinkedIn post, they can be:

- Woven into the body as a one-sentence plain-English explanation
- Dropped into a comment thread as a "for the technically curious" follow-up
- Used as standalone micro-posts (the Feynman explanation IS the post)

The decision depends on how central the concept is to the post's argument.

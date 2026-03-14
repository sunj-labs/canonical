# SDLC Portable Kit

Platform-agnostic strategy, requirements, and design methodology. Extracted from the sunj-labs IDP for use in any environment — Azure DevOps, GitHub, GitLab, or bare git.

## What's here

```
sdlc-portable/
├── strategy/
│   ├── sdlc-flow.md              ← Lifecycle from idea to production
│   └── templates/
│       ├── product-canvas.md     ← Progressive 3-stage canvas with conviction tests
│       ├── pr-faq.md             ← Amazon-style press release / FAQ
│       └── spec-template.md      ← Spec with deployment & access questionnaire
├── design/
│   ├── design-principles.md      ← The Seven Rules
│   ├── design-tokens.css         ← CSS custom properties (visual language seed)
│   ├── object-model.md           ← Shared nouns across systems
│   ├── component-patterns.md     ← Card, table, status, CLI, bot patterns
│   └── ai-design-guidelines.md   ← NNG + Anthropic informed AI UX rules
└── standards/
    ├── commit-conventions.md     ← Conventional commits
    ├── testing-philosophy.md     ← What to test, what to skip, pyramid
    └── branching-strategy.md     ← Trunk-based development
```

## What's NOT here (platform-specific)

These live in your CI/CD platform and aren't portable:
- Pipeline definitions (GitHub Actions, Azure DevOps YAML, etc.)
- Container registry config
- Deployment workflows
- Monitoring/alerting setup (Beszel, App Insights, etc.)
- Secret scanning tool config (gitleaks, CredScan, etc.)

## How to use

1. Copy this into your repo or wiki
2. Start every initiative with the product canvas (Stage 1 thesis — 5 minutes)
3. Write specs using the template before building anything size M or larger
4. Reference design principles in acceptance criteria
5. Follow the SDLC flow from idea through production

## Mapping to Azure DevOps

| This kit | Azure DevOps equivalent |
|----------|------------------------|
| Product canvas | Wiki page or README in repo |
| Spec template | Wiki page linked from Work Item |
| User story (from spec) | Work Item: User Story |
| Bug | Work Item: Bug |
| Task | Work Item: Task |
| Spike | Work Item: Task (tagged spike) |
| Spec review | Pull Request on the spec doc |
| Code review | Pull Request |
| CI pipeline | Azure Pipelines YAML |
| Project board views | Boards: custom queries and views |
| Milestones | Iterations / Sprints |
| Labels | Tags on Work Items |

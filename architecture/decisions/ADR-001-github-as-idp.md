# ADR-001: GitHub as Integrated Developer Platform

## Status
ACCEPTED

## Date
2026-02-28

## Context
sunj-labs runs multiple projects (OpenClaw, PruneGuice, Deal Pipeline, POA-ops) as a solo operator. Need a unified platform for source control, CI/CD, project management, issue tracking, and documentation — without the overhead of stitching together separate tools.

## Decision
Use GitHub as the integrated developer platform:

- **Source control:** GitHub repos under the `sunj-labs` org
- **CI/CD:** GitHub Actions with reusable workflows in the `.github` repo
- **Project management:** GitHub Projects v2 (cross-repo board)
- **Issue tracking:** GitHub Issues with org-wide label taxonomy
- **Container registry:** GitHub Container Registry (GHCR)
- **Documentation:** Markdown in repos (platform-docs, per-repo specs, ADRs)

## Consequences

### Positive
- Single platform, single login, single search
- Reusable workflows eliminate per-repo CI duplication
- Projects v2 gives cross-repo visibility without a separate PM tool
- GHCR is free for public repos, integrated with Actions
- Markdown docs live next to code, versioned together

### Negative
- GitHub Projects v2 is less powerful than dedicated PM tools (no dependencies, limited automations)
- Vendor lock-in to GitHub (mitigated: git is portable, Actions are YAML)
- No built-in design tool integration

### Risks
- GitHub outages block all work (mitigated: local git, offline-capable workflow)

---
session_id: 2026-04-01-0900
project: canonical
agent: personal
status: completed
tags: [canonical, inheritance, multi-device, rename, mobile-testing, cloud, portability]
---

# Session: Canonical Inheritance — Rename, Multi-Device Portability, Cloud Testing

## Entry State
- Substrate built but not portable — only worked on Mac with --add-dir
- Repo still named platform-docs
- POA had duplicates of canonical assets
- No mechanism for cloud/mobile sessions to inherit canonical
- Canonical product vision discussed but not yet a canvas

## Work Done

### Researched Claude Code cloud environment
- Cloud runs Ubuntu 24.04 with git, common runtimes, Postgres, Redis
- Git auth via secure proxy — private repos work if GitHub connected to claude.ai
- ~/.claude/ doesn't persist between cloud sessions — only repo-level .claude/ travels
- `permissions.additionalDirectories` in settings.json auto-adds directories
- Skills from additionalDirectories auto-discover; rules need CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 env var
- Hooks and agents do NOT inherit via additionalDirectories

### Designed inheritance architecture
- Three layers: canonical repo → ~/.claude/ (user-level) → .claude/ (app-specific)
- Skills + rules inherit via --add-dir / additionalDirectories
- Hooks + agents copy to ~/.claude/ at session start
- App-specific overrides stay in project .claude/
- "Inherit up" via /promote → canonical-evolution issues

### Renamed platform-docs → canonical
- GitHub repo renamed
- Local directory renamed, remote URL updated
- LaunchAgent plist updated
- All POA references updated

### Built canonical-sync.sh
- Clones canonical as sibling if missing, pulls latest if present
- Symlinks canonical skills into project .claude/skills/ for Skill harness auto-discovery
- Copies 3 general hooks to ~/.claude/hooks/
- Copies agents to ~/.claude/agents/
- Writes ~/.claude/settings.json on cloud (user-level hook wiring)
- Sets CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1
- Shows sync summary, flags new changes since last sync
- Instructs agent to confirm substrate status to user
- Committed to both POA repo and ~/.claude/ (belt + suspenders)

### Audited and cleaned POA
- Deleted 10 skills, 3 rules, 2 hooks (now canonical-owned)
- Kept app-specific: deploy-prod, test-e2e, test-integration, security, schema-management, multi-tenancy-check
- CLAUDE.md split: Canonical (inherited) vs POA-specific skills tables
- Merged feature branch to main so cloud sessions get infrastructure
- Added permissions.additionalDirectories: ["../canonical"] to settings.json

### Built /promote skill + canonical-evolution workflow
- /promote creates issue on canonical with "canonical-evolution" label
- sdlc-gates.md updated: check before committing .claude/ changes
- session-reflection.sh: canonical sessions show pending evolution issues
- GitHub label created

### Fixed operational issues
- settings.json hook format (string matchers, hooks array wrapper)
- Gitignored SDLC trace logs (dirty tree / commit loops)
- Auto-pull on session start
- Save-state in both repos
- Cloud ~/.claude/settings.json written by hook

### Canonical product vision (research, not canvas)
- "Canonical" as a service: napkin → full SDLC → production app with enterprise governance
- Jevons paradox: as code gen gets free, governance bottleneck grows
- Lovable/Replit solve "make it fast" — Canonical solves "make it right at scale"
- Moat: the substrate (accumulated methodology). Private, not open source.
- Saved to memory as research — canvas deferred

### Mobile/cloud testing (3 rounds)
- Round 1 (resume): Failed — changes on feature branch, not main
- Round 2 (new session): Partial — canonical cloned, skills visible but not auto-triggering
- Round 3 (new session with symlinks): Success — 18 skills synced, agent confirmed status
- Identified: cloud memory is ephemeral, trace logs need git rm --cached, symlinks need gitignoring

## Decisions Made
- **Canonical stays private** — substrate is the product
- **Repo renamed canonical** — tighter branding
- **Symlinks for skill auto-discovery** — runtime, gitignored
- **User-level ~/.claude/ for general hooks** — fires in all projects
- **All "inherit up" via issues** — canonical-evolution label, reviewed in canonical sessions
- **Trace logs gitignored** — operational overhead, no compliance value yet (#37)
- **canonical-sync.sh in repo AND ~/.claude/** — cloud needs repo copy, Mac has both
- **`/web-setup` syncs GitHub auth to cloud** — one-time setup for private repo access

## Open Threads
- [ ] Verify symlinked skills auto-trigger via Skill harness on cloud
- [ ] Plugin design for cleaner distribution (#38)
- [ ] Refactor hooks into canonical base + app extensions (#36)
- [ ] SDLC compliance tracking (#37)
- [ ] CLAUDE.md skills table + gotchas (#33)
- [ ] Cloud memory ephemeral — no carry-over between sessions
- [ ] Validate full SDLC chain end-to-end (#35)
- [ ] LinkedIn calibration: blend of technical depth + commercial relevance (#34)
- [ ] Chronicle + LinkedIn for this session (writing now)

## Key Files Changed
- Canonical: renamed from platform-docs, .claude/skills/promote/ NEW, .claude/rules/sdlc-gates.md updated, .claude/hooks/session-reflection.sh updated, .gitignore updated
- POA: canonical-sync.sh NEW, settings.json updated (additionalDirectories), .gitignore (symlinks + traces), CLAUDE.md (split skills table), 15 files deleted
- ~/.claude/: settings.json, hooks/ (3), agents/ (3), canonical-sync.sh
- LaunchAgent plist updated

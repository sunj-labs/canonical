#!/bin/bash
# Boot Canonical — first-time setup for the substrate.
# Run once per machine/environment to configure everything
# the substrate expects to be in place.
#
# Usage:
#   ./scripts/boot-canonical.sh
#   # or from any directory:
#   ~/src/sunj-labs/canonical/scripts/boot-canonical.sh

set -e

echo "============================================"
echo "BOOT CANONICAL — Substrate Setup"
echo "============================================"
echo ""

CANONICAL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0

# === 1. GitHub CLI ===
echo "1. GitHub CLI (gh)"
if command -v gh &>/dev/null; then
  if gh auth status &>/dev/null; then
    GH_USER=$(gh api user -q '.login' 2>/dev/null || echo "unknown")
    echo "   OK: gh authenticated as $GH_USER"
  else
    echo "   NEEDS SETUP: gh installed but not authenticated"
    echo "   Run: gh auth login"
    ERRORS=$((ERRORS + 1))
  fi
else
  echo "   NEEDS SETUP: gh not installed"
  echo "   Run: brew install gh && gh auth login"
  ERRORS=$((ERRORS + 1))
fi
echo ""

# === 2. Claude Code web setup ===
echo "2. Claude Code web sync (for mobile/cloud sessions)"
echo "   Run '/web-setup' inside a Claude Code session to sync"
echo "   gh credentials to claude.ai cloud. One-time setup."
echo "   (Cannot verify from outside Claude Code)"
echo ""

# === 3. Google service account (for LinkedIn → Google Docs) ===
echo "3. Google Docs service account"
SA_KEY="$HOME/.config/gcloud/sunjay-google-ops.json"
if [ -f "$SA_KEY" ]; then
  SA_EMAIL=$(python3 -c "import json; print(json.load(open('$SA_KEY'))['client_email'])" 2>/dev/null || echo "unknown")
  echo "   OK: service account key found at $SA_KEY"
  echo "   Email: $SA_EMAIL"
  echo "   Ensure this email has Editor access to your Google Docs"
else
  echo "   NEEDS SETUP: no service account key at $SA_KEY"
  echo "   Steps:"
  echo "   a. Go to console.cloud.google.com → IAM → Service Accounts"
  echo "   b. Create a service account with Google Docs API scope"
  echo "   c. Download the JSON key to $SA_KEY"
  echo "   d. Share your Google Docs with the service account email"
  ERRORS=$((ERRORS + 1))
fi
echo ""

# === 4. LinkedIn Google Doc ID ===
echo "4. LinkedIn Google Doc"
echo "   The Doc ID for LinkedIn drafts should be stored in project memory."
echo "   Current configured docs (check memory files):"
grep -r 'GDOC_LINKEDIN_ID\|Doc ID' "$CANONICAL_DIR/.claude/skills/linkedin/SKILL.md" 2>/dev/null | head -3
echo "   If not configured: create a Google Doc, share with the service"
echo "   account, and store the doc ID in project memory."
echo ""

# === 5. ~/.claude/ user-level setup ===
echo "5. User-level ~/.claude/ configuration"
if [ -f "$HOME/.claude/settings.json" ]; then
  echo "   OK: ~/.claude/settings.json exists"
else
  echo "   NEEDS SETUP: no ~/.claude/settings.json"
  ERRORS=$((ERRORS + 1))
fi

if [ -d "$HOME/.claude/hooks" ]; then
  HOOK_COUNT=$(ls "$HOME/.claude/hooks/"*.sh 2>/dev/null | wc -l | tr -d ' ')
  echo "   OK: ~/.claude/hooks/ has $HOOK_COUNT hooks"
else
  echo "   NEEDS SETUP: no ~/.claude/hooks/"
  echo "   Run canonical-sync.sh or start a Claude session — it auto-installs"
  ERRORS=$((ERRORS + 1))
fi

if [ -d "$HOME/.claude/agents" ]; then
  AGENT_COUNT=$(ls "$HOME/.claude/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
  echo "   OK: ~/.claude/agents/ has $AGENT_COUNT agents"
else
  echo "   NEEDS SETUP: no ~/.claude/agents/"
  echo "   Run canonical-sync.sh or start a Claude session — it auto-installs"
  ERRORS=$((ERRORS + 1))
fi
echo ""

# === 6. macOS launchd auto-save (Mac only) ===
echo "6. macOS idle auto-save (Mac only)"
if [ "$(uname)" = "Darwin" ]; then
  if launchctl list 2>/dev/null | grep -q "com.sunj-labs.auto-save"; then
    echo "   OK: auto-save launchd agent loaded"
  else
    PLIST="$HOME/Library/LaunchAgents/com.sunj-labs.auto-save.plist"
    if [ -f "$PLIST" ]; then
      echo "   NEEDS SETUP: plist exists but not loaded"
      echo "   Run: launchctl load $PLIST"
      ERRORS=$((ERRORS + 1))
    else
      echo "   NEEDS SETUP: no launchd plist"
      echo "   The auto-save-idle.sh hook needs a launchd agent to run every 15 min"
      ERRORS=$((ERRORS + 1))
    fi
  fi
else
  echo "   SKIPPED: not macOS"
fi
echo ""

# === 7. googleapis npm package (for push-to-gdoc.ts) ===
echo "7. googleapis package (for LinkedIn → Google Docs push)"
# Check if any sibling repo has it installed
GDOC_SCRIPT=""
for REPO in "$CANONICAL_DIR/../"*/; do
  if [ -f "$REPO/scripts/push-to-gdoc.ts" ] && [ -d "$REPO/node_modules/googleapis" ]; then
    GDOC_SCRIPT="$REPO/scripts/push-to-gdoc.ts"
    break
  fi
done
if [ -n "$GDOC_SCRIPT" ]; then
  echo "   OK: push-to-gdoc.ts found at $GDOC_SCRIPT"
else
  echo "   INFO: no push-to-gdoc.ts with googleapis found in sibling repos"
  echo "   LinkedIn drafts will be saved to docs/linkedin-drafts/ only (not pushed to Google Doc)"
fi
echo ""

# === Summary ===
echo "============================================"
if [ "$ERRORS" -eq 0 ]; then
  echo "BOOT COMPLETE — all checks passed"
else
  echo "BOOT INCOMPLETE — $ERRORS item(s) need setup"
  echo "Fix the items above, then re-run this script."
fi
echo ""
echo "Canonical substrate: $CANONICAL_DIR"
echo "Skills: $(ls "$CANONICAL_DIR/.claude/skills/" | wc -l | tr -d ' ')"
echo "Rules: $(ls "$CANONICAL_DIR/.claude/rules/" | wc -l | tr -d ' ')"
echo "Hooks: $(ls "$CANONICAL_DIR/.claude/hooks/" | wc -l | tr -d ' ')"
echo "Agents: $(ls "$CANONICAL_DIR/.claude/agents/" | wc -l | tr -d ' ')"
echo "============================================"

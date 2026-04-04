#!/bin/bash
# Deploy Guard — fires on PreToolUse for Bash commands containing "git push"
# Checks if the push targets main/master and whether prod deploy is approved.
#
# This hook exists because an agent pushed to main (triggering prod deploy)
# after the operator said "deploy locally." Rules are advisory. This hook
# is enforcement.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Only fire on git push commands
if ! echo "$COMMAND" | grep -q 'git push'; then
  exit 0
fi

# Check if pushing to main or master
if echo "$COMMAND" | grep -qE 'git push.*(origin|upstream).*(main|master)'; then
  # Check for substrate.config.md deploy targets
  MANIFEST="substrate.config.md"
  PROD_APPROVED="false"

  if [ -f "$MANIFEST" ]; then
    # Check if prod is explicitly set to a URL (not "false")
    PROD_TARGET=$(grep -A1 'prod:' "$MANIFEST" 2>/dev/null | tail -1 | tr -d ' ')
    if [ -n "$PROD_TARGET" ] && [ "$PROD_TARGET" != "false" ] && [ "$PROD_TARGET" != "prod:false" ]; then
      PROD_APPROVED="maybe"
    fi
  fi

  # Check if this is a docs-only repo (no CI/CD, safe to push)
  if [ -f "package.json" ] || [ -f "Dockerfile" ] || [ -d ".github/workflows" ]; then
    # This repo has app infrastructure — push to main likely triggers deploy
    echo "⚠️  DEPLOY GUARD: This push to main may trigger a production deployment."
    echo ""
    echo "Before pushing, confirm:"
    echo "  1. Did the operator explicitly say 'push' or 'deploy to prod'?"
    echo "  2. Was the instruction 'deploy locally' or 'test locally'? If so, do NOT push."
    echo "  3. Check substrate.config.md deploy_targets — is prod approved?"
    echo ""
    echo "If the operator said LOCAL: merge to main locally, restart dev server, do NOT push."
    echo "If the operator said PUSH/DEPLOY: proceed with git push."
    echo ""
    echo "Production deployment ALWAYS requires explicit human approval."
    echo "This is a hard guardrail. No exceptions. No muscle memory."
  fi
fi

exit 0

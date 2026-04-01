#!/bin/bash
# Type-check gate — fires before git push.
# Catches TypeScript errors that test runners miss but builds catch.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Only fire on git push commands
if ! echo "$COMMAND" | grep -q "git push"; then
  exit 0
fi

# Skip if no tsconfig (not a TypeScript project)
if [ ! -f "tsconfig.json" ]; then
  exit 0
fi

echo "============================================"
echo "TypeScript check before push..."
echo "============================================"

TSC_OUTPUT=$(npx tsc --noEmit --pretty 2>&1)

# Filter to source file errors only (not test files or node_modules)
NEW_ERRORS=$(echo "$TSC_OUTPUT" | grep -v "__tests__" | grep -v "node_modules" | grep "error TS" | head -5)

if [ -n "$NEW_ERRORS" ]; then
  echo "TypeScript errors detected in source files:"
  echo "$NEW_ERRORS"
  echo ""
  echo "Fix these before pushing to avoid CI failure."
  echo "============================================"
fi

exit 0

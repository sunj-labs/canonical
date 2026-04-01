#!/bin/bash
# Multi-Tenancy Check — canonical template.
# Fires on Edit/Write of source files.
# Warns when tenant-scoped patterns are missing.
#
# App repos should customize:
#   TENANT_MODELS — pipe-separated list of tenant-scoped model names
#   TENANT_CONTEXT_FN — function name that resolves tenant context
#   TENANT_PARAMS_FN — function name for tenant-specific parameters
#
# Override by placing your own multi-tenancy-check.sh in .claude/hooks/

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.file_path // ""')
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // .tool_input.content // ""')

# Skip non-source files
if echo "$FILE_PATH" | grep -qE '\.(sh|json|md)$|/\.claude/|/memory/|/docs/|/scripts/|__tests__'; then
  exit 0
fi

# === Customizable per project (override these in your app's copy) ===
TENANT_CONTEXT_FN="${TENANT_CONTEXT_FN:-getTenantContext}"
TENANT_PARAMS_FN="${TENANT_PARAMS_FN:-getTenantParams}"
# Default: no models (app must define its own)
TENANT_MODELS="${TENANT_MODELS:-}"

# Skip if no tenant models defined (not a multi-tenant project)
if [ -z "$TENANT_MODELS" ]; then
  exit 0
fi

WARNINGS=""

# Check 1: Hardcoded numeric thresholds that should use params facade
if echo "$CONTENT" | grep -qE '[0-9]{3,}\.?[0-9]*\.?[0-9]*' ; then
  if echo "$CONTENT" | grep -qE '_FLOOR|_CEILING|_THRESHOLD|_LIMIT|_MIN|_MAX'; then
    if ! echo "$CONTENT" | grep -q "$TENANT_PARAMS_FN"; then
      WARNINGS="${WARNINGS}
MULTI-TENANCY: Possible hardcoded threshold detected.
    Use ${TENANT_PARAMS_FN}() instead of hardcoded values.
    Financial and geographic thresholds must flow through
    the tenant params facade for multi-tenant readiness."
    fi
  fi
fi

# Check 2: Prisma queries on tenant-scoped models without context
if echo "$CONTENT" | grep -qiE "prisma\.(${TENANT_MODELS})\.(findMany|findFirst|create|update|delete)" ; then
  if ! echo "$CONTENT" | grep -q "$TENANT_CONTEXT_FN"; then
    WARNINGS="${WARNINGS}
MULTI-TENANCY: Query on tenant-scoped model without ${TENANT_CONTEXT_FN}().
    Tenant-scoped models must be filtered by tenant/user context.
    Use ${TENANT_CONTEXT_FN}() and filter appropriately."
  fi
fi

# Check 3: API routes missing tenant context
if echo "$FILE_PATH" | grep -qE 'src/app/api/.*route\.ts'; then
  if echo "$CONTENT" | grep -qE 'export async function (GET|POST|PATCH|DELETE|PUT)'; then
    if ! echo "$CONTENT" | grep -q "$TENANT_CONTEXT_FN"; then
      WARNINGS="${WARNINGS}
MULTI-TENANCY: API route handler without ${TENANT_CONTEXT_FN}().
    All API routes touching tenant-scoped data must resolve
    tenant context. Even GET routes need this for data isolation."
    fi
  fi
fi

if [ -n "$WARNINGS" ]; then
  echo "============================================"
  echo "MULTI-TENANCY GUARDRAIL"
  echo "============================================"
  echo "$WARNINGS"
  echo ""
  echo "These are WARNs, not BLOCKs. If this is intentional"
  echo "(e.g., platform-wide data), proceed."
  echo "If tenant-scoped, add the missing context/facade."
  echo "============================================"
fi

exit 0

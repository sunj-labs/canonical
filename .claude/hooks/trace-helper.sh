#!/bin/bash
# SDLC Trace Log helper — sourced by all hooks.
# Appends a trigger line to docs/sdlc-traces/YYYY-MM-DD.log
#
# Usage: source this file, then call:
#   trace_log "hook-name" "trigger-description"

TRACE_DIR="docs/sdlc-traces"

trace_log() {
  local hook="$1"
  local trigger="$2"
  local timestamp
  timestamp=$(date +%H:%M:%S)
  local today
  today=$(date +%Y-%m-%d)
  local log_file="${TRACE_DIR}/${today}.log"

  mkdir -p "$TRACE_DIR" 2>/dev/null || true
  echo "${timestamp} | ${hook} | ${trigger} | — | —" >> "$log_file" 2>/dev/null || true
}

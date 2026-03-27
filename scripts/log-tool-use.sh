#!/usr/bin/env bash
# Fail fast on command errors, unset variables, and pipeline failures.
set -euo pipefail

# Resolve repository root from this script location.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Build absolute path to logs directory.
LOG_DIR="$ROOT_DIR/logs"
# Ensure logs directory exists.
mkdir -p "$LOG_DIR"

# Read hook payload from stdin.
PAYLOAD="$(cat || true)"
# Capture current UTC timestamp for the log entry.
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Append pre-tool-use event header and payload.
{
  # Header line for this log block.
  printf '%s\n' "--- PreToolUse at $TIMESTAMP ---"
  # Write payload JSON when present.
  if [[ -n "$PAYLOAD" ]]; then
    printf '%s\n' "$PAYLOAD"
  else
    # Write empty object when no payload is provided.
    printf '{}\n'
  fi
} >> "$LOG_DIR/tool-use.log"

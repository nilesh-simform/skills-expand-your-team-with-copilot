#!/usr/bin/env bash
# Fail fast on command errors, unset variables, and pipeline failures.
set -euo pipefail

# Resolve repository root from this script location.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Build absolute path to logs directory.
LOG_DIR="$ROOT_DIR/logs"
# Ensure logs directory exists.
mkdir -p "$LOG_DIR"

# Read hook stdin payload; keep empty value if nothing is piped.
PAYLOAD="$(cat || true)"
# Capture current UTC timestamp for the log entry.
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Append a single prompt event entry with metadata and payload body.
{
  # Header line includes timestamp and configured log level.
  printf '%s\n' "--- Prompt submitted at $TIMESTAMP (level=${LOG_LEVEL:-INFO}) ---"
  # Write payload JSON when present.
  if [[ -n "$PAYLOAD" ]]; then
    printf '%s\n' "$PAYLOAD"
  else
    # Write empty object when no payload is provided.
    printf '{}\n'
  fi
} >> "$LOG_DIR/prompt-events.log"

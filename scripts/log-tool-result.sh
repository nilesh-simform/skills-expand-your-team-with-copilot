#!/usr/bin/env bash
# Fail fast on command errors, unset variables, and pipeline failures.
set -euo pipefail

# Resolve repository root from this script location.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Build absolute path to logs directory.
LOG_DIR="$ROOT_DIR/logs"
# Ensure logs directory exists.
mkdir -p "$LOG_DIR"

# Read tool result payload from stdin.
PAYLOAD="$(cat || true)"

# Append tool result payload to JSONL log.
if [[ -n "$PAYLOAD" ]]; then
  # Write actual payload when available.
  printf '%s\n' "$PAYLOAD" >> "$LOG_DIR/tool-results.jsonl"
else
  # Write empty object when payload is missing.
  printf '{}\n' >> "$LOG_DIR/tool-results.jsonl"
fi

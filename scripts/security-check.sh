#!/usr/bin/env bash
# Fail fast on command errors, unset variables, and pipeline failures.
set -euo pipefail

# Resolve repository root from this script location.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Build absolute path to logs directory.
LOG_DIR="$ROOT_DIR/logs"
# Ensure logs directory exists.
mkdir -p "$LOG_DIR"

# Read tool-intent payload from stdin.
PAYLOAD="$(cat || true)"
# Capture current UTC timestamp for auditing.
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
# Regex pattern for potentially destructive commands.
BLOCK_PATTERN='git reset --hard|git checkout --|rm -rf /|rm -fr /|dd if='

# Deny tool execution when payload matches blocked patterns.
if printf '%s' "$PAYLOAD" | grep -Eiq "$BLOCK_PATTERN"; then
  # Record denied event to security log.
  printf '[%s] Blocked tool payload by security policy\n' "$TIMESTAMP" >> "$LOG_DIR/security.log"
  # Return structured hook response to deny execution.
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked potentially destructive command pattern"}}'
  # Exit code 2 indicates blocking decision.
  exit 2
fi

# Record successful security check.
printf '[%s] Security check passed\n' "$TIMESTAMP" >> "$LOG_DIR/security.log"
# Return structured hook response to allow execution.
printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"Security checks passed"}}'

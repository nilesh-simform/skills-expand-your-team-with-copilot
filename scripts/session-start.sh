#!/usr/bin/env bash
# Fail on command errors, undefined vars, and pipeline failures.
set -euo pipefail

# Resolve repository root from this script location.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Build absolute path to logs directory.
LOG_DIR="$ROOT_DIR/logs"
# Ensure logs directory exists.
mkdir -p "$LOG_DIR"

# Append UTC session start timestamp to session log.
printf 'Session started: %s\n' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$LOG_DIR/session.log"

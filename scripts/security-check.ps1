# Resolve repository root from this script location.
$RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
# Build absolute path to logs directory.
$LogDir = Join-Path $RootDir "logs"
# Ensure logs directory exists.
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

# Read tool-intent payload from stdin.
$Payload = [Console]::In.ReadToEnd()
# Capture current UTC timestamp for auditing.
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
# Regex pattern for potentially destructive commands.
$Pattern = 'git reset --hard|git checkout --|rm -rf /|rm -fr /|dd if='

# Deny tool execution when payload matches blocked patterns.
if ($Payload -match $Pattern) {
  # Record denied event to security log.
  Add-Content -Path (Join-Path $LogDir "security.log") -Value "[$Timestamp] Blocked tool payload by security policy"
  # Return structured hook response to deny execution.
  Write-Output '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Blocked potentially destructive command pattern"}}'
  # Exit code 2 indicates blocking decision.
  exit 2
}

# Record successful security check.
Add-Content -Path (Join-Path $LogDir "security.log") -Value "[$Timestamp] Security check passed"
# Return structured hook response to allow execution.
Write-Output '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"Security checks passed"}}'

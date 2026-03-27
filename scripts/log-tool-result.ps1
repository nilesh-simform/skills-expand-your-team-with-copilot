# Resolve repository root from this script location.
$RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
# Build absolute path to logs directory.
$LogDir = Join-Path $RootDir "logs"
# Ensure logs directory exists.
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

# Read tool result payload from stdin.
$Payload = [Console]::In.ReadToEnd()
# Build output file path for JSONL tool results.
$LogFile = Join-Path $LogDir "tool-results.jsonl"

# Write payload when present, otherwise write empty JSON object.
if ([string]::IsNullOrWhiteSpace($Payload)) {
  Add-Content -Path $LogFile -Value "{}"
} else {
  Add-Content -Path $LogFile -Value $Payload
}

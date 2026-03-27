# Resolve repository root from this script location.
$RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
# Build absolute path to logs directory.
$LogDir = Join-Path $RootDir "logs"
# Ensure logs directory exists.
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

# Read hook stdin payload as raw text.
$Payload = [Console]::In.ReadToEnd()
# Capture current UTC timestamp for the log entry.
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
# Resolve log level from environment, with INFO fallback.
$Level = if ($env:LOG_LEVEL) { $env:LOG_LEVEL } else { "INFO" }

# Append header for this prompt submission event.
Add-Content -Path (Join-Path $LogDir "prompt-events.log") -Value "--- Prompt submitted at $Timestamp (level=$Level) ---"
# Write payload when present, otherwise write empty JSON object.
if ([string]::IsNullOrWhiteSpace($Payload)) {
  Add-Content -Path (Join-Path $LogDir "prompt-events.log") -Value "{}"
} else {
  Add-Content -Path (Join-Path $LogDir "prompt-events.log") -Value $Payload
}

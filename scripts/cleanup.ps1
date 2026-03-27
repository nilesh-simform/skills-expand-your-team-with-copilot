# Resolve repository root from this script location.
$RootDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
# Build absolute path to logs directory.
$LogDir = Join-Path $RootDir "logs"
# Ensure logs directory exists.
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null

# Capture current UTC timestamp for auditing.
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
# Append session end timestamp to session log.
Add-Content -Path (Join-Path $LogDir "session.log") -Value "Session ended: $Timestamp"

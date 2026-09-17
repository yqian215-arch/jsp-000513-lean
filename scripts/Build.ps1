$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\Enter-Lean.ps1"
New-Item -ItemType Directory -Path 'work' -Force | Out-Null
$taskLog = Join-Path 'work' ('build-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.log')
lake build 2>&1 | Tee-Object -FilePath $taskLog
$taskExitCode = $LASTEXITCODE
Write-Host "Build exit code: $taskExitCode; log: $taskLog"
exit $taskExitCode


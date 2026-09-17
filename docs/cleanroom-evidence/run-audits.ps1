[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$ErrorActionPreference='Continue'
Set-Location 'D:\Lean\jsp-000513-cleanroom\repo'
$env:ELAN_HOME='D:\Lean\tools\elan'
$env:PATH="$env:ELAN_HOME\bin;$env:PATH"
$env:LAKE_NO_CACHE='true'
$env:LAKE_ARTIFACT_CACHE='false'
$env:LAKE_CACHE_DIR='D:\Lean\jsp-000513-cleanroom\lake-cache'
$env:MATHLIB_NO_CACHE_ON_UPDATE='1'
$env:MATHLIB_CACHE_DIR='D:\Lean\jsp-000513-cleanroom\dependency-download-cache'
foreach ($audit in @('AxiomAudit','GraphAudit')) {
  "COMMAND: lake --no-cache env lean docs/cleanroom-evidence/$audit.lean; cwd=$PWD; start=$(Get-Date -Format o)" | Set-Content "D:\Lean\jsp-000513-cleanroom\evidence\$audit-command.txt"
  lake --no-cache env lean "docs/cleanroom-evidence/$audit.lean" *> "D:\Lean\jsp-000513-cleanroom\evidence\$audit-2.log"
  "exit=$LASTEXITCODE time=$(Get-Date -Format o)" | Set-Content "D:\Lean\jsp-000513-cleanroom\evidence\$audit-exit-2.txt"
}

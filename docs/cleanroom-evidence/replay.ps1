[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new($false)
Set-Location 'D:\Lean\jsp-000513-cleanroom\repo'
$env:ELAN_HOME='D:\Lean\tools\elan'
$env:PATH="$env:ELAN_HOME\bin;$env:PATH"
$env:LAKE_NO_CACHE='true'
$env:LAKE_ARTIFACT_CACHE='false'
$env:LAKE_CACHE_DIR='D:\Lean\jsp-000513-cleanroom\lake-cache'
"COMMAND: lake --no-cache env leanchecker --fresh --verbose JSP000513; cwd=$PWD; start=$(Get-Date -Format o)" | Set-Content 'D:\Lean\jsp-000513-cleanroom\evidence\kernel-replay-command.txt'
lake --no-cache env leanchecker --fresh --verbose JSP000513 *> 'D:\Lean\jsp-000513-cleanroom\evidence\kernel-replay.log'
"exit=$LASTEXITCODE time=$(Get-Date -Format o)" | Set-Content 'D:\Lean\jsp-000513-cleanroom\evidence\kernel-replay-exit.txt'

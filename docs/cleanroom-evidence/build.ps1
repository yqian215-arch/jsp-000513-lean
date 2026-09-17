$ErrorActionPreference = 'Continue'
Set-Location 'D:\Lean\jsp-000513-cleanroom\repo'
$env:ELAN_HOME = 'D:\Lean\tools\elan'
$env:MATHLIB_CACHE_DIR = 'D:\Lean\jsp-000513-cleanroom\dependency-download-cache'
$env:MATHLIB_NO_CACHE_ON_UPDATE = '1'
$env:PATH = "$env:ELAN_HOME\bin;C:\Users\Administrator\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd;$env:PATH"
$env:LAKE_NO_CACHE = 'true'
$env:LAKE_ARTIFACT_CACHE = 'false'
$env:LAKE_CACHE_DIR = 'D:\Lean\jsp-000513-cleanroom\lake-cache'
Start-Transcript -Path 'D:\Lean\jsp-000513-cleanroom\evidence\build-transcript-2.log'
Get-Date -Format o
Get-Location
[System.Environment]::OSVersion.VersionString
$PSVersionTable
Get-Command lean,lake,elan,git | Select-Object Name,Source
elan show 2>&1 | Out-String | Write-Output
lean --version 2>&1 | Out-String | Write-Output
lake --version 2>&1 | Out-String | Write-Output
git --version 2>&1 | Out-String | Write-Output
Write-Output "ELAN_HOME=$env:ELAN_HOME MATHLIB_CACHE_DIR=$env:MATHLIB_CACHE_DIR MATHLIB_NO_CACHE_ON_UPDATE=$env:MATHLIB_NO_CACHE_ON_UPDATE"
Write-Output 'COMMAND: lake --no-cache build; LAKE_NO_CACHE=true LAKE_ARTIFACT_CACHE=false LAKE_CACHE_DIR=D:\Lean\jsp-000513-cleanroom\lake-cache'
lake --no-cache build *> 'D:\Lean\jsp-000513-cleanroom\evidence\lake-build-2.log'
$buildExit = $LASTEXITCODE
"exit=$buildExit time=$(Get-Date -Format o)" | Set-Content 'D:\Lean\jsp-000513-cleanroom\evidence\build-exit-2.txt'
Get-Content 'D:\Lean\jsp-000513-cleanroom\evidence\build-exit-2.txt'
Stop-Transcript


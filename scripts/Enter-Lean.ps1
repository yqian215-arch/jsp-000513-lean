# Dot-source this file from PowerShell: . .\scripts\Enter-Lean.ps1
$env:ELAN_HOME = 'D:\Lean\tools\elan'
$env:MATHLIB_CACHE_DIR = 'D:\Lean\cache\mathlib'
$taskGit = 'C:\Users\Administrator\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd'
$env:PATH = "$env:ELAN_HOME\bin;$taskGit;$env:PATH"
Set-Location -LiteralPath (Split-Path -Parent $PSScriptRoot)

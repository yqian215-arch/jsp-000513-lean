[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new($false)
Set-Location 'D:\Lean\jsp-000513-cleanroom\repo'
$env:ELAN_HOME='D:\Lean\tools\elan'
$env:PATH="$env:ELAN_HOME\bin;$env:PATH"
$env:LAKE_NO_CACHE='true'
$env:LAKE_ARTIFACT_CACHE='false'
$env:MATHLIB_NO_CACHE_ON_UPDATE='1'
$env:MATHLIB_CACHE_DIR='D:\Lean\jsp-000513-cleanroom\dependency-download-cache'
$env:LAKE_CACHE_DIR='D:\Lean\jsp-000513-cleanroom\lake-cache'
Start-Transcript -Path docs/submission-evidence/regression-transcript.log
lean --version
lake --version
Write-Output 'COMMAND: lake env lean docs/submission-evidence/AxiomAudit.lean'
lake env lean docs/submission-evidence/AxiomAudit.lean *> docs/submission-evidence/axioms.log
"axiom_exit=$LASTEXITCODE" | Set-Content docs/submission-evidence/regression-exits.txt
Write-Output 'COMMAND: lake env lean docs/cleanroom-evidence/GraphAudit.lean'
lake env lean docs/cleanroom-evidence/GraphAudit.lean *> docs/submission-evidence/graph-regression.log
"graph_exit=$LASTEXITCODE" | Add-Content docs/submission-evidence/regression-exits.txt
Write-Output 'COMMAND: lake env leanchecker --fresh --verbose JSP000513'
lake env leanchecker --fresh --verbose JSP000513 *> docs/submission-evidence/kernel-regression.log
"kernel_exit=$LASTEXITCODE; time=$(Get-Date -Format o)" | Add-Content docs/submission-evidence/regression-exits.txt
Stop-Transcript

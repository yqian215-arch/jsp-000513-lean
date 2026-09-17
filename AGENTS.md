# JSP-000513 full formalization

- Work only on this home Windows host, in `D:\Lean\jsp-000513-lean`.
- Scope: fully prove the existence of a finite 4-choosable graph that is not (8:2)-choosable, following DHS19. The user explicitly expanded the scope beyond Phase 0 on 2026-09-17.
- Read README.md and docs/ before extending the project.
- User authorized pushing verified, locally committed progress to this repository only when its visibility is confirmed Private. Recheck visibility before the first push. Do not publish, submit an award application, or change visibility without authorization.
- At initial inspection on 2026-09-17, GitHub reported the remote as Public. Do not assume it is Private.
- No `sorry`, `admit`, new unproved axioms, or weakened target statements. Intermediate unproved targets must not be used as assumptions.
- Match quantifiers and all hypotheses to the original paper; distinguish proven results from conjectures.
- Use the pinned Lean and Mathlib version. Dot-source scripts/Enter-Lean.ps1 in PowerShell, then run lake build.
- Keep downloads and temporary investigations in work/ (ignored by Git).
- Record build commands, exit status, risks, and remaining work honestly in docs/.
- Every substantive stage: lake build, axiom audit, update docs/PROGRESS.md, local Git commit, then continue automatically.
- Prefer one execution route. Only use additional agents for substantive mathematical obstacles, uncertain Mathlib infrastructure, or repeated failures.
- Do not stop for ordinary compiler errors, missing lemmas, or file operations. Pause only for login/MFA, payment, publication/submission, substantive source contradictions, a potentially wrong mathematical route, order-of-magnitude cost changes, or usage exhaustion.
- Do not declare the overall task complete before the full main theorem is kernel-checked.
- Before usage exhaustion or forced interruption, save all source, update docs/PROGRESS.md, run feasible build checks, commit locally, and push verified stages if the private-repository/authentication preconditions hold. Never depend on conversation context as the only progress record.

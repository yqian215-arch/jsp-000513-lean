# Submission hardening report

Status: IN PROGRESS. Private preparation only; no license chosen, no publication or formal submission authorized.

Proof baseline: 8496ddb257bbdd9948417d3a98a563f2696cd47b.
New branch: submission-hardening, created from the proof baseline in the independent clone D:\Lean\jsp-000513-cleanroom\repo. Neither phase0-local nor cleanroom-verification is modified.
Clean-room evidence copied from f7ef7477619b081aa43eacde99ae0f32638897ba as historical evidence of the unchanged baseline. Builds in this stage may reuse that clone's independently built dependencies; this is regression testing, not a new from-zero clean-room build.

Next: add direct no-doubling wrapper from theorem2; remove stale C5 comment; omit only the three unused DecidableEq parameters; build and audit; commit verified code stage. Then prepare English README/ATTRIBUTION/license recommendation/current official submission checklist, and run regression.

## Code-stage checkpoint
2026-09-18: added JSP000513.Problem.list wrapper (actual fully qualified name JSP000513.list_choosability_doubling_is_false), importing it from the root. Direct proof destructures theorem2 and uses h82 (h n G h4).
Changed only the stale C5 module comment and three `omit [DecidableEq ...] in` lines; underlying proof bodies and graph/list definitions unchanged.
`lake build` completed with 828 jobs, exit 0 at 07:53:12+08:00; no warning/error lines. Root axiom audit and separate WrapperAudit both show only propext, Classical.choice, Quot.sound; wrapper exit 0.
Next: full regression closure/graph/kernel replay and current-source scan; finalize English public-facing documentation and remaining human gates. No LICENSE added.

# Submission-hardening report — JSP-000513

**Technical result: PASS. A private, submission-ready candidate has been prepared.**

**Ready for public review:** technically prepared, but release-gated. The repository is still Private, Apache-2.0 has been adopted, and public contact/publication/formal submission decisions remain with the maintainer. This is not a claim that anonymous reviewers can currently access the source, or that the prize has accepted the contribution.

Completed 2026-09-18 (Asia/Shanghai). Proof baseline: `83644d1838aadee8fc7acd9150c610aff5402ba7`. Branch: **`submission-hardening`**, created directly from that baseline in `D:\Lean\jsp-000513-cleanroom\repo`. Neither `phase0-local` nor `cleanroom-verification` was modified. Baseline clean-room evidence was copied from `c8b1f7cc5fdef20a06d3f6a886681ae2443cb992`; it remains historical evidence for that proof version.

## Changes and mathematical preservation

1. Added `JSP000513/Problem.lean` and imported it from the root. Its direct wrapper is proved from `theorem2` alone and uses exactly the same n,G witness.
2. Updated the stale C5Obstruction module comment to point to C5Positive and MainTheorem.
3. Added `omit [DecidableEq ...] in` to `exists_mem_of_card_lt`, `Triangle.vector_coloring`, and `Nine.combine_coloring`. This removes unused instance parameters; their conclusions and proof bodies are unchanged. It does not add assumptions or weaken the final theorem. The irrelevant binder disappears from these helper signatures.
4. Replaced README with an English project description, exact theorem/file coordinates, pinned environment/build instructions, verification scope, private status, and AI/attribution links.
5. Added ATTRIBUTION.md, LICENSE_RECOMMENDATION.md, and SUBMISSION_CHECKLIST.md. No license was silently selected. No public PR/issue/application was sent.

An automated comparison of all **21 pre-existing Lean modules** confirms unchanged code after removing only comments/whitespace and those three exact `omit` lines. All graph/list definitions, C5→G5 proof bodies, FinalConstruction, MainTheorem, and PaletteEquivalence remain unchanged. `lean-toolchain`, `lakefile.toml`, and `lake-manifest.json` are unchanged. The root additionally imports/audits the wrapper. See `submission-evidence/core-preservation.json` and `proof-diff.patch`.

## Exact wrapper

```lean
theorem JSP000513.list_choosability_doubling_is_false :
    ¬ (∀ (n : ℕ) (G : SimpleGraph (Fin n)),
      JSP000513.ABChoosable G 4 1 → JSP000513.ABChoosable G 8 2)
```

The proof in namespace JSP000513 is:

```lean
  intro h
  obtain ⟨n, G, h4, h82⟩ := theorem2
  exact h82 (h n G h4)
```

`ABChoosable` still universally quantifies over lists of the exact size. The wrapper neither replaces it with a fixed-list positive claim nor chooses different graphs for the two properties. A counterexample at a=4,b=1 resolves the general preservation question negatively; it does not assert failure for all a,b.

## Validation results

| Check | Result | Evidence under `docs/submission-evidence/` |
|---|---|---|
| `lake build` | PASS, exit 0, **828 jobs**, no warning/error lines | `build.log`, `build-exit.txt` |
| Wrapper in a standalone import file | PASS, exit 0 | `WrapperAudit.lean`, `wrapper.log`, `wrapper-exit.txt` |
| Root and independent axiom audit | PASS, standard axioms only | `axioms.log`, `AxiomAudit.lean` |
| Full transitive logical constant closure | PASS, zero unsafe/partial/unapproved-axiom flags | `closure-*.txt`, `axioms.log` |
| Current production-source scan | PASS, 26 source/config/script files, zero prohibited/placeholder hits | `scan-current.py`, `source-scan.json`, `scan.log` |
| Unchanged clean-room graph/list regression | PASS, exit 0 | `graph-regression.log`, unchanged `../cleanroom-evidence/GraphAudit.lean` |
| Fresh kernel replay of the root/imports | PASS, exit 0 | `kernel-regression.log`, `regression-exits.txt` |
| Core proof and lockfile preservation | PASS | `core-preservation.json`, `proof-diff.patch` |
| Reachable-history credential-pattern screening | 139 blobs screened at code-stage HEAD; zero hits | `publication-screen.json` |

The original three final declarations have closure sizes 6182, 6182, and 3992; the new wrapper has 6183. All four depend only on **`propext`, `Classical.choice`, `Quot.sound`**. No `sorryAx`, project-added axiom, `unsafe`/`partial` logical dependency, or native reduction oracle was found. Standard toolchain extern/implemented_by attributes are separately recorded in `closure-*.runtime.txt`; this does not claim the Lean implementation or its tactics contain no unsafe runtime code.

The production scan excludes docs audit harnesses so scanner keywords/string literals and historical failed-audit logs are not misrepresented as production proof. The original root's `#print axioms` commands are audits, not axiom declarations. No mathematical target was changed to make a test pass.

Graph regression checks complete vertex bijections, all edge iff statements and full lists for C5/G1/G2/G3/G4/G5 (5/8/14/36/49/61 undirected edges), the G5 embedding, final neighbor rule and a nonempty index witness. The independent C5 enumeration again checked 7776 candidates and found no valid assignment. This regression reuses the prior clean-room expectations, not new expectations generated from the modified proof.

## Environment, commands and limits

Lean 4.34.0, compiler commit `293d5d0c0c3f3dded4688b3ccd6a33939ac5102b`; Lake 5.0.0-src+293d5d0; Mathlib pinned at `5ed2965256430c3649e86755f9576b54eca72435`. Host is the same Windows machine used by the independent clean-room clone.

The build used `lake build` with `LAKE_NO_CACHE=true`, `LAKE_ARTIFACT_CACHE=false`, and `MATHLIB_NO_CACHE_ON_UPDATE=1`. It reused this clone's previously independently built dependencies; **this is a regression build, not another from-zero build**. The old reports and logs were not overwritten. Full environment and regression commands are in `regression.ps1` and `regression-transcript.log`.

```text
lake build
lake env lean docs/submission-evidence/WrapperAudit.lean
lake env lean docs/submission-evidence/AxiomAudit.lean
lake env lean docs/cleanroom-evidence/GraphAudit.lean
lake env leanchecker --fresh --verbose JSP000513
```

Build completed at 07:53:12+08:00, fresh replay at 08:00:48+08:00. Each required execution has exit 0. The replay uses the same Lean kernel; it is not an external kernel implementation or human peer review. The source scan and historical credential-pattern screening are bounded checks, not a universal security/copyright guarantee. Historical evidence contains local machine paths and generic automation identities; no public email is inferred from them.

## Official rules, attribution, and remaining gates

The current [official contribution instructions](https://github.com/TheJustinSunPrize/awards/blob/main/CONTRIBUTING.md#external-solver-and-lean-submissions), [claim form](https://github.com/TheJustinSunPrize/awards/blob/main/.github/ISSUE_TEMPLATE/claim-award.yml), and [attribution process](https://github.com/TheJustinSunPrize/awards/blob/main/docs/attribution.md#claiming-an-award) were read on 2026-09-18. Their downloaded content hashes are recorded. The checklist distinguishes catalog evidence (public source, branch, full SHA, theorem/file/build/attribution) from the later self-claim (entry/repository links, consented public email, true contribution role and related claims).

No known Lean build or theorem blocker remains.

License selection is complete: **Apache-2.0** is adopted in the root LICENSE. Third-party terms remain applicable; see LICENSE_RECOMMENDATION.md. This is no longer a release blocker.

Remaining human/external gates are:

- **Public visibility:** separate approval and anonymous accessibility check are still required. GitHub metadata confirmed owner yqian215-arch, private visibility, and push permission before publication of this private branch.
- **Public correspondence email:** not selected; must be supplied/approved by the user.
- **Formal catalog PR and claim issue:** separate approvals; no proxy or mathematical-author claim is supported by this project's evidence.
- **Applicant declarations and official review:** applicant account must equal the repo owner and establish its actual contribution. Ownership and AI-assisted workflow labels alone are not identity/eligibility certification. Related claims/conflicts must be truthfully supplied at filing. Final rights/history review and official approval remain external gates.

## Durable checkpoint and final pin

Checkpoint commits: initialization `d2018998079ebe36e74da8a6bd30479d5d6b4d42`, verified code stage `bbc9dcf35216341bb24931be8dceeb36a113fcec`. Each contains the then-current report/evidence. The earlier verified source/documentation commit is **cae0bc9db1f0ecf8c6fbb3ab2c5ed1c07a4fae68** (a historical reference; see PUBLICATION_CANDIDATE.md for the frozen publication candidate). Its pin and branch containment were recorded at that stage. The final publication SHA is recorded externally after the documentation-cleanup commit; no additional content commit is needed.

All authorized engineering work is complete. Exact continuation: read this report and SUBMISSION_CHECKLIST.md, obtain the remaining user decisions, then apply only the approved publication/submission actions. License selection is already complete. Do not redo the proof or silently change the baseline. Any later Lean or lockfile changes require appropriate renewed validation.

Operational issues resolved without source repair: a combined edit/build call was rejected by automatic policy review, so edits were applied as explicit patches and the build run separately; the patch tool rejected a same-call delete/add of README, resolved by separate operations; an official-repository Git metadata probe timed out while the official raw file downloads succeeded. None was a theorem failure.

## Historical private remote confirmation (before publication-document cleanup)

The private submission-hardening branch was pushed and its remote tip was confirmed as `d93382d1de2db8dda451f49c53aaaeac88653c25`, matching local HEAD at that check. It contains the selected source candidate `cae0bc9db1f0ecf8c6fbb3ab2c5ed1c07a4fae68`; no Lean/lockfile changes followed that candidate. The next checkpoint commit only records this verification. These historical refs are expressed using the post-email-rewrite SHA mapping. Their file trees were unchanged by the metadata rewrite. See `submission-evidence/remote-verification.txt`. Public-facing document links were checked successfully; no candidate-SHA placeholder remains in current documentation.

# Submission checklist — JSP-000513

Reviewed against the official materials on **2026-09-18**. This is private preparation, not a filed application or an eligibility decision. Recheck the rules immediately before any public action.

## Official sources

- [CONTRIBUTING: external solver and Lean submissions](https://github.com/TheJustinSunPrize/awards/blob/main/CONTRIBUTING.md#external-solver-and-lean-submissions)
- [Current claim form](https://github.com/TheJustinSunPrize/awards/blob/main/.github/ISSUE_TEMPLATE/claim-award.yml)
- [Attribution and claimant verification](https://github.com/TheJustinSunPrize/awards/blob/main/docs/attribution.md#claiming-an-award)
- [JSP-000513 catalog entry](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0501-0600.md#JSP-000513)

Downloaded copies of the first three were read; their hashes are in `submission-evidence/official-sources-hashes.txt`. Raw reference copies are local under `work/submission/`. A Git metadata probe for the official main branch timed out; no unverified official commit is asserted. The dated file snapshots and public URLs are the evidence.

## Candidate coordinates

- Original repository: `https://github.com/yqian215-arch/jsp-000513-lean`
- Submission branch: **`submission-hardening`**.
- Original verified proof baseline: **`8496ddb257bbdd9948417d3a98a563f2696cd47b`**.
- Hardened source candidate (full 40-character SHA): **PENDING_FINAL_SOURCE_COMMIT**. Filled after the source/documentation commit; later evidence-only commits do not change that candidate's Lean code.
- Direct theorem: **`JSP000513.list_choosability_doubling_is_false`**, `JSP000513/Problem.lean`.
- Same finite witness: **`JSP000513.theorem2`**, `JSP000513/MainTheorem.lean`.
- Build: `lake build` from the repository root; fixed versions and no-download-cache instructions are in README.

## Checks and human gates

| Requirement | Status | Evidence / remaining action |
|---|---|---|
| Complete answer to the original problem | PASS | The finite (4:1)/(8:2) counterexample negates the proposed universal doubling rule. Wrapper is derived directly from theorem2 with the same n,G. |
| Complete proof, no missing-proof assumptions | PASS | Baseline two-layer verification; current build, root/standalone wrapper audits, production scan and regression recorded in hardening report. |
| Public, accessible original Lean source | TODO — user decision | Repository remains Private. No visibility change is authorized. Verify anonymous access to the selected SHA after an approved publication. |
| Named branch contains selected SHA | PASS after final pin | Branch is submission-hardening; final pin is recorded below and checked as an ancestor of its remote tip. Do not replace it with a short SHA or only a branch URL. |
| Theorem/file and build instructions | PASS | Coordinates above and English README, lean-toolchain, locked manifest. |
| Formalization attribution | Prepared; official review pending | ATTRIBUTION.md separates DHS19 authors, yqian215-arch's actual project role, and extensive ChatGPT Work/Codex assistance. No claim of line-by-line manual authorship or mathematical authorship by the applicant. |
| Owner equals submitting GitHub account | Owner confirmed; applicant action TODO | GitHub reports owner yqian215-arch. Any claim must be submitted by that same account for its own actual contribution; no proxy submission. No issue has yet been filed, so issue-author identity cannot be pre-verified. |
| Account-to-contributor identity | TODO — official review | Source roles are explicit. Ownership and automated commit names alone are not authorship evidence. Maintainers may request clarification/independent corroboration; do not mark identity verified locally. |
| Public contact email | TODO — user decision | No email chosen or inferred. Claim form requires an address the applicant agrees to make public. Git author/no-reply addresses are not substituted. |
| License and contribution rights | TODO — user decision | No LICENSE adopted; review LICENSE_RECOMMENDATION.md, choose scope/holder, retain third-party notices. Official CONTRIBUTING requires entitlement to contribute; no specific external software license is asserted as mandatory. |
| Catalog PR | TODO — separate authorization | Use the default PR template and update only the existing catalog-0501-0600.md entry's permitted fields with references. Do not upload Lean source, build files, archives, or binaries to the awards repository. Maintainers handle resulting index/eligibility reconciliation. |
| Claim issue | TODO — separate authorization | Use the current form after catalog evidence is established. Link the entry and original public repo, provide public email, truthful role and related claims. Do not duplicate branch/SHA/theorem proof materials in the issue; link a catalog correction if needed. |
| Claimed role | TODO — applicant confirmation | This evidence supports consideration of an accurately described Lean/project contribution only. It does not support claiming the DHS19 mathematical solution. Eligibility of that contribution remains for maintainers. |
| Related claims/conflicts and duplicates | TODO — applicant declaration at filing | Check existing PRs/issues and disclose actual related claims/conflicts; update an existing one instead of duplicating. Do not prefill “None” without the applicant's knowledge. |
| Private material in public diff/history | Local screening recorded | No credentials are intentionally included; local machine paths and generic automation identities exist in historical evidence. Final publication approval must cover the visible history; no history rewrite is performed here. |
| Maintainer approval, identity/award confirmation | TODO — external process | Local build success is not official review, approval, prize entitlement, or payment authorization. |

The checklist does not require a mathematical-author email for a Lean-only claim whose source attribution establishes the account connection. If that connection is unclear, the current official identity-verification process still applies. Private identity/payment evidence belongs in the maintainer-designated private channel, not a public issue.

## Safe sequence after user decisions

1. Confirm LICENSE scope and public correspondence email; prepare the approved notices.
2. Approve publication and inspect anonymous access to the exact branch/SHA and attribution.
3. Recheck current rules and existing submissions; prepare/approve the catalog PR with links only.
4. Separately approve a truthful self-claim using the latest form, once the catalog evidence is correct.

None of these public actions has been executed by this hardening workflow.

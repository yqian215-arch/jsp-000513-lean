# JSP-000513: list choosability does not survive doubling

This Lean project formalizes a negative answer to [JSP-000513](https://github.com/TheJustinSunPrize/awards/blob/main/problems/catalog-0501-0600.md#JSP-000513): doubling both the available-list size and the required number of colors per vertex does not always preserve list choosability. One finite simple graph is (4:1)-choosable and is not (8:2)-choosable.

The mathematical proof is due to **Zdeněk Dvořák, Xiaolan Hu, and Jean-Sébastien Sereni**, *A 4-choosable Graph that is Not (8:2)-choosable*, Advances in Combinatorics 2019:5, [DOI](https://doi.org/10.19086/aic.10811), [arXiv v2](https://arxiv.org/abs/1806.03880v2). The formalization follows the C5 → G1/G2 → G3 → G4 → G5 → uniform-list construction.

## Main declarations

| Declaration (namespace `JSP000513`) | File | Meaning |
|---|---|---|
| `list_choosability_doubling_is_false` | [Problem.lean](JSP000513/Problem.lean) | Negates the universal doubling implication on finite graphs |
| `theorem2` | [MainTheorem.lean](JSP000513/MainTheorem.lean) | A single finite graph with both properties |
| `theorem2_all_palettes` | [MainTheorem.lean](JSP000513/MainTheorem.lean) | The same witness, arbitrary palettes on the positive side |
| `finitePaletteEquivalence` | [PaletteEquivalence.lean](JSP000513/PaletteEquivalence.lean) | Natural colors suffice for finite graphs with arbitrary palettes |

The direct problem statement is:

```lean
¬ (∀ (n : ℕ) (G : SimpleGraph (Fin n)),
  JSP000513.ABChoosable G 4 1 → JSP000513.ABChoosable G 8 2)
```

`ABChoosable` quantifies over every list assignment of the specified cardinality. A coloring selects exactly the required number of colors at each vertex, with disjoint sets on every edge. See [Definitions.lean](JSP000513/Definitions.lean).

## Reproducible build

Install Elan/Lean and Git, clone this repository with authorized access while it remains private, and run from its root:

```text
git checkout submission-hardening
git rev-parse HEAD
lake build
```

For review, use the frozen publication candidate described in [PUBLICATION_CANDIDATE.md](docs/PUBLICATION_CANDIDATE.md) and record its full 40-character SHA, rather than relying on a moving branch. Lean is pinned to **v4.34.0** in `lean-toolchain`; Mathlib **v4.34.0** is pinned at `5ed2965256430c3649e86755f9576b54eca72435`. All dependency revisions are in `lake-manifest.json`. Do not run `lake update` to reproduce that version.

For source builds without downloaded compilation caches, use a fresh clone and PowerShell:

```powershell
$env:MATHLIB_NO_CACHE_ON_UPDATE = '1'
$env:LAKE_NO_CACHE = 'true'
$env:LAKE_ARTIFACT_CACHE = 'false'
$env:MATHLIB_CACHE_DIR = Join-Path $PWD 'work/mathlib-cache'
$env:LAKE_CACHE_DIR = Join-Path $PWD 'work/lake-cache'
lake --no-cache build
```

This still uses the installed Lean toolchain/standard library. The legacy `scripts/Enter-Lean.ps1` convenience script contains maintainer-host paths and is not required for a normal checkout.

## Verification and current status

Proof baseline `83644d1838aadee8fc7acd9150c610aff5402ba7` has two recorded verification layers: [project verification](docs/FINAL_VERIFICATION.md) and [independent clean-room verification](docs/CLEANROOM_VERIFICATION.md). The latter rebuilt dependencies in a separate clone, checked theorem fidelity and complete gadget edge/list data, traversed proof dependencies, and replayed declarations in a fresh Lean kernel environment. Its shared-toolchain and interrupted/resumed-build limitations are documented. These are engineering records, not independent human peer review or prize approval.

[Submission hardening](docs/SUBMISSION_HARDENING_REPORT.md) adds the direct wrapper, removes stale comments and three unused-instance warnings, and records regression results without restructuring the mathematical construction. Historical reports describe their own versions; the hardening report describes the current candidate.

**As of 2026-09-18 this repository remains Private. This workflow has not submitted a catalog PR, claim issue, or formal award application.** Publication and formal submission require separate maintainer authorization.

Before formal publication, Git history underwent a metadata rewrite solely to remove a private commit email. File trees and Lean proof content were unchanged. Historical commit references in the current documents have been synchronized to the rewritten history.

## Attribution and licensing

**`yqian215-arch`** initiated and organized the project, maintains it, and prepares its submission. OpenAI ChatGPT Work/Codex was used extensively for Lean code generation, debugging, and formalization engineering. We do not claim that the maintainer manually wrote every line or authored the DHS19 mathematical proof. See [ATTRIBUTION.md](ATTRIBUTION.md).

This project has adopted **Apache License 2.0**; see [LICENSE](LICENSE). [LICENSE_RECOMMENDATION.md](docs/LICENSE_RECOMMENDATION.md) records the selected license and the historical comparison. Third-party licenses retain their own scope. [SUBMISSION_CHECKLIST.md](docs/SUBMISSION_CHECKLIST.md) records publication, contact, attribution, and application gates.

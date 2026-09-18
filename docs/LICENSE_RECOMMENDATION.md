# License decision — Apache-2.0 selected

Reviewed 2026-09-18. **Apache License 2.0 has been selected and is present in [LICENSE](../LICENSE).** The comparison below records the earlier evaluation; it is no longer a pending license decision. Third-party materials retain their own terms. This is a source-based engineering recommendation, not an assurance of copyright ownership or a legal opinion.

## Source findings

- **Mathlib:** [the pinned LICENSE](https://github.com/leanprover-community/mathlib4/blob/5ed2965256430c3649e86755f9576b54eca72435/LICENSE) is Apache-2.0. Redistribution requires its license, relevant notices, modification notices where applicable, and applicable NOTICE material. Different terms for one's own modifications remain subject to those conditions. Imports do not authorize removing Mathlib's notices. Dependencies are fetched, not vendored into the tracked proof source.
- **DHS19:** [the publisher page](https://doi.org/10.19086/aic.10811) identifies **CC BY 4.0**; the v2 PDF also carries a CC-BY notice. [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) permits sharing/adaptation with attribution, license link, and change indication, without implying endorsement. [arXiv v2](https://arxiv.org/abs/1806.03880v2) separately links [arXiv's non-exclusive distribution permission](https://arxiv.org/licenses/nonexclusive-distrib/1.0/license.html), which is not itself a general public reuse grant. Use the publisher's grant for article reuse and retain notices for reproduced text/figures.
- **Project contributions:** credit, rights in particular code/text, and distribution permission are separate matters. AI disclosure does not guarantee exclusive copyright in every generated passage or remove third-party obligations. This investigation did not prove originality of every code fragment. License only rights the maintainer may grant; do not package the article as project-owned software.

## Historical comparison

| Option | Reason and scope | Risk / required review |
|---|---|---|
| **Selected: Apache-2.0 for project contributions** | Aligns with Mathlib; explicit patent terms. The project LICENSE covers original project documentation as well; separately attributed third-party material retains its own terms. | More notice detail than MIT. Check adapted/copied source and rights-holder wording. The article and dependencies retain their own licenses. |
| **Alternative: MIT for original project code/scripts** | Short permissive software terms; see [OSI's MIT text](https://opensource.org/license/mit). | No comparable explicit patent grant. Do not replace Apache conditions on third-party copied code with MIT. Review documentation and paper excerpts separately. |

Avoid blanket ownership claims covering DHS19, Mathlib, or the dependency tree. CC BY 4.0 applies to relevant article/content reuse; it is not the recommended software license here.

## Maintainer decision

Apache-2.0 is adopted for project contributions under the root LICENSE. MIT remains an unselected historical alternative. This selection does not relicense DHS19 or dependencies, establish ownership of third-party material, or imply award eligibility. Preserve applicable third-party attribution and notices when redistributing.

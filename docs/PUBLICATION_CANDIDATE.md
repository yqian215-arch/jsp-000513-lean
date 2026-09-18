# Frozen publication candidate

The publication candidate is the commit introducing this file on `submission-hardening`, after the publication-document cleanup. Obtain its complete 40-character SHA with:

```text
git log --diff-filter=A --format=%H -- docs/PUBLICATION_CANDIDATE.md
```

The command must return exactly one commit. At completion of this cleanup it is also the local and remote branch tip. The external release receipt records that exact SHA after commit and push. Use that SHA in the official JSP catalog submission; earlier proof and hardening SHAs in verification reports are historical evidence, not the final publication pin. The full SHA is stored outside the committed tree to avoid an impossible self-referential commit hash.

Candidate contents are frozen after this commit unless an issue is discovered. No follow-up content commit is needed merely to record its SHA. Lean source, audit harness Lean files, `lake-manifest.json`, `lean-toolchain`, and `lakefile.toml` are unchanged by this documentation cleanup.

Before formal publication, Git history underwent a metadata rewrite solely to remove a private commit email. File trees and Lean proof content were unchanged. Current documentation and audit-script references have been translated to the rewritten commit IDs, including formerly abbreviated IDs. Historical evidence logs retain their original verification scope; translated references do not represent new proof runs.

Current status on 2026-09-18: **Private; Apache License 2.0 adopted**. Publication, public contact email, catalog PR, claim issue, applicant declarations, and official review remain separate actions. No public action is authorized by this cleanup.

Documentation-cleanup validation: `lake build` and the existing `docs/submission-evidence/AxiomAudit.lean` audit both exited 0. The mathematical declarations still use only `propext`, `Classical.choice`, and `Quot.sound`. All tracked text was scanned for old project commit IDs (full or abbreviated) and private Gmail. All reachable commit metadata/messages and historical tracked blobs were screened for private Gmail. Remote refs were checked to exclude old commit history. Detailed logs and the final post-push receipt are retained outside this frozen source tree.

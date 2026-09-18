# JSP-000513 完整形式化进度

2026-09-17：用户将目标从 Phase 0 扩展为完整主定理。任务持续进行；历史 Phase 0 文档只记录先前里程碑，不再限制后续范围。

## 最终目标

存在有限简单图，任意四元颜色列表都有普通合法染色，但存在八元颜色列表没有二重合法染色。保持 DHS19 Theorem 2 与 JSP-000513 的语义，禁止 sorry/admit/新未经证明公理以及弱化命题。

## 阶段计划

0. 保存已有环境、语义草案、C5 障碍的可复现基线。
1. 任意颜色类型的普通列表染色接口；完成 Lemma 3 正面半句。
2. Corollary 4 的 G1 构造与正负性质。
3. relaxed gadget 定义及 Lemma 5–7。
4. Lemma 8 的 G5 正负性质。
5. 最终有限图及四元列表可染、八元二重列表不可染证明。
6. 调色板重命名桥梁、最终 statement fidelity 和全部公理审计。

每阶段构建、公理审计、本地提交后继续。用户随后授权将已验证成果推送到当前私有仓库；实际可见性必须先核实为 Private，不公开成果或提交奖项。

## 阶段 0

此前 C5 负面 PoC 已通过；继续前重新构建并保存审计输出。远程初始提交为 c879d83654a8fdef4be8646b491da967f4fbacbb。当前 Git 无作者身份配置，本地提交使用明确的代理身份 `Codex <codex@localhost>`，不冒用用户身份、不配置远程凭据。

阶段0结果：lake build 退出0；六个已证引理的公理只有 propext、Classical.choice、Quot.sound（或其子集）。原始输出 docs/validation/stage0-build.log。基线保存后立即进入阶段1。

## 中断前保存与远程备份规则

用户要求额度耗尽或被迫中断前保存全部源码、更新本文件、执行可行构建、本地提交，并 push 已验证进度至私有仓库。当前已验证提交：`34c3ddca97772b26a30172d5461b1c9a1dff6cc8`（基线）、`4cc7fbc9ed9ac72dcc9b3faebab602f40e76e530`（Lemma 3 正面与普通染色桥梁）。

最新 GitHub 连接器复查仍返回 `visibility=public`，因此未推送；已请用户先将仓库改为 Private。该前置条件只阻止远程备份，不阻止本地形式化。后续执行者必须重新核实可见性后再 push，并记录实际远端提交及分支。

## 阶段 1 — 已完成

新增任意颜色类型上的普通列表染色接口及其与一重集合染色的双向等价。完成 DHS19 Lemma 3 正面半句：任意各有两色的列表、指定非邻接两顶点列表交至多一色时，五边形可染。证明直接构造贪心选色并使用图反射，不将任意列表限制成固定调色板。

验证：lake build 退出0（804 jobs）；新桥梁与 half_list_colorable 的公理均仅 propext、Classical.choice、Quot.sound。日志 docs/validation/stage1-build.log。普通导入路径与隐式集合参数的编译错误已修复，无数学假设更改。下一阶段自动开始 G1 / Corollary 4。

## 阶段 2 — 已完成

按论文实现七顶点 G1（五边形加 v1-x-y-v3 路径）及精确列表。已证明任意 half-list、L(v1)=L(v3) 时的普通列表可染性，以及固定列表不存在二重染色；负面证明从 y、x 的强制选色归约到已证 C5 障碍。新增一般有限集选择引理，未限制任意列表的调色板。

验证：lake build 退出0（806 jobs）；G1 两项定理公理仅 propext、Classical.choice、Quot.sound。日志 docs/validation/stage2-build.log。下一步进入 Lemma 5 / G2 及 relaxed 接口。

远程备份更新：用户已确认改为 Private 并重授权。连接器仍返回404；本地 Git 的非交互检查确认无可用凭据，已启动 Git Credential Manager 设备登录（尚未返回授权码/完成状态）。阶段提交均已本地保存，尚无成功 push 记录，不得误报远程备份完成。

远程备份已恢复：本地 Git Credential Manager 登录成功；通过 GitHub API 使用本地 Git 凭据核实 private=true、visibility=private、push_permission=true。首次 push 已成功，远端分支 phase0-local 包含截至 56cbb5d95632afcec8fb290de76b0aa5757fba4c 的全部已验证提交。后续仍只推送已验证阶段，不公开仓库或提交奖项。连接器404不再阻碍本地 Git 备份。

## 阶段 3a — 已完成（Lemma 5 前置）

新增五边形通用定理：所有列表至少两色时，或者可染，或者所有列表恰是同一二元集；非一致三元列表同时删除任一颜色后仍可染；公共三元列表可扩展两个非邻接顶点的任意预着色；四颜色调色板不可能给五边形每点分配两色。全部对任意颜色类型证明，未调用未形式化的分数色数结论。

lake build 退出0（807 jobs），四个主要新定理公理仅标准三项；原始审计 docs/validation/stage3a-build.log。继续 G2 构造与 relaxed 性质。

## 阶段 3b — 已完成（DHS19 Lemma 5 / G2）

九顶点 G2、列表与半列表大小全部定义并核查。证明任意颜色类型上的 StrongRelaxed 两种扩展分支，保留“先选一侧边界，再对另一侧全部选色”的量词；该接口比论文要求更强（不额外假设待扩展边界赋值已合法），实际独立边界满足它。负面结论证明每个二重列表染色的 y4 必须含7或8，采用一般五边形四调色板障碍而非未经证明的分数色数公式。

lake build 退出0（809 jobs）；新主要定理公理均仅标准三项。日志 docs/validation/stage3b-build.log。图的有限情形简化需要提高 combine_coloring 的局部 heartbeat 预算，逻辑假设不变。继续 Lemma 6 的两个七顶点附件。

## 阶段 4 — 已完成（DHS19 Lemma 6 / G3）

新增通用 attach / copies 图连接及染色组合、限制接口；七顶点附件的两种正面扩展与负面强制选色均已证明。G3 使用 Fin 9 ⊕ (Fin 2 × Fin 7) 编码23顶点，边严格由 G2、两个附件及 y4 到每附件前两点组成。任意半列表的 StrongRelaxed 性质已证明；任意固定列表二重染色至少一个末端等于{7,8}已证明。

lake build 退出0（813 jobs）；五项附件/G3审计只有 propext、Classical.choice、Quot.sound，无 sorryAx 或新增公理。日志 docs/validation/stage4-build.log。源文件：GraphAssembly.lean、ColorForcing.lean、SevenAttachment.lean、G3.lean，以及新增 FinsetTools 引理。仅一个无害的 unusedSectionVars 警告（exists_mem_of_card_lt 的 DecidableEq）。

## 使用额度前检查点

五小时额度最新检查已使用95%，剩余约5%；在开始下一大阶段前保存源码、成功构建日志、本地提交并推送私有仓库。完整主定理仍未完成，目标保持活动，不把此检查点当作最终成果。

## 下一步精确接续点：DHS19 Lemma 7 / G4

已读原论文 https://arxiv.org/html/1806.03880v2 （HTML编号存在偏移，以PDF Lemma 7为准）。G4为G3附加三个三角形：主 w1-w2-w3；两个子三角形 wi1-wi2-wi3。旧两个末端都邻接w1；w3邻接两个wi1。半列表三角形大小均为3,2,3，固定列表均为{1,2,3,4,7,8},{1,2,3,4},{1,2,3,4,7,8}。

建议仍用 attach / copies 与 sum 类型，避免32顶点全边枚举。正面第一分支先在旧两个末端各选颜色r1,r2，使 L(w1) 连续删除它们后至少两色且不等于 L(w2)。可用 exists_erase_ne：先选r1避免坏删除；若r1在L(w1)，从另一三元末端列表选r2不属于剩余二元集；若r1不在L(w1)，直接选r2避免坏删除。再从 L(w3) 的三色中选q，同时避免两个子三角形的坏删除，各约束至多排除一色。以 triangle_pair_extension 扩展三角形的预着色。第二分支固定旧末端后按论文贪心扩展，得到新的两个末端固定颜色。负面用 special_triangle_forcing 沿三个三角形依次传播{7,8}。

后续 Lemma 8/G5：G4与G1只共享v1,v3，增加两个末端到v2,v4和x,y的四条边；G1相关四个列表增加{7,8}。最终Theorem2按K4所有二重着色索引G5副本并补齐八元列表。最终还须完成有限颜色重命名桥梁与主statement语义审计。

本地Git登录已完成，GitHub API已确认private=true及push权限。可直接 git push origin phase0-local。不要依赖当前404的GitHub连接器。不要打印凭据。所有已验证阶段均需保留并持续推送。未进行任何发布或官方提交。

## 阶段 5 — 已完成（DHS19 Lemma 7 / G4）

额度恢复后从 6b4bf036a5490a62328632cfeb58c449843b2022 继续。新增 TriangleTools 的两个选色引理和坏删除至多一个的基数证明；NineAttachment 用三个三角形实现任意新边界预着色的扩展与固定旧边界的贪心扩展。G4 为 G3 与九顶点附件的连接，已证明 StrongRelaxed 和两个末端均强制为{7,8}，未使用额外数学假设。

lake build 退出0（816 jobs）。新增六项公理审计仅 propext、Classical.choice、Quot.sound，见 docs/validation/stage5-build.log。源码 TriangleTools.lean、NineAttachment.lean、G4.lean。继续 Lemma 8 的 G5：共享 G1 的0、2与G4的 first、third，其余五点另建；先组合半列表正面证明，再把负面染色限制到 G1。远程备份沿用已验证为 Private 的 origin/phase0-local；未消耗重置券。

## 阶段 6 — 已完成（DHS19 Lemma 8 / G5）

G5 以 G4.Vertex ⊕ Fin 5 编码37顶点，G1 的 v1,v3 分别共享 G4 的 first,third。另五点为 v2,v4,v5,x,y；额外四边及四个增添{7,8}的列表已显式实现。embed_adj 核查 G1 原边全部保留，combine_coloring 组合一致的两部分染色。

已证明任意半列表可染：G4 第一分支配合 G1 增大半列表上的预着色扩展；第二分支先删除两个末端的固定色，再选精确大小子列表应用 G1 正面定理。负面用 G4 两末端强制{7,8}，删去增添色并限制到 G1，得到矛盾。

lake build 退出0（817 jobs），两项主定理审计只有标准三公理，日志 docs/validation/stage6-build.log。继续最终 Theorem 2：K4 的所有合法二重着色索引 G5 副本，按 halfSizes 补邻居及补颜色；需证明半列表大小在2至4之间、固定颜色均在1至8、统一后的八元列表不可二重染色及任意四元列表可染。完整主定理尚在实现中。

## 阶段 7 — 完整主定理已通过 Lean（后续语义审计继续）

新增 FinalConstruction.lean：以{9,…,16}上的 K4 合法二重列表着色为有限索引，每个索引连接一个 G5 副本。halfSizes=2,3,4 时分别连接 K4 前2、1、0点，补入对应选色，证明全部固定列表恰八色。任意四元列表先贪心染 K4，删除邻居颜色后每副本仍可选出完整半列表，由 G5 染色；负面取由 K4 实际着色索引的副本，排除补入色后与 G5 矛盾。

MainTheorem.lean 通过顶点等价重编号得到 Fin n 图，已证明 JSP000513.theorem2 : Theorem2NatTarget 以及 theorem2_all_palettes : Theorem2AllPalettesTarget。不存在主命题弱化；正面直接对任意 universe 的颜色类型成立。lake build 退出0（826 jobs），两个完整主定理均仅依赖 propext、Classical.choice、Quot.sound，日志 docs/validation/stage7-build.log。

接下来完成单独的 FinitePaletteEquivalenceTarget 桥梁、更新已过时的 Phase 0 文档提示、最终逐项语义检查及全仓库审计，再保存推送最终验证状态。此阶段的完整主定理成果先提交并私有备份。

## 阶段 8 — 完整形式化与最终语义审计完成

完成时间 2026-09-18（北京时间）。新增 PaletteEquivalence.lean，证明单射颜色重命名、可选性沿调色板嵌入传回，以及有限图上自然数颜色与任意颜色类型的等价。FinitePaletteEquivalenceTarget 已由 finitePaletteEquivalence 完整证明；Theorem2NatTarget / Theorem2AllPalettesTarget 沿用原定义并已分别由 theorem2 / theorem2_all_palettes 证明。

最终 lake build 退出0（827 jobs）；三个最终定理公理依赖均只有 propext、Classical.choice、Quot.sound。原始输出 docs/validation/final-build.log。项目 Lean 源码无 sorry、admit、sorryAx、axiom、unsafe、native_decide 匹配；三个多余 DecidableEq 参数警告无碍证明。README、theorem_mapping、proof_dependency 已更新为完整结果；最终复现与语义检查见 docs/FINAL_VERIFICATION.md。

远程情况：G4 3d038a3cb659f48ee2106bbd3df8e4c1445b42af、G5 b352060da80a8ca5058d9ea59b9f66c28d8bc895 已推送；主定理b66f1eda7a2de086993981e26abe112b9b8fb03f第一次push遭遇网络连接重置，源码和提交未丢失。最终保存后重试推送全部提交并核对远端。当前数学与Lean证明目标已达到，完成状态只待最终提交和私有远程备份确认；不执行公开或奖项提交。


## 最终远程确认 — 已完成

2026-09-18：GitHub API 再次确认 yqian215-arch/jsp-000513-lean 为 private=true、visibility=private。完整证明及最终审计提交 bb09c6ceed0202204e2a1927d7bde5ff91a9f2b8 的本地 HEAD 与远端 refs/heads/phase0-local 完全一致，工作区干净。主定理b66f1eda7a2de086993981e26abe112b9b8fb03f也已包含在远端历史中；此前连接重置已恢复。此后的记录提交仅保存本段备份确认。完整形式化、构建、公理审计、本地提交及私有备份要求均已完成。无待证明的主命题依赖，未公开或提交官方奖项。

## 用户要求的全量检查与再次备份 — 2026-09-18

检查起点 d0b31ec6f72bb5c9e5e6f534b27d0845275a25a2：51个已跟踪文件，初始 Git status 干净，无未跟踪待纳入文件。Lean 源码、README、theorem_mapping、proof_dependency、构建与公理日志、PROGRESS 以及工具链和依赖锁定文件已全部跟踪。.lake/ 与 work/ 被忽略，跟踪文件中没有编译产物、私钥文件或凭据目录。对全部跟踪文本扫描常见 GitHub/API token、私钥头、URL内凭据及密码/密钥赋值模式，没有发现匹配；这是内容模式检查，不作超出检查范围的保证。

再次 lake build 退出0（827 jobs），日志 docs/validation/recheck-build.log。三个最终定理 theorem2、theorem2_all_palettes、finitePaletteEquivalence 公理仍仅标准三项。当前源文件、构建配置、锁定依赖及脚本的 SHA256 清单为 docs/validation/current-source-sha256.txt；原 source-sha256.txt 保留为早期检查历史。

GitHub API 在本次提交前再次确认 private=true、visibility=private，备份目标仍为 origin/phase0-local。新增检查日志、校验清单和本段记录一并提交推送。当前完整主定理已经证明，无缺失的主形式化步骤；后续不把已完成结果重新描述为只有 Phase 0 或 PoC。

## Submission-hardening code stage (2026-09-18)
Independent branch submission-hardening from proof 83644d1838aadee8fc7acd9150c610aff5402ba7. Wrapper and three unused-instance warnings addressed; lake build 828 jobs exit 0, wrapper-only check exit 0, standard axioms only. See SUBMISSION_HARDENING_REPORT.md and submission-evidence for ongoing stage status.

## Submission-hardening regression complete (2026-09-18)
Build and standalone wrapper pass; complete axiom closure, unchanged clean-room graph/list harness, and fresh kernel replay all exit 0. Production scan: 26 files, zero hits. All 21 existing module proof bodies preserved modulo comment/unused-instance cleanup. English README, attribution, licensing recommendation and official checklist prepared. At that historical stage no LICENSE had yet been added. Apache-2.0 has since been adopted; no visibility change, PR, issue or award claim was performed by this workflow. Detailed results and human release gates: SUBMISSION_HARDENING_REPORT.md.

## Publication-document cleanup — 2026-09-18
Synchronized full and abbreviated project commit references using the verified email-rewrite mapping; no old SHA mapping is published. Updated README, license decision, checklist, environment status, and hardening report for adopted Apache-2.0 and Private visibility. Added PUBLICATION_CANDIDATE.md to identify the frozen final candidate. No Lean source, lockfile, or toolchain/build configuration changes. lake build and the existing axiom audit both exit 0; only the standard three axioms remain. Current tracked text and reachable history privacy scans and remote-ref checks are recorded in the external publication-cleanup evidence. The final 40-character SHA is recorded externally after the single documentation commit/push; no further candidate changes are planned absent an issue.

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

此前 C5 负面 PoC 已通过；继续前重新构建并保存审计输出。远程初始提交为 535de844126b4b977e6615c6eb32d80a0b226302。当前 Git 无作者身份配置，本地提交使用明确的代理身份 `Codex <codex@localhost>`，不冒用用户身份、不配置远程凭据。

阶段0结果：lake build 退出0；六个已证引理的公理只有 propext、Classical.choice、Quot.sound（或其子集）。原始输出 docs/validation/stage0-build.log。基线保存后立即进入阶段1。

## 中断前保存与远程备份规则

用户要求额度耗尽或被迫中断前保存全部源码、更新本文件、执行可行构建、本地提交，并 push 已验证进度至私有仓库。当前已验证提交：`d77e9d8`（基线）、`e02a7c9`（Lemma 3 正面与普通染色桥梁）。

最新 GitHub 连接器复查仍返回 `visibility=public`，因此未推送；已请用户先将仓库改为 Private。该前置条件只阻止远程备份，不阻止本地形式化。后续执行者必须重新核实可见性后再 push，并记录实际远端提交及分支。

## 阶段 1 — 已完成

新增任意颜色类型上的普通列表染色接口及其与一重集合染色的双向等价。完成 DHS19 Lemma 3 正面半句：任意各有两色的列表、指定非邻接两顶点列表交至多一色时，五边形可染。证明直接构造贪心选色并使用图反射，不将任意列表限制成固定调色板。

验证：lake build 退出0（804 jobs）；新桥梁与 half_list_colorable 的公理均仅 propext、Classical.choice、Quot.sound。日志 docs/validation/stage1-build.log。普通导入路径与隐式集合参数的编译错误已修复，无数学假设更改。下一阶段自动开始 G1 / Corollary 4。

## 阶段 2 — 已完成

按论文实现七顶点 G1（五边形加 v1-x-y-v3 路径）及精确列表。已证明任意 half-list、L(v1)=L(v3) 时的普通列表可染性，以及固定列表不存在二重染色；负面证明从 y、x 的强制选色归约到已证 C5 障碍。新增一般有限集选择引理，未限制任意列表的调色板。

验证：lake build 退出0（806 jobs）；G1 两项定理公理仅 propext、Classical.choice、Quot.sound。日志 docs/validation/stage2-build.log。下一步进入 Lemma 5 / G2 及 relaxed 接口。

远程备份更新：用户已确认改为 Private 并重授权。连接器仍返回404；本地 Git 的非交互检查确认无可用凭据，已启动 Git Credential Manager 设备登录（尚未返回授权码/完成状态）。阶段提交均已本地保存，尚无成功 push 记录，不得误报远程备份完成。

远程备份已恢复：本地 Git Credential Manager 登录成功；通过 GitHub API 使用本地 Git 凭据核实 private=true、visibility=private、push_permission=true。首次 push 已成功，远端分支 phase0-local 包含截至 8f58279 的全部已验证提交。后续仍只推送已验证阶段，不公开仓库或提交奖项。连接器404不再阻碍本地 Git 备份。

## 阶段 3a — 已完成（Lemma 5 前置）

新增五边形通用定理：所有列表至少两色时，或者可染，或者所有列表恰是同一二元集；非一致三元列表同时删除任一颜色后仍可染；公共三元列表可扩展两个非邻接顶点的任意预着色；四颜色调色板不可能给五边形每点分配两色。全部对任意颜色类型证明，未调用未形式化的分数色数结论。

lake build 退出0（807 jobs），四个主要新定理公理仅标准三项；原始审计 docs/validation/stage3a-build.log。继续 G2 构造与 relaxed 性质。

# JSP-000513 来源核查

核查日期：2026-09-17。此文件记录 Phase 0 的来源和解释，不宣称已完成题目形式化或奖项审核。

## 官方题号与状态

[官方题库 JSP-000513](https://github.com/TheJustinSunPrize/awards/blob/f4e7173d89dfe91022a185427d63452c8ffbf6ae/problems/catalog-0501-0600.md)询问：列表长度和每个顶点所需颜色数同时翻倍后，列表多重可染性是否保持。核查时标记为 Solved、Lean proof: No、Eligible to claim: No；引用 ERT80 和 DHS19。官方目录提交固定为 `f4e7173d89dfe91022a185427d63452c8ffbf6ae`，通过 GitHub commits API 查得。

答案是否定的。项目应形式化反例的存在性，不能把原问题误当作需要证明的保持性定理。

## 论文与定义

- DHS19：Zdeněk Dvořák、Xiaolan Hu、Jean-Sébastien Sereni，*A 4-choosable graph that is not (8:2)-choosable*，Advances in Combinatorics 2019:5，9 页。[期刊与 DOI](https://doi.org/10.19086/aic.10811)。
- 固定论文版本：[arXiv:1806.03880v2](https://arxiv.org/abs/1806.03880v2)，2019-10-25；[PDF](https://arxiv.org/pdf/1806.03880v2)。期刊发布日期为 2019-10-30。
- **Theorem 2，论文第 2 页**：存在图 G，G 为 4-choosable，而非 (8:2)-choosable。论文给出有限构造。
- 定义核查：[期刊说明](https://www.advancesincombinatorics.com/article/10811-a-4-choosable-graph-that-is-not-8-2-choosable)。`(a:b)` 的含义是任意每顶点恰有 a 个颜色的列表，都能各选 b 个颜色，且相邻顶点选出的集合不交。普通 a-choosable 对应 b=1。不能把一个特定列表可染替换成任意列表可染，也不能把普通多重染色替换成列表多重染色。
- ERT80：Paul Erdős、Arthur L. Rubin、Herbert Taylor，*Choosability in graphs*，Congressus Numerantium XXVI，125–157，1980。[原始扫描件](https://www.renyi.hu/~p_erdos/1980-07.pdf)。已读取其有限顶点及 f-choosability 定义；原始一般倍增问题由 DHS19 明确追溯。扫描件后续页面抓取超时，因此本阶段不为 ERT80 的倍增问题虚填页码或编号。

## PoC 对应的精确局部命题

DHS19 **Lemma 3 的不可二重染色部分，第 3 页**：取五边形 `v1-v2-v3-v4-v5-v1`，列表为：

| 顶点 | L0 |
|---|---|
| v1 | {1,2,5,6} |
| v2 | {1,4,5,6} |
| v3 | {3,4,5,6} |
| v4 | {3,4,5,6} |
| v5 | {2,4,5,6} |

不存在从各列表选两个颜色且相邻选择不交的赋值。它是原论文依赖链中的局部障碍，不是 Theorem 2，也不包含 Lemma 3 关于任意 half-list 的正面半句。PoC 代码和最终编译状态另见项目构建记录。

## 审核边界

[官方 verification 规则](https://github.com/TheJustinSunPrize/awards/blob/f4e7173d89dfe91022a185427d63452c8ffbf6ae/docs/verification.md)明确区分 statement、实际证明、问题与 statement 的对应、固定源码、复现及审核结论；仅成功编译不能代替完整验证记录。[record guide](https://github.com/TheJustinSunPrize/awards/blob/f4e7173d89dfe91022a185427d63452c8ffbf6ae/docs/records.md)要求相关证据包含 toolchain/library、axiom audit、statement comparison 等。当前工作只完成 Phase 0；不据此推断奖金等级、金额或领取资格，不执行公开发布或官方提交。

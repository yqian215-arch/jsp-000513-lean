# Mathlib 基础设施调查（Phase 0）

调查日期：2026-09-17。全部读取发生在本台家用 Windows 电脑。

- 工作目录：`D:\Lean\jsp-000513-lean`。
- Mathlib 源目录：`.lake/packages/mathlib/Mathlib/`。
- 固定版本：`v4.34.0`，实际 `git rev-parse HEAD` 为 `5ed2965256430c3649e86755f9576b54eca72435`。
- 本文记录源代码检查和候选实现方案；不代表下面建议的证明已经通过 Lean 编译。实际 PoC 与构建结果由项目的 Lean 文件和构建记录说明。

## 搜索范围与结果

对固定 checkout 的整个 `Mathlib/` 目录进行了大小写不敏感的文本搜索。该目录包含 **8,529 个 `.lean` 文件**，并重点阅读 `Combinatorics/SimpleGraph/`、`Data/Finset/` 与有限求和文件。

执行过的搜索表达式：

```text
rg -n -i 'list.?colo|multi.?colo|choosab|fractional.?colo|b.?fold.?colo' Mathlib
rg -n -i 'listcolor|list_color|list color|list colour|multicolor|multi_color|multi.?colour|choosab|choice.?number|fractional chromatic|fractional coloring|fold.?color' Mathlib
```

两次搜索均没有匹配，`rg` 返回码均为 `1`（未找到匹配）。由此判断：在本次范围和这些词项下，没有找到直接可复用的 list coloring、multicoloring、`(a:b)`-choosability 或 fractional coloring API。文本搜索不能证明任何不同命名的语义等价工具绝不存在。

额外搜索 `cycleGraph.*(indep|Indep)|indep.*cycleGraph|IsIndepSet.*cycleGraph` 同样没有匹配。因此，本次未找到现成的 C5 独立集至多含两个顶点定理。

## 已确认可用的 API

下表的文件均相对于 `.lake/packages/mathlib/`，行号对应上述固定 commit，可用来重新核对。

| 用途 | 文件与行号 | 已确认符号及含义 |
| --- | --- | --- |
| 有限简单图的底层结构 | `Mathlib/Combinatorics/SimpleGraph/Basic.lean:95` | `SimpleGraph V`；邻接关系 `Adj`，对称性 `symm`，无自环 `loopless` |
| 邻接顶点不同 | `Mathlib/Combinatorics/SimpleGraph/Basic.lean:179` | `SimpleGraph.ne_of_adj` |
| 普通顶点着色 | `Mathlib/Combinatorics/SimpleGraph/Coloring/Vertex.lean:74` | `SimpleGraph.Coloring`，定义为到完全图的图同态 |
| 普通着色合法性及构造 | 同上，79、93 行 | `Coloring.valid`、`Coloring.mk`；邻接顶点的颜色不同 |
| 普通色数 | 同上，163、275 行 | `Colorable n`、`Colorable.mono`；不能直接替代列表可选性 |
| 颜色类为独立集 | 同上，123 行 | `Coloring.isIndepSet_colorClass` |
| 圈图 | `Mathlib/Combinatorics/SimpleGraph/CycleGraph.lean:29` | `SimpleGraph.cycleGraph n : SimpleGraph (Fin n)`，自带可判定邻接关系 |
| 圈图的具体邻接 | 同上，57、60 行 | `cycleGraph_adj`、`cycleGraph_adj'`；Fin 上的模减法描述相邻关系 |
| 独立集 | `Mathlib/Combinatorics/SimpleGraph/Clique.lean:907` | `SimpleGraph.IsIndepSet`；926 行提供有限集上的可判定实例 |
| 独立数 | 同上，1048、1056 行 | `indepNum`、`IsIndepSet.card_le_indepNum`；C5 的具体上界仍需证明 |
| 诱导子图 | `Mathlib/Combinatorics/SimpleGraph/Maps.lean:227` | `SimpleGraph.induce`、231 行的 `induce_adj` |
| 有限集合选取指定数量元素 | `Mathlib/Data/Finset/Card.lean:678` | `Finset.exists_subset_card_eq : n ≤ s.card → ∃ t ⊆ s, t.card = n` |
| 扩张/缩小到指定基数 | 同上，669 行 | `Finset.exists_subsuperset_card_eq` |
| 并集基数上界 | 同上，590 行 | `Finset.card_union_le` |
| 差集基数 | 同上，598、603、614 行 | `Finset.card_sdiff_of_subset`、`card_sdiff`、`le_card_sdiff` |
| 不交集合的并集基数 | 同上，595 行 | `Finset.card_union_of_disjoint` |
| 集合不交的逐元素刻画 | `Mathlib/Data/Finset/Disjoint.lean:47` | `Finset.disjoint_left` |
| 有限求和的基数表示 | `Mathlib/Algebra/BigOperators/Group/Finset/Basic.lean:966` | `Finset.card_eq_sum_ones` |
| 按纤维统计基数 | 同上，972、993、997 行 | `sum_card_fiberwise_eq_card_filter`、`card_eq_sum_card_fiberwise`、`card_eq_sum_card_image` |
| 不交并集的基数 / 一般并集上界 | 同上，981、984 行 | `Finset.card_biUnion`、`card_biUnion_le` |
| 依赖对的基数 | `Mathlib/Algebra/BigOperators/Group/Finset/Sigma.lean:134` | `Finset.card_sigma`，适合统计顶点–颜色 incidence |

导入时优先使用 `Mathlib.Combinatorics.SimpleGraph.Coloring.Vertex`。旧模块 `Mathlib.Combinatorics.SimpleGraph.Coloring` 和 `Mathlib.Combinatorics.SimpleGraph.Coloring.VertexColoring` 都只是带弃用标记的转发模块。

其他已检查但不作为当前 PoC 前置依赖的工具：`Bipartite.lean:290` 的 `IsBipartite` 是普通二着色性质；`Hall.lean:60` 的 `exists_isMatching_of_forall_ncard_le` 和 116 行的 `exists_isPerfectMatching_of_forall_ncard_le` 处理二部图匹配。不能因为这些 API 存在，就推断已经具备列表多重着色定理。

## 项目应补充的最小定义

对顶点类型 `V`、颜色类型 `Color`、图 `G : SimpleGraph V`：

1. 列表赋值：`L : V → Finset Color`。
2. 选色函数：`φ : V → Finset Color`。
3. `(L,b)`-合法性：对每个 `v`，`φ v ⊆ L v` 且 `(φ v).card = b`；对每条边 `G.Adj u v`，`Disjoint (φ u) (φ v)`。
4. `(a:b)`-choosability：对每个各顶点列表恰有 `a` 种颜色的赋值，都存在上述合法选色。
5. `a`-choosability 采用 `b = 1`；与 Mathlib 的单颜色函数式普通着色之间需要明确的桥接引理。

不能把 `G.Coloring (Finset Color)` 直接当作多重着色：它只保证邻接顶点的有限集合不相等，不保证不相交。例如 `{1,2}` 与 `{2,3}` 不相等，却违反多重着色条件。

题意中的“列表恰有 a 个元素”与“列表至少有 a 个元素”应先保留原论文用法。后者到前者可用 `exists_subset_card_eq` 逐顶点缩小，但这是需要补证的等价转换。同样，如果 theorem statement 为避免 universe 问题先限定颜色为 `ℕ`，应另证有限图的任意颜色类型列表可以重命名到有限自然数颜色；不能默默省去该语义桥接。

## 代表性 PoC 建议：论文 Lemma 3 的 C5 障碍

原论文来源：[Dvořák–Hu–Sereni, arXiv:1806.03880v2](https://arxiv.org/pdf/1806.03880v2)，第 3 页 Lemma 3。官方题意与论文的完整对应由另一个 Phase 0 来源核对文档负责。

使用 `G = SimpleGraph.cycleGraph 5`，顶点依次为 `0,1,2,3,4`，列表为：

| 顶点 | 列表 |
| --- | --- |
| 0 | `{1,2,5,6}` |
| 1 | `{1,4,5,6}` |
| 2 | `{3,4,5,6}` |
| 3 | `{3,4,5,6}` |
| 4 | `{2,4,5,6}` |

目标是证明不存在每顶点从其列表中选两个、且相邻选色集合不交的函数。这是完整构造中的有限局部障碍，不是整个 JSP-000513 定理。

建议优先证明可复用的计数核心：每种颜色出现的顶点集必须独立；颜色 1、2、3 各至多被一个顶点使用，颜色 4、5、6 各至多被两个顶点使用。因此总使用次数至多为 `1+1+1+2+2+2 = 9`，但五个顶点各需两种颜色，产生 `5×2 = 10` 次使用，矛盾。`IsIndepSet`、`Finset.card_sigma` 和按纤维计数工具可支持这个证明。

最小有限验证也可以每个四元列表枚举六个二元子集，只考察 `6^5 = 7776` 个候选赋值。须显式证明枚举涵盖所有合法二元子集，并把检查结果连接到抽象合法性定义；仅返回某个检查函数为 false 不够。直接量化所有 `Fin 6` 有限子集函数会产生 `64^5` 个候选，宜避免。

为满足项目“无 sorry、admit、新公理”的要求，优先用普通证明项、`decide` 或可检查的算术证明；若选择其他加速策略，应审查最后 theorem 的公理依赖，并在构建记录中如实说明。本文未运行 `lake build`，也未改写 PoC Lean 文件。

## 风险与后续依赖

- 已有普通着色 API 可帮助接入 SimpleGraph；列表赋值和多重着色仍是项目新增基础设施。
- C5 的有限障碍证明容易与完整定理混淆。其列表大小为 4、每点选 2；完整目标是构造 4-choosable 而非 `(8:2)`-choosable 的图，两者之间尚需论文 gadget 的完整连接论证。
- 下一阶段应把“重命名颜色”“限制/扩张列表”“选色类为独立集”“顶点–颜色双重计数”各自提成独立引理，再逐条接上原论文的 gadget 与粘合步骤。
- 固定 commit 下的声明路径和弃用信息可复现；将来升级 Mathlib 后应重新核对 API 和 import。

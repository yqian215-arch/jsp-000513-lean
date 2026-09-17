# 论文命题与 Lean 声明映射

核对日期：2026-09-17。依据为 [Dvořák–Hu–Sereni, arXiv:1806.03880v2](https://arxiv.org/pdf/1806.03880v2)，定义和 Theorem 2 在论文第 2 页，Lemma 3 与 Figure 1 在第 3 页。来源背景见 [source_verification.md](source_verification.md)。

## 定义和量词

`JSP000513/Definitions.lean` 中的声明均位于 `JSP000513` 命名空间。

| Lean 声明 | 论文含义与精确条件 |
| --- | --- |
| `IsListMulticoloring G L b φ` | 对所有顶点 `x`，`φ x ⊆ L x` 且 `card (φ x) = b`；对所有顶点 `x,y`，若 `G.Adj x y` 则选色集合不交 |
| `ListMulticolorable G L b` | 存在一个满足上述条件的选色函数 `φ`；对应 `(L:b)`-colorable |
| `ABChoosableOn G Color a b` | 对每个 `L : V → Finset Color`，若每个列表恰有 `a` 个颜色，则存在 `(L:b)`-coloring |
| `ABChoosable G a b` | 上一定义在 `Color = ℕ` 时的工作约定 |

量词顺序是 **对所有列表，存在选色函数**；函数可依赖于列表。不是对一个固定列表，也不是要求所有列表共用一个选色函数。`Color` 可为无限类型，无 `Fintype Color` 前提。列表与选色以 `Finset` 表示，元素不重复，基数均为恰好而非至少。邻接约束是集合不交，不是仅仅集合不相等。

基础定义对任意自然数 `a,b` 有意义；论文使用正整数且 `b ≤ a`。本项目使用的参数为 `(4,1)`、`(8,2)`、`(4,2)`，均满足这些条件。没有就其他参数宣称论文结论。`b = 1` 表达普通列表染色；与 Mathlib 单颜色函数式 `SimpleGraph.Coloring` 的转换尚未实现。

## 最终目标：只有命题草案

`JSP000513/StatementDrafts.lean` 中三个声明都是 `def ... : Prop`，没有相应证明，也未被当作公理或 PoC 的假设。

```lean
def Theorem2NatTarget : Prop :=
  ∃ n : ℕ, ∃ G : SimpleGraph (Fin n),
    ABChoosable G 4 1 ∧ ¬ ABChoosable G 8 2
```

这是有限图、自然数调色板版本的 Theorem 2 草案。`Fin n` 显式确保图有限；`n` 没有固定为 5，PoC 的五边形不是最终构造。

`Theorem2AllPalettesTarget` 把正面性质写为 `∀ Color : Type, ABChoosableOn G Color 4 1`，负面性质写为 `¬ (∀ Color : Type, ABChoosableOn G Color 8 2)`。负面性质只要求某个调色板上的失败，不能误写成每个调色板均失败。这里 `Type` 是 universe 0，未写成对所有 universe 的单个量词。

`FinitePaletteEquivalenceTarget` 单独命名尚缺的桥梁：对有限图，自然数调色板上的可选性与上述任意 `Type` 调色板版本等价。预期方法是把一个列表赋值使用的有限颜色并集重命名为自然数，再传回选色；本阶段未证明此转换，不能把两个最终目标草案当成已证等价。这一缺口不影响本次以自然数标签精确表述的固定列表障碍。

## 已证明的 PoC：Lemma 3 的负面半句

`JSP000513/C5Obstruction.lean` 中所有声明位于 `JSP000513.C5` 命名空间。

| 论文顶点 | Lean `Fin 5` 顶点 | `lists` |
| --- | --- | --- |
| v1 | 0 | `{1,2,5,6}` |
| v2 | 1 | `{1,4,5,6}` |
| v3 | 2 | `{3,4,5,6}` |
| v4 | 3 | `{3,4,5,6}` |
| v5 | 4 | `{2,4,5,6}` |

`graph` 以 `SimpleGraph (Fin 5)` 直接列出边 `01,12,23,34,40` 的两个方向，无其他边；对称性与无自环均由内核检查。它未使用 Mathlib 的 `cycleGraph` 定义，当前无需一个两者相等的定理来说明这份显式五边形的语义。

| Lean 定理 | 已证明内容 |
| --- | --- |
| `lists_card` | 五个列表的基数均为 4 |
| `mem_pairChoices_iff` | 对任意 `s : Finset ℕ`，属于候选集当且仅当 `s ⊆ lists x` 且 `s.card = 2` |
| `pairChoices_card` | 每个顶点恰有 6 个候选二元子集 |
| `no_compatible_choices` | 从五个候选集中各选一个集合，不能同时满足五条边上的不交条件 |
| `not_listMulticolorable` | `¬ ListMulticolorable graph lists 2`，精确对应 Lemma 3 负面半句 |
| `not_ABChoosable_four_two` | `¬ ABChoosable graph 4 2`，由该固定四元列表障碍得到的直接推论 |

候选集是实际列表的 `powersetCard 2`。`mem_pairChoices_iff` 使用 Mathlib 的 `Finset.mem_powersetCard`，因此并非未经证明的手写枚举覆盖假设。任意合法选色函数的每个取值都由此进入候选集，再将图的五条边的不交条件送入有限否定定理，得出矛盾。有限检查在 Lean 中通过普通 `decide` 完成，候选空间为 `6^5 = 7776`。

论文用颜色出现次数至多 9、所需次数为 10 的计数证明；本 PoC 采用不同证明方法，但结论、列表、图与否定量词一致。没有外部枚举结果作为证明前提。

## 范围边界与剩余工作

未证明 Lemma 3 的正面半句（任意 half-list 且 `|L(v1) ∩ L(v3)| ≤ 1` 时可染），未实现 Corollary 4、Lemma 5–8、最终粘合构造或 Theorem 2。也未证明自然数调色板等价性、普通着色 API 桥梁、颜色重命名等基础引理。PoC 的直接推论为非 `(4:2)` 可选，不能误报为完整目标中的非 `(8:2)` 可选。

实际构建与公理审计见 [poc_verification.md](poc_verification.md)。

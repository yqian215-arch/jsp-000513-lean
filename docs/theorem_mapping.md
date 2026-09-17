# 最终命题与 Lean 声明映射

核对：2026-09-17；[DHS19 v2](https://arxiv.org/pdf/1806.03880v2) 的定义、Theorem 2 及 Lemma 3–8。HTML 中部分编号偏移，本文按 PDF 编号。

## 定义与量词

| 声明 | 精确含义 |
| --- | --- |
| `IsListMulticoloring G L b φ` | 每点 `φ x ⊆ L x`、恰选 b 色，每条边两端选色集合不交 |
| `ListMulticolorable G L b` | 存在上述合法选色函数 |
| `ABChoosableOn G Color a b` | 对全部恰 a 元列表赋值，存在合法 b 重列表染色 |
| `ABChoosable G a b` | Color=ℕ 的约定 |
| `listColorable_iff_multicolorable_one` | 函数式普通列表染色与 b=1 集合式染色等价 |
| `finitePaletteEquivalence` | 对有限图，自然数颜色版本等价于任意 Type 调色板版本；无限调色板也适用 |

列表使用 Finset，重复元素不增加基数。颜色集合不交不是仅集合不相等。每个列表赋值可有自己的染色，未交换全称／存在量词。

## 完整主定理

`JSP000513.theorem2 : Theorem2NatTarget` 展开为：

```lean
∃ n : ℕ, ∃ G : SimpleGraph (Fin n),
  ABChoosable G 4 1 ∧ ¬ ABChoosable G 8 2
```

目标定义沿用 Phase 0 草案，内容未弱化。MainTheorem.lean 中的 witness 是 `Final.finiteGraph`，它由 `Final.graph` 经顶点等价重编号；并非五边形 PoC。

`theorem2_all_palettes` 为同一图证明正面 `∀ Color : Type, ABChoosableOn G Color 4 1`，负面 `¬ (∀ Color : Type, ABChoosableOn G Color 8 2)`。负面不是所有颜色类型均失败；具体自然数八元列表足以见证失败。`Final.finiteGraph_four_choosable` 本身支持任意颜色 universe。

PaletteEquivalence.lean 先证明单射颜色重命名，再将给定列表的有限并集限制为子类型并编码进自然数，最后映回原调色板。它无“全调色板有限”的假设。

## 论文构造对应

| 论文节点 | 文件与主要证明 |
| --- | --- |
| Lemma 3，C5 | C5Obstruction/C5Positive：固定列表二重障碍及任意半列表正面性质 |
| Corollary 4，G1 | G1.half_list_colorable / not_listMulticolorable |
| Lemma 5，G2 | G2.half_list_relaxed / twofold_special_mem |
| Lemma 6，G3 | G3.half_list_relaxed / twofold_terminal_forced |
| Lemma 7，G4 | G4.half_list_relaxed / twofold_terminals_forced |
| Lemma 8，G5 | G5.half_list_colorable / not_listMulticolorable |
| Theorem 2 | FinalConstruction.four_list_colorable / not_listMulticolorable；MainTheorem.theorem2 |

G1 索引0…6对应 v1…v5,x,y。G2 索引0…4为五边形，5为全邻接中心，6…8为三角形。G3 连接两个七顶点附件；G4 再连接三个三角形。G5 共享 G1 与 G4 的 v1,v3，并只添加论文指定的四条末端边；`embed_adj` 验证 G1 原边。

最终索引 `Index` 是四点完全图在{9,…,16}上的全部合法二重选色。每个索引对应一个 G5 副本；halfSizes 为2、3、4时分别连接前2、1、0个完全图顶点。补入这些顶点的两色集合，`lists_card` 证明每个最终列表恰为八元。负面选取实际完全图染色对应的副本；正面删除邻居的普通颜色后每份仍有足够大的半列表。

`StrongRelaxed` 保留原文两支及量词顺序，要求所有符合列表的边界赋值可扩展，因而比只要求合法边界赋值更强。未把正面任意列表约束替换成固定调色板枚举。C5 的固定负面实例以内核 `decide` 替代论文双计数；一般 C5 四调色板障碍亦独立证明，未假设分数色数结论。

最终目标、公理和构建证据见 [FINAL_VERIFICATION.md](FINAL_VERIFICATION.md)。

# 已完成证明依赖树

所有节点已有 Lean 证明；对应 [DHS19 v2](https://arxiv.org/pdf/1806.03880v2)。

```text
theorem2 / theorem2_all_palettes (MainTheorem)
├─ 顶点等价重编号：choosable_comap_equiv
└─ K4 与有限索引副本 (FinalConstruction)
   └─ G5 / Lemma 8
      ├─ G1 / Corollary 4
      │  └─ C5 / Lemma 3 正负性质
      └─ G4 / Lemma 7
         ├─ NineAttachment / TriangleTools
         └─ G3 / Lemma 6
            ├─ SevenAttachment / ColorForcing
            └─ G2 / Lemma 5
               └─ C5General

finitePaletteEquivalence (PaletteEquivalence)
├─ 有限列表并集、子类型、自然数编码
├─ ABChoosableOn.of_embedding
└─ IsListMulticoloring.map_colors
```

共用接口：Definitions、ListColoring、Relaxed、GraphAssembly、FinsetTools。任意列表正面证明使用一般有限集选色；有限枚举限于具体小图边关系和 C5 固定列表负面实例。

图的编码规模为 G2=9、G3=23、G4=32、G5=37 点。最终类型 `Fin 4 ⊕ (Index × G5.Vertex)` 有限，再重编号为 `Fin (Fintype.card Final.Vertex)`。按组合计算 Index 有2520个元素、最终图有93244点；该具体数字没有作为 Lean 定理证明，也不参与主定理，主定理的有限性由 Fintype 实例给出。

无尚缺的主证明依赖。构建与公理结果见 [最终验证](FINAL_VERIFICATION.md)，阶段历程见 [PROGRESS](PROGRESS.md)。

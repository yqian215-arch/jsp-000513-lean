# 最终验证记录

完成日期：2026-09-18（Asia/Shanghai）。本地目录 `D:\Lean\jsp-000513-lean`，仅使用家用 Windows 环境。

## 结论

完整目标已有 Lean 证明：

```lean
JSP000513.theorem2 : JSP000513.Theorem2NatTarget
JSP000513.theorem2_all_palettes : JSP000513.Theorem2AllPalettesTarget
JSP000513.finitePaletteEquivalence : JSP000513.FinitePaletteEquivalenceTarget
```

第一个命题为存在 `n` 与 `SimpleGraph (Fin n)`，该图任意四元列表有普通染色，但不满足任意八元列表有二重染色。后两项确认任意调色板语义及有限图自然数重命名等价。主定理不含外加假设。

## 检查与复现

1. `lean-toolchain` 固定 Lean v4.34.0，Mathlib v4.34.0，提交 `5ed2965256430c3649e86755f9576b54eca72435`，各包固定在 lake-manifest.json。
2. 在仓库运行 `. .\scripts\Enter-Lean.ps1` 后执行 `lake build`。最终退出0，827 jobs。原始输出 [final-build.log](validation/final-build.log)。
3. 根入口 JSP000513.lean 导入全部证明，打印各阶段关键定理和三个最终定理的公理依赖，亦打印目标定义，防止只检查未展开的名称。
4. 三个最终定理仅依赖 `propext`、`Classical.choice`、`Quot.sound`。没有 sorryAx 或项目新增公理。
5. 项目 Lean 源码扫描 `sorry|admit|sorryAx|axiom|unsafe|native_decide` 无匹配。有限实例使用普通 `decide`，没有外部原生计算结果作为未经证明的前提。
6. 构建有三个不影响证明的 unusedSectionVars 警告：两个三角形组合引理与一个有限集选择引理携带多余 DecidableEq 参数。没有错误。

## 语义复核

[官方 JSP-000513 固定目录](https://github.com/TheJustinSunPrize/awards/blob/f4e7173d89dfe91022a185427d63452c8ffbf6ae/problems/catalog-0501-0600.md)的问题是倍增保持性；本结果以 (4:1) 对 (8:2) 给出否定见证。详细定义、量词及源码对应见 [theorem_mapping.md](theorem_mapping.md)。

对照 [DHS19 v2](https://arxiv.org/pdf/1806.03880v2) 检查了各阶段图、列表、共享顶点及补边。最终类型用有限索引副本保持有限性；通过顶点双射转为 Fin n，染色性质在双射下双向传递。半列表正面论证允许任意颜色类型，未枚举有限固定调色板代替全称证明。负面明确存在八元列表障碍，未将其误写成普通八色染色不可行。

`StrongRelaxed` 是原文扩展接口的加强版，保留两种选择顺序。C5 固定障碍的证明方法与论文计数法不同，但图、列表和结论相同。原文的分数色数小步骤由一般有限集引理替代，没有引入额外假设。

## 保存与边界

主定理首次本地提交 `363d59f`；此前 G4、G5 检查点分别 `f15efde`、`7e9ec59`。最终提交还包含调色板桥梁及本文。当前分支为 phase0-local，最终远端状态由完成后的本地／远端提交哈希核对记录。

没有公开仓库、创建公开证明记录或提交官方奖项。官方审核与奖项资格不在这次本地形式化完成声明内。早期 Phase 0 报告为历史记录；无尚缺的主定理证明依赖。

# JSP-000513 — 完整 Lean 证明

已证明：**存在有限简单图，它是 4-choosable，但不是 (8:2)-choosable。** 采用 Dvořák–Hu–Sereni 论文的 C5 → G1/G2 → G3 → G4 → G5 → K4 副本构造。

- 完整主定理：[`JSP000513.theorem2`](JSP000513/MainTheorem.lean)。图的顶点类型为 `Fin n`，正面量化全部四元列表，负面给出八元列表障碍。
- 任意调色板版本：`theorem2_all_palettes`；有限图上自然数颜色与任意颜色类型的等价：[`finitePaletteEquivalence`](JSP000513/PaletteEquivalence.lean)。
- 全部主定理仅依赖 Lean/Mathlib 标准公理 `propext`、`Classical.choice`、`Quot.sound`。无证明占位、额外未经证明公理或外部求解器证书。

## 复现

在家用 Windows 的 `D:\Lean\jsp-000513-lean`：

```powershell
. .\scripts\Enter-Lean.ps1
lake build
```

固定 Lean/Mathlib v4.34.0，依赖提交保存在 `lake-manifest.json`。本机安装与缓存路径见 [environment.md](docs/environment.md)。根入口导入全部证明并打印主定理、公理依赖与目标命题。

## 验证记录

- [最终验证与语义审计](docs/FINAL_VERIFICATION.md)
- [命题与源码对应](docs/theorem_mapping.md)
- [已完成证明依赖树](docs/proof_dependency.md)
- [逐阶段进度与提交](docs/PROGRESS.md)
- [最终构建输出](docs/validation/final-build.log)

早期 Phase 0 文档保留为历史记录，不代表当前证明范围。

## 来源与保存

[JSP-000513 官方题库固定版本](https://github.com/TheJustinSunPrize/awards/blob/f4e7173d89dfe91022a185427d63452c8ffbf6ae/problems/catalog-0501-0600.md)；[DHS19 论文 v2](https://arxiv.org/pdf/1806.03880v2)。本成果证明其反例存在性，即对倍增保持问题给出否定答案。

源码在家用电脑完成，已授权备份至私有 `yqian215-arch/jsp-000513-lean` 的 `phase0-local` 分支。未更改可见性、公开发布或提交官方奖项。本地 Lean 验证与官方审核是不同事项。

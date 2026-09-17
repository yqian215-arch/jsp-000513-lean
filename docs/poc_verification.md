# Phase 0 PoC 构建与公理审计

验证日期：2026-09-17（Asia/Shanghai）。执行位置为本台家用 Windows 主机上的 `D:\Lean\jsp-000513-lean`。**完整 `lake build` 已成功，退出码 0**。本次不包含完整 JSP-000513 的证明、公开发布或奖项提交。

## 构建环境与文件

- Lean：`leanprover/lean4:v4.34.0`。
- Mathlib：`v4.34.0`，固定提交 `5ed2965256430c3649e86755f9576b54eca72435`。
- 工具链与依赖安装由环境任务完成；本次 PoC 实作没有执行 `lake update`、更改工具链或依赖固定版本。
- 入口为 `JSP000513.lean`，导入 `Definitions.lean`、`StatementDrafts.lean`、`C5Obstruction.lean`，并打印关键证明的公理依赖。
- 实作使用较小的 `Mathlib.Combinatorics.SimpleGraph.Basic`，未继续使用已弃用的 `Mathlib.Combinatorics.SimpleGraph.Coloring` 转发模块。

## 实际命令与退出状态

两次构建都先进入固定环境。第二次的完整记录命令如下；第一次仅将日志编号换为 `01`。

```powershell
Set-Location -LiteralPath 'D:\Lean\jsp-000513-lean'
. .\scripts\Enter-Lean.ps1
lake build *>&1 | Tee-Object -FilePath work\poc-build-02.log
$taskBuildExit = $LASTEXITCODE
"EXIT_CODE=$taskBuildExit" | Tee-Object -Append -FilePath work\poc-build-02.log
exit $taskBuildExit
```

| 尝试 | 日志（被 Git 忽略） | 退出码 | 结果 |
| --- | --- | --- | --- |
| 1 | `work/poc-build-01.log` | 1 | Definitions、StatementDrafts 通过；五条具体边上的 `decide` 无法合成 `Decidable (graph.Adj ...)` |
| 2 | `work/poc-build-02.log` | 0 | 补充可计算的 `DecidableRel graph.Adj` 实例后，全部目标通过；`Build completed successfully (801 jobs).` |

第二次日志在本地时间约 12:59 完成。日志报告 `StatementDrafts` 5.1 秒、`C5Obstruction` 5.2 秒、入口 3.3 秒；这些是模块构建时间，不代表完整定理的难度或后续性能保证。801 是 Lake 报告的作业总数，包含缓存依赖，不能理解为本次从零重编译 801 个文件。

## PoC 证明内容与信任边界

`JSP000513.C5.not_listMulticolorable` 证明原论文 Lemma 3 中，指定五边形和指定四元列表不存在二重列表染色。`pairChoices` 通过 `powersetCard 2` 生成各顶点的全部二元子集；`mem_pairChoices_iff` 证明覆盖精确；任意抽象合法染色通过该引理映射到有限检查，再由五条实际图边上的不交条件导出矛盾。不是只证明一个脱离 `SimpleGraph`/列表定义的布尔结果。

有限部分用普通 `decide`，由 Lean 内核核验约简产生的证明项；未使用 `native_decide`、外部求解器证书假设、项目新增公理或未完成证明占位。枚举定理局部设置 `maxRecDepth 65536`、`maxHeartbeats 8000000` 以提供计算预算；这两项不是逻辑假设。

## 实际公理输出

下列输出来自成功构建的入口 `#print axioms`，完整原始输出保存在第二次日志中。

```text
'JSP000513.C5.lists_card' depends on axioms: [propext, Quot.sound]
'JSP000513.C5.pairChoices_card' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000513.C5.mem_pairChoices_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000513.C5.no_compatible_choices' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000513.C5.not_listMulticolorable' depends on axioms: [propext, Classical.choice, Quot.sound]
'JSP000513.C5.not_ABChoosable_four_two' depends on axioms: [propext, Classical.choice, Quot.sound]
```

`propext`、`Classical.choice`、`Quot.sound` 是本次证明经依赖展开后使用的 Lean/Mathlib 标准基础。这里不声称“完全无公理”或“完全构造性”。输出未出现 `sorryAx`、新增项目公理或原生计算的额外信任入口。命题草案只是 `def ... : Prop`，没有被暗中加入证明依赖。

## 成功构建对应源码 SHA-256

通过本机 `Get-FileHash -Algorithm SHA256` 记录。以下源码在第二次构建之后未再修改。

| 文件 | SHA-256 |
| --- | --- |
| `JSP000513.lean` | `2A9DC2448281F505F6123FD686B70796AE2A6B8BD06E93B66E864C1F9CB8A454` |
| `JSP000513/Definitions.lean` | `75927D166499671A156FE4447D75F8A0F4A965D66B921DE1F8306408E4FB62FA` |
| `JSP000513/StatementDrafts.lean` | `985D6F03D154B6E6E23676B9832D8D6B182167C2CAE14A5C0C50A3F53F316017` |
| `JSP000513/C5Obstruction.lean` | `5108A4DF81E2288A764D5E3C93FB90C744960372309C8A1F2DD9CA306A1B3F41` |

## 风险与剩余工作

1. 此证明只是 Lemma 3 负面半句，并推出五边形非 `(4:2)` 可选。没有证明 Theorem 2、非 `(8:2)` 可选的最终图，或任何奖项资格。
2. 任意 half-list 的正面性质、后续 gadgets、边界扩展和粘合均未实现，才是后续主要证明工作。
3. 自然数调色板与任意颜色类型上的可选性等价尚未证明；三个草案的准确量词与缺口见 [theorem_mapping.md](theorem_mapping.md)。
4. 本次语义核对包括原论文和独立只读代码复核，但不等同于奖项官方审核。构建成功只支持这里列明的已证明局部结论。
5. 所有成果仅留本地；原始远程已知为 Public，本次没有 push、改变可见性或提交奖项申请。

# CLEANROOM VERIFICATION — JSP-000513

**结论：PASS（数学/形式化与本次可复现构建）；WARNING（环境与文档事项）。可以进入 submission-hardening。**

这是对固定提交 `8496ddb257bbdd9948417d3a98a563f2696cd47b` 的独立验证，不是开发工作。没有发现需要停止验证的实质性数学或形式化错误。没有修改证明逻辑、`lean-toolchain`、`lakefile.toml` 或 `lake-manifest.json`。PASS 仅限下表已完成范围；不等于正式提交、奖项资格或人工同行审稿认证。

最后更新：2026-09-18，Asia/Shanghai。全部要求的验证已完成，附加 fresh 内核重放亦 PASS。

## 1. 独立性、目录与安全边界

- 原项目 `D:\Lean\jsp-000513-lean` 未被读取、复用或修改；没有读取其他任务的对话、结论或历史审计文档。仓库源码注释仅视为主张，结论来自原文、代码和独立运行。
- `D:\Lean\jsp-000513-cleanroom` 原先不存在，创建后将仓库 clone 至其 `repo` 子目录；外置证据目录为 `D:\Lean\jsp-000513-cleanroom\evidence`。未覆盖任何旧数据。
- 使用现有合法 Git HTTPS 身份 clone；未读取、输出或提交凭据。checkout 后实际 `git rev-parse HEAD` 与上述 40 位 SHA 完全一致。
- 本地及已 fetch 的远程同名分支均不存在，创建 `cleanroom-verification`。未覆盖 `phase0-local`，未强推，未更改 visibility，未创建 PR 或正式提交。
- 仓库 AGENTS.md 指向原项目目录的旧指令，按本次用户明确要求以独立 clone 为准；没有据此回到原项目。
- GitHub connector 独立返回仓库 id `1373886577`、`visibility=private`、`permissions.push=true`，才推送验证分支。
- 第一次 checkpoint commit 因本机缺少作者设置失败。仅在此 clone 配置通用审计身份 `Clean-room verification <cleanroom-verification@users.noreply.github.com>` 后提交，不冒用原作者。

## 2. 判定表

| 检查 | 判定 | 证据 |
|---|---|---|
| 固定源码 SHA 与全新 clone | PASS | 外置 `clone.log`；Git 基线与 `proof-source-diff.txt` |
| 锁定依赖提交 | PASS | `cleanroom-evidence/dependency-revisions.json`，全部 9 项 match=true |
| 隔离目录中的源码构建 | PASS | `lake-build-2.log` + `lake-build-3.log`；最终 exit=0、827 jobs |
| Definitions / StatementDrafts / MainTheorem / PaletteEquivalence | PASS | §5 的逐定义展开与证明检查；独立 AxiomAudit 输出 |
| DHS19 C5、G1–G5 的边/列表/顶点编码 | PASS | `GraphAudit.lean`、`GraphAudit-2.log`、exit=0；全部顶点双射及全部有序顶点对 |
| 各引理正负证明与最终统一列表构造 | PASS | §6；源码全文检查 + 独立重新编译 |
| fresh 内核重放 | PASS | `kernel-replay.log`、exit=0；见 §10 |
| 三个最终定理的公理、传递常量与机制 | PASS | `AxiomAudit-final.log`、exit=0；closure 与 runtime 清单 |
| 基线实际证明代码的禁止项和占位扫描 | PASS | `source-scan.json`：25 个源码/配置/脚本文件，0 命中 |
| 完整不间断的一次构建 | WARNING | attempt 2 被中断，无退出码；attempt 3 接续成功，不能称其为一次不间断运行 |
| 共享工具链完全从源引导 | 未执行 | 复用锁定版本的已安装 Lean 官方工具链，未重建 Lean 编译器/标准库 |
| 第二台机器/另一操作系统复现 | 未执行 | 本次只在指定 Windows 主机 |
| 提交规范、版权归属、奖项资格审核 | 未执行 | 属于后续 submission-hardening |

## 3. 外部原题与论文

独立从官方题库获取：

- <https://raw.githubusercontent.com/TheJustinSunPrize/awards/main/problems/catalog-0501-0600.md>
- JSP-000513 条目（下载文本第 179–192 行）询问：列表大小与每点所需颜色数同时加倍是否保持列表多重可选色性。其 DHS19 引用指向 DOI `10.19086/aic.10811`。反例取 a=4、b=1 即足以否定该普遍命题；不需要证明所有 a,b 都失败。
- 原始快照：外置 `official-catalog.md`，SHA256 `8E760E26B5CCD9E3F568D756BD30DC5B49F0AAD63CE679FEFEDFB428FF04E240`。题库可变，其现行状态标签不被当作数学证据。

独立从 arXiv 获取指定版本：Zdeněk Dvořák、Xiaolan Hu、Jean-Sébastien Sereni，*A 4-choosable Graph that is Not (8:2)-choosable*，Advances in Combinatorics 2019:5，论文标明 CC-BY。

- <https://arxiv.org/pdf/1806.03880v2>；<https://arxiv.org/html/1806.03880v2>。
- 外置 `DHS19v2.pdf`，SHA256 `3119F19D70D0CDA397AA7BD9CEEDE8673C5BF6B1B740A6B4F3A0BE47091A7FFD`。
- PDF 第 1 页确认 v2 / 25 Oct 2019；第 2 页读定义和 Theorem 2；第 3–8 页读完整构造证明。第 3–7 页 Figure 1–5 另经渲染逐页视觉核对；文本保存在 `DHS19v2.txt`，页面图保存在外置 `paper-3.png` 至 `paper-8.png`。
- 本报告页码均为论文印刷页码，与该 PDF 的 1-based 页码相同。

## 4. 构建、环境和实际隔离程度

工作目录：`D:\Lean\jsp-000513-cleanroom\repo`。

- Windows NT 10.0.22631，x86_64；PowerShell 7.6.5；Git 2.53.0.windows.3。
- Elan 4.2.4；共享 `ELAN_HOME=D:\Lean\tools\elan`。
- Lean 4.34.0，`x86_64-w64-windows-gnu`，Release，编译器提交 `293d5d0c0c3f3dded4688b3ccd6a33939ac5102b`。
- Lake `5.0.0-src+293d5d0`；实际选中项目 `lean-toolchain` 的 `leanprover/lean4:v4.34.0`。
- Mathlib `5ed2965256430c3649e86755f9576b54eca72435`；其余 8 项完整 SHA 在 `dependency-revisions.json`，均实际执行 `git -C .lake/packages/<name> rev-parse HEAD` 比对。`dependency-worktree-status.txt` 记录依赖工作树状态。

隔离分三层：

1. **工具链共享**：复用预装 Lean/标准库/Elan，未宣称编译器 bootstrapping 或全系统无缓存。
2. **依赖源码获取**：全新 `.lake/packages`，实际 clone 固定提交，没有从原项目复制依赖目录，没有复用原项目 Git objects。
3. **编译产物**：从此 clone 空的项目/依赖构建目录开始。`MATHLIB_NO_CACHE_ON_UPDATE=1` 关闭 mathlib post-update 下载；`MATHLIB_CACHE_DIR`、`LAKE_CACHE_DIR` 均指向独立目录；`LAKE_NO_CACHE=true`、`LAKE_ARTIFACT_CACHE=false`、`lake --no-cache build` 禁止 Lake 预编译缓存路径。

过程与失败完整保留：

- **Attempt 1**：命令 `lake build`。仅设置 mathlib 的禁止缓存变量仍不足；观察到 Lake 的 curl 请求 Reservoir 的 batteries `build.barrel`。主动停止本次进程，不能记成功退出。库存显示只有两个本地 Lake 配置 `.olean` 和该下载包，没有依赖证明模块 `.olean`。下载包未作为证明产物使用，移出至外置 `attempt1-batteries-download.barrel` 保留取证。日志 `lake-build.log`、`attempt1-stop.txt`、`attempt1-artifacts.txt`。
- **Attempt 2**：补齐上述 Lake 变量，命令 `lake --no-cache build`。从依赖源码逐模块构建；最后可见 812/827，随后长时间中断，无退出码文件，恢复时无 lake/lean 进程。不能推断中断具体原因或将此轮标 PASS。
- **Attempt 3**：用户报告额度恢复后，读取 checkpoint，再用同一环境、同一命令接续。只复用**本次验证自身刚编译**的产物。`2026-09-18T07:18:32.4744993+08:00` exit=0，日志明确 `Build completed successfully (827 jobs)`。包括重新构建 C5 obstruction、G1–G5、FinalConstruction、MainTheorem、PaletteEquivalence 和根模块。
- 原始 PowerShell 构建日志有部分 Unicode 显示字符被本机代码页错误解码；ASCII 命令、模块名、退出码完整保留。独立审计轮显式设置 UTF-8，重新打印的目标及公理输出可读，见 `AxiomAudit-final.log`。
- 编译有 3 条 unusedSectionVars 警告：`FinsetTools.lean:19`、`NineAttachment.lean:16,64`。不是未完成证明；本次未为消除警告修改源码。

精确复现（新建空目录时应先确认目标不存在，不覆盖已有目录）：

```powershell
git clone https://github.com/yqian215-arch/jsp-000513-lean.git D:\Lean\jsp-000513-cleanroom\repo
Set-Location D:\Lean\jsp-000513-cleanroom\repo
git checkout --detach 8496ddb257bbdd9948417d3a98a563f2696cd47b
git rev-parse HEAD
# 选择尚不存在的独立验证分支名；本次使用 cleanroom-verification。
git switch -c cleanroom-verification
$env:ELAN_HOME = 'D:\Lean\tools\elan'
$env:PATH = "$env:ELAN_HOME\bin;$env:PATH"
$env:MATHLIB_CACHE_DIR = 'D:\Lean\jsp-000513-cleanroom\dependency-download-cache'
$env:MATHLIB_NO_CACHE_ON_UPDATE = '1'
$env:LAKE_NO_CACHE = 'true'
$env:LAKE_ARTIFACT_CACHE = 'false'
$env:LAKE_CACHE_DIR = 'D:\Lean\jsp-000513-cleanroom\lake-cache'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
lean --version
lake --version
lake --no-cache build *> ..\evidence\fresh-build.log
$buildExit = $LASTEXITCODE
"exit=$buildExit" | Set-Content ..\evidence\fresh-build-exit.txt
```

先创建 evidence 目录。基线不包含此次审计文件；复现审计时从本验证分支复制 `docs/cleanroom-evidence/*.lean` 和脚本，不改基线证明文件，再执行：

```powershell
lake --no-cache env lean docs/cleanroom-evidence/AxiomAudit.lean
lake --no-cache env lean docs/cleanroom-evidence/GraphAudit.lean
lake --no-cache env leanchecker --fresh --verbose JSP000513
```

每条命令分别保存 `$LASTEXITCODE`，不可只看最后一条命令。审计脚本当前使用本次绝对证据路径，迁移机器时需改证据输出路径；目标声明不受此路径影响。`build.ps1` 是实际第二轮环境脚本，`run-audits.ps1` 与 `replay.ps1` 保留完整命令。

## 5. Theorem fidelity：具体展开

下列行号来自固定基线，原证明文件无变化。

### 定义、量词、基数与否定

- `Definitions.lean:19–24`：`IsListMulticoloring G L b φ` 恰为 `(∀x, φ x ⊆ L x) ∧ (∀x, card(φ x)=b) ∧ (∀x y, G.Adj x y → Disjoint (φ x) (φ y))`。使用集合基数，不是可重复元素列表长度；要求每条边不交，不是仅不相等；选色数为等号而非上界。
- `Definitions.lean:27–29`：`ListMulticolorable` 为 `∃φ`。`Definitions.lean:34–37`：`ABChoosableOn` 为 `∀L, (∀x, card(L x)=a) → ∃φ,...`，所以是对任意列表分配分别存在着色，未把量词换成某个有利列表。`ABChoosable` 在 40–41 行仅固定 Color=ℕ，不限制可使用的自然数颜色范围。
- `StatementDrafts.lean:13–15`：存在 n 和 `SimpleGraph (Fin n)`，同一 G 同时满足正面和负面；`¬ABChoosable G 8 2` 是否定“每一个 8 列表分配都可着色”，即存在坏分配，不是错误地声称所有列表都无法着色。
- `FinalConstruction.lean:67–77,79–92,149–151` 给出具体 `Final.lists`，证明每个列表恰好 8，并否定其任意 2-选色方案，再将假设的普遍可选色性质应用于这个坏分配。因此负面结论不是空洞前提。
- 定义允许自然数 a,b 的所有取值；目标采用 4≥1>0、8≥2>0，符合论文第 2 页的参数限制，不涉及非正参数漏洞。
- `ListColoring.lean:19–43` 的 singleton/唯一元素转换证明普通列表着色与 b=1 多重列表着色等价；没有混用普通图着色与列表着色。

### 有限性和顶点换标

- `FinalConstruction.lean:25–33`：颜色池为 8 元集合 {9,…,16}，Pool 是其 powerset 的子类型，Index 是四个池内两元集两两不交的函数的子类型。有限类型经函数、子类型、积、和保持有限；`Fintype.ofFinite` 通过类型类证明取得实例，不是对无限类型凭空假定有限。
- G5 有 37 点，由独立 GraphAudit 的 `Function.Bijective mapG5` 证明。Index 有显式 `indexWitness`，四对为 {9,10},{11,12},{13,14},{15,16}，排除了空索引“无副本”漏洞。分析上有效索引数为 8!/(2!)^4=2520，从而该构造有 93244 点；这个数值是组合计数说明，本次未额外把其精确值作为 Lean 定理输出，有限性并不依赖该数值。
- `MainTheorem.lean:12–29` 双向证明 `ABChoosableOn (G.comap e) ... ↔ ABChoosableOn G ...`，e 是 `Equiv`；两个方向分别以 e/e.symm 运输 L 和 φ，回代严格保持包含、基数与边条件。
- `MainTheorem.lean:32–40` 用 `(Fintype.equivFin Vertex).symm` 作为双射，再定义 finiteGraph 为 comap。没有仅凭非单射 homomorphism 将负例错误推出。
- `MainTheorem.lean:44–51` 无假设地产出两个目标，使用同一有限图；GraphAssembly 的 `IsListMulticoloring.comap`（64–70 行）只用于拉回着色，提供明确保边条件，本就不要求单射。G5 的具体嵌入另独立检查了单射和邻接 iff。

### Palette bridge

- `StatementDrafts.lean:18–21` 的正面为 `∀Color, ABChoosableOn ... 4 1`；负面是 `¬(∀Color, ABChoosableOn ... 8 2)`，不是 `∀Color, ¬...`。后者对空调色板可能错误；这里 ℕ 上的具体反例足以否定普遍命题。
- `PaletteEquivalence.lean:7–21` 在注入 e 下 Finset.map 保持基数、包含与不交。`24–48` 的 of_embedding 将任意 C 列表映入 D，取得 D 着色后，用 `τ v=(L v).filter (e c∈φ v)` 拉回。关键 `map τ e=φ` 使用 `φ⊆map L e`，因此没有丢颜色、增颜色或假定全局满射。
- `52–72` 对每一个 L 单独取 `S=univ.biUnion L`；有限的是当前所有列表中出现的颜色，不是整个 Color。`K v` 将列表限制为 S 的子类型；`hS` 确保限制不改变基数。有限 S 注入 ℕ，通过 of_embedding 着色后沿 subtype 注入还原。
- `76–78` 将上一步用于任意 n,a,b,G，反方向仅取 Color=ℕ。任意 Color 可以无限，且辅助定理 `finite_palette_equivalence` 的 universe v 任意；包装目标中的 `Color : Type` 与有限反例的常规表述一致，没有要求所有调色板可数。

## 6. DHS19 构造与证明逐项核对

`GraphAudit.lean` 的期望数据按论文重新输入，不从被测 graph/列表定义自动推导。比较每一对有序顶点的邻接 iff、每个顶点的完整列表、顶点编码双射和边数，使用普通 `by decide`，不用 native_decide。JSON 保存论文期望数据。成功标准为整个文件 exit=0，而非其中的进度文字。

| 部件 | 原文 | 顶点/无向边 | 基线源码位置 |
|---|---|---|---|
| C5 | p.3 Lemma 3、Figure 1 左 | 5 / 5 | C5Obstruction:19–35,40–78；C5Positive:31–86 |
| G1 | pp.3–4 Corollary 4、Figure 1 右 | 7 / 8 | G1:7–26,32–65,68–105 |
| G2 | pp.4–5 Lemma 5、Figure 2 | 9 / 14 | G2:7–27,67–125,130–193 |
| G3 | pp.5–6 Lemma 6、Figure 3 | 23 / 36 | G3:5–12,39–72,76–94；SevenAttachment:8–21,40–177 |
| G4 | pp.6–7 Lemma 7、Figure 4 | 32 / 49 | G4:4–14,33–55,67–98；NineAttachment:49–114 |
| G5 | pp.7–8 Lemma 8、Figure 5 | 37 / 61 | G5:5–29,67–130,133–174 |
| Final | p.8 Theorem 2 proof | 有限 clique + 全部有效副本 | FinalConstruction:25–151 |

**C5**：编号 0,…,4 对应 v1,…,v5，边恰为环。完整列表为 {1,2,5,6}、{1,4,5,6}、{3,4,5,6}、{3,4,5,6}、{2,4,5,6}。正面从 L0∪L2 至少三色推出逃离 L1 的颜色，再贪心绕环；reflection 确认反射保持邻接。负面形式化以 powersetCard 2 穷举替代论文 10>9 计数；`mem_pairChoices_iff` 确保所有方案被覆盖，5 点每点 6 候选。额外 Python 从论文列表独立遍历 7776 方案均失败；这是交叉核对，不是 Lean 的信任输入。

**G1**：环外添加 v1–x–y–v3，列表与 Corollary 4 一致。正面对任意半列表且 L(v1)=L(v3)，先选不同的 cy,cx，从同一个三元列表取不同的两元子表避开两色，再应用 C5。负面由 y={1,2}、x={3,4} 将 v1,v3 的可用列表缩成 C5 障碍；没有将原列表直接缩小而未证明着色不能用删掉的颜色。

**Relaxed 接口**：论文 p.4 的 (i) 为 ∃固定 v1,v3 颜色，∀边界颜色，∃扩展；(ii) 为 L(v1)=L(v3) 且 ∃固定边界颜色，∀ v1,v3 颜色，∃扩展。`Relaxed.lean:19–25` 保留该量词顺序，并要求所有列表内边界赋值扩展，而不只已合法的部分着色，所以更强。具体 G2/G3/G4 的 `{v1,v3}∪S` 互不相邻、不同点，独立完整边集检查也覆盖这些对；不存在前提要求着色一个本已不可能的边界图而空洞成立的问题。

**G2**：0,…,4 为环 v1,u2,v3,u4,u5；5,…,8 为 y1,…,y4。五条辐条、y1y2、末端三角形全部存在。L2 环为 {1,…,6}，y1 为 {1,…,8}，y2/y4 为 {1,2,3,4,7,8}，y3 为 {1,2,3,4}。正面按环列表是否全相同分支，非相同时选 y1 不在 y2 列表的颜色；相同时选 y1 不在公共三元表的颜色，并先固定 y4。`C5General` 证明删除统一颜色后的非均一三元表可着色，以及公共三元表的指定两点扩展。负面若 y4 避开 7,8，先迫使 y2={7,8}，然后环只剩至多四色；源码用奇环上相隔两点的色对相同导出矛盾，合法替代论文分数色数论证。

**G3 / Seven**：每份 z1,…,z7 的头四点是 K4 去掉 z1z2（仅这条不在），附尾三角形 z5z6z7 和桥 z4z5；y4 邻接每份 z1,z2。下标 i=0,1 对应论文 i=1,2，特殊色 `7+i.val` 即论文 `6+i`。七个列表和全部新边逐项相同。正面 `diamond_signal` 先选 q，再∀避开 q 的根色 r，再∀终端色 t；没有交换 q 与 t。G3 先为两份选 q，再从三元 L(y4) 避开两者。另一分支先固定旧边界并贪心确定两个新终端。负面由 y4 含 7 或 8 激活对应副本；z1,z2 分属不交的 {1,2,3}/{4,5,6}，与 z3 合计耗尽六色，迫使 z4={7,8}，再用末端三角形迫使 z7={7,8}。

**G4 / Nine**：三角形 w1w2w3 和两份 wi,1wi,2wi,3；四条连接边恰为 z1,7w1、z2,7w1、w3w1,1、w3w2,1。三元位置中的中点列表为 {1,2,3,4}，其余为 {1,2,3,4,7,8}。正面 `Nine.flexible_extension` 先选择旧终端颜色 rs，之后才允许任意 ts；`two_roots_residual` 和 `avoid_two_bad_deletions` 确保剩余三角形可扩展。负面有一个旧终端为 {7,8} 已足够：w1 缩到四普通色，三角形迫使 w3={7,8}，再同时迫使两个新终端为该色对。

**G5**：G1 与 G4 仅合并 v1,v3；新增点按 v2,v4,v5,x,y 编码。其内部边是 v4v5、xy，与旧图的六条 G1 边和四条额外边均核验无遗漏。仅 v2,v4,x,y 的 L1 加上 {7,8}，v5 列表保持原状。正面 relaxed (i) 先扩展 G1 再选两终端避开相应的两个颜色；(ii) 先固定终端，删去对应终端色后精确截取半列表，v1,v3 的三元表不变，使用 G1 等列表情形。负面先用 G4 迫使两个终端为 {7,8}，因此删去的特殊色不可能被相邻的四个新点使用，再沿实际保边 embed 拉回 G1 障碍。独立检查 embed 单射且邻接 iff，不只接受项目中单向 embed_adj。

**FinalConstruction**：`Index` 正是 clique K4 的全部池内两元不交色集分配。G5.halfSizes 逐点只为 2、3、4，坏列表仅含 1,…,8。每点连接前 4-k 个 clique 点并填入其两元色集；GraphAudit 独立检查 neighbor 集等于该公式。padding 内色对互不交且与 1,…,8 不交，故列表恰为 2k+2(4-k)=8。任意假设的整体 2-着色在 clique 上限制自动构造合法 ψ；取它索引的副本，其所有 padding 色被邻边排除，得到 G5 矛盾。正面对任意四元列表先贪心着色 K4，删邻点颜色最多 4-k 个，至少剩 k 色；取精确 k 子表后使用 G5 的任意半列表定理，再将无跨副本边的着色合并。这里副本索引是固定坏列表的所有 clique 2-着色，而正面使用任意新的列表 L；源码未混淆这两个 L。

## 7. 公理、传递依赖和证明机制

独立 `AxiomAudit.lean` 实际解析并审计以下全限定名：

| 根定理 | 类型/证明传递常量数 | 公理 |
|---|---:|---|
| `JSP000513.theorem2` | 6182 | propext, Classical.choice, Quot.sound |
| `JSP000513.theorem2_all_palettes` | 6182 | propext, Classical.choice, Quot.sound |
| `JSP000513.finitePaletteEquivalence` | 3992 | propext, Classical.choice, Quot.sound |

完整 `#print axioms` 和定义展开输出：`cleanroom-evidence/AxiomAudit-final.log`；exit=0。

审计不只打印公理：从根开始遍历常量类型以及所有可取得的定义/定理/opaque body（`allowOpaque=true`），并对 inductive/recursor 相关项继续闭包。每一常量检查 `isUnsafe`、`isPartial`、axiom 种类，以及 sorry/native reduction 可疑名字；任何非白名单 axiom 或 flag 导致脚本失败。三个闭包的 flag 均为空。完整名称表外置 `closure-JSP000513.*.txt`。

另保存闭包中的 `extern` / `implemented_by` 属性，见 `closure-*.runtime.txt`。确有标准 Lean 的 Nat/Int、Array、String 等运行时实现，以及 Array.foldlMUnsafe、List.attachWithImpl 等标准实现替代。这些是工具链标准运行时，不是项目新增 unsafe 证明或 native_decide oracle；不能将“逻辑依赖中无 unsafe 声明”歪写成“Lean/Mathlib 整个实现不含 unsafe”。本次基线没有自定义 elab/macro/initialize/运行时替代或跳过内核设置。标准库/编译器仍是信任基础。

源码的计算证明使用普通 `decide`、`fin_cases`、`simp`、`omega` 等。检查实际工具链 `Lean/Elab/Tactic/Decide.lean` 的 `evalDecideCore/doElab`：非 native 分支产生证明项交由 kernel 重新计算；项目没有 `+native` 或 native_decide。`proof-mechanisms.txt` 保存相关调用/option 的源码命中。特别是 C5 大枚举采用普通 decide；本次从源码重建该模块成功。

## 8. 源码扫描及非证明命中

`scan-and-enumerate.py` 从固定基线 `git ls-tree` 取文件集合，对 25 个 `.lean/.ps1/.toml` 文件扫描：sorry、admit、sorryAx、axiom、unsafe、native_decide、partial、implemented_by、extern、debug.skipKernelTC、trustLevel、ofReduceBool、TODO/FIXME/placeholder。对 Lean 代码分类嵌套注释、行注释和字符串；实际结果所有类别均 0 命中，详见 `source-scan.json`。

根模块 `#print axioms` 是审计命令，复数 `axioms` 不是新 `axiom` 声明。新增审计脚本为扫描器自身包含这些词和 `#eval` 输出，位于 docs，不参与 `lake build` 目标，不能误报为原证明使用禁止项。首轮 GraphAudit 的错误日志出现 Lean 自动生成的 `sorry`，因为审计脚本缺少 match 上的 DecidableRel 实例；该轮 exit=1、明确不被接受。补上仅供审计的决定性实例后，完整重跑 exit=0。未修改任何 G 系列源码来让测试通过。

发现一个文档警告：`C5Obstruction.lean:12–13` 仍保留早期 PoC 的“positive half / Theorem 2 outside scope”注释；它与现在已实际构建的完整项目不一致。这不是占位证明，但 submission-hardening 应更新该注释。另有 unusedSectionVars 警告，见 §4。

## 9. 可恢复证据、剩余范围与下一步

仓库报告：`D:\Lean\jsp-000513-cleanroom\repo\docs\CLEANROOM_VERIFICATION.md`。

提交到验证分支的证据在 `docs/cleanroom-evidence/`：完整各轮构建日志、环境 transcript、退出码、依赖 SHA、审计源文件和成功输出、初轮失败输出、独立论文期望图、扫描及基线文件哈希。外置 evidence 还保留论文 PDF/HTML/文本/渲染图、完整传递闭包名称、未采用的缓存下载包。未将 `.lake`、凭据或巨大编译产物提交到 Git。

已完成的检查不需在额度恢复后重做。可恢复 checkpoint 已从开始即分阶段写入本报告并提交；Git 历史保留启动、缓存隔离修正、额度恢复、构建/审计通过的各阶段记录。最终状态见 §10，后续接续点为 submission-hardening。

本次未执行：Lean 自身或全部标准库实现的独立外部验证、第二机器构建、操作系统/硬件可信验证、所有辅助引理的完整枚举、最终 93244 点的完整邻接矩阵物化、论文之外更一般结论，以及公开提交规则/原创归属/许可证的完整审查。有限 G5 的全边集检查、任意列表的内核证明及最终符号构造验证已覆盖本次数学目标，无须物化巨图才能证明该目标。

**进入 submission-hardening 的条件已具备**：保留固定 proof SHA，整理陈旧注释/警告和独立复现入口、标清工具链与日志隔离边界、单独检查正式提交要求及归属。任何后续实质性源码修改都应触发相应重新验证。本次未执行正式提交或公开仓库。

## 10. 最终完成记录

- `lake --no-cache env leanchecker --fresh --verbose JSP000513` 已完成：`2026-09-18T07:25:17.4353515+08:00`，**exit=0**，输出 `replaying JSP000513 with --fresh`。命令、输出及退出码保存在 `cleanroom-evidence/kernel-replay-*`。这调用同一锁定 Lean 内核，将导入和项目常量在空环境重新 replay，进一步检查环境污染/绕过；它不是不同实现的外部验证器。
- 完整传递依赖名称表也已纳入 `cleanroom-evidence/closure-*.txt`，不只留在外置目录。
- 最终执行 `git diff --exit-code 8496ddb257bbdd9948417d3a98a563f2696cd47b -- lean-toolchain lakefile.toml lake-manifest.json JSP000513.lean JSP000513`，**exit=0**。9 个依赖工作树均无变更。
- 所有本次要求的数学与形式化验证步骤已经完成；此前 checkpoint 的“下一步”是历史记录，现已完成。后续接续点仅为 submission-hardening，不需要重做本次验证，除非证明或锁定配置改变。
- 附加工具探测说明：曾直接调用 `leanchecker --help`，该程序不实现 help 选项，并按包名推测成 `Jsp000513`，提示找不到模块。读其官方随工具链源码后，采用显式模块名及 `lake env` 的上述命令成功。该探测失败不是证明失败。

- 最终环境快照：父进程的 LEAN_PATH/LEAN_SRC_PATH/LEAN_SYSROOT/ELAN_TOOLCHAIN 均未设；通过 `lake --no-cache env pwsh -NoProfile -Command ''$env:LEAN_PATH''` 实测查找路径仅指向此 clone 的依赖/项目构建目录与共享工具链，无原项目路径。初次以 Unix `printenv` 探测因 Windows 没有该程序失败，原输出另存 initial-probe 文件后用 PowerShell 成功。这是结束时的环境快照，构建时显式环境见 transcript。


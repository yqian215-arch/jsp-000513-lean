# Phase 0 进度、风险与下一步

日期：2026-09-17。阶段结论：**本地环境与代表性 PoC 已通过；完整 JSP-000513 形式化未完成。**

## 已完成

| 用户目标 | 实际结果 |
| --- | --- |
| 家用电脑本地执行 | 当前 Windows 主机执行全部终端、安装、文件写入；未访问办公电脑本地环境 |
| 独立目录 | `D:\Lean\jsp-000513-lean`，D 盘存在，无需后备目录 |
| GitHub 验证与 clone | 已连接插件能读取目标仓库及权限；clone 成功，本地分支 `phase0-local` |
| 工具链 | Git 2.53.0；elan 4.2.4；Lean 4.34.0；配套 Lake 5.0.0；Mathlib v4.34.0 |
| 官方题意与原论文 | 对应 DHS19 Theorem 2 的反例存在性；来源及版本见 source_verification.md |
| Mathlib 调研 | 查明 SimpleGraph、普通 Coloring、Finset 可用 API；搜索范围和新增定义需求已记录 |
| statement 草案与依赖树 | 三个未证明目标写为 Prop 定义；原论文 gadget 链条与后续接口已记录 |
| 代表性 PoC | DHS19 Lemma 3 负面半句的五边形列表障碍；由 Lean 内核核验有限枚举 |
| 构建验证 | `lake build` 第二次通过，退出 0，日志 `work/poc-build-02.log` |
| 发布约束 | 无 push、无远程写入、无可见性修改、无官方奖项提交 |

应用中另建了绑定此目录的本地任务：**JSP-000513 Phase 0 本地 Lean 验证**，任务 ID `01a0adad-59ad-7262-981e-d4dc07d1655d`，执行主机为 local。

## PoC 的证明边界

已证明每份列表恰有 4 种颜色，每个顶点的二元候选恰有 6 个；`powersetCard` 的成员充要条件保证枚举覆盖任意合法选择。最终 `not_listMulticolorable` 对任意自然数颜色有限集赋值成立，并推出该 C5 不是 `(4:2)`-choosable。

这不是最终图不是 `(8:2)`-choosable 的证明，更不是其任意四元列表可染的证明。Lemma 3 正面 half-list 性质、后续 gadget 与最终图仍未形式化。

入口的 `#print axioms` 输出仅为标准 `propext`、`Classical.choice`、`Quot.sound`（个别引理是其子集），无 `sorryAx`、新增项目公理或原生决定程序的信任前提。独立只读语义审查确认图、列表、候选完备性和最终语义连接一致。详细命令与证明名见 poc_verification.md。

## 遇到并解决的问题

- GitHub 下载连接重置及超时：重试恢复，依赖锁文件与缓存已经成功生成。
- 首轮 PoC 构建缺少 `DecidableRel graph.Adj`：增加显式可判定邻接实例后，第二轮成功。
- 使用额度中断：用户重置后，从现有文件和安装状态继续，没有重新克隆或重置环境。

## 剩余风险

1. **远程仓库当前是 Public。** 这是首次检查时已存在的状态；新增成果只留本地。在决定推送之前，应先明确用户期望的可见性。
2. 自然数颜色与任意颜色类型的有限重命名等价尚未证明。全颜色草案当前量化 `Color : Type`，需结合目标 universe 要求复核。
3. 完整证明的主要工作是任意列表的扩展与 gadget 粘合，不能用 C5 有限枚举的成功估算全题已接近完成。
4. 后续 Mathlib 升级可能变更 API。当前工具链和所有依赖已固定；本地 Git 路径随桌面应用升级可能需调整。
5. ERT80 最初一般问题的原始扫描页码尚未确认；直接反例论文 DHS19 的版本、Theorem 2 和 PoC Lemma 3 已核查。

## 下一步（尚未执行）

1. 审阅 theorem_mapping.md，确定采用的正式主 statement 与颜色类型约定。
2. 建立有限颜色重命名与普通单色列表染色的桥接引理。
3. 完成 Lemma 3 的正面半句及 Corollary 4，检验任意列表扩展接口。
4. 稳定 relaxed gadget、共享边界与粘合接口，再规划 Lemma 5–8。

本次工作止于 Phase 0，不自动推进完整形式化或发布。所有修改保存在本地工作树，尚未创建本地提交或推送。

# JSP-000513 Lean — 完整形式化进行中

本项目在家用 Windows 电脑上研究 JSP-000513 的 Lean 形式化。工作目录：`D:\Lean\jsp-000513-lean`。

**当前范围：完整形式化，持续实现中。** 用户已授权越过 Phase 0，按论文依赖逐阶段证明主定理、审计并做本地提交。最新状态见 [PROGRESS.md](docs/PROGRESS.md)。正确目标是构造一个有限图，它是 4-choosable，却不是 (8:2)-choosable，对应 Dvořák–Hu–Sereni 论文 Theorem 2。不能把题目的疑问句误写为“倍增保持性”定理。

当前选取的最小 PoC 是论文 Lemma 3 中 C5 的具体列表障碍：证明无法每个顶点选两色且相邻选择不交。该局部结果不等于完整的反例构造，也不包括 Lemma 3 的正面 half-list 命题。具体编译结果见下列验证记录。

## 本地使用

```powershell
Set-Location -LiteralPath 'D:\Lean\jsp-000513-lean'
. .\scripts\Enter-Lean.ps1
lake build
```

Lean/Mathlib 固定为 v4.34.0。`scripts/Build.ps1` 可执行相同构建并保存日志。安装路径、版本与网络恢复记录见 [环境记录](docs/environment.md)。

## 研究与验证

- [Phase 0 进度、风险与下一步](docs/phase0_status.md)
- [官方题意与论文核查](docs/source_verification.md)
- [论文与 Lean statement 对照](docs/theorem_mapping.md)
- [证明依赖树](docs/proof_dependency.md)
- [Mathlib 基础设施调查](docs/mathlib_survey.md)
- [PoC 编译与公理核查](docs/poc_verification.md)

官方来源：[JSP-000513 题库](https://github.com/TheJustinSunPrize/awards/blob/f4e7173d89dfe91022a185427d63452c8ffbf6ae/problems/catalog-0501-0600.md)；[原论文 arXiv:1806.03880v2](https://arxiv.org/pdf/1806.03880v2)。

## 本地与发布边界

本次仓库从 `yqian215-arch/jsp-000513-lean` 克隆，本地分支为 `phase0-local`。2026-09-17 检查时远程实际是 **Public**，并非此前聊天中预期的 Private；本次没有更改其可见性，新增文件只保存在本地。

未经用户明确确认，不推送、公开成果、更改可见性或提交官方奖项。编译通过的局部 PoC 不代表完整证明、奖项审核或领取资格。

# 家用 Windows 环境记录

检查日期：2026-09-17（Asia/Shanghai）。所有终端与文件操作均在当前家用 Windows 主机执行，没有连接办公电脑或远程执行主机。

## 路径与版本

| 项目 | 实际值 |
| --- | --- |
| Windows | Windows 11 专业版，10.0.22631，64 位 |
| PowerShell | 7.6.5 |
| 仓库 | `D:\Lean\jsp-000513-lean` |
| 本地分支 | `phase0-local` |
| 初始提交 | `535de844126b4b977e6615c6eb32d80a0b226302` |
| 远程 | `https://github.com/yqian215-arch/jsp-000513-lean.git` |
| Git | 2.53.0.windows.3（桌面应用提供的本地 Git） |
| elan | 4.2.4，安装于 `D:\Lean\tools\elan` |
| Mathlib 下载缓存 | `D:\Lean\cache\mathlib` |
| Lean | 4.34.0，commit `293d5d0c0c3f3dded4688b3ccd6a33939ac5102b` |
| Lake | 5.0.0-src+293d5d0，与 Lean 4.34.0 一起安装 |
| Mathlib | v4.34.0，commit `5ed2965256430c3649e86755f9576b54eca72435` |

`lean-toolchain` 固定编译器版本，`lakefile.toml` 固定 Mathlib 发布标签；生成后的 `lake-manifest.json` 固定依赖提交。

## GitHub 检查

已通过已连接 GitHub 插件读取目标仓库，返回 `pull/push/admin` 等权限为 true。此为连接器权限检查，不代表本地 Git 已配置写入凭据；本阶段未测试推送。

**实际可见性为 Public**，与之前聊天中预期的 Private 不符。本次没有更改可见性，没有远程写入、push、奖项提交。原始远程仅有 README；新增成果只在本地。

## 进入环境和构建

在 PowerShell 中：

```powershell
Set-Location -LiteralPath 'D:\Lean\jsp-000513-lean'
. .\scripts\Enter-Lean.ps1
lean --version
lake --version
lake build
```

或运行 `scripts/Build.ps1`，自动保存日志到被 Git 忽略的 `work/`。

没有修改全局 PATH 或全局默认 Lean 工具链。进入脚本仅为当前 PowerShell 进程设置本地 elan、Git 和目录。新的终端需要重新执行进入脚本。Git 路径依赖当前桌面应用的运行时；若应用升级导致路径变化，更新脚本中的 Git 路径，或安装官方 Git for Windows 后使用系统 PATH 中的 Git。

## 安装依据和可复现性

- [elan 官方安装说明](https://github.com/leanprover/elan#installation)。使用官方 v4.2.4 Windows x86_64 安装包；SHA-256 已对照 GitHub release 元数据核验为 `fad2e980a191c15884cc1d80d170ffc5fa84f3774541020145b66d1a644c6111`。
- [Mathlib v4.34.0 工具链](https://github.com/leanprover-community/mathlib4/blob/v4.34.0/lean-toolchain)。选择与该发布版本严格配套的 Lean，而非独立选择不兼容的最新编译器。
- [Mathlib 缓存说明](https://github.com/leanprover-community/mathlib4/blob/v4.34.0/Cache/README.md)。缓存只下载上游预编译依赖；项目本身的证明仍需本地 Lean 检查。

初次 `lake update` 因 GitHub 连接重置在 plausible 依赖下载处退出 1，第二次在 GitHub 连接超时处退出 1。使用当前进程的 Git HTTP/1.1 配置重试后，第三次依赖更新成功（退出 0）；日志分别为 `work/lake-update.log`、`work/lake-update-retry.log`、`work/lake-update-retry2.log`。没有更改全局 Git 网络设置。

随后执行 `lake exe cache get Mathlib.Combinatorics.SimpleGraph.Coloring.Vertex Mathlib.Data.Finset.Powerset Mathlib.Tactic`，全部 3,100 个请求文件下载、解压成功，退出 0；日志为 `work/mathlib-cache.log`。这是所请求模块及其传递依赖的缓存，并非宣称整个 Mathlib 都已经本地编译。

最终项目证明的实际构建状态见 `phase0_status.md` 与 `poc_verification.md`。

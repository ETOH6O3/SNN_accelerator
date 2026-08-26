<#
.SYNOPSIS
    自动运行仿真并随时控制仿真进程
.DESCRIPTION
    该脚本用于自动运行仿真，同时在新开一个终端窗口中读取用户输入，以随时控制仿真进程。
.PARAMETER coe_file
    指定 synapse_mem.coe 文件的路径。默认值是 "$PSScriptRoot\..\..\coe\synapse_mem.coe"。
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [Alias('c')]
    [Alias('cf')]
    [string]$coe_file = "$PSScriptRoot/../../coe/synapse_mem.coe"
)

Set-PSReadLineOption -MaximumHistoryCount 65536

$ScriptDir = $PSScriptRoot

$coe_file = $coe_file.Replace('\', '/')

$TclScript = Join-Path -Path $ScriptDir -ChildPath "auto.tcl"
$CtrlScript = Join-Path -Path $ScriptDir -ChildPath "ctrl.ps1"

# 新开一个 pwsh 终端窗口运行 other.ps1
$proc = Start-Process pwsh -PassThru -ArgumentList '-NoExit', '-File', $CtrlScript

vivado -mode batch -source $TclScript -tclargs "-cf" $coe_file

# 关闭 ctrl.ps1
Stop-Process -Id $proc.Id
<#
.SYNOPSIS
    一键运行所有仿真。

.DESCRIPTION
    根据指定的日志模式和仿真集运行所有仿真。

.PARAMETER log
    指定 sv 仿真平台日志汇总文件名。默认值是 summary.log。

.PARAMETER log_mode
    指定仿真日志模式，允许的模式为 FATAL、ERROR、WARNING、INFO、DEBUG、TRACE。
    默认值是 INFO。

.PARAMETER simsets
    指定要运行的仿真集。例如 "sim_aer sim_udp_1"。
    默认运行所有仿真集：sim_udp_1 sim_upd_2 sim_weight_upd sim_aer sim_snn_acc。

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$log = "summary.log",

    [Parameter(Mandatory=$false)]
    [Alias('lm')]
    [string]$log_mode = "INFO",

    [Parameter(Mandatory=$false)]
    [Alias('s')]
    [string]$simsets = "sim_udp_1 sim_upd_2 sim_weight_upd sim_aer sim_snn_acc"

)

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot

Set-PSReadLineOption -MaximumHistoryCount 65536

# 删除目录下所有的 .log 文件
Get-ChildItem -Path $ScriptDir -Filter *.log -Recurse | Remove-Item -Force

$tcl_path = Join-Path $ScriptDir "run_all.tcl"

vivado -mode batch -notrace -source $tcl_path -tclargs "-s" $simsets "-lm" $log_mode

$exit_code = $LASTEXITCODE

if ($exit_code -ne 0) {
    Write-Host "`e[91m`e[1mVivado simulation failed with exit code $exit_code`e[0m"
    exit $exit_code
}

python3 (Join-Path $ScriptDir "summary.py") --log $log

exit $LASTEXITCODE
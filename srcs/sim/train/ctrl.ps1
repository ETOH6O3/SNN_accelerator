

while ($true) {
    # 读取用户输入
    $command = Read-Host "输入命令（stop/break/continue/check）以控制仿真进程"
    if ($command -eq "stop") {
        # 在本目录创建 stop 文件，通知 Vivado 停止仿真
        $stopFile = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "stop_sim"
        New-Item -Path $stopFile -ItemType File -Force | Out-Null
        Write-Host "已创建 stop 文件，Vivado 将在下一次检查时停止仿真。"
    }

    if ($command -eq "break") {
        # 在本目录创建 break 文件，通知 Vivado 暂停仿真
        $breakFile = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "break_sim"
        New-Item -Path $breakFile -ItemType File -Force | Out-Null
        Write-Host "已创建 break 文件，Vivado 将在下一次检查时暂停仿真。"
    }

    if ($command -eq "continue") {
        # 删除 break 文件，通知 Vivado 继续仿真
        $breakFile = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "break_sim"
        if (Test-Path -Path $breakFile) {
            Remove-Item -Path $breakFile -Force
            Write-Host "已删除 break 文件，Vivado 将在下一次检查时继续仿真。"
        } else {
            Write-Host "没有找到 break 文件，仿真已经在运行中。"
        }
    }

    if ($command -eq "check") {
        # 在本目录创建 check 文件，通知 Vivado 检查仿真状态
        $checkFile = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "check_sim"
        New-Item -Path $checkFile -ItemType File -Force | Out-Null
        Write-Host "已创建 check 文件，Vivado 将在下一次检查时报告仿真状态。"
    }
}


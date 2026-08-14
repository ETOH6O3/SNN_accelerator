<#
.SYNOPSIS
    将 hdf5_poisson_code_reader_for_dpic 的 Debug 输出文件（dll, .a, .exp）
    复制到 SNN_accelerator.sim 所有子文件夹的 behav\xsim 目录。
    遇到被占用的文件时会跳过并给出警告，不会中断脚本。
#>

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot

# 源目录
$SourceDir = Join-Path $ScriptDir "cpp_lib\hdf5_poisson_code_reader_for_dpic\x64\Release"
if (-not (Test-Path $SourceDir -PathType Container)) {
    Write-Error "源目录不存在: $SourceDir"
    exit 1
}


# 生成 .def 和 .a 文件
$dllpath = (Join-Path $SourceDir ".\hdf5_poisson_code_reader_for_dpic.dll").Replace('\','\\')
$defpath = (Join-Path $SourceDir ".\hdf5_poisson_code_reader_for_dpic.def").Replace('\','\\')
$apath = (Join-Path $SourceDir ".\hdf5_poisson_code_reader_for_dpic.a").Replace('\','\\')

$tcl = @"
puts "Generating .def and .a files for hdf5_poisson_code_reader_for_dpic.dll..."
exec pexports $dllpath > $defpath
exec dlltool -d $defpath -D $dllpath -l $apath
puts "Generation completed.
"@

$tcl | vivado -mode tcl

# pexports $dllpath > $defpath
# dlltool -d $defpath -D $dllpath -l $apath


# 获取需要复制的文件（仅该目录下的 .dll, .a, .exp）
$files = Get-ChildItem -Path $SourceDir -File | Where-Object { $_.Extension -in '.dll', '.a', '.exp' }
if ($files.Count -eq 0) {
    Write-Warning "在 $SourceDir 中未找到任何 .dll, .a, .exp 文件"
    exit 0
}
Write-Host "找到 $($files.Count) 个文件待复制。"

# 目标基础目录
$TargetBase = Join-Path $ScriptDir "..\SNN_accelerator.sim"
try {
    $TargetBase = Resolve-Path $TargetBase -ErrorAction Stop
} catch {
    Write-Error "目标基础目录不存在: $TargetBase"
    exit 1
}

# 获取第一级子文件夹
$subDirs = Get-ChildItem -Path $TargetBase -Directory -ErrorAction SilentlyContinue
if ($subDirs.Count -eq 0) {
    Write-Warning "在 $TargetBase 中未找到任何子文件夹"
    exit 0
}

$totalFiles = $files.Count
$copiedCount = 0
$skippedCount = 0

foreach ($dir in $subDirs) {
    $dest = Join-Path $dir.FullName "behav\xsim"
    # 确保目标目录存在
    if (-not (Test-Path $dest -PathType Container)) {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        Write-Verbose "创建目录: $dest" -Verbose
    }
    Write-Host "复制到: $dest"

    foreach ($file in $files) {
        $targetFile = Join-Path $dest $file.Name
        try {
            Copy-Item -LiteralPath $file.FullName -Destination $targetFile -Force -ErrorAction Stop
            # Write-Host "  ✔ $($file.Name)"
            $copiedCount++
        } catch {
            Write-Warning "  ⚠ 无法复制 $($file.Name) : $($_.Exception.Message)"
            $skippedCount++
        }
    }
}

$destCount = $subDirs.Count
Write-Host "操作完成：目标文件夹数: $destCount，成功复制次数: $copiedCount，跳过次数: $skippedCount。" -ForegroundColor Green

if ($skippedCount -gt 0) {
    Write-Host "注意：部分文件因被其他进程占用而无法复制。如需强制复制被占用的文件，可考虑：" -ForegroundColor Yellow
    Write-Host "  1. 以管理员身份运行脚本，并使用 VSS（卷影复制）工具（如 Hobocopy）。" -ForegroundColor Yellow
    Write-Host "  2. 手动关闭占用文件的程序后重新运行脚本。" -ForegroundColor Yellow
}
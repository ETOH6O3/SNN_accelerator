$ScriptDir = $PSScriptRoot

# 参数设置
$server = "127.0.0.1"
$port = 1145

# 创建 TCP 客户端
$client = New-Object System.Net.Sockets.TcpClient
$client.Connect($server, $port)
$stream = $client.GetStream()
$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true

# 发送 Tcl 命令（注意命令末尾加换行符）
$outfile =  (Join-Path $ScriptDir "\coe_and_weight\ram_data.txt").Replace('\','\\')
$tclCmd = "
set mem_obj {/train/SNN_Accelerater_inst/synapse_mem/inst/\native_mem_module.blk_mem_gen_v8_4_11_inst /memory}; set depth 65536 ;set outfile `"ram_data.txt`";set fh [open $outfile w];puts `"trg obj: `$mem_obj`";puts `"begin to export `$depth datas...`";set start_time [clock seconds];for {set i 0} {`$i < `$depth} {incr i} {set val [get_value `$mem_obj\[`$i\]];puts `$fh `$val;if {[expr {`$i % 1000}] == 0} {puts `" already done `$i / `$depth`"}};close `$fh;puts `"Completed! Time used: [expr {[clock seconds] - `$start_time}] s.`";puts `"data is saved in: $outfile`";return [file join [pwd] ram_data.txt]"
$writer.WriteLine($tclCmd)
# $mem_obj = {/train/SNN_Accelerater_inst/synapse_mem/inst/\native_mem_module.blk_mem_gen_v8_4_11_inst /memory}
# $depth = 65536
# $outfile =  (Join-Path $ScriptDir "ram_data.txt").Replace('\','\\')
# $tclCmd = "set fh [open $outfile w];"
# $writer.WriteLine($tclCmd)
# Write-Host "开始导出 $depth 个数据..."
# $tclCmd = "set start_time [clock seconds];for {set i 0} {$i < $depth} {incr i} {set val [get_value $mem_obj\[$i\]];puts $fh $val;if {[expr {$i % 1000}] == 0} {puts `"  已处理 $i / $depth`"}};"
# $writer.WriteLine($tclCmd)
# $tclCmd = "close $fh;puts `"导出完成！耗时 [expr {[clock seconds] - $start_time}] 秒。`";puts `"数据保存在: $outfile`";return [file join [pwd] ram_data.txt];"
# $writer.WriteLine($tclCmd)

# 关闭连接
$reader.Close()
$writer.Close()
$stream.Close()
$client.Close()

# $pyScriptPath1 = Join-Path $ScriptDir "coe_and_weight\draw_weight.py"
# $pyScriptPath2 = Join-Path $ScriptDir "coe_and_weight\gen_resume_synapose_mem_coe.py"

# python $pyScriptPath1
# python $pyScriptPath2
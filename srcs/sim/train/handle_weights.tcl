# ---------- 加载公共包（ANSI 样式常量） ----------
set _tcl_libs [file normalize [file join [file dirname [file normalize [info script]]] ../../tcl_libs]]
lappend auto_path $_tcl_libs
unset _tcl_libs
package require martin::ansi_style

# 一键导入其它包对外暴露的 proc（样式常量）
namespace import ::martin::ansi_style::*

set script_path [file normalize [info script]]
set script_dir  [file dirname $script_path]
puts "[RGB_GRAY][DIM]\[INFO\] tcl script is at $script_path[END]"

set mem_obj {/train/SNN_Accelerater_inst/synapse_mem/inst/\native_mem_module.blk_mem_gen_v8_4_11_inst /memory}; 
set depth 65536 ;
set outfile "$script_dir/coe_and_weight/ram_data.txt";
set fh [open $outfile w];

puts "[RGB_GRAY][DIM]trg obj: $mem_obj[END]";
puts "[RGB_GRAY][DIM]begin to export $depth datas...[END]";

set start_time [clock seconds];

for {set i 0} {$i < $depth} {incr i} {
    set val [get_value $mem_obj\[$i\]];
    puts $fh $val;
    if {[expr {$i % 1000}] == 0} {
        puts "[RGB_GRAY][DIM]already done $i / $depth[END]"
    }
};

close $fh;

puts "Completed! Time used: [expr {[clock seconds] - $start_time}] s.";
puts "data is saved in: $outfile";

exec python $script_dir/coe_and_weight/draw_weight.py -nh
exec python $script_dir/coe_and_weight/gen_resume_synapose_mem_coe.py

return 0;
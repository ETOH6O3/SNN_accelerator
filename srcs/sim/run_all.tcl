# ---------- 加载公共包（ANSI 样式常量 + 终端帮助打印） ----------
set _tcl_libs [file normalize [file join [file dirname [file normalize [info script]]] ../tcl_libs]]
lappend auto_path $_tcl_libs
unset _tcl_libs
package require martin::ansi_style
package require martin::help_msg

# 一键导入其它包对外暴露的 proc（样式常量 + 帮助打印）
namespace import ::martin::ansi_style::*
namespace import ::martin::help_msg::*


set log_mode "INFO"
set simsets {sim_udp_1 sim_upd_2 sim_weight_upd sim_aer sim_snn_acc }
# set simsets {sim_weight_upd}

# ---------- 帮助信息选项（本脚本自定义，由公共包 martin::help_msg 渲染） ----------
set help_options [list \
    [list "[BRIGHT_BLUE]-s[END], [BRIGHT_BLUE]-simsets[END], [BRIGHT_BLUE]--simsets[END] [BRIGHT_YELLOW]<simsets_str>[END]" \
          "Specify the simulation sets. Example: \"sim_aer sim_udp_1\". Default is to run all"] \
    [list "[BRIGHT_BLUE]-l[END], [BRIGHT_BLUE]-lm[END], [BRIGHT_BLUE]--log_mode[END] [BRIGHT_YELLOW]<mode>[END]" \
          "Set log mode, allowed modes are FATAL, ERROR, WARNING, INFO, DEBUG, TRACE. Default is INFO."] \
    [list "[BRIGHT_BLUE]-h[END], [BRIGHT_BLUE]-help[END], [BRIGHT_BLUE]--help[END]" \
          "Show this help message and immediately exit"] \
]

# ---------- 参数解析 ----------
for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]

    switch -glob -- $arg {
        "-s" -
        "-simsets" -
        "--simsets" {
            incr i
            if {$i >= $argc} {
                puts stderr "[RED][BOLD] Error: $arg requires an argument [END]"
                exit 1
            }
            set simsets [split [lindex $argv $i]]
            puts "[RGB_GRAY][DIM] Set simsets: $simsets [END]"
        }
        "-l" -
        "-lm" -
        "--log_mode" {
            incr i
            if {$i >= $argc} {
                puts stderr "[RED][BOLD] Error: $arg requires an argument [END]"
                exit 1
            }
            set log_mode [lindex $argv $i]
            puts "[RGB_GRAY][DIM] Set log_mode: $log_mode [END]"
        }

        "-h" -
        "-help" -
        "--help" {
            print_help $help_options
            exit 0
        }

        "--" {
            # 支持 -- 结束选项，后面参数作为位置参数
            incr i
            break
        }

        default {
            if {[string match "-*" $arg]} {
                puts stderr "[RED][BOLD] Unknown option: $arg [END]"
                puts stderr "Try '--help' for more information."
                exit 1
            } else {
                puts stderr "[RED][BOLD] Unexpected argument: $arg [END]"
                puts stderr "This script does not accept positional arguments."
                exit 1
            }
        }
    }
}



set script_path [file normalize [info script]]
set script_dir  [file dirname $script_path]
puts "[RGB_GRAY][DIM]\[INFO\] tcl script is at $script_path[RST_RGB]"

set proj "$script_dir/../../SNN_accelerator.xpr"
puts "[RGB_GRAY][DIM]\[INFO\] opening project $proj[RST_RGB]"
open_project $proj



set_property -name {xsim.simulate.runtime} -value {0ns} -objects [get_filesets $simsets]

# 保存每个仿真集当前的 verilog_define 到数组
foreach fs $simsets {
    # 检查仿真集是否存在，避免脚本中断
    if {[get_filesets -quiet $fs] ne ""} {
        set orig_defines($fs) [get_property verilog_define [get_filesets $fs]]
        puts "[RGB_GRAY][DIM] Saved $fs : $orig_defines($fs) [END]"
    }
}

set_property verilog_define "VMARTIN_CONSOLE_SUPPORT_ANSI_STYLE=1 VMARTIN_LOG_MODE_DEFAULT=$log_mode VMARTIN_LOG_DIR=$script_dir" [get_filesets $simsets]

set err_flag 0
foreach simset $simsets {
    puts "===== BEGIN SIMSET $simset ====="
    if {[catch {
        launch_simulation -simset $simset -mode behavioral
        run all
        close_sim
    } err]} {
        puts "[RED][BOLD] ERROR in $simset: $err[END]"
        set err_flag 1
        continue
    }
    
    puts "[GREEN][BOLD]========== END SIMSET $simset SUCCESSFULLY ==========[END]"
}

# 恢复原始的 verilog_define
foreach fs $simsets {
    if {[info exists orig_defines($fs)]} {
        set_property verilog_define $orig_defines($fs) [get_filesets $fs]
        puts "[RGB_GRAY][DIM] Restored $fs verilog_define: $orig_defines($fs) [END]"
    }
}

close_project

if {$err_flag} {
    puts "[RED][BOLD]========== END SIMSET WITH ERRORS ==========[END]"
    exit 1
}

puts "[MAGENTA][BOLD]======================================== SIM ALL DONE ========================================[END]"
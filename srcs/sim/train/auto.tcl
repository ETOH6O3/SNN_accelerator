
# ---------- 加载公共包（ANSI 样式常量 + 终端帮助打印） ----------
set _tcl_libs [file normalize [file join [file dirname [file normalize [info script]]] ../../tcl_libs]]
lappend auto_path $_tcl_libs
unset _tcl_libs
package require martin::ansi_style
package require martin::help_msg

# 一键导入其它包对外暴露的 proc（样式常量 + 帮助打印）
namespace import ::martin::ansi_style::*
namespace import ::martin::help_msg::*

set script_path [file normalize [info script]]
set script_dir  [file dirname $script_path]
puts "[RGB_GRAY][DIM]\[INFO\] tcl script is at $script_path[RST_RGB]"

set log_mode "INFO"
set default_coe_file "$script_dir/../../coe/synapse_mem.coe"
set coe_file $default_coe_file

# ---------- 帮助信息选项（本脚本自定义，由公共包 martin::help_msg 渲染） ----------
set help_options [list \
    [list "[BRIGHT_BLUE]-c[END], [BRIGHT_BLUE]-cf[END], [BRIGHT_BLUE]--coe_file[END] [BRIGHT_YELLOW]<absolute path>[END]" \
          "Specify the [BOLD]absolute[END] path to the synapse memory coe file. Default is \"$coe_file\"."] \
    [list "[BRIGHT_BLUE]-l[END], [BRIGHT_BLUE]-lm[END], [BRIGHT_BLUE]--log_mode[END] [BRIGHT_YELLOW]<mode>[END]" \
          "Set log mode, allowed modes are FATAL, ERROR, WARNING, INFO, DEBUG, TRACE. Default is INFO."] \
    [list "[BRIGHT_BLUE]-h[END], [BRIGHT_BLUE]-help[END], [BRIGHT_BLUE]--help[END]" \
          "Show this help message and immediately exit"] \
]

# ---------- 参数解析 ----------
for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]

    switch -glob -- $arg {
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

        "-c" -
        "-cf" -
        "--coe_file" {
            incr i
            if {$i >= $argc} {
                puts stderr "[RED][BOLD] Error: $arg requires an argument [END]"
                exit 1
            }
            set coe_file [lindex $argv $i]
            puts "[RGB_GRAY][DIM] Set coe_file: $coe_file [END]"
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

set proj "$script_dir/../../../SNN_accelerator.xpr"
puts "[RGB_GRAY][DIM]\[INFO\] opening project $proj[RST_RGB]"
open_project $proj

source "$script_dir/socket.tcl"

if {[catch {
    set coe_file [file normalize $coe_file]
    if {![file readable $coe_file]} {
        error "COE file does not exist or is not readable: $coe_file"
    }
    set_property CONFIG.Coe_File $coe_file [get_ips BRAM_12X65536]
    generate_target all [get_files  ${script_dir}/../../../SNN_accelerator.srcs/sources_1/ip/BRAM_12X65536_2/BRAM_12X65536.xci]
    catch { config_ip_cache -export [get_ips -all BRAM_12X65536] }
    export_ip_user_files -of_objects [get_files ${script_dir}/../../../SNN_accelerator.srcs/sources_1/ip/BRAM_12X65536_2/BRAM_12X65536.xci] -no_script -sync -force -quiet
    reset_run BRAM_12X65536_synth_1
    launch_runs BRAM_12X65536_synth_1 -jobs 24
} err ]} {
    puts "[RED][BOLD] Error occurred while generating IP: $err [END]"
    puts "Current coe file is: $coe_file"
    close_project
    exit 1
}


set simsets {train}
set_property -name {xsim.simulate.runtime} -value {0ns} -objects [get_filesets $simsets]
# 保存每个仿真集当前的 verilog_define 到数组
foreach fs $simsets {
    # 检查仿真集是否存在，避免脚本中断
    if {[get_filesets -quiet $fs] ne ""} {
        set orig_defines($fs) [get_property verilog_define [get_filesets $fs]]
        puts "[RGB_GRAY][DIM] Saved $fs : $orig_defines($fs) [END]"
    }
}

# 不记录波形
set_property -name {xsim.simulate.log_all_signals} -value {false} -objects [get_filesets $simsets]
set_property is_enabled true [get_files  ${script_dir}/../../../srcs/sim/train/train_no_log_behav.wcfg]
set_property is_enabled false [get_files  ${script_dir}/../../../SNN_accelerator.srcs/train/imports/train/train_behav.wcfg]

# 设置仿真集的 verilog_define，启用 ANSI 样式输出和日志模式
set_property verilog_define "VMARTIN_CONSOLE_SUPPORT_ANSI_STYLE=1 VMARTIN_LOG_MODE_DEFAULT=$log_mode VMARTIN_LOG_DIR=$script_dir" [get_filesets $simsets]

set stop_file "$script_dir/stop_sim"
set break_file "$script_dir/break_sim"
set check_file "$script_dir/check_sim"
file delete -force $stop_file
file delete -force $break_file
file delete -force $check_file

set err_flag 0
foreach simset $simsets {
    puts "===== BEGIN SIMSET $simset ====="
    if {[catch {
        launch_simulation -simset $simset -mode behavioral
        while {true} {
            source "$script_dir/handle_weights.tcl"
            for {set i 0} {$i < 10} {incr i} {
                if {[file exists $check_file]} {
                    puts "[BRIGHT_YELLOW][DIM]\[INFO\] Check file detected. Checking weights...[END]\r"
                    source "$script_dir/handle_weights.tcl"
                    file delete -force $check_file
                }
                if {[file exists $break_file]} {
                    puts "[BRIGHT_YELLOW][DIM]\[INFO\] Break file detected. Pausing simulation...[END]\r"
                }
                while {[file exists $break_file]} {
                    
                }
                if {[file exists $stop_file]} {
                    break
                }
                run 50ms
            }
            if {[file exists $stop_file]} {
                source "$script_dir/handle_weights.tcl"
                puts "[BRIGHT_YELLOW][DIM]\[INFO\] Stop file detected. Exiting simulation...[END]"
                close_sim
                break
            }
        }
    } err]} {
        # if {[string match "*Interrupt*" $err]} {
        #     # 安全退出
        #     puts "[BRIGHT_YELLOW][DIM]\[INFO\] Simulation interrupted by user. Exiting...[END]"
        #     close_sim
        #     continue
        # } else {
            puts "[RED][BOLD] ERROR in $simset: $err[END]"
            set err_flag 1
            continue 
        # }
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

set_property is_enabled false [get_files  ${script_dir}/../../../srcs/sim/train/train_no_log_behav.wcfg]
set_property is_enabled true  [get_files  ${script_dir}/../../../SNN_accelerator.srcs/train/imports/train/train_behav.wcfg]

close_project

if {$err_flag} {
    puts "[RED][BOLD]========== END SIMSET WITH ERRORS ==========[END]"
    exit 1
}

puts "[MAGENTA][BOLD]======================================== SIM ALL DONE ========================================[END]"
set RED  "\033\[91m"
set DIM  "\033\[2m"
set GREEN  "\033\[92m"
set BOLD  "\033\[1m"
set MAGENTA  "\033\[35m"
set UNDERLINE  "\033\[4m"
set BLUE "\033\[34m"
set BRIGHT_BLUE "\033\[94m"
set BRIGHT_YELLOW "\033\[93m"
set END  "\033\[0m"
set RGB_GRAY  "\033\[38;2;128;128;128m"
set RST_RGB  "\033\[0m"


set log_mode "INFO"
set simsets {sim_udp_1 sim_upd_2 sim_weight_upd sim_aer sim_snn_acc }
# set simsets {sim_weight_upd}

# ---------- 辅助：计算字符串显示长度（忽略 ANSI 颜色代码） ----------
proc display_len {str} {
    regsub -all {\033\[[0-9;]*m} $str "" stripped
    return [string length $stripped]
}

# ---------- 辅助：按单词折行输出描述文本 ----------
# 参数：
#   desc       描述字符串（可能包含颜色代码）
#   indent_col 后续行缩进的列数（即描述起始列）
#   width      终端总宽度
proc print_wrapped {desc indent_col width} {
    # 防止 indent_col 接近 width 导致每行可用宽度为负
    if {$indent_col >= $width} {
        set indent_col 20   ;# 退化处理
    }

    set words [split $desc]
    if {[llength $words] == 0} {
        puts ""
        return
    }

    set current ""          ;# 当前行文本（不含缩进）
    set current_len 0       ;# 当前行显示长度（忽略颜色）
    set first_line true

    foreach word $words {
        if {$current_len == 0} {
            set candidate $word
            set candidate_len [display_len $word]
        } else {
            set candidate "$current $word"
            set candidate_len [expr {$current_len + 1 + [display_len $word]}]
        }

        if {$candidate_len > ($width - $indent_col)} {
            # 输出当前行
            if {$first_line} {
                puts $current
                set first_line false
            } else {
                puts "[string repeat " " $indent_col]$current"
            }
            set current $word
            set current_len [display_len $word]
        } else {
            set current $candidate
            set current_len $candidate_len
        }
    }

    if {$current_len > 0} {
        if {$first_line} {
            puts $current
        } else {
            puts "[string repeat " " $indent_col]$current"
        }
    }
}

# ---------- 辅助：输出一组选项（自动对齐 + 折行） ----------
proc print_options {options} {
    # 1. 计算最长选项的显示宽度
    set max_opt_len 0
    foreach opt $options {
        set opt_str [lindex $opt 0]
        set len [display_len $opt_str]
        if {$len > $max_opt_len} { set max_opt_len $len }
    }
    set desc_col [expr {$max_opt_len + 4}]   ;# 描述起始列 = 最长选项宽 + 4 空格

    # 2. 终端宽度
    set term_width 100

    # 3. 逐项输出
    foreach opt $options {
        set opt_str [lindex $opt 0]
        set desc    [lindex $opt 1]

        # 输出选项字符串，不换行
        puts -nonewline $opt_str

        # 填充空格至描述起始列
        set pad [expr {$desc_col - [display_len $opt_str]}]
        puts -nonewline [string repeat " " $pad]

        # 输出描述（折行，后续行缩进 desc_col）
        print_wrapped $desc $desc_col $term_width
    }
}

# ---------- 帮助信息 ----------
proc print_help {} {
    global argv0
    global RED DIM GREEN BOLD MAGENTA UNDERLINE BLUE BRIGHT_BLUE BRIGHT_YELLOW END RGB_GRAY RST_RGB

    puts ""
    puts "$BOLD${BLUE}Usage:${END}"
    puts "  vivado ${BRIGHT_BLUE}-mode${END} batch ${BRIGHT_BLUE}-notrace${END} ${BRIGHT_BLUE}-source${END} $argv0 ${BRIGHT_BLUE}-tclargs${END} \[options\]"
    puts ""
    puts "$BOLD${BLUE}General Options:${END}"

    set options [list \
        [list "${BRIGHT_BLUE}-s${END}, ${BRIGHT_BLUE}-simsets${END}, ${BRIGHT_BLUE}--simsets${END} ${BRIGHT_YELLOW}<simsets_str>${END}" \
              "Specify the simulation sets. Example: \"sim_aer sim_udp_1\". Default is to run all"] \
        [list "${BRIGHT_BLUE}-l${END}, ${BRIGHT_BLUE}-lm${END}, ${BRIGHT_BLUE}--log_mode${END} ${BRIGHT_YELLOW}<mode>${END}" \
              "Set log mode, allowed modes are FATAL, ERROR, WARNING, INFO, DEBUG, TRACE. Default is INFO."] \
        [list "${BRIGHT_BLUE}-h${END}, ${BRIGHT_BLUE}-help${END}, ${BRIGHT_BLUE}--help${END}" \
              "Show this help message and immediately exit"] \
    ]

    print_options $options
}

# ---------- 参数解析 ----------
for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]

    switch -glob -- $arg {
        "-s" -
        "-simsets" -
        "--simsets" {
            incr i
            if {$i >= $argc} {
                puts stderr "$RED$BOLD Error: $arg requires an argument $END"
                exit 1
            }
            set simsets [split [lindex $argv $i]]
            puts "$RGB_GRAY$DIM Set simsets: $simsets $END"
        }
        "-l" -
        "-lm" -
        "--log_mode" {
            incr i
            if {$i >= $argc} {
                puts stderr "$RED$BOLD Error: $arg requires an argument $END"
                exit 1
            }
            set log_mode [lindex $argv $i]
            puts "$RGB_GRAY$DIM Set log_mode: $log_mode $END"
        }

        "-h" -
        "-help" -
        "--help" {
            print_help
            exit 0
        }

        "--" {
            # 支持 -- 结束选项，后面参数作为位置参数
            incr i
            break
        }

        default {
            if {[string match "-*" $arg]} {
                puts stderr "$RED$BOLD Unknown option: $arg $END"
                puts stderr "Try '--help' for more information."
                exit 1
            } else {
                puts stderr "$RED$BOLD Unexpected argument: $arg $END"
                puts stderr "This script does not accept positional arguments."
                exit 1
            }
        }
    }
}



set script_path [file normalize [info script]]
set script_dir  [file dirname $script_path]
puts "$RGB_GRAY$DIM\[INFO\] tcl script is at $script_path$RST_RGB"

set proj "$script_dir/../../SNN_accelerator.xpr"
puts "$RGB_GRAY$DIM\[INFO\] opening project $proj$RST_RGB"
open_project $proj



set_property -name {xsim.simulate.runtime} -value {0ns} -objects [get_filesets $simsets]
# Behavioral simulation does not use implementation SDF. Disable primitive timing
# checks to avoid false setup/hold warnings from XPM FIFO RAMB18E1 models.
set_property -name {xsim.elaborate.xelab.more_options} -value {-notimingchecks} -objects [get_filesets $simsets]


# 保存每个仿真集当前的 verilog_define 到数组
foreach fs $simsets {
    # 检查仿真集是否存在，避免脚本中断
    if {[get_filesets -quiet $fs] ne ""} {
        set orig_defines($fs) [get_property verilog_define [get_filesets $fs]]
        puts "$RGB_GRAY$DIM Saved $fs : $orig_defines($fs) $END"
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
        puts "$RED$BOLD ERROR in $simset: $err$END"
        set err_flag 1
        continue
    }
    
    puts "$GREEN$BOLD========== END SIMSET $simset SUCCESSFULLY ==========$END"
}

# 恢复原始的 verilog_define
foreach fs $simsets {
    if {[info exists orig_defines($fs)]} {
        set_property verilog_define $orig_defines($fs) [get_filesets $fs]
        puts "$RGB_GRAY$DIM Restored $fs verilog_define: $orig_defines($fs) $END"
    }
}

close_project

if {$err_flag} {
    puts "$RED$BOLD========== END SIMSET $simset WITH ERRORS ==========$END"
    exit 1
}

puts "$MAGENTA$BOLD======================================== SIM ALL DONE ========================================$END"
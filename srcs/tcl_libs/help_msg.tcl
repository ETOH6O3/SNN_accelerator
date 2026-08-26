#=============================================================================
# Package   : martin::help_msg
# 说明      : 终端帮助信息打印包。提供选项列表的自动对齐、折行输出与帮助信息打印。
#
# 命名空间结构 :
#   martin::help_msg            - 对外暴露 : print_help
#   martin::help_msg::__details - 实现细节 : display_len / print_wrapped / print_options
#
# 使用方法 :
#   package require martin::help_msg
#   namespace import ::martin::help_msg::*
#   print_help $my_options
#=============================================================================
package require martin::ansi_style
package provide martin::help_msg 1.0

namespace eval ::martin::help_msg {
    # 一键导入 ansi_style 包的样式常量函数
    namespace import ::martin::ansi_style::*

    # ==================== 实现细节（不对外暴露） ====================
    namespace eval __details {
        # 计算字符串显示长度（忽略 ANSI 颜色代码）
        proc display_len {str} {
            regsub -all {\033\[[0-9;]*m} $str "" stripped
            return [string length $stripped]
        }

        # 按单词折行输出描述文本
        # 参数：
        #   desc       描述字符串（可能包含颜色代码）
        #   indent_col 后续行缩进的列数（即描述起始列）
        #   width      终端总宽度
        proc print_wrapped {desc indent_col width} {
            # 防止 indent_col 接近 width 导致每行可用宽度为负
            if {$indent_col >= $width} {
                set indent_col 20   ;# 退化处理
            }

            set __temp1 [regsub -all " " $desc "\x1F \x1F"]
            set __temp2 [regsub -all "/" $__temp1 "\x1F/\x1F"]
            set words [split $__temp2 "\x1F"]
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
                    set candidate "$current$word"
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

        # 输出一组选项（自动对齐 + 折行）
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
            set term_width 120

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
    }

    # ==================== 对外暴露 ====================
    # 打印帮助信息。options 为 {选项文本 描述} 的列表，由调用方提供。
    proc print_help {options} {
        global argv0

        puts ""
        puts "[BOLD][BLUE]Usage:[END]"
        puts "  vivado [BRIGHT_BLUE]-mode[END] batch [BRIGHT_BLUE]-notrace[END] [BRIGHT_BLUE]-source[END] $argv0 [BRIGHT_BLUE]-tclargs[END] \[options\]"
        puts ""
        puts "[BOLD][BLUE]General Options:[END]"

        __details::print_options $options
    }

    namespace export print_help
}

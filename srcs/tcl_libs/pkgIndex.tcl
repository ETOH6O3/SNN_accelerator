#=============================================================================
# pkgIndex.tcl - srcs/tcl_libs 包索引
#
# 由 Tcl 的 package 机制自动读取。使用前需将本目录加入 auto_path：
#   lappend auto_path <srcs/tcl_libs 绝对路径>
#
# 提供的包：
#   martin::ansi_style  - ANSI 控制台样式常量（只读函数）
#   martin::help_msg    - 终端帮助信息打印（自动对齐/折行/帮助输出）
#=============================================================================
if {![package vsatisfies [package provide Tcl] 8.5]} {return}

package ifneeded martin::ansi_style 1.0 [list source [file join $dir ansi_style.tcl]]
package ifneeded martin::help_msg   1.0 [list source [file join $dir help_msg.tcl]]

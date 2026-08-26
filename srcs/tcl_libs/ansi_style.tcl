#=============================================================================
# Package   : martin::ansi_style
# 说明      : ANSI 控制台样式常量包。
#             对外以“只读函数”形式提供一组 ANSI 转义序列，供控制台彩色/样式输出使用。
#
# 命名空间结构 :
#   martin::ansi_style            - 对外暴露的样式常量函数 (RED, DIM, ...)
#   martin::ansi_style::__details - 实现细节（不对外暴露）
#
# 使用方法 :
#   package require martin::ansi_style
#   namespace import ::martin::ansi_style::*
#   puts "[RED] hello[END]"
#=============================================================================
package provide martin::ansi_style 1.0

namespace eval ::martin::ansi_style {
    # ==================== 实现细节（不对外暴露） ====================
    namespace eval __details {
        # 内部：样式码唯一来源（名字 -> 已解析的 ANSI 转义序列）
        proc _code {name} {
            switch -- $name {
                RED           { return "\033\[91m" }
                DIM           { return "\033\[2m" }
                GREEN         { return "\033\[92m" }
                BOLD          { return "\033\[1m" }
                MAGENTA       { return "\033\[35m" }
                UNDERLINE     { return "\033\[4m" }
                BLUE          { return "\033\[34m" }
                BRIGHT_BLUE   { return "\033\[94m" }
                BRIGHT_YELLOW { return "\033\[93m" }
                END           { return "\033\[0m" }
                RGB_GRAY      { return "\033\[38;2;128;128;128m" }
                RST_RGB       { return "\033\[0m" }
                default       { return "" }
            }
        }
    }

    # ==================== 对外暴露的只读常量函数 ====================
    proc RED           {} { return [__details::_code RED] }
    proc DIM           {} { return [__details::_code DIM] }
    proc GREEN         {} { return [__details::_code GREEN] }
    proc BOLD          {} { return [__details::_code BOLD] }
    proc MAGENTA       {} { return [__details::_code MAGENTA] }
    proc UNDERLINE     {} { return [__details::_code UNDERLINE] }
    proc BLUE          {} { return [__details::_code BLUE] }
    proc BRIGHT_BLUE   {} { return [__details::_code BRIGHT_BLUE] }
    proc BRIGHT_YELLOW {} { return [__details::_code BRIGHT_YELLOW] }
    proc END           {} { return [__details::_code END] }
    proc RGB_GRAY      {} { return [__details::_code RGB_GRAY] }
    proc RST_RGB       {} { return [__details::_code RST_RGB] }

    namespace export RED DIM GREEN BOLD MAGENTA UNDERLINE BLUE BRIGHT_BLUE BRIGHT_YELLOW END RGB_GRAY RST_RGB
}

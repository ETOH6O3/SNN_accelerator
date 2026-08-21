
package logger_pkg;

`define __VMARTIN_STRINGFY(x) `"x`"

`ifdef VMARTIN_LOG_DIR
  `define __VMARTIN_LOGGER_PKG_LOG_PATH {`__VMARTIN_STRINGFY(`VMARTIN_LOG_DIR), "/", __logger_file_name}
  `define __VMARTIN_LOGGER_PKG_OPEN_LOG_CMD(mode = "a") file = $fopen(`__VMARTIN_LOGGER_PKG_LOG_PATH, mode); if (file == 0) begin $fatal(1, "Failed to open log file"); end
  `define __VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD $fclose(file);
  `define __VMARTIN_LOGGER_PKG_LOG_CMD(message, __end = "\n ") $fwrite(file, "%0s%0s", message, __end);
`endif
`ifndef VMARTIN_LOG_DIR
  `define __VMARTIN_LOGGER_PKG_LOG_PATH 
  `define __VMARTIN_LOGGER_PKG_OPEN_LOG_CMD(mode = "a") ;
  `define __VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD ;
  `define __VMARTIN_LOGGER_PKG_LOG_CMD(message, __end = "\n ") ;
`endif
`ifndef VMARTIN_LOG_MODE_DEFAULT
  `define VMARTIN_LOG_MODE_DEFAULT INFO
`endif

  // ------------------------------------------ 控制台输出样式与颜色控制 --------------------------------------------------

  // ANSI 样式与颜色枚举（整数值对应 SGR 参数）
  typedef enum int {
    // ----- 重置所有属性 -----
    RESET = 0,  // 关闭所有属性（恢复默认样式）

    // ----- 字体样式（SGR 1~9） -----
    BOLD          = 1,  // 粗体/增强强度
    DIM           = 2,  // 弱光（降低强度）
    ITALIC        = 3,  // 斜体（部分终端支持）
    UNDERLINE     = 4,  // 下划线（单线）
    BLINK         = 5,  // 缓慢闪烁（通常 < 150 次/分钟）
    INVERSE       = 7,  // 前景色与背景色互换
    HIDDEN        = 8,  // 隐藏（不可见，但文本仍可被选中）
    STRIKETHROUGH = 9,  // 删除线（贯穿线）

    // ----- 标准前景色（SGR 30~37） -----
    FG_BLACK   = 30,  // 前景色：黑色
    FG_RED     = 31,  // 前景色：红色
    FG_GREEN   = 32,  // 前景色：绿色
    FG_YELLOW  = 33,  // 前景色：黄色
    FG_BLUE    = 34,  // 前景色：蓝色
    FG_MAGENTA = 35,  // 前景色：品红
    FG_CYAN    = 36,  // 前景色：青色
    FG_WHITE   = 37,  // 前景色：白色

    // ----- 标准背景色（SGR 40~47） -----
    BG_BLACK   = 40,  // 背景色：黑色
    BG_RED     = 41,  // 背景色：红色
    BG_GREEN   = 42,  // 背景色：绿色
    BG_YELLOW  = 43,  // 背景色：黄色
    BG_BLUE    = 44,  // 背景色：蓝色
    BG_MAGENTA = 45,  // 背景色：品红
    BG_CYAN    = 46,  // 背景色：青色
    BG_WHITE   = 47,  // 背景色：白色

    // ----- 亮前景色（SGR 90~97，高亮/亮色） -----
    FG_BRIGHT_BLACK   = 90,  // 亮前景色：亮黑（深灰）
    FG_BRIGHT_RED     = 91,  // 亮前景色：亮红
    FG_BRIGHT_GREEN   = 92,  // 亮前景色：亮绿
    FG_BRIGHT_YELLOW  = 93,  // 亮前景色：亮黄
    FG_BRIGHT_BLUE    = 94,  // 亮前景色：亮蓝
    FG_BRIGHT_MAGENTA = 95,  // 亮前景色：亮品红
    FG_BRIGHT_CYAN    = 96,  // 亮前景色：亮青
    FG_BRIGHT_WHITE   = 97,  // 亮前景色：亮白

    // ----- 亮背景色（SGR 100~107，高亮背景） -----
    BG_BRIGHT_BLACK   = 100,  // 亮背景色：亮黑（深灰背景）
    BG_BRIGHT_RED     = 101,  // 亮背景色：亮红背景
    BG_BRIGHT_GREEN   = 102,  // 亮背景色：亮绿背景
    BG_BRIGHT_YELLOW  = 103,  // 亮背景色：亮黄背景
    BG_BRIGHT_BLUE    = 104,  // 亮背景色：亮蓝背景
    BG_BRIGHT_MAGENTA = 105,  // 亮背景色：亮品红背景
    BG_BRIGHT_CYAN    = 106,  // 亮背景色：亮青背景
    BG_BRIGHT_WHITE   = 107   // 亮背景色：亮白背景
  } ansi_style_e;

  // --------------------- 常用样式组合 ---------------------

  // ----- 日志/调试级别 -----
  localparam ansi_style_e DebugStyle[2]        = '{DIM, FG_BRIGHT_BLACK};      // 调试（灰色）
  localparam ansi_style_e TraceStyle[1]        = '{FG_BRIGHT_CYAN};            // 追踪（亮青）
  localparam ansi_style_e FatalStyle[3]        = '{BOLD, FG_YELLOW, BG_RED};   // 致命错误（加粗并更改为红色背景黄色）
  localparam ansi_style_e FatalStyle2[3]       = '{BOLD, FG_WHITE, BG_RED};    // 致命错误（白字红底粗体）
  localparam ansi_style_e ErrorStyle[2]        = '{BOLD, FG_RED};              // 错误（红色粗体）
  localparam ansi_style_e BgWarningStyle[2]    = '{BG_YELLOW, FG_BLACK};       // 黄色背景黑字（警告）
  localparam ansi_style_e WarningStyle[2]      = '{BOLD, FG_YELLOW};           // 警告（黄色粗体）
  localparam ansi_style_e SuccessStyle[2]      = '{BOLD, FG_GREEN};            // 成功（绿色粗体）
  // ----- 文本结构与强调 -----
  localparam ansi_style_e StrongStyle[2]       = '{BOLD, UNDERLINE};           // 强强调
  localparam ansi_style_e PathStyle[2]         = '{UNDERLINE, FG_BRIGHT_BLUE}; // 路径/链接
  localparam ansi_style_e KeywordStyle[1]      = '{FG_BRIGHT_MAGENTA};         // 关键字/常量
  localparam ansi_style_e NumberStyle[1]       = '{FG_BRIGHT_YELLOW};          // 数字/数值
  // ----- 状态与进度 -----
  localparam ansi_style_e PendingStyle[2]      = '{BLINK, FG_CYAN};            // 进行中/等待（闪烁）
  localparam ansi_style_e DoneInverseStyle[2]  = '{INVERSE, FG_GREEN};         // 完成反色（绿底黑字）
  localparam ansi_style_e SkipStyle[2]         = '{DIM, FG_WHITE};             // 跳过/忽略
  // ----- 纯提醒/提示/通知（非错误、非警告） -----
  localparam ansi_style_e NoticeStyle[1]       = '{FG_BRIGHT_CYAN};            // 中性提醒（最常用）
  localparam ansi_style_e PromptStyle[2]       = '{BOLD, FG_BRIGHT_BLUE};      // 交互提示（如"请输入您的选择："）
  localparam ansi_style_e MutedStyle[2]        = '{DIM, FG_WHITE};             // 辅助注释（如时间戳、括号说明）
  localparam ansi_style_e HighlightNote[2]     = '{UNDERLINE, FG_BRIGHT_WHITE};// 高亮提示（不紧急的重点提醒）
  // ----- 其它组合 -----
  localparam ansi_style_e CodeBlockStyle[2]    = '{FG_BLACK, BG_BRIGHT_CYAN};  // 代码引用（黑字亮青底）  
  localparam ansi_style_e HighlightStyle[2]    = '{UNDERLINE, FG_BRIGHT_WHITE};// 高亮（下划线白色）
  localparam ansi_style_e TitleStyle[2]        = '{BOLD, FG_BRIGHT_WHITE};     // 标题（加粗白色）
  localparam ansi_style_e StrikeStyle[2]       = '{STRIKETHROUGH, FG_RED};     // 删除线（红色）
  localparam ansi_style_e BgHighlightStyle[2]  = '{BG_BRIGHT_BLUE, FG_WHITE};  // 蓝色背景白字（高亮）

  bit __resume_style_ansi_or_rgb = 1;  // 1: ANSI, 0: RGB
  ansi_style_e __resume_style[] = '{RESET};
  string __f_resume_rgb_style_cmd = " \033[39m";  // 前景
  string __b_resume_rgb_style_cmd = " \033[49m";  // 背景


  function automatic string ansi_style_combo_to_string(ansi_style_e style_combo[]);
    string seq = "\033[";
    for (int i = 0; i < style_combo.size(); i++) begin
      if (i != 0) seq = {seq, ";"};
      seq = {seq, $sformatf("%0d", style_combo[i])};
    end
    return {seq, "m"};
  endfunction

  function automatic void set_ansi_style(ansi_style_e style_combo[], bit change_resume = 1/*置 0 可配合 resume_style 实现临时修改*/);
    string seq = ansi_style_combo_to_string(style_combo);
`ifdef VMARTIN_CONSOLE_SUPPORT_ANSI_STYLE
    $write("%s", seq);
`endif
    if (change_resume) begin
      __resume_style_ansi_or_rgb = 1;
      __resume_style = style_combo;
    end
  endfunction

  function automatic void resume_style();
    if (__resume_style_ansi_or_rgb) begin
      set_ansi_style(__resume_style);
    end else begin
      $write("%s", __f_resume_rgb_style_cmd);
      $write("%s", __b_resume_rgb_style_cmd);
    end
  endfunction

  function automatic void reset_style();
    set_ansi_style('{RESET});
    __resume_style_ansi_or_rgb = 1;
    __resume_style = '{RESET};
  endfunction

  function automatic void set_ansi_style_rgb(int r, int g, int b, bit foreground = 1,
                                             bit change_resume = 1);
    string esc = $sformatf("%c", 27);  // ASCII ESC字符
    string mode = foreground ? "38" : "48";  // 38:前景, 48:背景
    // 格式: ESC[38;2;R;G;Bm 或 ESC[48;2;R;G;Bm
`ifdef VMARTIN_CONSOLE_SUPPORT_ANSI_STYLE
    $write("%s[%s;2;%0d;%0d;%0dm", esc, mode, r, g, b);
`endif
    if (change_resume) begin
      if (foreground) begin
        __f_resume_rgb_style_cmd = $sformatf("%s[%s;2;%0d;%0d;%0dm", esc, mode, r, g, b);
      end else begin
        __b_resume_rgb_style_cmd = $sformatf("%s[%s;2;%0d;%0d;%0dm", esc, mode, r, g, b);
      end
    end
  endfunction

  // ------------------------------------------ 增强版日志管理器 --------------------------------------------------
  class logger;

    typedef enum int {
      FATAL = 0,
      ERROR = 1,
      WARNING = 2,
      INFO = 3,
      DEBUG = 4,
      TRACE = 5
    } output_level_e;

    local const output_level_e current_level;
    integer file;
    string __logger_file_name;

    function new(output_level_e level = `VMARTIN_LOG_MODE_DEFAULT, string logger_file_name = "vmartin_logger.log");
      string init_message = $sformatf("Logger initialized!");
      current_level = level;
      __logger_file_name = logger_file_name;
      // 初始化日志文件
      `__VMARTIN_LOGGER_PKG_OPEN_LOG_CMD("w");
      `__VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD;
      info(init_message);
`ifdef VMARTIN_LOG_DIR
      set_ansi_style(HighlightNote, 0);
      $display("Logs will be also written to: %s", `__VMARTIN_LOGGER_PKG_LOG_PATH);
      resume_style();
`endif
`ifndef VMARTIN_LOG_DIR
      set_ansi_style(NoticeStyle, 0);
      info("You can define VMARTIN_LOG_DIR to specify the log directory. Example: C:/verilog/logs (`\"\"` is not needed)");
      resume_style();
`endif
    endfunction  //new

    function automatic void display(string message);
      string log_message = $sformatf("%0s", message);
      $display("%s", log_message);
      `__VMARTIN_LOGGER_PKG_OPEN_LOG_CMD("a");
      `__VMARTIN_LOGGER_PKG_LOG_CMD(log_message);
      `__VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD;
    endfunction

    function automatic void write(string message);
      string log_message = $sformatf("%0s", message);
      $write("%s", log_message);
      `__VMARTIN_LOGGER_PKG_OPEN_LOG_CMD("a");
      `__VMARTIN_LOGGER_PKG_LOG_CMD(log_message, "");
      `__VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD;
    endfunction

    function automatic void debug(string message);
      string log_message = $sformatf("[debug|%0t] %0s", $time, message);
      if (current_level >= DEBUG) begin
        set_ansi_style(DebugStyle, 1);
        $display("%s", log_message);
        resume_style();
        `__VMARTIN_LOGGER_PKG_OPEN_LOG_CMD("a");
        `__VMARTIN_LOGGER_PKG_LOG_CMD(log_message);
        `__VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD;
      end
    endfunction

    function automatic void trace(string message);
      string log_message = $sformatf("[trace|%0t] %0s", $time, message);
      if (current_level >= TRACE) begin
        set_ansi_style(TraceStyle, 1);
        $display("%s", log_message);
        resume_style();
        `__VMARTIN_LOGGER_PKG_OPEN_LOG_CMD("a");
        `__VMARTIN_LOGGER_PKG_LOG_CMD(log_message);
        `__VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD;
      end
    endfunction

    function automatic void info(string message);
      string log_message = $sformatf("[info|%0t] %0s", $time, message);
      if (current_level >= INFO) begin
        set_ansi_style_rgb(128, 128, 128, 1, 0);  // 更改为灰色
        $display("%s", log_message);
        resume_style();
        `__VMARTIN_LOGGER_PKG_OPEN_LOG_CMD("a");
        `__VMARTIN_LOGGER_PKG_LOG_CMD(log_message);
        `__VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD;
      end
    endfunction
    function automatic void warning(string message);
      string log_message = $sformatf("[warning|%0t] %0s", $time, message);
      if (current_level >= WARNING) begin
        set_ansi_style(WarningStyle, 0);  // 加粗并更改为黄色
        $display("%s", log_message);
        resume_style();
        `__VMARTIN_LOGGER_PKG_OPEN_LOG_CMD("a");
        `__VMARTIN_LOGGER_PKG_LOG_CMD(log_message);
        `__VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD;
      end
    endfunction  // warning
    function automatic void error(string message);
      string log_message = $sformatf("[error|%0t] %0s", $time, message);
      if (current_level >= ERROR) begin
        set_ansi_style(ErrorStyle, 0);  // 加粗并更改为红色
        $display("%s", log_message);
        resume_style();
        `__VMARTIN_LOGGER_PKG_OPEN_LOG_CMD("a");
        `__VMARTIN_LOGGER_PKG_LOG_CMD(log_message);
        `__VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD;
      end
    endfunction  //error
    function automatic void fatal(string message);
      string log_message = $sformatf("[fatal|%0t] %0s", $time, message);
      if (current_level >= FATAL) begin
        set_ansi_style(FatalStyle, 0);  // 加粗并更改为红色背景黄色
        $display("%s", log_message);
        resume_style();
        `__VMARTIN_LOGGER_PKG_OPEN_LOG_CMD("a");
        `__VMARTIN_LOGGER_PKG_LOG_CMD(log_message);
        `__VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD;
        $fatal(1, "%s", log_message);
      end
    endfunction  //fatal
  endclass  //logger


endpackage

`undef __VMARTIN_LOGGER_PKG_LOG_PATH
`undef __VMARTIN_LOGGER_PKG_OPEN_LOG_CMD
`undef __VMARTIN_LOGGER_PKG_CLOSE_LOG_CMD
`undef __VMARTIN_LOGGER_PKG_LOG_CMD

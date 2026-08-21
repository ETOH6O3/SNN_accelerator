# 处理客户端连接
proc handleClient {sock addr port} {
    fileevent $sock readable [list processCommands $sock]
}

# 处理接收到的命令并返回结果
proc processCommands {sock} {
    if {[gets $sock line] < 0} {
        close $sock
        return
    }
    # 执行命令并捕获输出
    if {[catch {eval $line} result]} {
        set output "Error: $result"
    } else {
        set output $result
    }
    puts $sock $output
    flush $sock
}

proc rputs {msg} {
    puts $msg          ;# 输出到 Vivado 控制台
    return $msg        ;# 返回给客户端
}

# 在端口 1145 上启动服务器

# 自定义函数：根据端口号关闭对应的 server socket（Vivado 兼容版）
proc close_port {pnum} {
    foreach ch [file channels] {
        if {[catch {fconfigure $ch -sockname} sockInfo]} {
            continue
        }
        if {[llength $sockInfo] >= 2 && [lindex $sockInfo 1] == $pnum} {
            puts "找到占用端口 $pnum 的通道: $ch，正在关闭..."
            catch {close $ch}
            return 0
        }
    }
    puts "端口 $pnum 当前未被本进程占用。"
    return 1
}

if {[info exists ::serverSocket]} {
    catch {close $::serverSocket}
    unset -nocomplain ::serverSocket
}

close_port 1145

# 将端口号存入变量
set ::serverSocket [socket -server handleClient 1145]
# fconfigure $::serverSocket -reuseaddr 1

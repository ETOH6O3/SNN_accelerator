# �����ͻ�������
proc handleClient {sock addr port} {
    fileevent $sock readable [list processCommands $sock]
}

# �������յ���������ؽ��
proc processCommands {sock} {
    if {[gets $sock line] < 0} {
        close $sock
        return
    }
    # ִ������������
    if {[catch {eval $line} result]} {
        set output "Error: $result"
    } else {
        set output $result
    }
    puts $sock $output
    flush $sock
}

proc rputs {msg} {
    puts $msg          ;# ����� Vivado ����̨
    return $msg        ;# ���ظ��ͻ���
}

# �ڶ˿� 1145 ������������

# �Զ��庯�������ݶ˿ںŹرն�Ӧ�� server socket��Vivado ���ݰ棩
proc close_port {pnum} {
    foreach ch [file channels] {
        if {[catch {fconfigure $ch -sockname} sockInfo]} {
            continue
        }
        if {[llength $sockInfo] >= 2 && [lindex $sockInfo 1] == $pnum} {
            puts "�ҵ�ռ�ö˿� $pnum ��ͨ��: $ch�����ڹر�..."
            catch {close $ch}
            return 0
        }
    }
    puts "�˿� $pnum ��ǰδ��������ռ�á�"
    return 1
}

if {[info exists ::serverSocket]} {
    catch {close $::serverSocket}
    unset -nocomplain ::serverSocket
}

close_port 1145

# ���˿ںŴ������
set ::serverSocket [socket -server handleClient 1145]
# fconfigure $::serverSocket -reuseaddr 1

# Handle client connection
proc handleClient {sock addr port} {
    fileevent $sock readable [list processCommands $sock]
}

# Process the received command and return result
proc processCommands {sock} {
    if {[gets $sock line] < 0} {
        close $sock
        return
    }
    # Execute the command and set output
    if {[catch {eval $line} result]} {
        set output "Error: $result"
    } else {
        set output $result
    }
    puts $sock $output
    flush $sock
}

proc rputs {msg} {
    puts $msg          ;# Print to Vivado console
    return $msg        ;# Return to client
}

# Start server on port 1145

# Custom proc to close the server socket on the given port (Vivado Tcl version)
proc close_port {pnum} {
    foreach ch [file channels] {
        if {[catch {fconfigure $ch -sockname} sockInfo]} {
            continue
        }
        if {[llength $sockInfo] >= 2 && [lindex $sockInfo 1] == $pnum} {
            puts "Found channel $ch occupying port $pnum. Closing..."
            catch {close $ch}
            return 0
        }
    }
    puts "Port $pnum is not currently occupied."
    return 1
}

if {[info exists ::serverSocket]} {
    catch {close $::serverSocket}
    unset -nocomplain ::serverSocket
}

# Create socket on port
set ::serverSocket [socket -server handleClient 1145]
# fconfigure $::serverSocket -reuseaddr 1
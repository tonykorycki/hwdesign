set p1 [get_parts xc7z020clg400-1]
set p2 [get_parts xczu48dr-ffvg1517-2-e]
puts "PYNQ=[llength $p1]"
puts "RFSOC=[llength $p2]"
set zynq [lsort [get_parts xc7z*]]
puts "ZYNQ_COUNT=[llength $zynq]"
if {[llength $zynq] > 0} { puts "ZYNQ_SAMPLE=[lindex $zynq 0]" }
exit

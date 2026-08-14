set p1 [get_parts xc7z020clg400-1]
set p2 [get_parts xczu48dr-ffvg1517-2-e]
puts "PYNQ=[llength $p1]"
puts "RFSOC=[llength $p2]"
set any [get_parts *]
puts "TOTAL=[llength $any]"
if {[llength $any] > 0} {
  puts "FIRST=[lindex $any 0]"
}
exit

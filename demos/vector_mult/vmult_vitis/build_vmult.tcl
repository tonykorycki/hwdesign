open_project vmult_hls -reset
set_top vec_mult

add_files -cflags "-Iinclude" src/vmult.cpp
add_files -tb testbench/tb_vmult.cpp

open_solution "solution1" -reset
set_part {xa7a12tcpg238-2I}
create_clock -period 10 -name default

csim_design
csynth_design
cosim_design
export_design -format ip_catalog
open_project poly_vec_hls -reset
set_top poly_vec

add_files -cflags "-Iinclude" src/poly_vec.cpp
add_files -tb testbench/tb_poly_vec.cpp

open_solution "solution1" -reset
set_part {xczu48dr-ffvg1517-2-e}
create_clock -period 3 -name default

csim_design
csynth_design
cosim_design
export_design -format ip_catalog
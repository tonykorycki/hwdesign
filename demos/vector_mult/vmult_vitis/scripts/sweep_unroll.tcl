set unroll_factors {1 2 4 8}

# Choose target part:
# 1) If HLS_PART is set, try it first.
# 2) Then fall back to known parts used in this repo.
set candidate_parts [list]
if {[info exists ::env(HLS_PART)] && $::env(HLS_PART) ne ""} {
    lappend candidate_parts $::env(HLS_PART)
}
lappend candidate_parts \
    xa7a12tcpg238-2I \
    xc7z020clg400-1 \
    xczu48dr-ffvg1517-2-e

# Override clock period with HLS_CLK_PERIOD_NS if desired.
set clock_period_ns 4.0
if {[info exists ::env(HLS_CLK_PERIOD_NS)] && $::env(HLS_CLK_PERIOD_NS) ne ""} {
    set clock_period_ns $::env(HLS_CLK_PERIOD_NS)
}

puts "Using clock period (ns): $clock_period_ns"

foreach uf $unroll_factors {

    # Set the solution and open the project
    # Note we do not do `open_project vmult_hls --reset` 
    # since we want to maintain multiple solutions
    set sol_name "sol_uf$uf"
    open_project vmult_hls 
    set_top vec_mult

    # Pass UNROLL_FACTOR as a macro
    add_files -cflags "-Iinclude -DPIPELINE_EN=1 -DUNROLL_FACTOR=$uf" src/vmult.cpp
    add_files -tb testbench/tb_vmult.cpp

    open_solution $sol_name -reset

    set target_part ""
    set part_error ""
    foreach p $candidate_parts {
        if {[catch {set_part $p} err]} {
            set part_error $err
        } else {
            set target_part $p
            break
        }
    }
    if {$target_part eq ""} {
        error "Could not set any candidate part ($candidate_parts). Last set_part error: $part_error"
    }
    puts "Using target part: $target_part"
    create_clock -period $clock_period_ns -name default

    # Optional: run C simulation
    # csim_design

    csynth_design

    # Optional: run co-simulation
    # cosim_design

    # Optional: export IP
    # export_design -format ip_catalog

    # Save and close the project
    close_project

}

exit

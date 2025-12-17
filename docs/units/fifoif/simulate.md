---
title: C and RTL Simulation
parent: Command-Response FIFO Interface
nav_order: 4
has_children: false
---

# C and RTL Simulation

## Building the Project
Having designed the IP, we can now simulate it.
First, follow the instructions to [build the Vitis project](../../support/amd/vitis_build.md) but use the design and testbench files in:

* [Launch Vitis HLS](./lauching.md)
* Go to **File → New Component → HLS**.  You will set a sequence of items:
   * For **Component name** select `hls_component`
   * For **Component location** select `hwdesign/fifoif/fifo_fun_vitis`
   * For **Configuration File** select `Empty File`
   * For **Source Files** set:
       * Top Function: `simp_fun`
       * Design Files: Add `src/fifofun.cpp`
       * Testbench: Add `src/tb_fifofun.cpp`
   * For **Hardware** part select the [part number](../../support/amd/fpga_part.md)
   * For **Settings** keep as default, with the clock frequency to `100MHz`
* Vitis will reopen with the project.

## Simulation 
In the Flow panel (left):

* Run the **C Simulation->Run**.
    * You should get that the five tests pass
* Run **C synthesis**
    * This step will synthesize the IP from the Vitis HLS
* Find the **C/RTL Co-Simulation** section
    * Select the settings (gear box) in the C/RTL Simulation
    * Select `cosim.trace.all` to `all`.  This setting will trace all the outputs.
    * Select the **Run** option to run the simulation 
* Re-run the RTL co-simulation to generate the VCD trace:
    * Open a Windows powershell or Linux terminal
    * [Activate the virtual environment](../../support/repo/python.md) with `xilinxutils`
    * Navigate (i.e., `cd`) to the directory of the Vitis IP project in `hwdesign\fifoif\fifo_fun_vitis`
    * Identify the `component_name` and `top_name`. 
        * When the IP was synthesized, Vitis created a directory of the form `<component_name>/<top_name>` based on the names of the component and top-level function.  Based on the settings we used in this project, this directory is: 
        ~~~bash
            fifo_fun_vitis\hls_component\simp_fun
        ~~~
        * Hence, in this example `component_name=hls_component` and `top_name=scalar_fun`
    * Re-run the simulation with VCD with the command from PowerShell or Linux terminal:
        ~~~bash
        (env) xsim_vcd --top sim_fun --comp hls_component --out dump.vcd
        ~~~
        * Note:  We have not yet created a version of the script `xsim_vcd` for Linux.
        * After running the script, there will be a VCD file with the simulation:
        ~~~bash
            fifo_fun_vitis\vcd\dump.vcd
        ~~~    

## Viewing the Command-Response Timing

Now go to the [jupyter notebook](https://github.com/sdrangan/hwdesign/tree/main/fifoif/python/view_axi_stream.ipynb) to view the command-response timing.


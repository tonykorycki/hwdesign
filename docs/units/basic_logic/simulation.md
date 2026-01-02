---
title: Simulation of the Module 
parent: Basic Digital Logic
nav_order: 2
has_children: false
---

# Simulating the Module

## Running the Simulation with the `xilinxutils` package
Once the testbench and module SV files are written, we run a **behavioral simulation**
to validate the functionality.  The simulation in Vivado is a bit complex, 
so I have inluded a function `sv_sim` in the `xilinxutils` package to run the simulation.
It can be used as follows:

* Open a terminal window in Linux or command prompt window in Windows
    * In Windows, do not use PowerShell.
* Follow the command to [set the path](../../support/amd/lauching.md) for the command-line utilities
* [Activate the virtual environment](../../support/repo/python.md) for `xilinxutils` package
* Run the command:
~~~bash
    (env) sv_sim --source simp_fun.sv --tb tb_simp_fun.sv
~~~ 

Running this command will run several Vivado command line utilities to simulate the
testbench.

## Visualizing the Timing Diagram
Once the simulation is complete, it will create a **Value-Change Dump** or VCD file
with the trace of all the inputs.  You can then visualize that in [jupyter notebook](https://github.com/sdrangan/hwdesign/blob/main/demos/basic_logic/timing_diag.ipynb).


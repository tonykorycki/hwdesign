// ReLU function: y = ax² + max{bx, 0} + c
// Two-cycle implementation: register x in cycle 1, compute in cycle 2

// Pipeline: Register input in cycle 1, compute multiplications in cycle 2
always_ff @(posedge clk) begin
    if (rst) begin
        xreg <= '0;
        xsq <= '0;
        bx <= '0;
    end else begin
        xreg <= x;              // Cycle 1: Register input x
        xsq <= xreg * xreg;     // Cycle 2: Compute x² using registered xreg (parallel with bx)
        bx <= b * xreg;         // Cycle 2: Compute b*xreg using registered xreg (parallel with xsq)
    end
end

// Combinational output (available after cycle 2)
always_comb begin
    y = a * xsq + ((bx > 0) ? bx : 0) + c;  // ax² + max{bx, 0} + c
end

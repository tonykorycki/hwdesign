`timescale 1ns/1ps

module subc_divide(
    input  logic         clk,
    input  logic         rst,

    // Handshake for inputs
    input  logic         invalid,
    output logic         inready,

    // Inputs
    input  logic [31:0]  a,
    input  logic [31:0]  b,
    input  logic [5:0]   nbits,     // runtime number of iterations (0–32)

    // Handshake for outputs
    input  logic         outready,
    output logic         outvalid,

    // Output
    output logic [31:0]  z
);

    // Internal registers
    logic [31:0] a_reg, b_reg;
    logic [31:0] z_reg;
    logic [5:0]  count;

    typedef enum logic [1:0] {
        IDLE,
        RUN,
        DONE
    } state_t;

    state_t state;

     // Output ready when we're in the DONE state

    // TODO:  Complete the code for the divide operation
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            inready <= 1;
            outvalid <= 0;
            a_reg <= 0;
            b_reg <= 0;
            z_reg <= 0;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (invalid==1) begin
                        state <= RUN;
                        inready <= 0;
                        a_reg <= a;
                        b_reg <= b;
                        z_reg <= 0;
                        count <= 0;
                    end
                end
                RUN: begin
                    if (count == nbits) begin
                        state <= DONE;
                        outvalid <= 1;
                    end
                    else begin
                        automatic logic [31:0] a_shifted = a_reg << 1;
                        automatic logic do_sub = (a_shifted >= b_reg);
                        
                        a_reg <= a_shifted - (do_sub ? b_reg : 32'b0);
                        z_reg <= (z_reg << 1) | {31'b0, do_sub};
                        count <= count + 1;
                    end
                end
                DONE: begin
                    z <= z_reg;
                    if (outready == 1) begin
                        state <= IDLE;
                        outvalid <= 0;
                        inready <= 1;
                    end
                end
            endcase
        end
    end


endmodule
`timescale 1ns/1ps

module tb_simp_fun;

    localparam WIDTH = 8;
    localparam CLK_PERIOD = 10;  // 100 MHz clock

    logic clk = 0;
    logic rst = 1;
    logic [WIDTH-1:0] a_in, b_in;
    logic [WIDTH-1:0] c_out;

    
    always #(CLK_PERIOD/2) clk = ~clk;   

    simp_fun #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .a_in(a_in),
        .b_in(b_in),
        .c_out(c_out)
    );


    // Test vector structure
    typedef struct {
        logic [WIDTH-1:0] a;
        logic [WIDTH-1:0] b;
    } test_vector_t;

    initial begin
        // Define test vectors
        test_vector_t test_vectors[] = '{
            '{a: 5, b: 7},
            '{a: 10, b: 20},
            '{a: 100, b: 50},
            '{a: 0, b: 0},
            '{a: 255, b: 255}
        };

        // Reset for a few cycles
        repeat (3) @(posedge clk);
        rst = 0;

        // Loop through test vectors
        for (int i = 0; i < test_vectors.size(); i++) begin
            a_in = test_vectors[i].a;
            b_in = test_vectors[i].b;
            @(posedge clk);
            @(posedge clk);
            $display("Test %0d: a_in=%0d, b_in=%0d, c_out=%0d", i+1, a_in, b_in, c_out);
        end

        repeat (3) @(posedge clk);
        $finish;
    end

endmodule
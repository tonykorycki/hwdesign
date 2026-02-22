`timescale 1ns/1ps

module tb_ball_bounce;

    // Parameters
    localparam WALL1 = 0;
    localparam WALL2 = 100;
    localparam time CLK_PERIOD = 10ns;  // 100 MHz clock

    // Signals
    logic clk = 0;
    logic reset = 1;
    logic signed [16:0] x;
    logic signed [7:0] v;
    logic signed [16:0] x_next;
    logic signed [7:0] v_next;

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // DUT instantiation
    ball_bounce #(
        .wall1(WALL1),
        .wall2(WALL2)
    ) dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .v(v),
        .x_next(x_next),
        .v_next(v_next)
    );

    // Test vector structure
    typedef struct {
        logic signed [16:0] x_init;
        logic signed [7:0] v_init;
        string description;
    } test_vector_t;

    initial begin
        // Define test vectors
        test_vector_t test_vectors[] = '{
            '{x_init: 50,  v_init: 5,   description: "Normal movement right"},
            '{x_init: 50,  v_init: -5,  description: "Normal movement left"},
            '{x_init: 95,  v_init: 10,  description: "Bounce off right wall"},
            '{x_init: 5,   v_init: -10, description: "Bounce off left wall"},
            '{x_init: 0,   v_init: 5,   description: "Start at left wall"},
            '{x_init: 100, v_init: -5,  description: "Start at right wall"},
            '{x_init: 50,  v_init: 0,   description: "Zero velocity"},
            '{x_init: 98,  v_init: 5,   description: "Bounce with small overshoot"},
            '{x_init: 2,   v_init: -5,  description: "Bounce with small overshoot left"}
        };

        $display("========================================");
        $display("Ball Bounce Testbench");
        $display("Wall1 = %0d, Wall2 = %0d", WALL1, WALL2);
        $display("========================================");

        // Apply reset and initial values
        x = 50;
        v = 0;
        repeat (3) @(posedge clk);
        reset = 0;

        // Loop through test vectors
        for (int i = 0; i < test_vectors.size(); i++) begin
            // Apply reset to load new initial values
            reset = 1;
            x = test_vectors[i].x_init;
            v = test_vectors[i].v_init;
            @(posedge clk);
            reset = 0;

            $display("\nTest %0d: %s", i+1, test_vectors[i].description);
            $display("  Initial: x=%0d, v=%0d", x, v);

            // Run for a few cycles to observe behavior
            repeat (5) begin
                @(posedge clk);
                $display("  After clock: x_next=%0d, v_next=%0d", x_next, v_next);
                // Update inputs for next cycle (feedback loop)
                x = x_next;
                v = v_next;
            end
        end

        $display("\n========================================");
        $display("Testbench Complete");
        $display("========================================");
        
        $finish;
    end

endmodule

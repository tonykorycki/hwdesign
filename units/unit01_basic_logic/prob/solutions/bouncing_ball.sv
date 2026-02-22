module ball_bounce #(
    parameter wall1 = 0,
    parameter wall2 = 100
) (
    input logic clk,
    input logic reset,
    input logic signed [16:0] x,
    input logic signed [7:0] v,
    output logic signed [16:0] x_next,
    output logic signed [7:0] v_next
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            x_next <= x;
            v_next <= v;
        end else begin
            logic signed [16:0] x_temp;
            logic signed [7:0] v_temp;

            x_temp = x + v;

            if (x_temp > wall2) begin
                x_next <= wall2 - (x_temp - wall2);
                v_next <= -v;
            end else if (x_temp < wall1) begin
                x_next <= wall1 + (wall1 - x_temp);
                v_next <= -v;
            end else begin
                x_next <= x_temp;
                v_next <= v;
            end
        end
    end
endmodule
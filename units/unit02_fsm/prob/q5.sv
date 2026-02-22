always_ff @(posedge clk or posedge reset) begin
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
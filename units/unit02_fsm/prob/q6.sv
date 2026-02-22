always_comb begin
    x2_c = x0 * x0;
    x3_c = x2_r * x1;

    case(i1)
        0: y_c = 1;
        1: y_c = x_1;
        2: y_c = x2_r;
        3: y_c = x3_c;
    endcase
        
end

always_ff @( posedge clk ) begin
    x0 <= x;
    i0 <= i;

    x1 <= x0;
    i1 <= i0;
    x2_r <= x2_c;
    y<= y_c;
end
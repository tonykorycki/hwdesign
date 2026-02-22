always_ff @(posedge clk) begin
    xreg <= x;
    a_r <= a;
    xsq_r <= xsq;
    y <= y_c;
end

always_comb begin
    act_in = w1*xreg + b1;
    if (act_in > 0) begin
        a = act_in;
    end else begin
        a = 0;
    end
    xsq = ((xreg*xreg) >> 2);
end

always_comb begin
    y_c = xsq_r + w2*a_r + b2;
end




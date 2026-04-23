# Q1
(a) 5ns
(b) 
always_ff @(posedge clk) begin
    xreg1 <= x1;
    xreg2 <= x2;
end
always_comb begin
    z1 = f1(xreg1, xreg2); 
    z2 = f2(xreg1, xreg2); 
end
always_ff @(posedge clk) begin
    xreg1_2 <= xreg1;
    z1_reg  <= z1;
    z2_reg  <= z2;
end
always_comb begin
    z3 = f3(xreg1_2, z2_reg);    
    y  = f4(z1_reg, z3);    
**end**

(c) 3.8 ns

# Q2
        0   1   2   3   4   5     
x_s0    ?   3   6   12  ?   ?  
z1_s1   ?   ?   30  60  120 ?  
z2_s2   ?   ?   ?   30  60  120 
y       ?   ?   ?   22  45  90 

# Q3
always_ff @(posedge clk) begin
    x_reg <= x;
end
always_comb begin
    z = f(x_reg);
    max1 = (x_reg > z) ? x_reg : z;
end
always_ff @(posedge clk) begin
    z_reg <= z;
    max_reg <= max1;
end
always_comb begin
    z2 = f(z_reg)
    max2 = (max_reg > z2) ? max_reg : z2;
end

# Q4

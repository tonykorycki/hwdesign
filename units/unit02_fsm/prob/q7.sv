initial begin
    // defaults
    rst = 1;
    x   = '0;

    // Cycle 0: rst=1 already
    @(posedge clk);          // -> Cycle 1
    rst = 0;                 // de-assert on next cycle

    // Wait until Cycle 4
    repeat (3) @(posedge clk);   // cycles 2,3,4 reached

    // Apply xtest[0] on cycle 4, print y on cycle 8
    x = xtest[0];
    repeat (4) @(posedge clk);   // cycles 5,6,7,8
    $display("x = %0d", xtest[0]);
    $display("y = %0d", y);

    // Apply xtest[1] on cycle 9, print y on cycle 13
    @(posedge clk);              // -> cycle 9
    x = xtest[1];
    repeat (4) @(posedge clk);   // -> cycle 13
    $display("x = %0d", xtest[1]);
    $display("y = %0d", y);

    // Apply xtest[2] on cycle 14, print y on cycle 18
    @(posedge clk);              // -> cycle 14
    x = xtest[2];
    repeat (4) @(posedge clk);   // -> cycle 18
    $display("x = %0d", xtest[2]);
    $display("y = %0d", y);

    // Apply xtest[3] on cycle 19, print y on cycle 23
    @(posedge clk);              // -> cycle 19
    x = xtest[3];
    repeat (4) @(posedge clk);   // -> cycle 23
    $display("x = %0d", xtest[3]);
    $display("y = %0d", y);

    $finish;
end

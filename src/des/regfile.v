module regfile (
    input wire clk, we3,
    input wire [3:0] ra1, ra2, wa3,
    input wire [31:0] wd3, r15,
    output wire [31:0] rd1, rd2
);   
    reg [31:0] rf [14:0];

    // Write to the register file on the falling edge of the clock
    always @(negedge clk)
        if (we3)
            rf[wa3] <= wd3;

    // Read two ports combinationally
    assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
    assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];

endmodule
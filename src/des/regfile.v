module regfile (
    input wire clk, we3,
    input wire [3:0] ra1, ra2, wa3,
    input wire [31:0] wd3, r15,
    output wire [31:0] rd1, rd2,
    output wire [479:0] rf_out
); 
    reg [31:0] rf [14:0];
    // Write to the register file on the falling edge of the clock
    always @(negedge clk)
        if (we3)
            rf[wa3] <= wd3;

    // Read two ports combinationally
    assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
    assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
    
    assign rf_out = {rf[0], rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7], rf[8], rf[9], rf[10], rf[11], rf[12], rf[13], rf[14]};
endmodule
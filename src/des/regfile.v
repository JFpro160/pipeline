module regfile (
    input wire clk,
    input wire reset,
    input wire we3,
    input wire we1,
    input wire [3:0] ra1,
    input wire [3:0] ra2,
    input wire [3:0] ra3,
    input wire [3:0] wa1,
    input wire [3:0] wa3,
    input wire [31:0] wd3,
    input wire [31:0] wd1,
    input wire [31:0] r15,
    output wire [31:0] rd1,
    output wire [31:0] rd2,
    output wire [31:0] rd3
);
    reg [31:0] rf [14:0];
    
    always @(negedge clk) begin
       if (we3) rf[wa3] <= wd3; 
       if (we1) rf[wa1] <= wd1; 
       end    

    assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
    assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
    assign rd3 = (ra3 == 4'b1111) ? r15 : rf[ra3];

endmodule

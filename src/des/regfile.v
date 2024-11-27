module regfile (
    input wire clk,
    input wire reset,
    input wire we3,
    input wire we1,
    input wire [3:0] ra1,
    input wire [3:0] ra2,
    input wire [3:0] ra3,
    input wire [3:0] wa3,
    input wire [31:0] wd3,
    input wire [31:0] wd1,
    input wire [31:0] r15,
    output wire [31:0] rd1,
    output wire [31:0] rd2,
    output wire [31:0] rd3
);
    reg [31:0] rf [14:0]; // 15 registers (R0-R14)

    // Reset block (synchronous reset)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rf[0] <= 32'b0;
            rf[1] <= 32'b0;
            rf[2] <= 32'b0;
            rf[3] <= 32'b0;
            rf[4] <= 32'b0;
            rf[5] <= 32'b0;
            rf[6] <= 32'b0;
            rf[7] <= 32'b0;
            rf[8] <= 32'b0;
            rf[9] <= 32'b0;
            rf[10] <= 32'b0;
            rf[11] <= 32'b0;
            rf[12] <= 32'b0;
            rf[13] <= 32'b0;
            rf[14] <= 32'b0;
        end else begin
            if (we3) rf[wa3] <= wd3; // Write to wa3
            if (we1) rf[ra1] <= wd1;   // Write to R0 (or other logic if needed)
        end
    end

    // Read logic
    assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
    assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
    assign rd3 = (ra3 == 4'b1111) ? r15 : rf[ra3];

endmodule

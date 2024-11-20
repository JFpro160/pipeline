module F_D_Register (
    input wire clk,
    input wire reset,
    input wire stall,
    // Inputs from IF stage
    input wire [31:0] InstrF,
    output reg [31:0] InstrD
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            InstrD <= 32'b0;
        end
        else if (!stall) begin
            InstrD <= InstrF;
        end
    end
endmodule
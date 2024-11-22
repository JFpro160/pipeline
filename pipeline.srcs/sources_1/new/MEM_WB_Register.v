module MEM_WB_Register (
    input wire clk,
    input wire reset,
    input wire PCSrcM,
    input wire MemtoRegM,
    input wire RegWriteM,
    input wire [31:0] ReadDataM,
    input wire [31:0] ALUResultM,
    input wire [3:0] WA3M,
    output reg PCSrcW,
    output reg MemtoRegW,
    output reg RegWriteW,
    output reg [31:0] ReadDataW,
    output reg [31:0] ALUResultW,
    output reg [3:0] WA3W
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs to zero
            PCSrcW     <= 1'b0;
            MemtoRegW  <= 1'b0;
            RegWriteW  <= 1'b0;
            ReadDataW  <= 32'b0;
            ALUResultW <= 32'b0;
            WA3W       <= 4'b0;
        end
        else begin
            // Pass inputs to outputs on the rising clock edge
            PCSrcW     <= PCSrcM;
            MemtoRegW  <= MemtoRegM;
            RegWriteW  <= RegWriteM;
            ReadDataW  <= ReadDataM;
            ALUResultW <= ALUResultM;
            WA3W       <= WA3M;
        end
    end

endmodule

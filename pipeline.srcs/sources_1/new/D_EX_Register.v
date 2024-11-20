module D_EX_Register (
    input wire clk,
    input wire reset,
    input wire PCSrcD,
    input wire MemWriteD,
    input wire [3:0] CondD,
    input wire MemtoRegD,
    input wire RegWriteD,
    input wire [3:0] ALUControlD,
    input wire BranchD,
    input wire FlagWriteD,
    input wire ALUSrcD,
    input wire [31:0] RD1D,
    input wire [31:0] RD2D,
    input wire [3:0] RA1D,
    input wire [3:0] RA2D,
    input wire [3:0] WA3D,
    input wire [31:0] ExtImmD,
    input wire [4:0] Flags_,
    output reg PCSrcE,
    output reg MemWriteE,
    output reg [3:0] CondE,
    output reg MemtoRegE,
    output reg RegWriteE,
    output reg [3:0] ALUControlE,
    output reg BranchE,
    output reg FlagWriteE,
    output reg ALUSrcE,
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [3:0] RA1E,
    output reg [3:0] RA2E,
    output reg [3:0] WA3E,
    output reg [31:0] ExtImmE
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PCSrcE      <= 1'b0;
            MemWriteE   <= 1'b0;
            CondE       <= 4'b0;
            MemtoRegE   <= 1'b0;
            RegWriteE   <= 1'b0;
            ALUControlE <= 4'b0;
            BranchE     <= 1'b0;
            FlagWriteE  <= 1'b0;
            ALUSrcE     <= 1'b0;
            RD1E        <= 32'b0;
            RD2E        <= 32'b0;
            RA1E        <= 4'b0;
            RA2E        <= 4'b0;
            WA3E        <= 4'b0;
            ExtImmE     <= 32'b0;
        end
        else begin
            PCSrcE      <= PCSrcD;
            MemWriteE   <= MemWriteD;
            CondE       <= CondD;
            MemtoRegE   <= MemtoRegD;
            RegWriteE   <= RegWriteD;
            ALUControlE <= ALUControlD;
            BranchE     <= BranchD;
            FlagWriteE  <= FlagWriteD;
            ALUSrcE     <= ALUSrcD;
            RD1E        <= RD1D;
            RD2E        <= RD2D;
            RA1E        <= RA1D;
            RA2E        <= RA2D;
            WA3E        <= WA3D;
            ExtImmE     <= ExtImmD;
        end
    end

endmodule

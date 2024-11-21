module arm (
    clk,
    reset,
    PCF,
    InstrF,
    MemWriteM,
    ALUOutM,
    WriteDataM,
    ReadDataM
);
    input wire clk;
    input wire reset;
    output wire [31:0] PCF;
    input wire [31:0] InstrF;
    output wire MemWriteM;
    output wire [31:0] ALUOutM;
    output wire [31:0] WriteDataM;
    input wire [31:0] ReadDataM;

    // Internal wires
    wire [31:0] InstrD;
    wire [3:0] ALUFlagsE;
    wire RegWriteM;
    wire ALUSrcE;
    wire MemtoRegW;
    wire PCSrcW;
    wire BranchTakenE;
    wire RegWriteW;
    wire [1:0] RegSrcD;
    wire [1:0] ImmSrcD;
    wire [1:0] ALUControlE;
    wire MemtoRegE;
    wire PCWrPendingF;
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
    wire StallF;
    wire StallD;
    wire FlushD;
    wire FlushE;
    wire Match_1E_M;
    wire Match_1E_W;
    wire Match_2E_M;
    wire Match_2E_W;
    wire Match_12D_E;

    // Controller instantiation
    controller c(
        .clk(clk),
        .reset(reset),
        .InstrD(InstrD[31:12]),
        .ALUFlagsE(ALUFlagsE),
        .RegSrcD(RegSrcD),
        .RegWriteW(RegWriteW),
        .ImmSrcD(ImmSrcD),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .MemWriteM(MemWriteM),
        .MemtoRegE(MemtoRegE),
        .PCSrcW(PCSrcW),
        .BranchTakenE(BranchTakenE),
        .MemtoRegW(MemtoRegW),
        .RegWriteM(RegWriteM),
        .PCWrPendingF(PCWrPendingF),
        .FlushE(FlushE)
    );

    // Datapath instantiation
    datapath dp(
        .clk(clk),
        .reset(reset),
        .RegSrcD(RegSrcD),
        .RegWriteW(RegWriteW),
        .ImmSrcD(ImmSrcD),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .MemtoRegW(MemtoRegW),
        .PCSrcW(PCSrcW),
        .ALUFlagsE(ALUFlagsE),
        .PCF(PCF),
        .InstrF(InstrF),
        .ALUOutM(ALUOutM),
        .WriteDataM(WriteDataM),
        .ReadDataM(ReadDataM),
        .BranchTakenE(BranchTakenE),
        .InstrD(InstrD),
        .Match_1E_M(Match_1E_M),
        .Match_1E_W(Match_1E_W),
        .Match_2E_M(Match_2E_M),
        .Match_2E_W(Match_2E_W),
        .Match_12D_E(Match_12D_E),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD)
    );

    // Hazard unit instantiation
    hazard h(
        .clk(clk),
        .reset(reset),
        .Match_1E_M(Match_1E_M),
        .Match_1E_W(Match_1E_W),
        .Match_2E_M(Match_2E_M),
        .Match_2E_W(Match_2E_W),
        .Match_12D_E(Match_12D_E),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .BranchTakenE(BranchTakenE),
        .PCWrPendingF(PCWrPendingF),
        .RegWriteW(RegWriteW),
        .RegWriteM(RegWriteM),
        .MemtoRegE(MemtoRegE),
        .PCSrcW(PCSrcW)
    );

endmodule
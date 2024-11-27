module arm ( 
    input wire clk, reset, 
    input wire [31:0] InstrF, ReadDataM,
    output wire [31:0] PCF, ALUOutM, WriteDataM, 
    output wire MemWriteM 
); 
    // Internal signals 
    wire BranchTakenD, ALUSrcE, MemtoRegE,  
         RegWriteM, PCSrcW, RegWriteW, MemtoRegW, 
         PCWrPendingF, StallF, StallD, FlushD, FlushE, 
         Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E; 
    wire [1:0] RegSrcD, ImmSrcD, ForwardAE, ForwardBE; 
    wire [2:0] ALUControlE;
    wire [3:0] ALUFlagsE; 
    wire [31:0] InstrD; 

    // Instantiate controller
    controller c(
        .clk(clk),
        .reset(reset),
        .InstrD(InstrD[31:12]),
        .ALUFlagsE(ALUFlagsE),
        .RegSrcD(RegSrcD),
        .ImmSrcD(ImmSrcD),
        .ALUSrcE(ALUSrcE),
        .BranchTakenD(BranchTakenD),
        .ALUControlE(ALUControlE),
        .MemWriteM(MemWriteM),
        .MemtoRegW(MemtoRegW),
        .PCSrcW(PCSrcW), 
        .RegWriteW(RegWriteW),
        .RegWriteM(RegWriteM),
        .MemtoRegE(MemtoRegE),
        .PCWrPendingF(PCWrPendingF),
        .FlushE(FlushE),
        .BranchD(BranchD)
    );

    // Instantiate datapath
    datapath dp(
        .clk(clk),
        .reset(reset),
        .RegSrcD(RegSrcD),
        .RegWriteW(RegWriteW),
        .ImmSrcD(ImmSrcD),
        .ALUSrcE(ALUSrcE),
        .BranchTakenD(BranchTakenD),
        .ALUControlE(ALUControlE),
        .MemtoRegW(MemtoRegW),
        .PCSrcW(PCSrcW), 
        .ALUFlagsE(ALUFlagsE),
        .PCF(PCF),
        .InstrF(InstrF),
        .InstrD(InstrD),
        .ALUOutM(ALUOutM),
        .WriteDataM(WriteDataM),
        .ReadDataM(ReadDataM),
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
        .BranchD(BranchD),
        .BranchMissed(BranchMissed)
    );

    // Instantiate hazard unit
    hazard h(
        .clk(clk),
        .reset(reset),
        .Match_1E_M(Match_1E_M),
        .Match_1E_W(Match_1E_W),
        .Match_2E_M(Match_2E_M),
        .Match_2E_W(Match_2E_W),
        .Match_12D_E(Match_12D_E),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .BranchMissed(BranchMissed),
        .MemtoRegE(MemtoRegE),
        .PCWrPendingF(PCWrPendingF),
        .PCSrcW(PCSrcW), 
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE)
    );

endmodule
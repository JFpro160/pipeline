module arm ( 
    input wire clk, reset, 
    input wire [31:0] InstrF, ReadDataM,
    output wire [31:0] PCF, ALUOutM, WriteDataM, 
    output wire MemWriteM 
); 
    // Internal signals 
    wire BranchTakenD, ALUSrcE, MemtoRegE,  
         RegWriteM, PCSrcW, RegWriteW, RegShiftE,MemtoRegW, 
         PCWrPendingF, StallF, StallD, FlushD, FlushE, 
         Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W,
         Match_3E_W,Match_3E_M, Match_12D_E; 
    wire [1:0] RegSrcD, ImmSrcD, ForwardAE, ForwardBE, ForwardCE;
    wire WriteBackW, ShiftE,PreIndexE,PostIndexE, CarryE;
    wire [3:0] ALUControlE;
    wire [4:0] ALUFlagsE; 
    wire [31:0] InstrD; 
    wire MulOpD, MulOpE;
    wire [1:0] ShiftControlE;

    // Instantiate controller
    controller c(
        .clk(clk),
        .reset(reset),
        .InstrD(InstrD),
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
        .RegShiftE(RegShiftE),
        .MemtoRegE(MemtoRegE),
        .PCWrPendingF(PCWrPendingF),
        .WriteBackW(WriteBackW),
        .ShiftControlE(ShiftControlE),
        .SaturatedOpE(SaturatedOpE),
        .ShiftE(ShiftE),
        .PreIndexE(PreIndexE),
        .PostIndexE(PostIndexE),
        .CarryE(CarryE),
        .MulOpD(MulOpD),
        .MulOpE(MulOpE),
        .FlushE(FlushE)
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
        .RegShiftE(RegShiftE),
        .PCF(PCF),
        .InstrF(InstrF),
        .InstrD(InstrD),
        .ALUOutM(ALUOutM),
        .WriteDataM(WriteDataM),
        .MemtoRegE(MemtoRegE),
        .ReadDataM(ReadDataM),
        .Match_1E_M(Match_1E_M),
        .Match_1E_W(Match_1E_W),
        .Match_2E_M(Match_2E_M),
        .Match_2E_W(Match_2E_W),
        .Match_3E_W(Match_3E_W),
        .Match_3E_M(Match_3E_M),
        .Match_12D_E(Match_12D_E),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ForwardCE(ForwardCE),
        .WriteBackW(WriteBackW),
        .ShiftControlE(ShiftControlE),
        .SaturatedOpE(SaturatedOpE),
        .ShiftE(ShiftE),
        .PreIndexE(PreIndexE),
        .PostIndexE(PostIndexE),
        .MulOpD(MulOpD),
        .MulOpE(MulOpE),
        .CarryE(CarryE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD)
    );

    // Instantiate hazard unit
    hazard h(
        .clk(clk),
        .reset(reset),
        .Match_1E_M(Match_1E_M),
        .Match_1E_W(Match_1E_W),
        .Match_2E_M(Match_2E_M),
        .Match_2E_W(Match_2E_W),
        .Match_3E_W(Match_3E_W),
        .Match_3E_M(Match_3E_M),
        .Match_12D_E(Match_12D_E),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .BranchTakenD(BranchTakenD),
        .MemtoRegE(MemtoRegE),
        .PCWrPendingF(PCWrPendingF),
        .PCSrcW(PCSrcW), 
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ForwardCE(ForwardCE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE)
    );

endmodule
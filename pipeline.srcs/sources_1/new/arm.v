module arm (
    clk,
    reset,
    PCF,
    InstrF,
    MemWriteM,
    ALUResultM,
    WriteDataM,
    ReadDataM
);

    // Inputs and Outputs
    input wire clk;
    input wire reset;
    output wire [31:0] PCF;
    input wire [31:0] InstrF;
    output wire MemWriteM;
    output wire [31:0] ALUResultM;
    output wire [31:0] WriteDataM;
    input wire [31:0] ReadDataM;

    // Internal Wires
    wire [31:0] InstrD;
    wire [3:0] ALUFlagsE;
    wire RegWriteM;
    wire ALUSrcE;
    wire MemtoRegW;
    wire PCSrcW;
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

    // Fetch-Decode Register Wires
    wire PCSrcD;
    wire MemWriteD;
    wire MemtoRegD;
    wire [1:0] ALUControlD;
    wire BranchD;
    wire FlagWriteD;
    wire ConD;
    wire [3:0] Flags_;
    wire [31:0] RD1D, RD2D;
    wire [3:0] RA1D, RA2D, WA3D;
    wire [31:0] ExtImmD;

    // Decode-Execute Register Wires
    wire PCSrcE;
    wire MemWriteE;
    wire [3:0] CondE;
    wire RegWriteE;
    wire BranchE;
    wire [1:0] FlagWriteE;
    wire [31:0] RD1E, RD2E;
    wire [3:0] RA1E, RA2E, WA3E;
    wire [31:0] ExtImmE;

    // Execute-Memory Register Wires
    wire PCSrcE_;
    wire MemWriteE_;
    wire RegWriteE_;
    wire [31:0] ALUResultW;
    wire [31:0] ALUResultE;
    wire [31:0] WriteDataE;
    wire [3:0] WA3E;
    wire PCSrcM;
    wire MemtoRegM;
    wire [3:0] WA3M;
    wire [31:0] ExtImmD;

    // Memory-WriteBack Register Wires
    wire MemtoRegM;
    wire [31:0] ReadDataW;
    wire [3:0] WA3W;

    // Instantiate Submodules
    controller c(
        .clk(clk),
        .reset(reset),
        .InstrD(InstrD[31:12]),
        .RegSrcD(RegSrcD),
        .PCSrcD(PCSrcD),
        .RegWriteD(RegWriteD),
        .MemtoRegD(MemtoRegD),
        .MemWriteD(MemWriteD),
        .ALUControlD(ALUControlD),
        .BranchD(BranchD),
        .ALUSrcD(ALUSrcD),
        .FlagWriteD(FlagWriteD),
        .ImmSrcD(ImmSrcD)
    );

    F_D_Register FetchDecode(
        .clk(clk),
        .reset(FlushD),
        .en(~StallD),
        .InstrF(InstrF),
        .InstrD(InstrD)
    );
    
    flopenr #(2) flagreg1(
		.clk(clk),
		.reset(reset),
		.en(FlagWriteE[1]),
		.d(ALUFlagsE[3:2]),
		.q(Flags_[3:2])
	);
	flopenr #(2) flagreg0(
		.clk(clk),
		.reset(reset),
		.en(FlagWriteE[0]),
		.d(ALUFlagsE[1:0]),
		.q(Flags_[1:0])
	);
	condcheck cc(
		.Cond(CondE),
		.Flags(FlagsE),
		.CondEx(CondEx)
	);
	
	assign BranchTakenE = BranchE & CondEx;
	assign PCSrcE_ = (PCSrcE & CondEx) | BranchTakenE;       
	assign RegWriteE_ = RegWriteE & CondEx;
	assign MemWriteE_ = MemWriteE & CondEx; 
	
    D_EX_Register DecodeExecute(
        .clk(clk),
        .reset(reset),
        .PCSrcD(PCSrcD),
        .MemWriteD(MemWriteD),
        .MemtoRegD(MemtoRegD),
        .ALUControlD(ALUControlD),
        .RegWriteD(RegWriteD),
        .BranchD(BranchD),
        .ALUSrcD(ALUSrcD),
        .FlagWriteD(FlagWriteD),
        .CondD(InstrD[31:28]),
        .Flags_(Flags_),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .RA1D(RA1D),
        .RA2D(RA2D),
        .WA3D(InstrD[15:12]),
        .ExtImmD(ExtImmD),
        .PCSrcE(PCSrcE),
        .MemWriteE(MemWriteE),
        .CondE(CondE),
        .MemtoRegE(MemtoRegE),
        .RegWriteE(RegWriteE),
        .ALUControlE(ALUControlE),
        .BranchE(BranchE),
        .FlagWriteE(FlagWriteE),
        .FlagsE(FlagsE),
        .ALUSrcE(ALUSrcE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .RA1E(RA1E),
        .RA2E(RA2E),
        .WA3E(WA3E),
        .ExtImmE(ExtImmE)
    );

    EX_MEM_Register ExecuteMemory(
        .clk(clk),
        .reset(reset),
        .PCSrcE_(PCSrcE_),
        .MemWriteE_(MemWriteE_),
        .RegWriteE_(RegWriteE_),
        .MemtoRegE(MemtoRegE),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .WA3E(WA3E),
        .PCSrcM(PCSrcM),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .WA3M(WA3M)
    );

    MEM_WB_Register MemoryWriteBack(
        .clk(clk),
        .reset(reset),
        .PCSrcM(PCSrcM),
        .WA3M(WA3M),
        .ReadDataM(ReadDataM),
        .ALUResultM(ALUResultM),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .WA3W(WA3W),
        .ALUResultW(ALUResultW),
        .PCSrcW(PCSrcW),
        .RegWriteW(RegWriteW),
        .MemtoRegW(MemtoRegW),
        .ReadDataW(ReadDataW)
    );

    datapath dp(
        .clk(clk),
        .reset(reset),
        .RA1D(RA1D),
        .RA2D(RA2D),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .WA3W(WA3W),
        .ExtImmE(ExtImmE),
        .RegSrcD(RegSrcD),
        .RegWriteW(RegWriteW),
        .ExtImmD(ExtImmD),
        .ImmSrcD(ImmSrcD),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .MemtoRegW(MemtoRegW),
        .PCSrcW(PCSrcW),
        .ALUFlagsE(ALUFlagsE),
        .PCF(PCF),
        .InstrF(InstrF),
        .ALUResultW(ALUResultW),
        .InstrD(InstrD),
        .Match_1E_M(Match_1E_M),
        .Match_1E_W(Match_1E_W),
        .Match_2E_M(Match_2E_M),
        .Match_2E_W(Match_2E_W),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .BranchTakenE(BranchTakenE),
        .ALUResultM(ALUResultM),
        .ALUResultE(ALUResultE)
        );
        
        	
    assign Match_1E_M = (RA1E == WA3M);
    assign Match_1E_W = (RA1E == WA3W);
    assign Match_2E_M = (RA2E == WA3M);
    assign Match_2E_W = (RA2E == WA3W);

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
        .RA1D(RA1D),
        .RA2D(RA2D),
        .WA3E(WA3E),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .BranchTakenE(BranchTakenE),
        .PCWrPendingF(PCWrPendingF),
        .RegWriteW(RegWriteW),
        .RegWriteM(RegWriteM),
        .MemtoRegE(MemtoRegE),
        .PCSrcW(PCSrcW),
        .PCSrcD(PCSrcD),
        .PCSrcE(PCSrcE),
        .PCSrcM(PCSrcF)
    );

endmodule

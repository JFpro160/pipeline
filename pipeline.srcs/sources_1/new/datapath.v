module datapath (
	clk,
	reset,
	RegSrcD,
	RegWriteW,
	ImmSrcD,
	ALUSrcE,
	ALUResultW,
	ALUControlE,
	MemtoRegW,
	PCSrcW,
	ALUFlagsE,
	PCF,
	InstrF,
	BranchTakenE,
	InstrD,
	Match_1E_M,
	Match_1E_W,
	Match_2E_M,
	Match_2E_W,
	ForwardAE,
	ForwardBE,
	StallF,
	StallD,
	FlushD,
	ExtImmD,
	RA1D,
	RA2D,
	RD1D,
	RD2D,
	RD1E,
	RD2E,
	WA3W,
	ExtImmE,
	ALUResultM,
	ALUResultE
	);
	
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrcD;
	wire [31:0] ResultW; 
	input wire RegWriteW;
	input wire [1:0] ImmSrcD;
	input wire ALUSrcE;
	input wire [1:0] ALUControlE;
	input wire [31:0] ALUResultW;
	input wire MemtoRegW;
	input wire PCSrcW;
	output wire [3:0] ALUFlagsE;
	output wire [31:0] PCF;
	input wire [31:0] InstrF;
	output wire [31:0] InstrD;
	input wire BranchTakenE;
	output wire Match_1E_M;
	output wire Match_1E_W;
	output wire Match_2E_M;
	output wire Match_2E_W;
	input wire [1:0] ForwardAE;
	input wire [1:0] ForwardBE;
	input wire StallF;
	input wire StallD;
	input wire FlushD;
	input wire [3:0] WA3W;
	
	output wire [31:0] ALUResultE;
	wire [31:0] PCnextF1;
	wire [31:0] PCnextF;
	wire [31:0] PCPlus4F;
	wire [31:0] PCPlus8D;
	output wire [31:0] ExtImmD;
	input wire [31:0] ExtImmE;
	input wire [31:0] ALUResultM;
//	wire [31:0] Result;
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;
	wire [31:0] WriteDataE;
	output wire [3:0] RA1D;
	output wire [3:0] RA2D;
	input wire [31:0] RD1E;
	input wire [31:0] RD2E;
	output wire [31:0] RD1D;
	output wire [31:0] RD2D;
	wire [3:0] InstrD;
		
	mux2 #(32) pcnextmux(
		.d0(PCPlus4F),
		.d1(ResultW),
		.s(PCSrcW),
		.y(PCnextF1)
	);
	
	mux2 #(32) branchmux(
		.d0(PCnextF1),
		.d1(ALUResultE),
		.s(BranchTakenE),
		.y(PCnextF)
	);
	
	flopenr #(32) pcreg(
		.clk(clk),
		.en(~StallF),
		.reset(reset),
		.d(PCnextF),
		.q(PCF)
	);
	
	adder #(32) pcadd1(
		.a(PCF),
		.b(32'b100),
		.y(PCPlus4F)
	);
    	
	assign PCPlus8D = PCPlus4F;
	
	mux2 #(4) ra1mux(
		.d0(InstrD[19:16]),
		.d1(4'b1111),
		.s(RegSrcD[0]),
		.y(RA1D)
	);

		
	mux2 #(4) ra2mux(
		.d0(InstrD[3:0]),
		.d1(InstrD[15:12]),
		.s(RegSrcD[1]),
		.y(RA2D)
	);
	
	regfile rf(
		.clk(~clk), // preguntar a carlos
		.we3(RegWriteW),
		.ra1(RA1D),
		.ra2(RA2D),
		.wa3(WA3W),
		.wd3(ResultW),
		.r15(PCPlus8D),
		.rd1(RD1D),
		.rd2(RD2D)
	);
	
	extend ext(
		.Instr(InstrD[23:0]),
		.ImmSrc(ImmSrcD),
		.ExtImm(ExtImmD)
	);

	mux3 #(32) forwardSrcA(
	   .d0(RD1E),
	   .d1(ResultW),
	   .d2(ALUResultM),
	   .s(ForwardAE),
	   .y(SrcAE)
	);
	
	mux3 #(32) forwardSrcB(
	   .d0(RD2E),
	   .d1(ResultW),
	   .d2(ALUResultM),
	   .s(ForwardBE),
	   .y(WriteDataE)
	);
		
	mux2 #(32) srcbmux(
		.d0(WriteDataE),
		.d1(ExtImmE),
		.s(ALUSrcE),
		.y(SrcBE)
	);
	
	alu alu(
		.a(SrcAE),
		.b(SrcBE),
		.ALUControl(ALUControlE),
		.Result(ALUResultE),
		.ALUFlags(ALUFlagsE)
	);
	
	mux2 #(32) resmux(
		.d0(ALUResultW),
		.d1(ReadDataW),
		.s(MemtoRegW),
		.y(ResultW)
	);

endmodule
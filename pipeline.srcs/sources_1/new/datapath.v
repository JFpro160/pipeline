module datapath (
	clk,
	reset,
	RegSrcD,
	RegWriteW,
	ImmSrcD,
	ALUSrcE,
	ALUControlE,
	MemtoRegW,
	PCSrcW,
	ALUFlagsE,
	PCF,
	InstrF,
	ALUOutM,
	WriteDataM,
	ReadDataM,
	BranchTakenE,
	InstrD,
	Match_1E_M,
	Match_1E_W,
	Match_2E_M,
	Match_2E_W,
	Match_12D_E,
	ForwardAE,
	ForwardBE,
	StallF,
	StallD,
	FlushD
	
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrcD;
	input wire RegWriteW;
	input wire [1:0] ImmSrcD;
	input wire ALUSrcE;
	input wire [1:0] ALUControlE;
	input wire MemtoRegW;
	input wire PCSrcW;
	output wire [3:0] ALUFlagsE;
	output wire [31:0] PCF;
	input wire [31:0] InstrF;
	output wire [31:0] ALUOutM;
	output wire [31:0] WriteDataM;
	input wire [31:0] ReadDataM;
	output wire [31:0] InstrD;
	input wire BranchTakenE;
	output wire Match_1E_M;
	output wire Match_1E_W;
	output wire Match_2E_M;
	output wire Match_2E_W;
	output wire Match_12D_E;
	input wire [1:0] ForwardAE;
	input wire [1:0] ForwardBE;
	input wire StallF;
	input wire StallD;
	input wire FlushD;
	
	
	wire [31:0] PCnextF;
	wire [31:0] PCPlus4F;
	wire [31:0] PCPlus8D;
	wire [31:0] ExtImmD;
	wire [31:0] ExtImmE;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [3:0] RA1;
	wire [3:0] RA2;
	wire [3:0] InstrD;
		
	mux2 #(32) pcnextmux(
		.d0(PCPlus4F),
		.d1(ResultW),
		.s(PCSrcW),
		.y(PCnext1F)
	);
	
	mux2 #(32) branchmux(
		.d0(PCnext1F),
		.d1(ALUResultE),
		.s(PCSrcW),
		.y(PCnextF)
	);
	
	flopr #(32) pcreg(
		.clk(clk),
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
		
	mux2 #(32) srcbmux(
		.d0(WriteDataE),
		.d1(ExtImmE),
		.s(ALUSrcE),
		.y(SrcBE)
	);
	
	alu alu(
		SrcAE,
		SrcBE,
		ALUControlE,
		ALUResultE,
		ALUFlagsE
	);
	
	
	mux2 #(32) resmux(
		.d0(ALUOutW),
		.d1(ReadDataW),
		.s(MemtoRegW),
		.y(ResultW)
	);
endmodule
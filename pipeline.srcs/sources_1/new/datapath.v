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
	ReadDataM
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
	wire [31:0] PCnextF;
	wire [31:0] PCPlus4F;
	wire [31:0] PCPlus8D;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [3:0] RA1;
	wire [3:0] RA2;
	wire [3:0] InstrD;
	
	//Fetch
	
	mux2 #(32) pcmux(
		.d0(PCPlus4F),
		.d1(ResultW),
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
	
	//Reg
	
	flopr #(32) InstrReg(
	   .clk(clk),
	   .reset(reset),
	   .d(InstrF),
	   .q(InstrD)
	);

	//Decode
	
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
	
	// reg
	
	flopr #(32) rd1Reg(
	   .clk(clk),
	   .reset(reset),
	   .d(RD1D),
	   .q(RD1E)
	);
	
	flopr #(32) rd2Reg(
	   .clk(clk),
	   .reset(reset),
	   .d(RD2D),
	   .q(WriteDataE)
	);
	
	flopr #(32) ExtImmReg(
	   .clk(clk),
	   .reset(reset),
	   .d(ExtImmD),
	   .q(ExtImmE)
	);
	
	flopr #(32) wa3eReg(
	   .clk(clk),
	   .reset(reset),
	   .d(InstrD[15:12]),
	   .q(WA3E)
	);
	
	// Execute
	
	mux2 #(32) srcbmux(
		.d0(WriteDataE),
		.d1(ExtImmEE),
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
	
	// Reg
	
	
	flopr #(32) aluResReg(
	   .clk(clk),
	   .reset(reset),
	   .d(ALUResultE),
	   .q(ALUOutM)
	);
	
	flopr #(32) wdReg(
	   .clk(clk),
	   .reset(reset),
	   .d(WriteDataE),
	   .q(WriteDataM)
	);
	
	flopr #(32) wa3mReg(
	   .clk(clk),
	   .reset(reset),
	   .d(WA3E),
	   .q(WA3M)
	);
	
	// Memory (output input)
	
	// Reg
	
	flopr #(32) aluoutReg(
	   .clk(clk),
	   .reset(reset),
	   .d(ALUOutM),
	   .q(ALUOutW)
	);
	
	flopr #(32) rdReg(
	   .clk(clk),
	   .reset(reset),
	   .d(ReadDataM),
	   .q(ReadDataW)
	);
	
	flopr #(32) wa3wReg(
	   .clk(clk),
	   .reset(reset),
	   .d(WA3M),
	   .q(WA3W)
	);
	
	
	mux2 #(32) resmux(
		.d0(ALUOutW),
		.d1(ReadDataW),
		.s(MemtoRegW),
		.y(ResultW)
	);
endmodule
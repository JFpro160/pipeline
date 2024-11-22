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
	FlushD,
	FlushE
	
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
	input wire FlushE;
	
	
	wire [31:0] PCnextF;
	wire [31:0] PCnext1F;
	wire [31:0] PCPlus4F;
	wire [31:0] PCPlus8D;
	wire [31:0] RD1D;
	wire [31:0] RD2D;
	wire [31:0] RD1E;
	wire [31:0] RD2E;
	wire [31:0] ExtImmD;
	wire [31:0] ExtImmE;
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;
	wire [31:0] WriteDataE;
	reg [31:0] ALUresultE;
	
	wire [31:0] ReadDataW;
	wire [31:0] ALUOutW;
	wire [31:0] ResultW;
	wire [3:0] RA1D;
	wire [3:0] RA2D;
	wire [3:0] RA1E;
	wire [3:0] RA2E;
	wire [3:0] WA3E;
	wire [3:0] WA3M;
	wire [3:0] WA3W;
	wire Match_1D_E;
	wire Match_2D_E;
	
	//Fetch
	
	mux2 #(32) pcnextmux(
		.d0(PCPlus4F),
		.d1(ResultW),
		.s(PCSrcW),
		.y(PCnext1F)
	);
	
	mux2 #(32) breanchmux(
		.d0(PCnext1F),
		.d1(ALUResultE),
		.s(BranchTakenE),
		.y(PCnextF)
	);
	
	flop #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCnextF),
		.q(PCF),
		.en(~StallF),
		.clr(1'b0)
	);
	adder #(32) pcadd1(
		.a(PCF),
		.b(32'b100),
		.y(PCPlus4F)
	);
	
	//Reg
	
	flop #(32) InstrReg( // falta implementar
	   .clk(clk),
	   .reset(reset),
	   .d(InstrF),
	   .q(InstrD),
	   .en(~StallD),
	   .clr(FlushD)
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
	
	flop #(32) rd1Reg(
	   .clk(clk),
	   .reset(reset),
	   .d(RD1D),
	   .q(RD1E),
	   .clr(FlushE),
	   .en(1'b1)
	);
	
	flop #(32) rd2Reg(
	   .clk(clk),
	   .reset(reset),
	   .d(RD2D),
	   .q(RD2E),
	   .clr(FlushE),
	   .en(1'b1)
	);
	
	flop #(32) ExtImmReg(
	   .clk(clk),
	   .reset(reset),
	   .d(ExtImmD),
	   .q(ExtImmE),
	   .clr(FlushE),
	   .en(1'b1)
	);
	
	flop #(4) wa3eReg(
	   .clk(clk),
	   .reset(reset),
	   .d(InstrD[15:12]),
	   .q(WA3E),
	   .clr(FlushE),
	   .en(1'b1)
	);
	
	flop #(4) RA1Reg(
	   .clk(clk),
	   .reset(reset),
	   .d(RA1D),
	   .q(RA1E),
	   .clr(1'b0),
	   .en(1'b1)
	);
	
	flop #(4) RA2Reg(
	   .clk(clk),
	   .reset(reset),
	   .d(RA2D),
	   .q(RA2E),
	   .clr(1'b0),
	   .en(1'b1)
	);
	
	
	
	// Execute
	
	
	mux3 #(32) byp1mux( // falta implementar
		.d0(RD1E),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardAE),
		.y(SrcAE)
	);
	
	mux3 #(32) byp2mux( // falta implementar
		.d0(RD2E),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardAE),
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
	
	// Reg
	
	
	flop #(32) aluResReg(
	   .clk(clk),
	   .reset(reset),
	   .d(ALUResultE),
	   .q(ALUOutM),
	   .clr(1'b0),
	   .en(1'b1)
	);
	
	flop #(32) wdReg(
	   .clk(clk),
	   .reset(reset),
	   .d(WriteDataE),
	   .q(WriteDataM),
	   .clr(1'b0),
	   .en(1'b1)
	);
	
	flop #(4) wa3mReg(
	   .clk(clk),
	   .reset(reset),
	   .d(WA3E),
	   .q(WA3M),
	   .clr(1'b0),
	   .en(1'b1)
	);
	
	// Memory (output input)
	
	
	// Reg
	
	flop #(32) aluoutReg(
	   .clk(clk),
	   .reset(reset),
	   .d(ALUOutM),
	   .q(ALUOutW),
	   .clr(1'b0),
	   .en(1'b1)
	);
	
	flop #(32) rdReg(
	   .clk(clk),
	   .reset(reset),
	   .d(ReadDataM),
	   .q(ReadDataW),
	   .clr(1'b0),
	   .en(1'b1)
	);
	
	flop #(4) wa3wReg(
	   .clk(clk),
	   .reset(reset),
	   .d(WA3M),
	   .q(WA3W),
	   .clr(1'b0),
	   .en(1'b1)
	);
	
	
	mux2 #(32) resmux(
		.d0(ALUOutW),
		.d1(ReadDataW),
		.s(MemtoRegW),
		.y(ResultW)
	);
	
	// hazards
	
	assign Match_1E_M = WA3M == RA1E;
	assign Match_1E_W = WA3W == RA1E;
	assign Match_2E_M = WA3M == RA2E;
	assign Match_2E_W = WA3W == RA2E;
	assign Match_1D_E = WA3E == RA1D;
	assign Match_2D_E = WA3E == RA2D;
    assign Match_12D_E = Match_1D_E | Match_2D_E; 
	
endmodule
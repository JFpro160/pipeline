module datapath ( 
	input wire clk, reset, BranchTakenD, ALUSrcE, PCSrcW, RegWriteW, MemtoRegW, 
	           StallF, StallD, FlushD, 
	input wire [1:0] RegSrcD, ImmSrcD, ALUControlE, ForwardAE, ForwardBE, 
	input wire [31:0] InstrF, ReadDataM, 
	output wire [31:0] PCF, InstrD, ALUOutM, WriteDataM, 
	output wire [3:0] ALUFlagsE, 
	output wire Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E 
); 
	// Internal wires 
	wire [31:0] PCnext1F, PCnextF, PCPlus4F, PCPlus8D, rd1D, rd2D, ExtImmD, PCBranchD,
	            rd1E, rd2E, ExtImmE, WriteDataE, SrcAE, SrcBE, ALUResultE, 
	            ReadDataW, ALUOutW, ResultW; 
	wire [3:0] RA1D, RA2D, RA1E, RA2E, WA3E, WA3M, WA3W; 
	wire Match_1D_E, Match_2D_E; 

	// Fetch Stage
	mux2 #(32) pcnextmux(
		.d0(PCPlus4F),
		.d1(ResultW),
		.s(PCSrcW),
		.y(PCnext1F)
	);
	mux2 #(32) branchmux(
		.d0(PCnext1F),
		.d1(PCBranchD),
		.s(BranchTakenD),
		.y(PCnextF)
	);
	flopenr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.en(~StallF),
		.d(PCnextF),
		.q(PCF)
	);
	adder #(32) pcadd(
		.a(PCF),
		.b(32'h4),
		.y(PCPlus4F)
	);

	// Decode Stage
	assign PCPlus8D = PCPlus4F;

	flopenrc #(32) instrreg(
		.clk(clk),
		.reset(reset),
		.en(~StallD),
		.clear(FlushD),
		.d(InstrF),
		.q(InstrD)
	);

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
		.clk(clk),
		.we3(RegWriteW),
		.ra1(RA1D),
		.ra2(RA2D),
		.wa3(WA3W),
		.wd3(ResultW),
		.r15(PCPlus8D),
		.rd1(rd1D),
		.rd2(rd2D)
	);
	extend ext(
		.Instr(InstrD[23:0]),
		.ImmSrc(ImmSrcD),
		.ExtImm(ExtImmD)
	);
	adder #(32) pcbranchadd(
	    .a(ExtImmD),
		.b(PCPlus8D),
		.y(PCBranchD)
	);

	// Execute Stage
	flopr #(32) rd1reg(
		.clk(clk),
		.reset(reset),
		.d(rd1D),
		.q(rd1E)
	);
	flopr #(32) rd2reg(
		.clk(clk),
		.reset(reset),
		.d(rd2D),
		.q(rd2E)
	);
	flopr #(32) immreg(
		.clk(clk),
		.reset(reset),
		.d(ExtImmD),
		.q(ExtImmE)
	);
	flopr #(4) wa3ereg(
		.clk(clk),
		.reset(reset),
		.d(InstrD[15:12]),
		.q(WA3E)
	);
	flopr #(4) ra1ereg(
		.clk(clk),
		.reset(reset),
		.d(RA1D),
		.q(RA1E)
	);
	flopr #(4) ra2ereg(
		.clk(clk),
		.reset(reset),
		.d(RA2D),
		.q(RA2E)
	);
	mux3 #(32) byp1mux(
		.d0(rd1E),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardAE),
		.y(SrcAE)
	);
	mux3 #(32) byp2mux(
		.d0(rd2E),
		.d1(ResultW),
		.d2(ALUOutM),
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
		.Flags(ALUFlagsE)
	);

	// Memory Stage
	flopr #(32) aluresreg(
		.clk(clk),
		.reset(reset),
		.d(ALUResultE),
		.q(ALUOutM)
	);
	flopr #(32) wdreg(
		.clk(clk),
		.reset(reset),
		.d(WriteDataE),
		.q(WriteDataM)
	);
	flopr #(4) wa3mreg(
		.clk(clk),
		.reset(reset),
		.d(WA3E),
		.q(WA3M)
	);

	// Writeback Stage
	flopr #(32) aluoutreg(
		.clk(clk),
		.reset(reset),
		.d(ALUOutM),
		.q(ALUOutW)
	);
	flopr #(32) rdreg(
		.clk(clk),
		.reset(reset),
		.d(ReadDataM),
		.q(ReadDataW)
	);
	flopr #(4) wa3wreg(
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

	// Hazard Comparison
	eqcmp #(4) m0(WA3M, RA1E, Match_1E_M);
	eqcmp #(4) m1(WA3W, RA1E, Match_1E_W);
	eqcmp #(4) m2(WA3M, RA2E, Match_2E_M);
	eqcmp #(4) m3(WA3W, RA2E, Match_2E_W);
	eqcmp #(4) m4a(WA3E, RA1D, Match_1D_E);
	eqcmp #(4) m4b(WA3E, RA2D, Match_2D_E);
	assign Match_12D_E = Match_1D_E | Match_2D_E;

endmodule
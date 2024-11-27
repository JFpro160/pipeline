module datapath ( 
	input wire clk, reset, BranchTakenD, ALUSrcE, PCSrcW, RegWriteW, MemtoRegW, 
	           StallF, StallD, FlushD, 
	input wire [1:0] RegSrcD, ImmSrcD, ForwardAE, ForwardBE,ForwardCE, 
	input wire [2:0] ALUControlE,
	input wire Writeback, ShiftControlD,Saturated,
	input wire [31:0] InstrF, ReadDataM, 
	output wire [31:0] PCF, InstrD, ALUOutM, WriteDataM, 
	output wire [3:0] ALUFlagsE,
	output wire Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E 
); 
	// Internal wires 
	wire [31:0] PCnext1F, PCnextF, PCPlus4F, PCPlus8D, RD1D, RD2D, ExtImmD, PCBranchD,
	            RD1E, RD2E, ExtImmE, WriteDataE, SrcAE, SrcBE, ALUResultE, 
	            ReadDataW, ALUOutW, ResultW; 
	wire [3:0] RA1D, RA2D, RA1E, RA2E, WA3E, WA3M, WA3W; 
	wire Match_1D_E, Match_2D_E; 
    wire [3:0] RA1Wire;
    wire [3:0] RA3D;
    wire [31:0] RD3D, RD3E;
    wire [3:0] WA3E_;
    wire [31:0] RotE;
    wire [4:0] shamnt5;
    wire [31:0] SrcCE;
    wire MulOpD,MulOpE;
    wire [1:0] ShiftControlE;
    wire [3:0] rot_immE;
    wire [31:0] RotExtImmE,SrcBEWire;
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

    mux2 #(4) ra1mux_mul(
        .d0(InstrD[19:16]),
        .d1(InstrD[11:8]),
        .s(MulOpD),
        .y(RA1Wire)
    );

	mux2 #(4) ra1mux(
		.d0(RA1Wire),
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
	
	mux2 #(4) ra3mux(
	   .d0(InstrD[11:8]),
	   .d1(InstrD[15:12]),
	   .s(MulOpD),
	   .y(RA3D)
	);
	
	mux2 #(4) wa3mux(
	   .d0(InstrD[15:12]),
	   .d1(InstrD[19:16]),
	   .s(MulOpD),
	   .y(WA3E_)
	);
	
	
	regfile rf(
		.clk(clk),
		.we3(RegWriteW),
		.we1(WriteBack),
		.ra1(RA1D),
		.ra2(RA2D),
		.ra3(RA3D),
		.wa3(WA3W),
		.wd3(ResultW),
		.r15(PCPlus8D),
		.rd1(RD1D),
		.rd2(RD2D),
		.rd3(RD3D)
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
		.d(RD1D),
		.q(RD1E)
	);
	
	flopr #(1) mulopreg(
	   .clk(clk),
	   .reset(reset),
	   .d(MulOpD),
	   .q(MulOpE)
	);

	flopr #(32) rd2reg(
		.clk(clk),
		.reset(reset),
		.d(RD2D),
		.q(RD2E)
	);
	
    flopr #(32) rd3reg(
        .clk(clk),
        .reset(reset),
        .d(RD3D),
        .q(RD3E)
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
		.d(WA3E_),
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
	flopr #(4) rotreg(
	   .clk(clk),
	   .reset(reset),
	   .d(InstrD[11:8]),
	   .q(rot_immE)
	);
	flopr #(2) shcontrol(
	   .clk(clk),
	   .reset(reset),
	   .d(ShiftControlD),
	   .q(ShiftControlE)
	);
	
	flopr #(5) shamnt5reg(
	   .clk(clk),
	   .reset(reset),
	   .d(InstrD[11:7]),
	   .q(shamnt5)
	);
	
	mux3 #(32) byp1mux(
		.d0(RD1E),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardAE),
		.y(SrcAE)
	);
	mux3 #(32) byp2mux(
		.d0(RD2E),
		.d1(ResultW),
		.d2(ALUOutM),
		.s(ForwardBE),
		.y(WriteDataE)
	);
	
	mux3 #(32) byp3mux(
	   .d0(RD3E),
	   .d1(ResultW),
	   .d2(ALUOutM),
	   .s(ForwardCE),
	   .y(SrcCE)
	);
	
	mux2 #(32) rotmux(
	   .d0(shamnt5),
	   .d1(SrcCE),
	   .s(RegShiftE),
	   .y(RotE)
	);
	
	shift shsrcb(
	   .a(WriteDataE),
	   .b(RotE),
	   .d(ShiftControlE),
	   .carry_in(CarryE),
	   .y(ShiftedSrcBE)
	);
	
	
	mux2 #(32) shiftmux(
	   .d0(ShiftedSrcBE),
	   .d1(WriteDataE),
	   .s(MulOpE),
	   .y(SrcBWireE)
	);

    		
	mux2 #(32) srcbmux(
		.d0(SrcBWireE),
		.d1(ImmE),
		.s(ALUSrcE),
		.y(SrcBEWire)
	);
	
	mux2 #(32) srcbmux2(
	   .d0(SrcBEWire),
	   .d1(WriteDataE),
	   .s(SaturatedE),
	   .y(SrcBE)
	);
	
	mux2 #(32) rotextmux(
	   .d0(RotExtImmE),
	   .d1(ExtImmE),
	   .s(MemtoRegE),
	   .y(ImmE)
	);
	
	 rotator ror(
	   .a(ExtImmE),
	   .b(rot_immE),
	   .y(RotExtImmE)
	);
	//critical error just realized that for postindex
	//to work i need to to have ra1 as the adress that ive been passing
	//onto the different registers
	//i need to make this write postindex during the first half of the cycle
	//also a new mux that only activated during the first 
	
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
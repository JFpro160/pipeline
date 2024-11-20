module datapath (
	clk,
	reset,
	RegSrc,
	RegWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	MemtoReg,
	PCSrc,
	ALUFlags,
	PC,
	Instr,
	ALUResultOut,
	WriteData,
	ReadData,
	MulOp, // Nuevo!
	Carry, // new
	Shift, // new
	CarryOut // new
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrc;
	input wire RegWrite;
	input wire [1:0] ImmSrc;
	input wire ALUSrc;
	input wire [3:0] ALUControl; // ch
	input wire MemtoReg;
	input wire PCSrc;
	output wire [3:0] ALUFlags;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire [31:0] ALUResultOut; // lsl?
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	input wire MulOp; // New :v
	input wire Carry; // new
	input wire Shift; // New
	output wire CarryOut; // New
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCPlus8;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] SrcC; // new
	wire [31:0] Result;
	wire [3:0] RA10; // new
	wire [3:0] RA1;
	wire [3:0] RA2;
	wire [3:0] RA3; // new
	wire [3:0] A3; // new
	wire [31:0] SrcBsh, ALUResult; // new lsl
	wire [31:0] SrcB0; // new
	wire [4:0] rotamm; // new
	
	//next PC logic
	mux2 #(32) pcmux( 
		.d0(PCPlus4),
		.d1(Result),
		.s(PCSrc),
		.y(PCNext)
	);
	flopr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCNext),
		.q(PC)
	);
	adder #(32) pcadd1(
		.a(PC),
		.b(32'b100),
		.y(PCPlus4)
	);
	adder #(32) pcadd2(
		.a(PCPlus4),
		.b(32'b100),
		.y(PCPlus8)
	);
	
	// Register File logic
	mux2 #(4) ra1mux0 (       // Nuevo mux dx
		.d0(Instr[19:16]),
		.d1(Instr[11:8]),
		.s(MulOp),
		.y(RA10)
	);
	
	mux2 #(4) ra1mux(
		.d0(RA10), // ch
		.d1(4'b1111),
		.s(RegSrc[0]),
		.y(RA1)
	);
	
	mux2 #(4) a3mux (        // Nuevo mux xd
		.d0(Instr[15:12]),
		.d1(Instr[19:16]),
		.s(MulOp),
		.y(A3)
	);
	
	mux2 #(4) ra2mux(
		.d0(Instr[3:0]),
		.d1(A3), // ch
		.s(RegSrc[1]),
		.y(RA2)
	);
	
	mux2 #(4) ra3mux(      //new
		.d0(Instr[11:8]),
		.d1(Instr[15:12]),
		.s(MulOp),
		.y(RA3)
	);
	
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.ra1(RA1),
		.ra2(RA2),
		.ra3(RA3), // new
		.wa3(A3), // ch
		.wd3(Result),
		.r15(PCPlus8),
		.rd1(SrcA),
		.rd2(WriteData),
		.rd3(SrcC) // new
	);
	mux2 #(32) resmux(
		.d0(ALUResultOut), // ch
		.d1(ReadData),
		.s(MemtoReg),
		.y(Result)
	);
	extend ext(
		.Instr(Instr[23:0]),
		.ImmSrc(ImmSrc),
		.ExtImm(ExtImm)
	);
	
	// ALU logic
	mux2 #(32) rotmux( // new
		.d0({Instr[11:7]}),
		.d1(SrcC[4:0]),
		.s(~Instr[7] & Instr[4]),
		.y(rotamm)
	);
	
	shifter sh(WriteData, rotamm, Carry, Instr[6:5], SrcBsh, CarryOut); // new lsl falta carry out
	
	mux2 #(32) srcb0mux( // new
		.d0(SrcBsh),
		.d1(WriteData),
		.s(MulOp),
		.y(SrcB0)
	);
	
	mux2 #(32) srcbmux(
		.d0(SrcB0), // ch
		.d1(ExtImm),
		.s(ALUSrc),
		.y(SrcB)
	);
	alu alu(
		SrcA,
		SrcB,
		SrcC, // new
		ALUControl,
		ALUResult,
		ALUFlags,
		Carry // new
	);
	mux2 #(32) aluresultmux(ALUResult, SrcB, Shift, ALUResultOut); // new
endmodule
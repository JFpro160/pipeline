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
	ALUResult,
	WriteData,
	ReadData,
	MulOp,
	shamnt5,
	Carry,
	Shift,
	ShiftControl,
	RegShift
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrc;
	input wire RegWrite;
	input wire [1:0] ImmSrc;
	input wire ALUSrc;
	input wire [2:0] ALUControl;
	input wire MemtoReg;
	input wire PCSrc;
	output wire [3:0] ALUFlags;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [31:0] SrcBWire;
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCPlus8;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] SrcC;
	wire [31:0] Result;
	wire [3:0] RA1;
	wire [3:0] RA1Wire;
	wire [3:0] RA2;
	wire [3:0] WA3;
	wire [3:0] RA3;
	input wire Shift;
	input wire MulOp;
	input wire Carry;
	wire [4:0] Rot;
	input wire [4:0] shamnt5;
	input wire [1:0] ShiftControl;
	input wire RegShift;
	wire [31:0] ShiftedSrcB;
	wire [31:0] PreResult;
	
	
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
    mux2 #(4) mulra1mux(
	.d0(Instr[19:16]),
	.d1(Instr[11:8]),
	.s(MulOp),
	.y(RA1Wire)
	);
	
	mux2 #(4) ra1mux(
		.d0(RA1Wire),
		.d1(4'b1111),
		.s(RegSrc[0]),
		.y(RA1)
	);

	mux2 #(4) ra2mux(
		.d0(Instr[3:0]),
		.d1(Instr[15:12]),
		.s(RegSrc[1]),
		.y(RA2)
	);
	
	mux2 #(4) ra3mux(
	   .d0(Instr[11:8]),
	   .d1(Instr[15:12]),
	   .s(MulOp),
	   .y(RA3)
	);
	mux2 #(4) rwa3mux(
	   .d0(Instr[15:12]),
	   .d1(Instr[19:16]),
	   .s(MulOp),
	   .y(WA3)
	); 
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.ra1(RA1),
		.ra2(RA2),
		.ra3(RA3),
		.wa3(WA3),
		.wd3(Result),
		.r15(PCPlus8),
		.rd1(SrcA),
		.rd2(WriteData),
		.rd3(SrcC)
	);
	extend ext(
		.Instr(Instr[23:0]),
		.ImmSrc(ImmSrc),
		.ExtImm(ExtImm)
	);
	
	mux2 #(32) rotmux(
	   .d0(shamnt5),
	   .d1(SrcC),
	   .s(RegShift),
	   .y(Rot)
	);
	
	shift sh(
	   .a(WriteData),
	   .b(Rot),
	   .d(ShiftControl),
	   .carry_in(Carry),
	   .y(ShiftedSrcB)
	);
	
//	mux2 #(32) shiftmux(
//	   .d0(WriteData),
//	   .d1(ShiftedSrcB),
//	   .s(Shift),
//	   .y(SrcBWire)
//	);

	mux2 #(32) srcbmux(
		.d0(ShiftedSrcB),
		.d1(ExtImm),
		.s(ALUSrc),
		.y(SrcB)
	);
	alu alu(
		.a(SrcA),
		.b(SrcB),
		.c(SrcC),
		.ALUControl(ALUControl),
		.Result(PreResult),
		.ALUFlags(ALUFlags)
	);
	mux2 #(32) resultmux(    
	   .d0(PreResult),       
	   .d1(ShiftedSrcB),     
	   .s(Shift),            
	   .y(ALUResult)         
	);                   
	mux2 #(32) resmux( 
	.d0(ALUResult),   
	.d1(ReadData),    
	.s(MemtoReg),     
	.y(Result)        
    );                     
endmodule
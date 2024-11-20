module controller (
	clk,
	reset,
	InstrD,
	ALUFlagsE,
	RegSrcD,
	RegWriteW,
	ImmSrcD,
	ALUSrcE,
	ALUControlE,
	MemWriteM,
	MemtoRegE,
	PCSrcW,
	BranchTakenE,
	MemtoRegW,
	RegWriteM,
	PCWrPendingF,
	FlushE
);
	input wire clk;
	input wire reset;
	input wire [31:12] InstrD;
	input wire [3:0] ALUFlagsE;
	output wire [1:0] RegSrcD;
	output wire RegWriteW;
	output wire [1:0] ImmSrcD;
	output wire ALUSrcE;
	output wire [1:0] ALUControlE;
	output wire MemWriteM;
	output wire MemtoRegE;
	output wire PCSrcW;
	output wire BranchTakenE;
	output wire MemtoRegW;
	output wire RegWriteM;
	output wire PCWrPendingF;
	input wire FlushE;
	wire [1:0] FlagW;
	wire PCS;
	wire RegW;
	wire MemW;
	decode dec(
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.Rd(Instr[15:12]),
		.FlagW(FlagW),
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.MemtoReg(MemtoReg),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl)
	);
	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Cond(Instr[31:28]),
		.ALUFlags(ALUFlags),
		.FlagW(FlagW),
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.PCSrcD(PCSrcD),
		.RegWriteD(RegWriteD),
		.MemWriteD(MemWriteD)
	);
	
	
	// flip flop
endmodule
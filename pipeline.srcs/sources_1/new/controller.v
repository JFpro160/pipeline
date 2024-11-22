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
	wire PCSrcD;
	wire RegWriteD;
	wire MemtoRegD;
	wire MemWriteD;
	wire [1:0] ALUControlD;
	wire BranchD;
	wire ALUSrcD;
	wire [1:0] FlagWriteD;
	wire [1:0] FlagWriteE;
	wire PCSrcE;
	wire RegWriteE;
	wire MemWriteE;
	wire BranchE;
	wire [3:0] CondE;
	wire [3:0] FlagsE;
	wire [3:0] Flags;
	wire PCSrcAndCondExE;
	wire RegWriteEAndCondExe;
	wire MemWriteEAndCondExE;
	wire CondExE;
	wire PCSrcM;
	wire MemtoRegM;





	decode dec(
		.Op(InstrD[27:26]),
		.Funct(InstrD[25:20]),
		.Rd(InstrD[15:12]),
		.PCSrcD(PCSrcD),
		.RegWriteD(RegWriteD),
		.MemtoRegD(MemtoRegD),
		.MemWriteD(MemWriteD),
		.ALUControlD(ALUControlD),
		.BranchD(BranchD),
		.ALUSrcD(ALUSrcD),
		.FlagWriteD(FlagWriteD),
		.ImmSrcD(ImmSrcD),
		.RegSrcD(RegSrcD)
	);
	
	// reg Decode  a Execute(todos son flop clear en flushE)
	flop #(1) RegPCSrc( 
		.clk(clk),
		.reset(reset),
		.d(PCSrcD),
		.q(PCSrcE),
		.en(1'b1),
		.clr(FlushE)
	);

	flop #(1) RegRegWrite(
		.clk(clk),
		.reset(reset),
		.d(RegWriteD),
		.q(RegWriteE),
		.en(1'b1),
		.clr(FlushE)
	);

	flop #(1) RegMemtoReg(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegD),
		.q(MemtoRegE),
		.en(1'b1),
		.clr(FlushE)
	);

	flop #(1) RegMemWrite(
		.clk(clk),
		.reset(reset),
		.d(MemWriteD),
		.q(MemWriteE),
		.en(1'b1),
		.clr(FlushE)
	);

	flop #(2) RegALUControl(
		.clk(clk),
		.reset(reset),
		.d(ALUControlD),
		.q(ALUControlE),
		.en(1'b1),
		.clr(FlushE)
	);

	flop #(1) RegBranch(
		.clk(clk),
		.reset(reset),
		.d(BranchD),
		.q(BranchE),
		.en(1'b1),
		.clr(FlushE)
	);

	flop #(1) RegALUSrc(
		.clk(clk),
		.reset(reset),
		.d(ALUSrcD),
		.q(ALUSrcE),
		.en(1'b1),
		.clr(FlushE)
	);

	flop #(2) RegFlagWrite(
		.clk(clk),
		.reset(reset),
		.d(FlagWriteD),
		.q(FlagWriteE),
		.en(1'b1),
		.clr(FlushE)
	);

	flop #(4) RegCond(
		.clk(clk),
		.reset(reset),
		.d(InstrD[31:28]),
		.q(CondE),
		.en(1'b1),
		.clr(FlushE)
	);

	flop #(4) RegFlags(
		.clk(clk),
		.reset(reset),
		.d(Flags),
		.q(FlagsE),
		.en(1'b1),
		.clr(FlushE)
	);

	//condlogic 

	assign PCSrcAndCondExE = PCSrcE & CondExE;
	assign PCSrcAndCondExEOrBranchEAndCondExE = PCSrcAndCondExE | BranchTakenE;
	assign RegWriteEAndCondExe = RegWriteE & CondExE;
	assign MemWriteEAndCondExE = MemWriteE & CondExE;
	assign BranchTakenE = BranchE & CondExE;
	
	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Flags(Flags),
		.CondE(CondE),
		.FlagsE(FlagsE),
		.FlagsWrite(FlagWriteE),
		.CondExE(CondExE),
		.ALUFlags(ALUFlagsE)
	);

	// reg Execute to Memory todos normales

	flop #(1) RegPCSrcE(
		.clk(clk),
		.reset(reset),
		.d(PCSrcAndCondExEOrBranchEAndCondExE),
		.q(PCSrcM),
		.en(1'b1),
		.clr(1'b0)
	);

	flop #(1) RegRegWriteE(
		.clk(clk),
		.reset(reset),
		.d(RegWriteEAndCondExe),
		.q(RegWriteM),
		.en(1'b1),
		.clr(1'b0)
	);

	flop #(1) RegMemtoRegE(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegE),
		.q(MemtoRegM),
		.en(1'b1),
		.clr(1'b0)
	);

	flop #(1) RegMemWriteE(
		.clk(clk),
		.reset(reset),
		.d(MemWriteEAndCondExE),
		.q(MemWriteM),
		.en(1'b1),
		.clr(1'b0)
	);

	// reg Memory to Writeback

	flop #(1) RegPCSrcM(
		.clk(clk),
		.reset(reset),
		.d(PCSrcM),
		.q(PCSrcW),
		.en(1'b1),
		.clr(1'b0)
	);

	flop #(1) RegRegWriteM(
		.clk(clk),
		.reset(reset),
		.d(RegWriteM),
		.q(RegWriteW),
		.en(1'b1),
		.clr(1'b0)
	);

	flop #(1) RegMemtoRegM(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegM),
		.q(MemtoRegW),
		.en(1'b1),
		.clr(1'b0)
	);
	
	assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
	

endmodule
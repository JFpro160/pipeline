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
	reg [1:0] FlagWriteD;
	wire PCSrcE;
	wire RegWriteE;
	wire MemtoRegE;
	wire MemWriteE;
	wire [2:0] ALUControlE;
	wire BranchE;
	reg [1:0] FlagsWriteE;
	wire [1:0] CondE;
	wire [3:0] FlagsE;
	wire [3:0] Flags;
	wire PCSrcAndCondExE;
	wire PCSrcAndCondExEOrBranchEAndCondExE;
	wire RegWriteEAndCondExe;
	wire MemWriteEAndCondExE;
	wire BranchEAndCondExE;
	wire [3:0] CondExE;
	wire PCSrcM;
	wire RegWriteM;
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
	
	// reg Decode  a Execute
	floprc #(1) RegPCSrc(
		.clk(clk),
		.reset(reset),
		.d(PCSrcD),
		.q(PCSrcE)
	);

	floprc #(1) RegRegWrite(
		.clk(clk),
		.reset(reset),
		.d(RegWriteD),
		.q(RegWriteE)
	);

	floprc #(1) RegMemtoReg(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegD),
		.q(MemtoRegE)
	);

	floprc #(1) RegMemWrite(
		.clk(clk),
		.reset(reset),
		.d(MemWriteD),
		.q(MemWriteE)
	);

	floprc #(2) RegALUControl(
		.clk(clk),
		.reset(reset),
		.d(ALUControlD),
		.q(ALUControlE)
	);

	floprc #(1) RegBranch(
		.clk(clk),
		.reset(reset),
		.d(BranchD),
		.q(BranchE)
	);

	floprc #(1) RegALUSrc(
		.clk(clk),
		.reset(reset),
		.d(ALUSrcD),
		.q(ALUSrcE)
	);

	floprc #(2) RegFlagWrite(
		.clk(clk),
		.reset(reset),
		.d(FlagWriteD),
		.q(FlagWriteE)
	);

	floprc #(2) RegCond(
		.clk(clk),
		.reset(reset),
		.d(InstrD[31:28]),
		.q(CondE)
	);

	floprc #(4) RegFlags(
		.clk(clk),
		.reset(reset),
		.d(Flags),
		.q(FlagsE)
	);

	//condlogic 

	assign PCSrcAndCondExE = PCSrcE & CondExE;
	assign PCSrcAndCondExEOrBranchEAndCondExE = PCSrcAndCondExE | BranchEAndCondExE;
	assign RegWriteEAndCondExe = RegWriteE & CondExE;
	assign MemWriteEAndCondExE = MemWriteE & CondExE;
	assign BranchEAndCondExE = BranchE & CondExE;
	
	condlogic cl(
		.clk(clk),
		.reset(reset),
		.Flags(Flags),
		.CondE(CondE),
		.FlagsE(FlagsE),
		.FlagsWrite(FlagsWrite),
		.CondExE(CondExE),
		.ALUFlags(ALUFlags)
	);

	// reg Execute to Memory

	flopr #(1) RegPCSrcE(
		.clk(clk),
		.reset(reset),
		.d(PCSrcAndCondExEOrBranchEAndCondExE),
		.q(PCSrcM)
	);

	floprc #(1) RegRegWriteE(
		.clk(clk),
		.reset(reset),
		.d(RegWriteEAndCondExe),
		.q(RegWriteM)
	);

	floprc #(1) RegMemtoRegE(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegE),
		.q(MemtoRegM)
	);

	floprc #(1) RegMemWriteE(
		.clk(clk),
		.reset(reset),
		.d(MemWriteEAndCondExE),
		.q(MemWriteM)
	);

	// reg Memory to Writeback

	flopr #(1) RegPCSrcM(
		.clk(clk),
		.reset(reset),
		.d(PCSrcM),
		.q(PCSrcW)
	);

	flopr #(1) RegRegWriteM(
		.clk(clk),
		.reset(reset),
		.d(RegWriteM),
		.q(RegWriteW)
	);

	flopr #(1) RegMemtoRegM(
		.clk(clk),
		.reset(reset),
		.d(MemtoRegM),
		.q(MemtoRegW)
	);



	

	
	assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
	
	
	// flip flop
endmodule
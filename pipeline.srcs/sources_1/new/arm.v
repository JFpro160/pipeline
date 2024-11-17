module arm (
	clk,
	reset,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire MemWrite;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [3:0] ALUFlags;
	wire RegWrite;
	wire ALUSrc;
	wire MemtoReg;
	wire PCSrc;
	wire MulOp; // new
	wire Carry; // new
	wire Shift; // new
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire [3:0] ALUControl; // ch
	wire CarrySh; // new
	controller c(
		.clk(clk),
		.reset(reset),
		.Instr(Instr[31:12]),
		.Mult(Instr[7:4]), // new
		.ALUFlags(ALUFlags),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemWrite(MemWrite),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.MulOp(MulOp), // new
		//.Carry((~Instr[27:26] & ) ? CarrySh : Carry), // new
		.Carry(Carry),
		.Shift(Shift) // new
	);
	datapath dp(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCSrc),
		.ALUFlags(ALUFlags),
		.PC(PC),
		.Instr(Instr),
		.ALUResultOut(ALUResult), // ch
		.WriteData(WriteData),
		.ReadData(ReadData),
		.MulOp(MulOp), // new
		.Carry(Carry), // new
		.Shift(Shift), // new
		.CarryOut(CarryOut) // new
	);
endmodule
module controller (
	clk,
	reset,
	Instr,
	Mult, // new
	ALUFlags,
	RegSrc,
	RegWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	MemWrite,
	MemtoReg,
	PCSrc,
	MulOp, // new
	Carry, // new
	Shift // new
	
);
	input wire clk;
	input wire reset;
	input wire [31:12] Instr;
	input wire [3:0] Mult; // new
	input wire [3:0] ALUFlags;
	output wire [1:0] RegSrc;
	output wire RegWrite;
	output wire [1:0] ImmSrc;
	output wire ALUSrc;
	output wire [3:0] ALUControl; // ch
	output wire MemWrite;
	output wire MemtoReg;
	output wire PCSrc;
	output wire MulOp; // new
	output wire Carry; // new
	output wire Shift; // new
	wire [1:0] FlagW;
	wire PCS;
	wire RegW;
	wire MemW;
	wire NoWrite; // new
	
	assign MulOp = ~Instr[27:24] & Mult == 4'b1001; // new
	
	decode dec(
		.Op(Instr[27:26]),
		.Funct(Instr[25:20]),
		.MulOp(MulOp), // new
		.Rd(MulOp ? Instr[19:16] : Instr[15:12]), // ch
		.FlagW(FlagW),
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.MemtoReg(MemtoReg),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl),
		.NoWrite(NoWrite), // new
		.Shift(Shift) // new
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
		.PCSrc(PCSrc),
		.RegWrite(RegWrite),
		.MemWrite(MemWrite),
		.Carry(Carry), // ch
		.NoWrite(NoWrite) // ch
	);
endmodule
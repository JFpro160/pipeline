module condlogic (
	clk,
	reset,
	Flags,
	CondE,
	FlagsE,
	FlagsWrite,
	CondExE,
	ALUFlags
);
	input wire clk;
	input wire reset;
	input wire [3:0] ALUFlags;
	output wire CondExE;
	output wire [3:0] Flags;
	input wire [3:0] FlagsE;
	input wire CondE;
	input wire [1:0] FlagsWrite;
	condcheck cc(
		.Cond(CondE),
		.Flags(FlagsE),
		.CondEx(CondExE)
	);
	
	assign Flags = {(FlagsWrite[1] & CondExE)?ALUFlags[3:2]:FlagsE[3:2],
	                (FlagsWrite[0] & CondExE)?ALUFlags[1:0]:FlagsE[1:0]};
endmodule
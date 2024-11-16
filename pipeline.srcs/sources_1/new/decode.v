module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	ImmSrc,
	RegSrc,
	ALUControl,
	MulOp,
	MulCode,
	Shift,
	RegShift
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	input wire [3:0] MulCode;
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [2:0] ALUControl;
	output wire MulOp;
	output wire Shift;
	output wire RegShift;
	reg [9:0] controls;
	wire Branch;
	wire ALUOp;
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 10'b0000101001;
				else
					controls = 10'b0000001001;
			2'b01:
				if (Funct[0])
					controls = 10'b0001111000;
				else
					controls = 10'b1001110100;
			2'b10: controls = 10'b0110100010;
			default: controls = 10'bxxxxxxxxxx;
		endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	assign MulOp = ((Funct[5:4] == 2'b00) & (MulCode == 4'b1001));
	assign Shift = (Funct[4:1] == 4'b1101);
	assign RegShift = (MulCode[3] == 1'b0 & MulCode[0] == 1'b1 & Funct[5] == 1'b0);
	always @(*)
		if (ALUOp) begin
			case (Funct[4:1])
				4'b0100: ALUControl = 3'b000;
				4'b0010: ALUControl = 3'b001;
				4'b0000: ALUControl = 3'b010;
				4'b1100: ALUControl = 3'b011;
				4'b1101: ALUControl = 3'b000;
				default: ALUControl = 3'bxxx;
			endcase
			if(MulOp)
			begin
			case (Funct[3:1])
			 3'b000: ALUControl = 3'b100; //MUL
			 3'b001: ALUControl = 3'b101; //MAL
			 default: ALUControl = 3'b000; //xd?
			 endcase
			end
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 2'b00) | (ALUControl == 2'b01));
		end
		else begin
			ALUControl = 2'b00;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule
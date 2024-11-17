module decode (
	Op,
	Funct,
	MulOp, // new
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
	NoWrite,
	Shift
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	input wire MulOp; // new
	output reg [1:0] FlagW;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [3:0] ALUControl; // ch
	output reg NoWrite; // new
	output reg Shift; // new
	reg [9:0] controls;
	wire Branch;
	wire ALUOp;
	
	// Main Decoder
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 10'b0000101001; // immediate
				else 
				    controls = 10'b0000001001; // register
			2'b01:
				if (Funct[0])
					controls = 10'b0001111000; // ldr
				else
					controls = 10'b1001110100; // str
			2'b10: controls = 10'b0110100010; // b
			default: controls = 10'bxxxxxxxxxx;
		endcase
	
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	
	// ALU Decoder
	always @(*)
	    if (MulOp) begin // new
	       case (Funct[3:1])
				3'b000: ALUControl = 4'b0101; // mul
				3'b001: ALUControl = 4'b0110; // mla
				3'b010: ALUControl = 4'b0100; // sdiv
				3'b011: ALUControl = 4'b0111; // udiv
				default: ALUControl = 4'bxxxx; // ch
			endcase
			FlagW[1] = Funct[0]; // NZ
			FlagW[0] = 0; // OV
			NoWrite = 1'b0; // new
			Shift = 1'b0; // new
	    end else
		if (ALUOp) begin // ch
			case (Funct[4:1])
				4'b0100: begin
				    ALUControl = 4'b0000; // add
				    NoWrite = 1'b0;
				    Shift = 1'b0;
				    end
				4'b0010: begin
				    ALUControl = 4'b0001; // sub
				    NoWrite = 1'b0;
				    Shift = 1'b0;
				    end
				4'b0000: begin
				    ALUControl = 4'b0010; // and
				    NoWrite = 1'b0;
				    Shift = 1'b0;
				    end
				4'b1100: begin
				    ALUControl = 4'b0011; // or
				    NoWrite = 1'b0;
				    Shift = 1'b0;
				    end
				4'b1111: begin
				    ALUControl = 4'b1000; // MVN
				    NoWrite = 1'b0;
				    Shift = 1'b0;
				    end
				4'b1101: begin
				    ALUControl = 4'b0000; // lsl
				    NoWrite = 1'b0;
				    Shift = 1'b1;
				    end
				default: begin
				    ALUControl = 4'bxxxx; //ch
				    NoWrite = 1'bx; // new
				    Shift = 1'bx; // new
				    end
			endcase
			FlagW[1] = Funct[0]; // S
			FlagW[0] = Funct[0] & ((ALUControl == 3'b000) | (ALUControl == 3'b001)); // ch
		end
		else begin
			ALUControl = 4'b0000; // ch
			FlagW = 2'b00;
			NoWrite = 1'b0; // new
			Shift = 1'b0; // new
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch; // PC Logic
endmodule
module condcheck (
	Cond,
	Flags,
	CondEx
);
	input wire [3:0] Cond;
	input wire [3:0] Flags;
	output reg CondEx;
	wire neg;
	wire zero;
	wire carry;
	wire overflow;
	wire ge;
	assign {neg, zero, carry, overflow} = Flags;
	assign ge = neg == overflow;
	always @(*)
		case (Cond)
			4'b0000: CondEx = zero; // eq
			4'b0001: CondEx = ~zero; // ne
			4'b0010: CondEx = carry; // cs
			4'b0011: CondEx = ~carry; // cc
			4'b0100: CondEx = neg; // mi
			4'b0101: CondEx = ~neg; // pl
			4'b0110: CondEx = overflow; // vs
			4'b0111: CondEx = ~overflow; // vc
			4'b1000: CondEx = carry & ~zero; // hi
			4'b1001: CondEx = ~(carry & ~zero); // ls
			4'b1010: CondEx = ge; // ge
			4'b1011: CondEx = ~ge; // lt
			4'b1100: CondEx = ~zero & ge; // gt
			4'b1101: CondEx = ~(~zero & ge); // le
			4'b1110: CondEx = 1'b1; // always
			default: CondEx = 1'bx;
		endcase
endmodule
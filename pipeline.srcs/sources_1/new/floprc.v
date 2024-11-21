module floprc (
	clk,
	reset,
	clr,
	d,
	q
);
	parameter WIDTH = 8;
	input wire clk;
	input wire reset, clr;
	input wire [WIDTH - 1:0] d;
	output reg [WIDTH - 1:0] q;
	always @(posedge clk, posedge reset)
        if (reset) q <= 0;
        else if (clr) q <= 0;
             else q <= d;
endmodule

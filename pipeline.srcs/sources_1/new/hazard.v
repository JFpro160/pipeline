module hazard(
        clk,
	    reset,
	    RA1D,
	    RA2D,
	    WA3E,
		Match_1E_M,
		Match_1E_W,
		Match_2E_M,
		Match_2E_W,
		Match_12D_E,
		ForwardAE,
		ForwardBE,
		StallF,
		StallD,
		FlushD,
		FlushE,
		BranchTakenE,
		PCWrPendingF,
		RegWriteW,
		RegWriteM,
		MemtoRegE,
		PCSrcW,
		RA1D,
		RA2D,
		WA3E
    );
    input wire clk;
	input wire reset;
	input wire	Match_1E_M;
	input  wire	Match_1E_W;
	input wire Match_2E_M;
	input wire	Match_2E_W;
	input wire	Match_12D_E;
	input wire [3:0] RA1D;
	input wire [3:0] RA2D;
	input wire [3:0] WA3E;
	output wire [1:0] ForwardAE;
	output wire	[1:0] ForwardBE;
	input wire	StallF;
	input wire	StallD;
	input wire	FlushD;
	input wire	FlushE;
	input wire	BranchTakenE;
	input wire	PCWrPendingF;
	input wire	RegWriteW;
	input wire	RegWriteM;
	input wire	MemtoRegE;
	input wire	PCSrcW;
	assign ForwardAE = Match_1E_M & RegWriteM ? 2'b10 : 
	                   Match_1E_W & RegWriteW ? 2'b01 : 
	                   2'b00;
                   
    assign ForwardBE = Match_2E_M & RegWriteM ? 2'b10 : 
	                   Match_2E_W & RegWriteW ? 2'b01 : 
	                   2'b00;

    assign Match_12D_E = (RA1D == WA3E) | (RA2D == WA3E);
    assign LDRstall = Match_12D_E & MemtoRegE;
    assign StallF = LDRstall;
    assign StallD = LDRstall;
    assign FlushE = LDRstall;
    assign FlushD = LDRstall;
endmodule

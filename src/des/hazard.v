module hazard (
    input wire clk, reset, BranchMissed, MemtoRegE, RegWriteM, PCSrcW, RegWriteW, 
               PCWrPendingF, Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, 
               Match_12D_E,  Match_3E_M, Match_3E_W,MemWriteE,
               Match_1E_M_Index,Match_1E_W_Index,WriteBackM,WriteBackW,
	Match_2E_M_Index,Match_2E_W_Index, Match_3E_M_Index, Match_3E_W_Index,
    output reg [1:0] ForwardAE, ForwardBE,ForwardCE,ForwardAEIndex,ForwardBEIndex,ForwardCEIndex,
    output wire StallF, StallD, FlushD, FlushE
);
    wire ldrStallD;

    // Forwarding logic
    always @(*) begin
        if (Match_1E_M & RegWriteM)
            ForwardAE = 2'b10;
        else if (Match_1E_W & RegWriteW)
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;
        if(Match_1E_M_Index & WriteBackM) 
            ForwardAEIndex = 2'b10;
        else if(Match_1E_W_Index & WriteBackW)
            ForwardAEIndex = 2'b01;
        else 
            ForwardAEIndex = 2'b00;
        
        if (Match_2E_M & RegWriteM)
            ForwardBE = 2'b10;
        else if (Match_2E_W & RegWriteW)
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
            
        if(Match_2E_M_Index & WriteBackM) 
            ForwardBEIndex = 2'b10;
        else if(Match_2E_W_Index & WriteBackW)
            ForwardBEIndex = 2'b01;
        else 
            ForwardBEIndex = 2'b00;
            
        if (Match_3E_M & RegWriteM)
            ForwardCE = 2'b10;
        else if (Match_3E_W & RegWriteW)
            ForwardCE = 2'b01;
        else
            ForwardCE = 2'b00;
            
        if(Match_3E_M_Index & WriteBackM) 
            ForwardCEIndex = 2'b10;
        else if(Match_3E_W_Index & WriteBackW)
            ForwardCEIndex = 2'b01;
        else 
            ForwardCEIndex = 2'b00;
    end

    // Load RAW hazard
    assign ldrStallD = Match_12D_E & MemtoRegE & ~MemWriteE;

    // Stall and flush logic
    assign StallD = ldrStallD;
    assign StallF = ldrStallD | PCWrPendingF;
    
    assign FlushE = ldrStallD;
    assign FlushD = PCWrPendingF | PCSrcW | BranchMissed;

endmodule
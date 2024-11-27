module hazard (
    input wire clk, reset, BranchTakenD, MemtoRegE, RegWriteM, PCSrcW, RegWriteW, 
               PCWrPendingF, Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, 
               Match_12D_E, Prediction,
    output reg [1:0] ForwardAE, ForwardBE,
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

        if (Match_2E_M & RegWriteM)
            ForwardBE = 2'b10;
        else if (Match_2E_W & RegWriteW)
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end

    // Load RAW hazard
    assign ldrStallD = Match_12D_E & MemtoRegE;

    // Stall and flush logic
    assign StallD = ldrStallD;
    assign StallF = ldrStallD | PCWrPendingF;
    
    assign FlushE = ldrStallD;
    assign FlushD = PCWrPendingF | PCSrcW | BranchTakenD ^ Prediction;

endmodule
module hazard (
    input wire clk,
    input wire reset,
    input wire Match_1E_M,
    input wire Match_1E_W,
    input wire Match_2E_M,
    input wire Match_2E_W,
    input wire Match_12D_E,
    input wire RegWriteM,
    input wire RegWriteW,
    input wire BranchTakenE,
    input wire MemtoRegE,
    input wire PCWrPendingF,
    input wire PCSrcW,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output wire StallF,
    output wire StallD,
    output wire FlushD,
    output wire FlushE
);

    wire ldrStallD;

    // Forwarding logic
    always @ (*) begin
        // Forwarding for source operand A
        if (Match_1E_M & RegWriteM)
            ForwardAE = 2'b10;
        else if (Match_1E_W & RegWriteW)
            ForwardAE = 2'b01;
        else
            ForwardAE = 2'b00;

        // Forwarding for source operand B
        if (Match_2E_M & RegWriteM)
            ForwardBE = 2'b10;
        else if (Match_2E_W & RegWriteW)
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;
    end

    // Stall and flush logic
    assign ldrStallD = Match_12D_E & MemtoRegE;
    assign StallD = ldrStallD;
    assign StallF = ldrStallD | PCWrPendingF;
    assign FlushE = ldrStallD | BranchTakenE;
    assign FlushD = PCWrPendingF | PCSrcW | BranchTakenE;
    assign StallF = ldrStallD | PCWrPendingF;

endmodule
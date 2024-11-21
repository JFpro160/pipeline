module condlogic (
    input wire clk,
    input wire reset,
    input wire [3:0] CondE,         // Condition code
    input wire [3:0] FlagsE,        // Current Flags
    input wire [3:0] ALUFlags,      // ALU Flags to update
    input wire [1:0] FlagsWrite,    // Control to write Flags
    output wire CondExE,            // Condition evaluation result
    output wire [3:0] FlagsNextE    // Updated Flags
);

    // Instantiate condcheck for condition evaluation
    condcheck cc (
        .Cond(CondE),
        .Flags(FlagsE),
        .CondEx(CondExE)
    );

    // Flags update logic
    assign FlagsNextE[3:2] = (FlagsWrite[1] & CondExE) ? ALUFlags[3:2] : FlagsE[3:2];
    assign FlagsNextE[1:0] = (FlagsWrite[0] & CondExE) ? ALUFlags[1:0] : FlagsE[1:0];

endmodule
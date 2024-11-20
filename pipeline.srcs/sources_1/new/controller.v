module controller (
    clk,
    reset,
    InstrD,
    ALUFlagsE,
    RegSrcD,
    RegWriteW,
    ImmSrcD,
    ALUSrcE,
    ALUControlE,
    MemWriteM,
    MemtoRegE,
    PCSrcW,
    BranchTakenE,
    MemtoRegW,
    RegWriteM,
    PCWrPendingF,
    FlushE
);
    input wire clk;
    input wire reset;
    input wire [31:12] InstrD;
    input wire [3:0] ALUFlagsE;
    output wire [1:0] RegSrcD;
    output wire RegWriteW;
    output wire [1:0] ImmSrcD;
    output wire ALUSrcE;
    output wire [1:0] ALUControlE;
    output wire MemWriteM;
    output wire MemtoRegE;
    output wire PCSrcW;
    output wire BranchTakenE;
    output wire MemtoRegW;
    output wire RegWriteM;
    output wire PCWrPendingF;
    output wire FlushE;

    wire [1:0] FlagW;
    wire PCS;
    wire RegW;
    wire MemW;

    decode dec(
        .Op(InstrD[27:26]),
        .Funct(InstrD[25:20]),
        .Rd(InstrD[15:12]),
        .FlagW(FlagWD),
        .PCS(PCS),
        .RegW(RegW),
        .MemW(MemW),
        .MemtoReg(MemtoRegD),
        .ALUSrc(ALUSrcE),
        .ImmSrc(ImmSrcD),
        .RegSrc(RegSrcD),
        .ALUControl(ALUControlD)
    );

    condlogic cl(
        .clk(clk),
        .reset(reset),
        .Cond(InstrD[31:28]),
        .ALUFlags(ALUFlagsE),
        .FlagW(FlagWD),
        .PCS(PCS),
        .RegW(RegW),
        .MemW(MemW),
        .PCSrc(PCSrcW),
        .RegWrite(RegWriteW),
        .MemWrite(MemWriteM)
    );

    assign BranchTakenE = PCS;  // Derived from PCS signal in `condlogic`.
    assign PCWrPendingF = PCS;  // Example connection, if required.
    assign FlushE = PCS;        // Example connection, if required.

endmodule

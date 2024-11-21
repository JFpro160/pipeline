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
    input wire FlushE;

    // Internal signals
    wire [9:0] controlsD;
    wire [1:0] FlagWriteD, FlagWriteE;
    wire ALUOpD, BranchD, PCSrcD, PCSrcE, PCSrcM;
    wire MemWriteD, MemWriteE, MemWriteGatedE, MemtoRegD, MemtoRegM;
    wire RegWriteD, RegWriteE, RegWriteGatedE, ALUSrcD;
    wire [1:0] ALUControlD;
    wire CondExE;
    wire [3:0] CondE, FlagsE, FlagsNextE;

    // Decode stage logic
    decode dec(
        .Op(InstrD[27:26]),
        .Funct(InstrD[25:20]),
        .Rd(InstrD[15:12]),
        .FlagWriteD(FlagWriteD),
        .PCSrcD(PCSrcD),
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .MemtoRegD(MemtoRegD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD),
        .RegSrcD(RegSrcD),
        .ALUControlD(ALUControlD)
    );

    // Execute stage flip-flops
    flopr #(7) flushedregsE (
        .clk(clk),
        .reset(reset),
        .d({FlagWriteD, BranchD, MemWriteD, RegWriteD, PCSrcD, MemtoRegD}),
        .q({FlagWriteE, BranchE, MemWriteE, RegWriteE, PCSrcE, MemtoRegE})
    );

    flopr #(3) regsE (
        .clk(clk),
        .reset(reset),
        .d({ALUSrcD, ALUControlD}),
        .q({ALUSrcE, ALUControlE})
    );

    flopr #(4) condregE (
        .clk(clk),
        .reset(reset),
        .d(InstrD[31:28]),
        .q(CondE)
    );

    // Conditional Logic
    condlogic cl(
        .clk(clk),
        .reset(reset),
        .FlagsE(FlagsE),
        .CondE(CondE),
        .CondExE(CondExE),
        .ALUFlags(ALUFlagsE),
        .FlagsNextE(FlagsNextE)
    );

    // Memory stage flip-flops
    flopr #(4) regsM (
        .clk(clk),
        .reset(reset),
        .d({MemWriteE & CondExE, MemtoRegE, RegWriteE & CondExE, PCSrcE & CondExE}),
        .q({MemWriteM, MemtoRegM, RegWriteM, PCSrcM})
    );

    // Writeback stage flip-flops
    flopr #(3) regsW (
        .clk(clk),
        .reset(reset),
        .d({MemtoRegM, RegWriteM, PCSrcM}),
        .q({MemtoRegW, RegWriteW, PCSrcW})
    );

    // Hazard detection logic
    assign BranchTakenE = BranchE & CondExE;
    assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;

endmodule
module controller (
    clk,
    reset,
    InstrD,
    PCSrcD,
    RegWriteD,
    MemtoRegD,
    MemWriteD,
    ALUControlD,
    BranchD,
    ALUSrcD,
    FlagWriteD,
    ImmSrcD,
    RegSrcD
    );
    input wire clk;
    input wire reset;
    input wire [31:12] InstrD;
    output wire PCSrcD;
    output wire RegWriteD;
    output wire MemtoRegD;
    output wire MemWriteD;
    output wire [1:0] ALUControlD;
    output wire BranchD;
    output wire ALUSrcD;
    output wire FlagWriteD;
    output wire [1:0] ImmSrcD;
    output wire [1:0] RegSrcD;

    wire [1:0] FlagWD;
    wire PCS;
    wire RegW;
    wire MemW;
    wire Flags;
    wire ALUFlags;
    wire Cond;
    // Decode stage logic
    decode dec(
        .Op(InstrD[27:26]),
        .Funct(InstrD[25:20]),
        .Rd(InstrD[15:12]),
        .PCS(PCS),
        .RegWD(RegW),
        .MemWD(MemW),
        .MemtoRegD(MemtoRegD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD),
        .RegSrcD(RegSrcD),
        .ALUControlD(ALUControlD),
        .BranchD(BranchD),
        .FlagWD(FlagWD)
    );
    condlogic cl(
        .clk(clk),
        .reset(reset),
        .Cond(InstrD[31:28]),
        .ALUFlags(ALUFlags),
        .FlagW(FlagWD),
        .PCS(PCS),
        .RegW(RegW),
        .MemW(MemW),
        .PCSrc(PCSrcD),
        .RegWrite(RegWriteD),
        .MemWrite(MemWriteD),
        .FlagWrite(FlagWriteD)
        );
endmodule

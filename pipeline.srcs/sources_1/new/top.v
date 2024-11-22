module top (
    clk,
    reset,
    WriteDataM,
    DataAdrM,
    MemWriteM
);
    input wire clk;
    input wire reset;
    output wire [31:0] WriteDataM;
    output wire [31:0] DataAdrM;
    output wire MemWriteM;

    // Internal wires
    wire [31:0] PCF;
    wire [31:0] InstrF;
    wire [31:0] ReadDataM;

    // Instantiate processor
    arm arm(
        .clk(clk),
        .reset(reset),
        .PCF(PCF),
        .InstrF(InstrF),
        .MemWriteM(MemWriteM),
        .ALUOutM(DataAdrM),
        .WriteDataM(WriteDataM),
        .ReadDataM(ReadDataM)
    );

    // Instruction memory
    imem imem(
        .a(PCF),
        .rd(InstrF)
    );

    // Data memory
    dmem dmem(
        .clk(clk),
        .we(MemWriteM),
        .a(DataAdrM),
        .wd(WriteDataM),
        .rd(ReadDataM)
    );

endmodule
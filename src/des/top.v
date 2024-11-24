module top (
    input wire clk, reset,
    output wire [31:0] WriteDataM, DataAdrM,
    output wire MemWriteM
);
    // Internal wires
    wire [31:0] PCF, InstrF, ReadDataM;

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
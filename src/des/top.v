module top (
    input wire clkDiv, reset,
    output wire [31:0] PCF,
	output wire [479:0] rf
);
    wire MemWriteM;
    wire [31:0] WriteDataM, DataAdrM;
    // Internal wires
    wire [31:0] InstrF, ReadDataM;

    // Instantiate processor
    arm arm(
        .clk(clkDiv),
        .reset(reset),
        .PCF(PCF),
        .InstrF(InstrF),
        .MemWriteM(MemWriteM),
        .ALUOutM(DataAdrM),
        .WriteDataM(WriteDataM),
        .ReadDataM(ReadDataM),
        .rf(rf)
    );

    // Instruction memory
    imem imem(
        .a(PCF),
        .rd(InstrF)
    );

    // Data memory
    dmem dmem(
        .clk(clkDiv),
        .we(MemWriteM),
        .a(DataAdrM),
        .wd(WriteDataM),
        .rd(ReadDataM)
    );

endmodule

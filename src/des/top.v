module top (
    input wire clk, reset,
    output wire [31:0] WriteDataM, DataAdrM,
    output wire MemWriteM
);
    // Internal wires
    wire [31:0] PCF, InstrF, ReadDataM;
    
    // clk divider
    clk_divider #(0) clkd( // 26
        .clk(clk),
        .rst(reset),
        .led(clkDiv)
    );

    // Instantiate processor
    arm arm(
        .clk(clkDiv),
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
        .clk(clkDiv),
        .we(MemWriteM),
        .a(DataAdrM),
        .wd(WriteDataM),
        .rd(ReadDataM)
    );

endmodule

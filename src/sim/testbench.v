`timescale 1ns / 1ps

module testbench;
    // Clock and reset signals
    reg clk, reset;
    // Outputs from the processor
    wire [31:0] WriteData, DataAdr;
    wire MemWrite;

    // Instantiate the top module (processor under test)
    top dut(
        .clk(clk),
        .reset(reset),
        .WriteDataM(WriteData),
        .DataAdrM(DataAdr),
        .MemWriteM(MemWrite)
    );

    // Initialize testbench
    initial begin
        reset <= 1;
        #22;
        reset <= 0;
    end

    // Generate clock signal
    always begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
    end

    // Timeout to avoid infinite simulation
    initial begin
        #2147483647; // Max 2147483647;
        $display("Simulation timed out at time %0t", $time);
        $finish;
    end

    // Dump waveform data for analysis
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
    end

endmodule


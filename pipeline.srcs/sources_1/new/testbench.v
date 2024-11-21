`timescale 1ns / 1ps

module testbench;
    // Signals for testing
    reg clk;
    reg reset;
    wire [31:0] WriteData;
    wire [31:0] DataAdr;
    wire MemWrite;

    // Instantiate the top module
    top dut(
        .clk(clk),
        .reset(reset),
        .WriteDataM(WriteData),
        .DataAdrM(DataAdr),
        .MemWriteM(MemWrite)
    );

    // Initialize reset
    initial begin
        reset <= 1;
        #22;
        reset <= 0;
    end

    // Clock generation
    always begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
    end

    // Check simulation results
    always @(negedge clk) begin
        if (MemWrite) begin
            if ((DataAdr === 100) && (WriteData === 7)) begin
                $display("Simulation succeeded at time %0t", $time);
                $stop;
            end else if (DataAdr !== 96) begin
                $display("Simulation failed at time %0t", $time);
                $stop;
            end
        end
    end

    // Timeout to avoid infinite simulation
    initial begin
        #100;
        $display("Simulation timed out at time %0t", $time);
        $finish;
    end

    // Dump waveforms for analysis
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
    end

endmodule
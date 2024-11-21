`timescale 1ns / 1ps

module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteData;
	wire [31:0] DataAdr;
	wire MemWrite;
	top dut(
		.clk(clk),
		.reset(reset),
		.WriteDataM(WriteData),
		.DataAdrM(DataAdr),
		.MemWriteM(MemWrite)
	);
	initial begin
		reset <= 1;
		#(22)
			;
		reset <= 0;
	end
	always begin
		clk <= 1;
		#(5)
			;
		clk <= 0;
		#(5)
			;
	end
	always @(negedge clk)
		if (MemWrite)
			if ((DataAdr === 100) & (WriteData === 7)) begin
				$display("Simulation succeeded");
				$stop;
			end
			else if (DataAdr !== 96) begin
				$display("Simulation failed");
				$stop;
			end
	initial begin
		#100;
		$display("Simulation timed out at time %0t", $time);
		$finish;
	end
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
    end

endmodule

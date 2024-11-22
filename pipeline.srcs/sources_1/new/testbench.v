`timescale 1ns / 1ps

module testbench;
	reg clk;
	reg reset;
	wire [31:0] WriteDataM;
	wire [31:0] DataAdrM;
	wire MemWriteM;
	top dut(
		.clk(clk),
		.reset(reset),
		.WriteDataM(WriteDataM),
		.DataAdrM(DataAdrM),
		.MemWriteM(MemWriteM)
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
		if (MemWriteM)
			if ((DataAdrM === 100) & (WriteDataM === 7)) begin
				$display("Simulation succeeded");
				$stop;
			end
			else if (DataAdrM !== 96) begin
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

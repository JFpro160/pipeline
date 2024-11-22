module EX_MEM_Register (
    input wire clk,
    input wire reset,
    input wire PCSrcE_,
    input wire RegWriteE_,
    input wire MemWriteE_,
    input wire MemtoRegE,
    input wire [31:0] ALUResultE,
    input wire [31:0] WriteDataE,
    input wire [3:0] WA3E,
    output reg PCSrcM,
    output reg MemWriteM,
    output reg MemtoRegM,
    output reg RegWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [3:0] WA3M
);


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PCSrcM      <= 1'b0;
            MemWriteM   <= 1'b0;
            MemtoRegM   <= 1'b0;
            RegWriteM   <= 1'b0;
            ALUResultM <= 32'b0;
            WriteDataM <= 32'b0;
            WA3M <= 4'b0;
        end
        else begin
            PCSrcM      <= PCSrcE_;
            MemWriteM   <= MemWriteE_;
            MemtoRegM   <= MemtoRegE;
            RegWriteM   <= RegWriteE_;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            WA3M <= WA3E; 
            
        end
    end

endmodule

module btb #(parameter SIZE = 64) (
    input wire clk, reset, 
    input wire UpdateEnable, BranchTaken, Branch,
    input wire [31:0] PC, PCBranch, PCUpdate, 
    output wire [31:0] PredictedTarget, 
    output wire Prediction
);

    reg [32:0] buff [SIZE-1:0]; // [32:1] target [0] taken

    wire [$clog2(SIZE)-1:0] indexRead, indexWrite;
    assign indexRead = PC[$clog2(SIZE)+2:2];
    assign indexWrite = PCUpdate[$clog2(SIZE)+2:2];

    assign PredictedTarget = Branch ? buff[indexRead][32:1] : 32'bx; // Branch target
    assign Prediction = Branch ? buff[indexRead][0] : 1'b0;

    // Initialize the BTB
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                buff[i][0] <= 1'b0;         // Not taken
                buff[i][32:1] <= 32'bx;    // Undefined target
            end
        end else if (UpdateEnable) begin
            buff[indexWrite][32:1] <= PCBranch;   // Correct destination
            buff[indexWrite][0] <= BranchTaken;  // Taken or not
        end
    end
endmodule
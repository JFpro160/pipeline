module btb #(parameter SIZE = 64) (
    input wire clk, reset, en, BranchTaken,
    input wire [31:0] PC, PCBranch, 
    output wire [31:0] Target, 
    output wire Prediction
);

    reg [32:0] buff [SIZE-1:0]; // [32:1] target [0] taken

    wire [$clog2(SIZE)-1:0] index;
    assign index = PC[$clog2(SIZE)+2:2];

    assign Target = buff[index][32:1]; // Branch target
    assign Prediction = buff[index][0];

    // Initialize the BTB
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                buff[i][0] <= 1'b0; // not taken
                buff[i][32:1]  <= 32'bx; // Undefined target
            end
        end else if (en) begin
            buff[index][32:1] <= PCBranch;      
            buff[index][0] <= BranchTaken;         
        end
    end
endmodule
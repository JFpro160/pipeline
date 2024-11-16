// 32-bit ALU for ARM processor
module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [2:0] ALUControl,
    output reg [31:0] Result,
    output wire [3:0] ALUFlags
);

    wire neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;

    assign condinvb = ALUControl[0] ? ~b : b;
    assign sum = a + condinvb + ALUControl[0];

    always @(*) begin
        casex (ALUControl[2:0])
            3'b00?: Result = sum; //add and sub
            3'b010: Result = a & b; //and
            3'b011: Result = a | b; //orr
            3'b100: Result = a * b; //mul
            3'b101: Result = a*b + c; //mla
        endcase
    end

    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = (ALUControl[1] == 1'b0) & sum[32];
    assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);

    assign ALUFlags = {neg, zero, carry, overflow};

endmodule
// 32-bit ALU for ARM processor
module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [1:0] ALUControl,
    output reg [31:0] Result,
    output wire [3:0] Flags
);

    wire neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;

    // Generate conditional inverse of b
    assign condinvb = ALUControl[0] ? ~b : b;

    // Perform addition/subtraction
    assign sum = a + condinvb + ALUControl[0];

    // Compute result based on ALUControl
    always @(*) begin
        casex (ALUControl[1:0])
            2'b0?: Result = sum;       // Addition/Subtraction
            2'b10: Result = a & b;     // AND
            2'b11: Result = a | b;     // OR
        endcase
    end

    // Compute flags
    assign neg = Result[31];                              // Negative flag
    assign zero = (Result == 32'b0);                      // Zero flag
    assign carry = (ALUControl[1] == 1'b0) & sum[32];     // Carry flag
    assign overflow = (ALUControl[1] == 1'b0) & 
                      ~(a[31] ^ b[31] ^ ALUControl[0]) & 
                      (a[31] ^ sum[31]);                 // Overflow flag

    // Assign flags to output
    assign Flags = {neg, zero, carry, overflow};

endmodule
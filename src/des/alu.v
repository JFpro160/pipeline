// 32-bit ALU for ARM processor
module alu (
    input wire [2:0] ALUControl,
    input wire [31:0] a, b,
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
        casex (ALUControl[2:0])
            3'b00?: Result = sum;       // Addition/Subtraction
            3'b010: Result = a & b;     // AND
            3'b011: Result = a | b;     // OR
            3'b100: Result = a ^ b;     // XOR
        endcase
    end

    // Compute flags
    wire sumOp = ALUControl[2:1] == 2'b0;
    assign neg = Result[31];                              // Negative flag
    assign zero = (Result == 32'b0);                      // Zero flag
    assign carry = sumOp & sum[32];                       // Carry flag
    assign overflow = sumOp &                             // Overflow flag
                      ~(a[31] ^ b[31] ^ ALUControl[0]) & 
                       (a[31] ^ sum[31]);                       

    // Assign flags to output
    assign Flags = {neg, zero, carry, overflow};

endmodule
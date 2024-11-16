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
    wire signed [31:0] sb = b; // new
    wire signed [31:0] sa = a; //new
    
    assign condinvb = ALUControl[0] ? ~b : b;
    assign sum = a + condinvb + ALUControl[0];

    always @(*) begin
        casex (ALUControl[2:0])
            3'b00?: Result = sum;
            3'b010: Result = a & b;
            3'b011: Result = a | b;
            3'b101: Result = b * a; // new  todas las operaciones de mul son b / a porque se inivirtio en el regfile xdxd
            3'b110: Result = b * a + c; // new
            3'b100: Result = sb / sa; // new
            3'b111: Result = b / a; // new
        endcase
    end

    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = (ALUControl[1] == 1'b0) & sum[32];
    assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);

    assign ALUFlags = {neg, zero, carry, overflow};

endmodule
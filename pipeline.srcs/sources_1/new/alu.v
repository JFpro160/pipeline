// 32-bit ALU for ARM processor
module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c, // new
    input wire [3:0] ALUControl, // ch
    output reg [31:0] Result,
    output wire [3:0] ALUFlags,
    input wire Carry // new
);

    wire neg, zero, carry, overflow;
    wire [31:0] condinvb;
    wire [32:0] sum;
    wire carryin; // new
    wire signed [31:0] sb = b; // new
    wire signed [31:0] sa = a; //new
    
    assign carryin = ALUControl[2] ? Carry : ALUControl[0]; // new
    assign condinvb = ALUControl[0] ? ~b : b;
    assign sum = a + condinvb + carryin; // ch

    always @(*) begin
        casex (ALUControl[3:0])
            4'b000?: Result = sum;
            4'b0010: Result = a & b;
            4'b0011: Result = a | b;
            4'b0101: Result = b * a; // new  todas las operaciones de mul son b / a porque se inivirtio en el regfile xdxd
            4'b0110: Result = b * a + c; // new
            4'b0100: Result = sb / sa; // new
            4'b0111: Result = b / a; // new
            4'b1000: Result = ~b; // new
        endcase
    end

    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = (ALUControl[1] == 1'b0) & sum[32];
    assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);

    assign ALUFlags = {neg, zero, carry, overflow};

endmodule
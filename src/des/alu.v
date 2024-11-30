    module alu (
        input wire [31:0] a,
        input wire [31:0] b,
        input wire [31:0] c,
        input wire [3:0] ALUControl,
        output reg [31:0] Result,
        output wire [4:0] ALUFlags
    );
    
        // Intermediate signals
        wire neg, zero, carry, overflow, q;
        wire [31:0] condinvb, condinva;
        wire [32:0] sum, sumq;
        wire [31:0] qadd, qsub;
    
      assign condinvb = ALUControl[0] ? ~b : b;
      assign sum = a + condinvb + ALUControl[0];
        
      assign condinva = ALUControl[0] ? ~a : a;
      assign sumq = b + condinva + ALUControl[0]; //operators inverted when qinstr
      assign qadd = (b[31] == a[31]) ? // Same sign
               ((b[31] == 1'b0 && sumq[31]) ? 32'h7FFFFFFF :  // Positive overflow
                (b[31] == 1'b1 && ~sumq[31]) ? 32'h80000000 : sumq[31:0]) : sumq[31:0];

      assign qsub = (b[31] == a[31]) ? // Same sign, no overflow
                sumq[31:0] :
                ((b[31] == 1'b0 && a[31] == 1'b1 && sumq[31]) ? 32'h7FFFFFFF :  // Positive overflow
                 (b[31] == 1'b1 && a[31] == 1'b0 && ~sumq[31]) ? 32'h80000000 : sumq[31:0]);

    always @(*) begin
            casex (ALUControl[3:0])
                4'b000?: Result = sum; // Add/Sub
                4'b0010: Result = a & b; // AND
                4'b0011: Result = a | b; // ORR
                4'b0100: Result = a * b; // MUL
                4'b0101: Result = a * b + c; // MLA
                4'b0110: Result = a ^ b; // EOR
                4'b111?: Result = condinvb; //MOV MVN all shift and rot 10000iq
                4'b1010: Result = a & ~b; // BIC
                4'b1000: Result = qadd; // QADD
                4'b1001: Result = qsub; // QSUB
            endcase
        end
    
        assign neg = Result[31];
        assign zero = (Result == 32'b0);
        assign carry = (ALUControl[2:1] == 2'b00 & ALUControl[3] == 1'b0 & sum[32]);
        assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
        assign q = ((ALUControl == 4'b1000) && (Result != sum)) || // QADD saturation
                   ((ALUControl == 4'b1001) && (Result != sum));  // QSUB saturation
    
        assign ALUFlags = {neg, zero, carry, overflow, q};
    
    endmodule

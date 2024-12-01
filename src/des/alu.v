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
        wire [31:0] condinvb;
        reg [32:0] qsum;
        wire [32:0] sum;

        assign condinvb = ALUControl[0] ? ~b : b;
        assign sum = a + condinvb + ALUControl[0]; 

    always @(*) begin
            casex (ALUControl[3:0])
                4'b000?: Result = sum; // Add/Sub
                4'b0010: Result = a & b; // AND
                4'b0011: Result = a | b; // ORR
                4'b0100: Result = a * b; // MUL
                4'b0101: Result = a * b + c; // MLA
                4'b0110: Result = a ^ b; // EOR
                4'b0111: Result = ~b; // MVN
                4'b1010: Result = a & ~b; // BIC
                4'b1000: begin // QADD (Saturating Addition)
                    qsum = {1'b0, a} + {1'b0, b};

                    // Detect overflow with precise conditions
                    if ((a[31] == b[31]) && (qsum[31] != a[31]))
                        // Saturate based on input sign
                        Result = a[31] ? 32'h80000000 : 32'h7FFFFFFF;
                    else
                        Result = qsum[31:0];
                end
                4'b1001: begin // QSUB (Saturating Subtraction)
                    qsum = {1'b0, b} - {1'b0, a};

                    // Detect overflow with precise conditions
                    if ((b[31] != a[31]) && (qsum[31] != b[31]))
                        // Saturate based on first input's sign
                        Result = b[31] ? 32'h80000000 : 32'h7FFFFFFF;
                    else
                        Result = qsum[31:0];
                end
            endcase
        end
    
        assign neg = Result[31];
        assign zero = (Result == 32'b0);
        assign carry = (ALUControl[1] == 1'b0) & sum[32];
        assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
        assign q = ((ALUControl == 4'b1000) && (qsum[32] != qsum[31])) || 
               ((ALUControl == 4'b1001) && (qsum[32] != qsum[31]));        assign ALUFlags = {neg, zero, carry, overflow, q};
    endmodule

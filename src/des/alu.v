module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    input wire [3:0] ALUControl,
    output reg [31:0] Result,
    output wire [4:0] ALUFlags
);

    wire neg, zero, carry, overflow, underflow, q;
    wire [31:0] condinvb;
    wire [32:0] sum;
    
    assign condinvb = ALUControl[0] ? ~b : b;  
    assign sum = a + condinvb + ALUControl[0];
    
    assign sat_pos = ~a[31] & ~condinvb[31] & sum[31];  
    assign sat_neg = a[31] & condinvb[31] & ~sum[31]; 

    always @(*) begin
        casex (ALUControl[3:0])
            4'b000?: Result = sum; // add y sub
            4'b0010: Result = a & b; // and
            4'b0011: Result = a | b; // orr
            4'b0100: Result = a * b; // mul
            4'b0101: Result = a * b + c; // mla
            4'b0110: Result = a ^ b; // eor
            4'b0111: Result = ~b; // mvn ~ not
            4'b100?: begin // QADD (Suma saturada con signo)
                if (overflow)
                    Result = 32'h7FFFFFFF; // Máximo positivo
                else if (underflow)
                    Result = 32'h80000000; // Mínimo negativo
                else Result = sum;
                end
                //when SaturatedOp, operators are inversed
                //maybe thats why qsub sometimes
                //throws out not accurate result?
                //a -b != b - a
                //becasue qadd looks fine 
        endcase
    end

    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = (ALUControl[1] == 1'b0) & sum[32];
    assign overflow = (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    assign underflow = (ALUControl[1] == 1'b1) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
    assign q = (overflow | underflow); 
    assign ALUFlags = {neg, zero, carry, overflow,q};

endmodule

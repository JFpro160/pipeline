module conditional (
    input wire [3:0] Cond,
    input wire [4:0] Flags, ALUFlags,
    input wire [2:0] FlagsWrite,
    output wire [4:0] FlagsNext,
    output reg CondEx
);  
    wire neg, zero, carry, overflow, q ,ge;

    // Extract individual flags
    assign {neg, zero, carry, overflow, q} = Flags;
    assign ge = (neg == overflow);

    // Condition evaluation
    always @(*) begin
        case (Cond)
            4'b0000: CondEx = zero;                // EQ
            4'b0001: CondEx = ~zero;               // NE
            4'b0010: CondEx = carry;               // CS
            4'b0011: CondEx = ~carry;              // CC
            4'b0100: CondEx = neg;                 // MI
            4'b0101: CondEx = ~neg;                // PL
            4'b0110: CondEx = overflow;            // VS
            4'b0111: CondEx = ~overflow;           // VC
            4'b1000: CondEx = carry & ~zero;       // HI
            4'b1001: CondEx = ~(carry & ~zero);    // LS
            4'b1010: CondEx = ge;                  // GE
            4'b1011: CondEx = ~ge;                 // LT
            4'b1100: CondEx = ~zero & ge;          // GT
            4'b1101: CondEx = ~(~zero & ge);       // LE
            4'b1110: CondEx = 1'b1;                // AL (Always)
            default: CondEx = 1'bx;                // Undefined
        endcase
    end

    // Update flags conditionally
    assign FlagsNext[4:3] = (FlagsWrite[2] & CondEx) ? ALUFlags[4:3] : Flags[4:3];
    assign FlagsNext[2:1] = (FlagsWrite[1] & CondEx) ? ALUFlags[2:1] : Flags[2:1];
    assign FlagsNext[0] = (FlagsWrite[0] & CondEx) ? ALUFlags[0]:Flags[0];             
endmodule
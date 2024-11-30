module rotator(
    input wire [31:0] a,     
    input wire [3:0] b, // 4-bit rotation field from ARM instruction
    output wire [31:0] y    // Rotated result
);
    wire [4:0] rotate_amt = {b, 1'b0}; //amount multiplied by two according to documentation
    assign y = (a >> rotate_amt) | (a << (32 - rotate_amt)); //or sum the bits that got to the left
endmodule
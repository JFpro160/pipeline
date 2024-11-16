// shifter needed for LSL
module shifter(input wire [31:0] a,
input wire [4:0] shamt,
input wire [1:0] shtype,
output reg [31:0] y);

    always @(*) 
    case (shtype)
        2'b00: y = a << shamt; 
    default: y = a;
    endcase
    
endmodule
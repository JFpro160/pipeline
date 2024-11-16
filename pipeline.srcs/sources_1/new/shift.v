module shift(s, a, d, y, carry_in, carry_out);
    input [3:0] s;          
    input [31:0] a;         
    input [2:0] d;          
    input carry_in;         
    output reg [31:0] y;   
    output reg carry_out;   
    
    always @(*) begin
        case (d)
            3'b001: begin 
                y = a >> s;              // lsr
                carry_out = a[s-1];      
            end
            3'b010: begin 
                y = a << s;              // lsl
                carry_out = a[31-s];     
            end
            3'b011: begin 
                y = $signed(a) >>> s;    // asr
                carry_out = a[s-1];      
            end
            3'b100: begin 
                y = (a >> s) | (a << (32 - s)); // ror 
                carry_out = a[s-1];      
            end
            3'b101: begin 
                y = {carry_in, a[31:1]}; // rrx
                carry_out = a[0];        
            end
            default: begin 
                y = a;                   // mov (No operation)
                carry_out = 0;           
            end
        endcase
    end
endmodule
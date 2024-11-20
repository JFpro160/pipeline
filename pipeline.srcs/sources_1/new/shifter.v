module shifter(
    input wire [31:0] a,       
    input wire [4:0] rot,     
    input wire carry_in,       
    input wire [1:0] shtype,   
    output reg [31:0] y,       
    output reg carry_out       
);

    always @(*) begin
        carry_out = 1'b0; 

        case (shtype)
            2'b00: y = a << rot;      
            2'b01: y = a >> rot;         
            2'b10: y = a >>> rot;      
            2'b11: begin
                if (rot == 0) begin
                    y = {carry_in, a[31:1]}; 
                    carry_out = a[0];  
                end else begin
                    y = (a >> rot) | (a << (32 - rot));
                end
            end
            default: y = a;      
        endcase
    end

endmodule
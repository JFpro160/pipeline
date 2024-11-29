module shift(b, a, d, y, carry_in);
    input wire [7:0] b;          // Shift amount //Rs bottom byte
    input wire [31:0] a;         // Input value to be shifted
    input wire [1:0] d;    //shift type selec
    input wire carry_in;      
    output reg [31:0] y;    // Shifted result

    always @(*) begin
        case (d)
            2'b00: begin // Logical bhift Left (LbL)
                if (b == 0) begin
                    y = a;
                end else begin
                    y = a << b;
                end
            end
            2'b01: begin // Logical bhift Right (LbR)
                if (b == 0) begin
                    y = a;
                end else begin
                    y = a >> b;
                end
            end
            2'b10: begin // Arithmetic Shift Right (ASR)
                if (b == 0) begin
                    y = a;
                end else begin
                    y = a >>> b;
                end
            end
            2'b11: begin // Rotate Right (ROR) or Rotate Right with Extend (RRX)
                if (b == 0) begin
                    // RRX
                    y = {carry_in, a[31:1]};
                end else begin
                    y = (a >> b) | (a << b%32);
                end
            end
            default: begin // No operation
                y = a;
            end
        endcase
    end
endmodule

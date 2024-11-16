module shift(b, a, d, y, carry_in);
    input [4:0] b;          // Shift amount (0 to 31)
    input [31:0] a;         // Input value to be shifted
    input [1:0] d;    
    input wire carry_in;      // Shift type selector
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
            2'b10: begin // Arithmetic bhift Right (AbR)
                if (b == 0) begin
                    y = a;
                end else begin
                    y = a >>> b;
                end
            end
            2'b11: begin // Rotate Right (ROR) or Rotate Right with Extend (RRX)
                if (b == 0) begin
                    // RRX
                    y = {1'b1, a[31:1]};
                end else begin
                    y = (a >> b) | (a << (32 - b));
                end
            end
            default: begin // No operation
                y = a;
            end
        endcase
    end
endmodule

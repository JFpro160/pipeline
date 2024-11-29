module basys(
    input wire reset,
    input wire clk,
    output wire [6:0] seg,
    output reg [3:0] an
);
    reg[3:0] num;
    clk_divider #(26) clkd(
        .clk(clk),
        .rst(reset),
        .led(clkDiv)
    );

    decode de(
        num,
        enable,
        seg
    );

    always @ (posedge clkDiv) begin
        if(reset) begin
        num <= 0;
        an <= 0;
         end;
        if(an == 4'b0011) begin
            an <= 0;
            if(num == 9) begin
                num <= 0;
            end
            else
                num <= num + 1;
        end
        else an <= an + 1'b1;
    end


endmodule


         


module decode(
    input wire [3:0] in,
    output wire [3:0] enable,
    output reg [0:6] out
);
   
        always@(in)            //Procedural block: in order to describe the decoder we'll use the case construct. The sensivity list is composed only by in signal cause is the only one to generate a variation to the output
        begin
       
            case(in)       //We will display all possible combination of the input word, 0 to F.
               
                4'b0000 : out<=7'b0000001;    //Display 0
                4'b0001 : out<=7'b1001111;    //Display 1
                4'b0010 : out<=7'b0010010;    //Display 2
                4'b0011 : out<=7'b0000110;    //Display 3
                4'b0100 : out<=7'b1001100;    //Display 4
                4'b0101 : out<=7'b0100100;    //Display 5
                4'b0110 : out<=7'b0100000;    //Display 6
                4'b0111 : out<=7'b0001111;    //Display 7
                4'b1000 : out<=7'b0000000;    //Display 8
                4'b1001 : out<=7'b0001100;    //Display 9
                4'b1010 : out<=7'b0001000;    //Display A
                4'b1011 : out<=7'b1100000;    //Display b
                4'b1100 : out<=7'b0110001;    //Display C
                4'b1101 : out<=7'b1000010;    //Display d
                4'b1110 : out<=7'b0110000;    //Display E
                4'b1111 : out<=7'b0111000;    //Display F
                                                     
           
            endcase    
        end
endmodule

module dff(
    input D,
    input clk,
    input rst,
    output reg Q
    );
 
always @ (posedge(clk), posedge(rst))
begin
    if (rst)
        Q <= 1'b0;
    else
            Q <= D;
end
endmodule



module clk_divider #(parameter X = 32) (
    input clk,
    input rst,
    output led
    );
 
wire [X:0] din;
wire [X:0] clkdiv;
 
dff dff_inst0 (
    .clk(clk),
    .rst(rst),
    .D(din[0]),
    .Q(clkdiv[0])
);

genvar i;
generate
for (i = 1; i < X+1; i=i+1)
begin : dff_gen_label
    dff dff_inst (
        .clk(clkdiv[i-1]),
        .rst(rst),
        .D(din[i]),
        .Q(clkdiv[i])
    );
    end
endgenerate

assign din = ~clkdiv;
 
assign led = clkdiv[X];
 
endmodule

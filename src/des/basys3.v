module basys(
    input wire reset,
    input wire resetClk,
    input wire clk,
    input wire [14:0] sw,
    output wire [6:0] seg,
    output clkDiv,
    output wire [3:0] an
);
    wire [3:0] num;
    wire clkLed;
    reg [1:0] sel;
    clk_divider #(10) clkd( //26
        .clk(clk),
        .rst(resetClk),
        .led(clkLed)
    );
    clk_divider #(26) clkdarm( //26
        .clk(clk),
        .rst(resetClk),
        .led(clkDiv)
    );
    
    
	wire [479:0] rf;
    wire [31:0] PCF;
    top(
        .clkDiv(clkDiv),
        .reset(reset),
        .PCF(PCF),
        .rf(rf)
    );
    
    reg [7:0] re;
        
    always @(*) begin
        case (sw)  // El valor de sw determina qué registro seleccionar
            15'b000000000000001: re = rf[31:0];    // Selecciona rf[0]
            15'b000000000000010: re = rf[63:32];   // Selecciona rf[1]
            15'b000000000000100: re = rf[95:64];   // Selecciona rf[2]
            15'b000000000001000: re = rf[127:96];  // Selecciona rf[3]
            15'b000000000010000: re = rf[159:128]; // Selecciona rf[4]
            15'b000000000100000: re = rf[191:160]; // Selecciona rf[5]
            15'b000000001000000: re = rf[223:192]; // Selecciona rf[6]
            15'b000000010000000: re = rf[255:224]; // Selecciona rf[7]
            15'b000000100000000: re = rf[287:256]; // Selecciona rf[8]
            15'b000001000000000: re = rf[319:288]; // Selecciona rf[9]
            15'b000010000000000: re = rf[351:320]; // Selecciona rf[10]
            15'b000100000000000: re = rf[383:352]; // Selecciona rf[11]
            15'b001000000000000: re = rf[415:384]; // Selecciona rf[12]
            15'b010000000000000: re = rf[447:416]; // Selecciona rf[13]
            15'b100000000000000: re = rf[479:448]; // Selecciona rf[14]
            default: re = 32'b0;  // Si sw no es válido, asignamos 0
        endcase
    end

    wire [3:0] w1, w2, w3, w4;
    assign w1 = PCF[7:4];
    assign w2 = PCF[3:0];
    assign w3 = re[7:4];
    assign w4 = re[3:0];
    
    parameter a1 = 4'b1110;
    parameter a2 = 4'b1101;
    parameter a3 = 4'b1011;
    parameter a4 = 4'b0111;
    
    assign num = sel[1]?(sel[0]?w4:w3):(sel[0]?w2:w1);
    assign an = sel[1]?(sel[0]?a4:a3):(sel[0]?a2:a1);

    always @ (posedge clkLed) begin
        if (reset) begin
            sel <= 2'b00;
        end
        else begin
            sel <= sel + 1;
        end
    end
    
    basys_decode de(
        num,
        seg
    );

endmodule

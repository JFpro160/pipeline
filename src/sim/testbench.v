module tb_basys;

    // Declaración de señales
    reg reset;
    reg resetClk;
    reg clk;
    reg [14:0] sw;
    wire [6:0] seg;
    wire clkDiv;
    wire [3:0] an;
    wire [479:0] rf;
    wire [31:0] PCF;

    // Instancia del módulo a testear
    basys uut (
        .reset(reset),
        .resetClk(resetClk),
        .clk(clk),
        .sw(sw),
        .seg(seg),
        .clkDiv(clkDiv),
        .an(an)
    );

    // Generación del reloj de 50 MHz (asumido)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Período de 20 unidades de tiempo (50 MHz)
    end

    // Generación del reloj de reset
    initial begin
        resetClk = 0;
        #5 resetClk = 1;  // Asignar reset al principio
        #5 resetClk = 0;  // Desactivar reset
    end

    // Generación de la señal reset
    initial begin
        reset = 0;
        #15 reset = 1;
        #5 reset = 0;
    end

    // Prueba de la señal 'sw'
    initial begin
        sw = 15'b000000000000001; // Selecciona rf[0]
        #20 sw = 15'b000000000000010; // Selecciona rf[1]
        #20 sw = 15'b000000000001000; // Selecciona rf[3]
        #20 sw = 15'b000000010000000; // Selecciona rf[7]
        #20 sw = 15'b000000100000000; // Selecciona rf[8]
        #20 sw = 15'b000000000000000; // Valor no válido, selecciona 0
        #20 sw = 15'b000001000000000; // Selecciona rf[9]
    end

    // Monitoreo de las señales de salida
    initial begin
        $monitor("At time %t, reset = %b, resetClk = %b, clk = %b, sw = %b, seg = %b, clkDiv = %b, an = %b",
                 $time, reset, resetClk, clk, sw, seg, clkDiv, an);
    end

    // Fin de la simulación
    initial begin
        #200 $finish;
    end

endmodule

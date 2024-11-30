`timescale 1ns / 1ps
module tb_basys();

    // Declaración de señales de prueba
    reg clk;
    reg reset;
    reg resetClk;
    wire [6:0] seg;
    wire clkDiv;
    wire [3:0] an;

    // Instanciación del módulo basys
    basys uut (
        .reset(reset),
        .resetClk(resetClk),
        .clk(clk),
        .seg(seg),
        .clkDiv(clkDiv),
        .an(an)
    );

    // Generación de señal de reloj (clk)
    always begin
        #5 clk = ~clk; // Reloj de 10 unidades de tiempo (50 MHz)
    end

    // Inicialización y estímulos
    initial begin
        // Inicialización de señales
        clk = 0;
        reset = 0;
        resetClk = 0;

        // Visualización de señales en la simulación
        $monitor("Time: %0t, clk: %b, reset: %b, seg: %b, clkDiv: %b, an: %b", 
                 $time, clk, reset, seg, clkDiv, an);

        // Reset inicial
        reset = 1;
        resetClk = 1;
        #10 resetClk = 0;
         #10 reset = 0; // Desactivar reset después de 10 unidades de tiempo

        // Simulación de comportamiento durante un período largo
        #1000;
        $stop; // Detener la simulación después de 1000 unidades de tiempo
    end

endmodule

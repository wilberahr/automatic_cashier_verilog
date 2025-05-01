
module tester(
    output reg clk,
    output reg reset,
    output reg tarjeta_recibida,
    input wire fin
);


    // Señal de reloj
    always #1 clk = ~clk;

    // Pruebas de funcionamiento
    initial begin
        // Inicializando entradas
        clk = 0;
        reset = 1;
        tarjeta_recibida = 1'b0;

        // Aplicar reset
        #10 reset = 0;
        #10 reset = 1;

        // Prueba 1
        #10 tarjeta_recibida = 1'b0;

        // Prueba 2
        #10 tarjeta_recibida = 1'b1;

        // Finalizar simulacion
        #20 $finish;
    end

endmodule
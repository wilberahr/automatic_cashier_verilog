
module tester(
    output reg clk,
    output reg reset,
    output reg digito_stb,
    output reg [3:0] digito,
    output reg [15:0] pin_correcto,
    input wire pin_incorrecto,
    input wire advertencia,
    input wire bloqueo,
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

        // Pruebas del estado idle
        // Prueba 1
        #10 tarjeta_recibida = 1'b0;

        // Prueba 2
        #10 tarjeta_recibida = 1'b1;

        // Pruebas del estado recibiendo_pin

        // Finalizar simulacion
        #20 $finish;
    end

endmodule
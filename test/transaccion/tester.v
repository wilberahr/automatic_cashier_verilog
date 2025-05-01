
module tester(
    output reg clk,
    output reg reset,
    output reg tarjeta_recibida,
    output reg tipo_trans,
    output reg [31:0] monto,
    output reg [63:0] balance_inicial,
    input wire [63:0] balance_actualizado,
    input wire balance_stb,
    input wire entregar_dinero,
    input wire fondos_insuficientes
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

        // Pruebas del estado transaccion
        // Prueba 1: Deposito
        
        // Prueba 2: Retiro

        // Prueba 3: Fondos insuficienttes

        // Finalizar simulacion
        #20 $finish;
    end

endmodule
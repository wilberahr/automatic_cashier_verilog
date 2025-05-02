
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
    always #5 clk = ~clk;

    // Pruebas de funcionamiento
    initial begin
        // Inicializando entradas
        clk = 0;
        reset = 1;
        tarjeta_recibida = 1'b0;
        balance_inicial = 64'd1000;
        tipo_trans = 1'b0;
        monto = 32'd0;

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
        #10 tipo_trans = 1'b0;
        #10 monto = 32'd100;
        // Prueba 2: Retiro
        #10 tipo_trans = 1'b1;
        #10 monto = 32'd50;
        // Prueba 3: Fondos insuficienttes
        #10 tipo_trans = 1'b1;
        #10 monto = 32'd2000;
        // Finalizar simulacion
        #10 tarjeta_recibida = 1'b0;
        #20 $finish;
    end

endmodule
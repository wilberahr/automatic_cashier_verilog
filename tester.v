module tester(
    output reg clk,
    output reg reset,
    output reg tarjeta_recibida,
    output reg digito_stb,
    output reg [3:0] digito,
    output reg [15:0] pin_correcto,
    input wire pin_incorrecto,
    input wire advertencia,
    input wire bloqueo,
    output reg tipo_trans,
    output reg [31:0] monto,
    output reg [63:0] balance_inicial,
    input wire [63:0] balance_actualizado,
    input wire balance_stb,
    input wire entregar_dinero,
    input wire fondos_insuficientes,
    input wire [15:0] pin
);


    // Señal de reloj
    always #5 clk = ~clk;

    // Pruebas de funcionamiento
    initial begin
        // Inicializando entradas
        clk = 0;
        reset = 1;
        tarjeta_recibida = 1'b0;
        pin_correcto = 16'h3257;
        digito_stb = 1'b0;
        digito = 4'hf;
        tipo_trans = 1'b0;
        monto = 32'd0;
        balance_inicial = 64'd1000;

        // Aplicar reset
        #10 reset = 0;
        #10 reset = 1;

        // Pruebas del estado idle
        // Prueba 1
        #10 tarjeta_recibida = 1'b0;

        // Prueba 2
        #10 tarjeta_recibida = 1'b1;

        // Pruebas del estado recibiendo_pin
        // Prueba 1: pin correcto
        #10     
        digito_stb = 1'b1;
        digito = 4'h3;
        #10 digito_stb = 1'b0;
        digito = 4'hf;

        #10     
        digito_stb = 1'b1;
        digito = 4'h2;
        #10 
        digito_stb = 1'b0;
        digito = 4'hf;

        #10     
        digito_stb = 1'b1;
        digito = 4'h5;
        #10 digito_stb = 1'b0;
        digito = 4'hf;

        #10 
        digito_stb = 1'b1;
        digito = 4'h7;
        #10 
        digito_stb = 1'b0;
        digito = 4'hf;

        // Aplicar reset
        #10 reset = 0;
        #10 reset = 1;


        // Prueba 2: pin incorrecto
        repeat(4) begin
            repeat(4) begin
                #10
                digito_stb = 1'b1;
                digito = 4'h5;
                #10 
                digito_stb = 1'b0;
                digito = 4'hf;
            end    
        end
        #20
        // Aplicar reset
        #10 reset = 0;
        #10 reset = 1;


        // Pruebas del estado transaccion
        // Prueba 1: Deposito
        #10 tipo_trans = 1'b0;
        #10 monto = 32'd100;
        #10 tarjeta_recibida = 1'b1;

        // Ingresar pin correcto
        #10     
        digito_stb = 1'b1;
        digito = 4'h3;
        #10 digito_stb = 1'b0;
        digito = 4'hf;

        #10     
        digito_stb = 1'b1;
        digito = 4'h2;
        #10 
        digito_stb = 1'b0;
        digito = 4'hf;

        #10     
        digito_stb = 1'b1;
        digito = 4'h5;
        #10 digito_stb = 1'b0;
        digito = 4'hf;

        #10 
        digito_stb = 1'b1;
        digito = 4'h7;
        #10 
        digito_stb = 1'b0;
        digito = 4'hf;

        #40


        // Prueba 2: Retiro
        #10 tipo_trans = 1'b1;
        #10 monto = 32'd50;
        #10 tarjeta_recibida = 1'b1;

        // Ingresar pin correcto
        #10     
        digito_stb = 1'b1;
        digito = 4'h3;
        #10 digito_stb = 1'b0;
        digito = 4'hf;

        #10     
        digito_stb = 1'b1;
        digito = 4'h2;
        #10 
        digito_stb = 1'b0;
        digito = 4'hf;

        #10     
        digito_stb = 1'b1;
        digito = 4'h5;
        #10 digito_stb = 1'b0;
        digito = 4'hf;

        #10 
        digito_stb = 1'b1;
        digito = 4'h7;
        #10 
        digito_stb = 1'b0;
        digito = 4'hf;

        #40

        // Prueba 3: Fondos insuficienttes
        #10 tipo_trans = 1'b1;
        #10 monto = 32'd2000;
        #10 tarjeta_recibida = 1'b1;
        // Ingresar pin correcto
        #10     
        digito_stb = 1'b1;
        digito = 4'h3;
        #10 digito_stb = 1'b0;
        digito = 4'hf;

        #10     
        digito_stb = 1'b1;
        digito = 4'h2;
        #10 
        digito_stb = 1'b0;
        digito = 4'hf;

        #10     
        digito_stb = 1'b1;
        digito = 4'h5;
        #10 digito_stb = 1'b0;
        digito = 4'hf;

        #10 
        digito_stb = 1'b1;
        digito = 4'h7;
        #10 
        digito_stb = 1'b0;
        digito = 4'hf;



        // Finalizar simulacion
        #10 tarjeta_recibida = 1'b0;
        #20 $finish;
    end

endmodule
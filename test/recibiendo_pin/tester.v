
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
    input wire fin,
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

        // Aplicar reset
        #10 reset = 0;
        #10 reset = 1;

        // Pruebas del estado idle
        // Prueba 1
        #10 tarjeta_recibida = 1'b0;

        // Prueba 2
        #10 tarjeta_recibida = 1'b1;

        // Pruebas del estado recibiendo_pin
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

        // Aplicar reset
        #10 reset = 0;
        #10 reset = 1;
        
        // Finalizar simulacion
        #20 $finish;
    end

endmodule
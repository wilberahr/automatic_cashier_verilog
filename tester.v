module tester(  clock,
                reset,
                tarjeta_recibida, 
                tipo_trans, 
                digito_stb, 
                digito, 
                pin,
                balance_inicial, 
                monto,
                monto_stb,
                balance_actualizado,
                entregar_dinero,
                pin_incorrecto,
                advertencia,
                bloqueo,
                fondos_insuficientes);

    //Declaracion de salidas
    output reg clock;
    output reg reset;
    output reg tarjeta_recibida; 
    output reg tipo_trans; 
    output reg digito_stb; 
    output reg [3:0] digito; 
    output reg [15:0] pin;
    output reg [63:0] balance_inicial;
    output reg [31:0] monto;
    output reg monto_stb;

    //Declaraacion de entradas
    input wire balance_actualizado;
    input wire entregar_dinero;
    input wire pin_incorrecto;
    input wire advertencia;
    input wire bloqueo;
    input wire fondos_insuficientes;


    
    initial begin
    //Incializacion en bajo del clock y en alto del reset
    // al inicio de los tiempos
    $display("====INICIANDO SIMULACION====");
    $display("Incializacion del clock y reset");
    clock = 0;
    reset = 1;

    $display("====FINALIZANDO SIMULACION====");
    #200 $finish;
    end

    always begin
    #5 clock = !clock;
    end
    
endmodule

task prueba(    output reg tarjeta_recibida, 
                output reg tipo_trans, 
                output reg digito_stb, 
                output reg [3:0] digito, 
                output reg [15:0] pin,
                output reg [63:0] balance_inicial,
                output reg [31:0] monto,
                output reg monto_stb); 
    fork
        tarjeta_recibida = ; 
        tipo_trans; 
        digito_stb; 
        digito; 
        pin;
        balance_inicial;
        monto;
        monto_stb;
    join

endtask 
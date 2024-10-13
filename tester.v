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
    output wire clock;
    output wire reset;
    output wire tarjeta_recibida; 
    output wire tipo_trans; 
    output wire digito_stb; 
    output wire [3:0] digito; 
    output wire [15:0] pin;
    output wire [63:0] balance_inicial;
    output wire [31:0] monto;
    output wire monto_stb;

    //Declaraacion de entradas
    input reg balance_actualizado;
    input reg entregar_dinero;
    input reg pin_incorrecto;
    input reg advertencia;
    input reg bloqueo;
    input reg fondos_insuficientes;


    
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
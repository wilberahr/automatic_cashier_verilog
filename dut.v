module cajero(  tarjeta_recibida, 
                tipo_trans, 
                digito_stb, 
                digito[3:0], 
                pin[15:0], 
                monto_stb
                balance_actualizado[31:0],
                entregar_dinrero,
                pin_incorrecto,
                advertencia,
                bloqueo,
                fondos_insuficientes
                );

    //Declaracion de entradas
    input wire tarjeta_recibida; 
    input wire tipo_trans; 
    input wire digito_stb; 
    input wire [3:0] digito; 
    input wire [15:0] pin;
    input wire monto_stb;

    //Declaraacion de salidas
    output reg [31:0] balance_actualizado;
    output reg entregar_dinrero;
    output reg pin_incorrecto;
    output reg advertencia;
    output reg bloqueo;
    output reg fondos_insuficientes;

    //Declaracion de parametros locales
    localparam 4bits = 3;
    localparam 16bits = 15; 

endmodule // endmodule cajero
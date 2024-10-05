module cajero(  clock,
                reset,
                tarjeta_recibida, 
                tipo_trans, 
                digito_stb, 
                digito, 
                pin, 
                monto_stb,
                balance_actualizado,
                entregar_dinrero,
                pin_incorrecto,
                advertencia,
                bloqueo,
                fondos_insuficientes
                );

    //Declaracion de entradas
    input wire clock;
    input wire reset;
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

    //Declaracion de regstros internos
    reg [4:0] estado_actual;
    reg [4:0] proximo_estado;

    reg [1:0] cuenta_bit;
    reg [1:0] proxima_bit;

    reg [1:0] cuenta_digito;
    reg [1:0] proximo_digito;

    //Declaracion de estados
    localparam idle             = 5'b00001;
    localparam recibiendo_pin   = 5'b00010;
    localparam comparar_pin     = 5'b00100;
    localparam transaccion      = 5'b01000;
    localparam bloqueo_cajero   = 5'b10000;

    //Declaracion de digitos
    localparam uno =    4'b0001;
    localparam dos =    4'b0010;
    localparam tres =   4'b0011;
    localparam cuatro = 4'b0100;
    localparam cinco =  4'b0101;
    localparam seis =   4'b0110;
    localparam siete =  4'b0111;
    localparam ocho =   4'b1000;
    localparam nueve =  4'b1001;
    localparam cero =   4'b0000;
    localparam vacio =  4'b1111;  


    //Declaracion de flipflops
    always @(posedge clock) begin
        if (reset) begin 
            estado_actual <= 5'b00001; 
            cuenta_bit <= 2'b00;
            cuenta_digito <= 2'b00;
        end //end if
        else begin
            estado_actual <= proximo_estado;
            cuenta_bit <= proxima_bit;
            cuenta_digito <= proximo_digito;
        end //end else        
    end //end always @(posedge clock)

    //Declaracion de logica combinacional
    always @(*) begin

        estado_actual = proximo_estado;
        cuenta_bit = proxima_bit;
        cuenta_digito = proximo_digito;

        case (estado_actual)

            idle:   
                begin
                    if(tarjeta_recibida == 1) begin
                        proximo_estado = recibiendo_pin;
                    end //end if
                    else begin
                        proximo_estado = idle;
                    end //end else
                end //end idle
        endcase
    end //end always @(*)

endmodule // endmodule cajero
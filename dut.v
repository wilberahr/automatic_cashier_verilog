module dut (
    input wire clk,
    input wire reset,
    input wire tarjeta_recibida,
    input wire digito_stb,
    input wire [3:0] digito,
    input wire [15:0] pin_correcto,
    output reg pin_incorrecto,
    output reg advertencia,
    output reg bloqueo,
    input wire tipo_trans,
    input wire [31:0] monto,
    input wire [63:0] balance_inicial,
    output reg [63:0] balance_actualizado,
    output reg balance_stb,
    output reg entregar_dinero,
    output reg fondos_insuficientes
);



    //Declaracion de regstros internos
    reg [4:0] estado_actual;
    reg [4:0] proximo_estado;
    reg [15:0] pin;
    reg [15:0] proximo_pin;

    reg [1:0] contador,intentos;
    reg [1:0] proximo_contador, proximo_intento;

    //Declaracion de estados
    localparam idle             = 5'b00001;
    localparam recibiendo_pin   = 5'b00010;
    localparam comparando_pin   = 5'b00100;
    localparam transaccion      = 5'b01000;
    localparam sistema_bloqueado= 5'b10000;

    // Declaracion de parametros para transacciones
    // Se declaran como 1 bit para poder almacenar la transaccion
    localparam deposito = 1'b0;
    localparam retiro = 1'b1;

    // Declaracion de estados
    always @(posedge clk) begin
        if (~reset) begin
            estado_actual <= idle;
            contador <= 0;
            intentos <= 0;
            pin <= 15'hfff;
        end else begin
            estado_actual <= proximo_estado;
            contador <= proximo_contador;
            intentos <= proximo_intento;
            pin <= proximo_pin;
        end
    end

    //Declaracion de logica combinacional
    always @(*) begin

        proximo_estado = estado_actual;
        proximo_contador = contador;
        proximo_intento = intentos;
        proximo_pin = pin;

        case (estado_actual)

            idle: begin
                // Salidas en bajo
                pin_incorrecto = 0;
                advertencia = 0;
                bloqueo = 0;
                balance_stb = 0;
                balance_actualizado = 0;
                entregar_dinero = 0;
                fondos_insuficientes = 0;
                // Si se recibe la tarjeta, pasar al estado de recibiendo_pin
                // Si no, permanecer en el estado idle
                if (tarjeta_recibida)begin 
                    proximo_estado = recibiendo_pin;
                end
                else begin
                    proximo_estado = idle;
                end 
            end

            recibiendo_pin: begin

                pin_incorrecto = 0;
                if(digito_stb) begin
                    proximo_contador = contador +1;
                    
                    if(contador == 0)begin
                        proximo_pin[15:12] = digito;
                    end
                    else if(contador == 1)begin
                        proximo_pin[11:8] = digito;
                    end 
                    else if (contador == 2)begin
                        proximo_pin[7:4] = digito;
                    end 
                    else if (contador == 3)begin
                        proximo_pin[3:0] = digito;
                        proximo_estado = comparando_pin;
                        proximo_contador = 0;
                    end
  
                end else begin
                    proximo_estado = recibiendo_pin;
                end                            
                
            end

            comparando_pin:begin
                proximo_intento = intentos + 1;
                if (pin == pin_correcto) begin
                    proximo_intento = 0;
                    advertencia = 0;
                    bloqueo = 0;
                    pin_incorrecto =0;
                    proximo_estado = transaccion;
                end
                else begin
                    pin_incorrecto = 1;
                    // Si el pin es incorrecto, incrementar el intento
                    if (intentos == 3) begin
                        pin_incorrecto = 1;
                        advertencia = 0;
                        bloqueo = 1;
                        proximo_estado = sistema_bloqueado;
                    end
                    else begin
                        if (intentos==2) begin
                            advertencia = 1;
                            bloqueo = 0;
                            pin_incorrecto =1;
                        end 
                        else if (intentos==1) begin
                            advertencia = 0;
                            bloqueo = 0;
                            pin_incorrecto =1;
                        end
                        else begin
                            advertencia = 0;
                            bloqueo = 0;
                            pin_incorrecto =0;
                        end
                        proximo_estado = recibiendo_pin;
                    end
 
                end
            end

            transaccion:begin
                
                if (tipo_trans == retiro) begin
                    // Realizar deposito
                    if (monto > balance_inicial) begin
                        // Fondos insuficientes
                        balance_actualizado = 0;
                        balance_stb = 0;
                        entregar_dinero = 0;
                        fondos_insuficientes = 1;
                        proximo_estado = idle;
                    end else begin
                        // Actualizar balance
                        balance_actualizado = balance_inicial - monto;
                        balance_stb = 1;
                        fondos_insuficientes = 0;
                        proximo_estado = idle;
                        entregar_dinero = 1;
                    end
                end else begin
                    // Realizar depósito
                    balance_actualizado = balance_inicial + monto;
                    balance_stb = 1;
                    entregar_dinero = 0;
                    proximo_estado = idle;
                    fondos_insuficientes = 0;
                    
                end
            end

//            finalizado: begin
//                proximo_estado = idle;
 //                
  //          end

            sistema_bloqueado: begin
                bloqueo = 1;
                proximo_estado = sistema_bloqueado;
            end

            // Se programa el estado "idle" como el default    
            default: proximo_estado = idle;
        endcase
    end //end always @(*)

endmodule // endmodule cajero
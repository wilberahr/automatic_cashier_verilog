module cajero(  clock,
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
    input wire [63:0] balance_inicial;
    input wire [31:0] monto;
    input wire monto_stb;

    //Declaraacion de salidas
    output reg balance_actualizado;
    output reg entregar_dinero;
    output reg pin_incorrecto;
    output reg advertencia;
    output reg bloqueo;
    output reg fondos_insuficientes;

    //Declaracion de regstros internos
    reg [4:0] estado_actual;
    reg [4:0] proximo_estado;

    reg [1:0] cuenta_pin_bit;
    reg [1:0] proxima_cuenta_pin_bit;

    reg [1:0] intentos_fallidos;
    reg [1:0] proximo_intentos_fallidos;

    reg [15:0] pin_recibido;

    reg [63:0] balance;
    
    integer cuenta_digito_bit;
    localparam deposito = 1'b0;
    localparam retiro = 1'b1;

    //Declaracion de estados
    localparam idle             = 5'b00001;
    localparam recibiendo_pin   = 5'b00010;
    localparam comparar_pin     = 5'b00100;
    localparam transaccion      = 5'b01000;
    localparam bloqueo_cajero   = 5'b10000;

    //Declaracion de flipflops
    always @(posedge clock) begin
        if (reset) begin 
            estado_actual <= 5'b00001; 
            cuenta_pin_bit <= 2'b00;
            intentos_fallidos <= 2'b00;
        end //end if
        else begin
            estado_actual <= proximo_estado;
            cuenta_pin_bit <= proxima_cuenta_pin_bit;
            intentos_fallidos <= proximo_intentos_fallidos;
        end //end else        
    end //end always @(posedge clock)

    //Declaracion de logica combinacional
    always @(*) begin

        estado_actual = proximo_estado;
        cuenta_pin_bit = proxima_cuenta_pin_bit;
        intentos_fallidos = proximo_intentos_fallidos;

        case (estado_actual)

            idle:   
                begin
                    //Todas las salidas en bajo
                    balance_actualizado = 1'b0;
                    entregar_dinero = 1'b0;
                    pin_incorrecto = 1'b0;
                    advertencia = 1'b0;
                    bloqueo = 1'b0;
                    fondos_insuficientes = 1'b0;

                    if(tarjeta_recibida == 1) begin
                        proximo_estado = recibiendo_pin;
                    end // if
                    else begin
                        proximo_estado = idle;
                    end // else
                end // idle

            recibiendo_pin:
                begin
                    //Si todavía no se ha ingresado todo el pin
                    if(cuenta_pin_bit < 16) begin
                        if(digito_stb == 1'b0) begin
                            proximo_estado = recibiendo_pin;
                        end //end if(digito_stb == 1'b0)
                        else begin
                            //Se recorre el digito entrante y se asigna al bit al registo de pin recibido, con los digitos anteriores
                            for(cuenta_digito_bit = 0; cuenta_digito_bit<4; cuenta_digito_bit = cuenta_digito_bit + 1) begin
                                pin_recibido[cuenta_pin_bit + cuenta_digito_bit] = digito[cuenta_digito_bit];
                            end //end for
                            //Se suma 4 bits a la cuenta de bits en el pin
                            proxima_cuenta_pin_bit = cuenta_pin_bit + 4;
                            proximo_estado = recibiendo_pin;

                        
                        end // else
                    end // if(cuenta_pin_bit < 16)
                    //Si ya se ingreso todo el pin
                    else begin
                        //Se reinicia el contador de digitos
                        proxima_cuenta_pin_bit = 0;
                        proximo_estado = comparar_pin;
                    end //else

                end // recibiendo_pin

            comparar_pin:
                begin
                    // Se ingreso el pin correcto
                    if(pin_recibido == pin) begin
                        proximo_intentos_fallidos = 2'b00;
                        proximo_estado = transaccion;
                    end //end if
                    else begin
                        //Si no han habido intentos fallidos
                        if(intentos_fallidos == 2'b00) begin
                            pin_incorrecto = 1'b1;
                            proximo_intentos_fallidos = intentos_fallidos + 1;
                            proximo_estado = transaccion;
                        end //end if
                        // Si ha habido un intento fallido
                        else if(intentos_fallidos == 2'b10) begin
                            advertencia = 1'b1;
                            proximo_intentos_fallidos = intentos_fallidos + 1;
                            proximo_estado = transaccion;
                        end //end else if
                        // Si ha habido dos intentos fallidos
                        else if(intentos_fallidos == 2'b11) begin
                            advertencia = 1'b0;
                            bloqueo = 1'b1;
                            proximo_intentos_fallidos = 2'b00;
                            proximo_estado = bloqueo_cajero;
                        end //end else if
                    end //end else
                end //comparar_pin

            transaccion:
                begin
                    //Si tipo _trans == 0, es un deposito
                    if(tipo_trans == deposito) begin
                        balance = balance_inicial + monto;
                        balance_actualizado = 1'b1;
                    end // if(tipo_trans == deposito)
                    else begin
                        //Si tipo _trans == 1, es un retiro Y monto es menor al balance inicial
                        if(tipo_trans == retiro && monto <= balance_inicial) begin
                            balance = balance_inicial - monto;
                            balance_actualizado = 1'b1;
                        end // if(tipo_trans == retiro && monto <= balance_inicial)
                        else fondos_insuficientes = 1'b1;
                    end //else
                    proximo_estado = idle;
                end // transaccion
            bloqueo_cajero:
                begin
                    bloqueo = 1'b1;
                    proximo_estado = bloqueo;
                end
        endcase
    end //end always @(*)

endmodule // endmodule cajero
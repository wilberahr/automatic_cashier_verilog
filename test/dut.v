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
    reg [4:0] digito_actual;
    reg [4:0] intento_actual;
    reg [15:0] pin;

    reg [1:0] contador,intentos;
    reg [1:0] proximo_contador, proximo_intento;

    

    //Declaracion de estados
    localparam idle             = 5'b00001;
    localparam recibiendo_pin   = 5'b00010;
    localparam comparando_pin     = 5'b00100;
    localparam transaccion      = 5'b01000;
    localparam sistema_bloqueado= 5'b10000;

    // Declaracion de digitos
    // Se declaran como 4 bits para poder almacenar la posicion del digito
    localparam digito0          = 4'b0001;
    localparam digito1          = 4'b0010;
    localparam digito2          = 4'b0100;
    localparam digito3          = 4'b1000;
    
    // Declaracion de intentos
    // Se declaran como 3 bits para poder almacenar la cantidad de intentos
    localparam intento0        = 3'b001;
    localparam intento1        = 3'b010;
    localparam intento2        = 3'b100;

    // Declaracion de parametros para transacciones
    // Se declaran como 1 bit para poder almacenar la transaccion
    localparam deposito = 1'b0;
    localparam retiro = 1'b1;

    // Declaracion de estados
    always @(posedge clk) begin
        if (~reset) begin
            estado_actual <= idle;
            contador <= 0;
        end else begin
            estado_actual <= proximo_estado;
            contador <= proximo_contador;
        end
    end

    //Declaracion de logica combinacional
    always @(*) begin

        proximo_estado = estado_actual;
        proximo_contador = contador;
        proximo_intento = intentos;

        case (estado_actual)

            idle: begin
                // Salidas en bajo
                pin_incorrecto = 0;
                advertencia = 0;
                bloqueo = 0;
                pin = 16'hffff;
                digito_actual = digito0;
                intento_actual = intento0;
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
                    //pin = pin << 4;
                    //pin = pin + digito;
                    proximo_contador = contador +1;
                    
                    if(contador == 0)begin
                        pin[3:0] = digito;
                    end
                    else if(contador == 1)begin
                        pin[7:4] = digito;
                    end 
                    else if (contador == 2)begin
                        pin[11:8] = digito;
                    end 
                    else if (contador == 3)begin
                        pin[15:12] = digito;
                        proximo_estado = comparando_pin;
                        proximo_contador = 0;
                    end
                    
                    /**
                    if (digito_actual == digito3) begin
                        digito_actual = digito0;
                        proximo_estado = comparando_pin;
                    end
                    else begin
                                              
                        digito_actual = digito_actual << 1;
                        proximo_estado = recibiendo_pin;
                        
                    end**/
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
                    //intento_actual = intento0;
                    proximo_estado = transaccion;
                end
                else begin
                    pin_incorrecto = 1;
                    // Si el pin es incorrecto, incrementar el intento
                    pin = 16'hffff;
                    if (intentos == 3) begin
                        pin_incorrecto = 0;
                        advertencia = 0;
                        bloqueo = 1;
                        proximo_estado = sistema_bloqueado;
                    end
                    else begin
                        if (intentos==2) begin
                            advertencia = 1;
                            bloqueo = 0;
                            pin_incorrecto =0;
                            //intento_actual = intento2;
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
                        fondos_insuficientes = 1;
                        proximo_estado = idle;
                    end else begin
                        // Actualizar balance
                        balance_actualizado = balance_inicial - monto;
                        balance_stb = 1;
                        proximo_estado = idle;
                    end
                end else begin
                    // Realizar retiro
                    balance_actualizado = balance_inicial + monto;
                    balance_stb = 1;
                    entregar_dinero = 1;
                    proximo_estado = idle;
                    
                end
            end

            sistema_bloqueado: begin
                bloqueo = 1;
                proximo_estado = sistema_bloqueado;
            end

            // Se programa el estado "idle" como el default    
            default: proximo_estado = idle;
        endcase
    end //end always @(*)

endmodule // endmodule cajero
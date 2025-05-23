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
    output reg fin,
    output reg [15:0] pin
);
    // Declaracion de variables de estado y proximo estado
    reg [4:0] estado_actual;
    reg [4:0] proximo_estado;
    reg [4:0] digito_actual;
    //reg [4:0] proximo_digito;
    reg [4:0] intento_actual;
    //reg [4:0] proximo_intento;

    // Declaracion de registro interno que recibe el pin
    // Se declaran como 16 bits para poder almacenar el pin
    // reg [15:0] pin;

   // Declaracion de estados
    localparam idle             = 5'b00001;
    localparam recibiendo_pin   = 5'b00010;
    localparam transaccion      = 5'b00100;
    localparam comparando_pin   = 5'b01000;
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

    // Declaracion de estados
    always @(posedge clk) begin
        if (~reset) begin
            estado_actual <= idle;
            //digito_actual <= digito0;
            //intento_actual <= intento0; 
        end else begin
            estado_actual <= proximo_estado;
            //digito_actual <= proximo_digito;
            //intento_actual <= proximo_intento;
        end
    end

    // Declaracion de logica combinacional
    always @(*) begin

        proximo_estado = estado_actual;
        //proximo_digito = digito_actual;
        //proximo_intento = intento_actual;

        case (estado_actual)
            idle: begin
                // Salidas en bajo
                pin_incorrecto = 0;
                advertencia = 0;
                bloqueo = 0;
                fin = 0;
                pin = 16'hffff;
                digito_actual = digito0;
                intento_actual = intento0;
                // Si se recibe la tarjeta, pasar al estado de recibiendo_pin
                // Si no, permanecer en el estado idle
                if (tarjeta_recibida) 
                    proximo_estado = recibiendo_pin;
                else 
                    proximo_estado = idle;
            end
            recibiendo_pin: begin

                pin_incorrecto = 0;
                if(digito_stb) begin
                    pin = pin << 4;
                    pin = pin + digito;
                    if (digito_actual == digito3) begin
                        digito_actual = digito0;
                        proximo_estado = comparando_pin;
                    end
                    else begin
                                              
                        digito_actual = digito_actual << 1;
                        proximo_estado = recibiendo_pin;
                        
                    end
                end else begin
                    proximo_estado = recibiendo_pin;
                end                            
                
            end

            comparando_pin: begin
                if (pin == pin_correcto) begin
 
                    intento_actual = intento0;
                    proximo_estado = transaccion;
                end
                else begin
                    pin_incorrecto = 1;
                    // Si el pin es incorrecto, incrementar el intento
                    pin = 16'hffff;
                    if (intento_actual==intento2) begin
                        advertencia = 0;
                        bloqueo = 1;
                        proximo_estado = sistema_bloqueado;
                    end
                    else begin
                        if (intento_actual==intento1) begin
                            advertencia = 1;
                            intento_actual = intento2;
                        end 
                        else begin
                            intento_actual = intento1;
                        end
                        proximo_estado = recibiendo_pin;
                    end
 
                end
            end

            transaccion: begin
                fin = 1;
                proximo_estado = idle;
            end

            sistema_bloqueado: begin
                bloqueo = 1;
                proximo_estado = sistema_bloqueado;
            end
            default: proximo_estado = idle;
        endcase
    end


endmodule
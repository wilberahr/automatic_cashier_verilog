module dut (
    input wire clk,
    input wire reset,
    input wire digito_stb,
    input wire [3:0] digito,
    input wire [15:0] pin_correcto,
    output reg advertencia,
    output reg bloqueo,
    output reg fin
);
    // Declaracion de variables de estado y proximo estado
    reg [4:0] estado_actual;
    reg [4:0] proximo_estado;

    // Declaracion de registro interno de intentos
    reg [3:0] intentos;

   // Declaracion de estados
    localparam idle             = 5'b00001;
    localparam recibiendo_pin   = 5'b00010;
    localparam transaccion      = 5'b00100;

    // Declaracion de estados
    always @(posedge clk) begin
        if (~reset) begin
            estado_actual <= idle;
        end else begin
            estado_actual <= proximo_estado;
        end
    end

    // Declaracion de logica combinacional
    always @(*) begin

        estado_actual = proximo_estado;

        case (estado_actual)
            idle: begin
                // Salidas en bajo
                fin = 0;
                // Si se recibe la tarjeta, pasar al estado de recibiendo_pin
                // Si no, permanecer en el estado idle
                if (tarjeta_recibida) 
                    proximo_estado = recibiendo_pin;
                else 
                    proximo_estado = idle;
            end
            recibiendo_pin: begin
                proximo_estado = transaccion;
            end
            transaccion: begin
                fin = 1;
                proximo_estado = idle;
            end
            default: proximo_estado = idle;
        endcase
    end


endmodule
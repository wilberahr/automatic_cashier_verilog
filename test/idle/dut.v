module dut (
    input wire clk,
    input wire reset,
    input wire tarjeta_recibida,
    output reg fin
);

   // Declaracion de estados
    localparam idle             = 5'b00001;
    localparam recibiendo_pin   = 5'b00010;
    localparam prueba           = 5'b00100;

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
                proximo_estado = prueba;
            end
            prueba: begin
                fin = 1;
                proximo_estado = idle;
            end
            default: proximo_estado = idle;
        endcase
    end


endmodule
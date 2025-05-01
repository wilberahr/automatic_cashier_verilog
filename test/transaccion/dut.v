module dut (
    input wire clk,
    input wire reset,
    input wire tarjeta_recibida,
    input wire tipo_trans,
    input wire [31:0] monto,
    input wire [63:0] balance_inicial,
    output reg [63:0] balance_actualizado,
    output reg balance_stb,
    output reg entregar_dinero,
    output reg fondos_insuficientes
);

   // Declaracion de estados
    localparam idle             = 5'b00001;
    localparam recibiendo_pin   = 5'b00010;
    localparam transaccion      = 5'b00100;

    // Declaracion de parametros
    localparam deposito        = 1'b0;
    localparam retiro          = 1'b1;    

    // Declaracion de variables de estado y proximo estado
    reg [4:0] estado_actual;
    reg [4:0] proximo_estado;
    
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
                balance_stb = 0;
                entregar_dinero = 0;
                fondos_insuficientes = 0;
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
                        entregar_dinero = 1;
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
            default: proximo_estado = idle;
        endcase
    end


endmodule
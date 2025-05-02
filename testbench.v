`include "dut.v"
`include "tester.v"

module testbench;

    wire clk;
    wire reset;
    wire tarjeta_recibida;
    wire digito_stb;
    wire [3:0] digito;
    wire [15:0] pin_correcto;
    wire pin_incorrecto;
    wire advertencia;
    wire bloqueo;
    wire tipo_trans;
    wire [31:0] monto;
    wire [63:0] balance_inicial;
    wire [63:0] balance_actualizado;
    wire balance_stb;
    wire entregar_dinero;
    wire fondos_insuficientes;

    // Instanciacion del DUT
    dut DUT (
        .clk(clk),
        .reset(reset),
        .tarjeta_recibida(tarjeta_recibida),
        .digito_stb(digito_stb),
        .digito(digito[3:0]),
        .pin_correcto(pin_correcto[15:0]),
        .pin_incorrecto(pin_incorrecto),
        .advertencia(advertencia),
        .bloqueo(bloqueo),
        .tipo_trans(tipo_trans),
        .monto(monto[31:0]),
        .balance_inicial(balance_inicial[63:0]),
        .balance_actualizado(balance_actualizado[63:0]),
        .balance_stb(balance_stb),
        .entregar_dinero(entregar_dinero),
        .fondos_insuficientes(fondos_insuficientes)
    );

    // Instanciacion del tester
    tester TESTER (
        .clk(clk),
        .reset(reset),
        .tarjeta_recibida(tarjeta_recibida),
        .digito_stb(digito_stb),
        .digito(digito[3:0]),
        .pin_correcto(pin_correcto[15:0]),
        .pin_incorrecto(pin_incorrecto),
        .advertencia(advertencia),
        .bloqueo(bloqueo),
        .tipo_trans(tipo_trans),
        .monto(monto[31:0]),
        .balance_inicial(balance_inicial[63:0]),
        .balance_actualizado(balance_actualizado[63:0]),
        .balance_stb(balance_stb),
        .entregar_dinero(entregar_dinero),
        .fondos_insuficientes(fondos_insuficientes)
    );

    // Resultados de la simulacion
    initial begin
        $dumpfile("resultados.vcd");
        $dumpvars(-1,testbench);
        $monitor(
            "Tiempo: %0t | reset: %b | digito_stb: %b | digito: %h | pin_correcto: %h | pin_incorrecto: %b | advertencia: %b | bloqueo: %b | Tipo de transaccion: %b | Monto: %d | Balance inicial: %d | Balance actualizado: %d | Balance stb: %b | Entregar dinero: %b | Fondos insuficientes: %b",
            $time, reset, digito_stb, digito, pin_correcto, pin_incorrecto, advertencia, bloqueo,tipo_trans, monto, balance_inicial, balance_actualizado, balance_stb, entregar_dinero, fondos_insuficientes); 
            
     end

endmodule
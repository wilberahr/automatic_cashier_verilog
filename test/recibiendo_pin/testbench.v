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
    wire fin;

    // Senales de prueba
    wire [15:0] pin;
    
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
        .fin(fin),
        .pin(pin[15:0])
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
        .fin(fin),
        .pin(pin[15:0])
    );

    // Resultados de la simulacion
    initial begin
        $dumpfile("resultados.vcd");
        $dumpvars(-1,testbench);
        $monitor(
            "Tiempo: %0t | reset: %b | digito_stb: %b | digito: %h | pin_correcto: %h | pin: %h |pin_incorrecto: %b | advertencia: %b | bloqueo: %b | fin: %b",
            $time, reset, digito_stb, digito, pin_correcto, pin, pin_incorrecto, advertencia, bloqueo, fin); 
            
     end

endmodule
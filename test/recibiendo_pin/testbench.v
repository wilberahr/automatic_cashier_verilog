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
        .fin(fin)
    );

    // Instanciacion del tester
    tester TESTER (
        .clk(clk),
        .reset(reset),
        .tarjeta_recibida(tarjeta_recibida),
        .digito_stb(digito_stb),
        .digito(digito[3:0]),
        .pin_correcto(pin_correcto),
        .pin_incorrecto(pin_incorrecto[15:0]),
        .advertencia(advertencia),
        .bloqueo(bloqueo),
        .fin(fin)
    );

    // Resultados de la simulacion
    initial begin
        $dumpfile("resultados.vcd");
        $dumpvars(-1,testbench);
        $monitor(
            "Tiempo: %0t | reset: %b | digito_stb: %b | digito: %b | pin_correcto: %b | pin_incorrecto: %b | advertencia: %b | bloqueo: %b | fin: %b",
            $time, reset, digito_stb, digito, pin_correcto, pin_incorrecto, advertencia, bloqueo, fin); 
            
     end

endmodule
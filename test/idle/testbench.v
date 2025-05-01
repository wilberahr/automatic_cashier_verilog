`include "dut.v"
`include "tester.v"

module testbench;

    wire clk;
    wire reset;
    wire tarjeta_recibida;
    wire fin;

    // Instanciacion del DUT
    dut DUT (
        .clk(clk),
        .reset(reset),
        .tarjeta_recibida(tarjeta_recibida),
        .fin(fin)
    );
    
    // Instanciacion del tester
    tester TESTER (
        .clk(clk),
        .reset(reset),
        .tarjeta_recibida(tarjeta_recibida),
        .fin(fin)
    );

    // Resultados de la simulacion
    initial begin
        $dumpfile("resultados.vcd");
        $dumpvars(-1,testbench);
        $monitor(
            "Tiempo: %0t | Reset: %b | tarjeta_recibida: %b | fin: %b", 
            $time, reset, tarjeta_recibida,fin);
    end

endmodule
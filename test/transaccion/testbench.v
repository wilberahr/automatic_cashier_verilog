`include "dut.v"
`include "tester.v"

module testbench;

    wire clk;
    wire reset;
    wire tarjeta_recibida;
    wire tipo_trans;
    wire [31:0] monto;
    wire [63:0] balance_inicial;
    wire [63:0] balance_actualizado;
    wire balance_stb;
    wire entregar_dinero;
    wire fondos_insuficiente;
    
    // Instanciacion del DUT
    dut DUT (
        .clk(clk),
        .reset(reset),
        .tarjeta_recibida(tarjeta_recibida),
        .tipo_trans(tipo_trans),
        .monto(monto[31:0]),
        .balance_inicial(balance_inicial[63:0]),
        .balance_actualizado(balance_actualizado[63:0]),
        .balance_stb(balance_stb),
        .entregar_dinero(entregar_dinero),
        .fondos_insuficientes(fondos_insuficiente)
    );

    // Instanciacion del tester
    tester TESTER (
        .clk(clk),
        .reset(reset),
        .tarjeta_recibida(tarjeta_recibida),
        .tipo_trans(tipo_trans),
        .monto(monto[31:0]),
        .balance_inicial(balance_inicial[63:0]),
        .balance_actualizado(balance_actualizado[63:0]),
        .balance_stb(balance_stb),
        .entregar_dinero(entregar_dinero),
        .fondos_insuficientes(fondos_insuficiente)
    );

    // Resultados de la simulacion
    initial begin
        $dumpfile("resultados.vcd");
        $dumpvars(-1,testbench);
        $monitor(
            "Tiempo: %0t | Reset: %b | Tarjeta  recibida: %b | Tipo de transaccion: %b | Monto: %d | Balance inicial: %d | Balance actualizado: %d | Balance stb: %b | Entregar dinero: %b | Fondos insuficientes: %b", 
            $time, reset, tarjeta_recibida, tipo_trans, monto, balance_inicial, balance_actualizado, balance_stb, entregar_dinero, fondos_insuficiente);
     end

endmodule
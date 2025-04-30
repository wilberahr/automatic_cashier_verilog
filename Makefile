tarea:testbench.v mdios.ys # Archivos requeridos
	#yosys -s mdios.ys # Corre sintesis 
	iverilog -o salida estadoInicial_testbench.v #Corre Icarus
	vvp salida # Corre la simulacion
	gtkwave resultados.vcd # Abre las formas de onda
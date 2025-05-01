all: tarea

tarea:testbench.v # Archivos requeridos 
	iverilog -o salida testbench.v #Corre Icarus
	vvp salida # Corre la simulacion
	gtkwave resultados.vcd # Abre las formas de onda

clean: 
	rm -f salida resultados.vcd # Elimina los archivos generados

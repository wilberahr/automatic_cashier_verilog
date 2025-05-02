all: tarea

tarea:testbench.v # Archivos requeridos
	
	iverilog -o salida testbench.v #Corre Icarus
	vvp salida # Corre la simulacion
	gtkwave resultados.vcd # Abre las formas de onda

yosys:mdios.ys # Archivos requeridos
	yosys -s mdios.ys # Corre sintesis 

clean:
	rm -f salida *.vcd # Elimina los archivos generados
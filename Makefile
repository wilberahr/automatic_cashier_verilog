BUILD = ./build/salida
VERILOG = iverilog
OFLAGS = -o 
MDIOS = mdios.ys

all: tarea

tarea:$(DESIGN_TB) $(SYNTH_TB) $(MDIOS) # Archivos requeridos
	
	$(VERILOG) $(OFLAGS) $(BUILD) $(DESIGN_TB) #Corre Icarus
	vvp $(BUILD) # Corre la simulacion
	gtkwave resultados_design.vcd # Abre las formas de onda
	yosys -s $(MDIOS) # Corre sintesis
	rm -rf $(BUILD) # Elimina la carpeta de salida
	$(VERILOG) $(OFLAGS) $(BUILD) $(SYNTH_TB) #Corre Icarus
	vvp $(BUILD) # Corre la simulacion
	gtkwave resultados_synth.vcd # Abre las formas de onda

clean:
	rm -f salida *.vcd # Elimina los archivos generados

$(MDIOS):tools/mdios.ys # Archivos requeridos

$(SYNTH_TB): synthesis/testbench.v # Archivos requeridos

$(DESIGN_TB): design/testbench.v # Archivos requeridos
	

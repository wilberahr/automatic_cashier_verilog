BUILD = ./build/salida
VERILOG = iverilog
OFLAGS = -o 
MDIOS = ./tools/mdios.ys
GTKW = ./tools/resultados.gtkw
SYNTH_TB = ./testbench/synthesis/testbench.v 
DESIGN_TB = ./testbench/design/testbench.v
SYNTH_VCD = resultados_synth.vcd
DESIGN_VCD = resultados_design.vcd

all: tarea

tarea:$(DESIGN_TB) $(SYNTH_TB) $(MDIOS) # Archivos requeridos
	
	$(VERILOG) $(OFLAGS) $(BUILD) $(DESIGN_TB) #Corre Icarus
	vvp $(BUILD) # Corre la simulacion
	gtkwave $(DESIGN_VCD) $(GTKW) # Abre las formas de onda
	yosys -s $(MDIOS) # Corre sintesis
	rm -rf $(BUILD) # Elimina la carpeta de salida
	$(VERILOG) $(OFLAGS) $(BUILD) $(SYNTH_TB) #Corre Icarus
	vvp $(BUILD) # Corre la simulacion
	gtkwave $(SYNTH_VCD) $(GTKW) # Abre las formas de onda

clean:
	rm -f $(BUILD) *.vcd # Elimina los archivos generados


	

# Variables de entorno para la compilación
# de los testbenches de diseño y síntesis

# Directorios donde los archivos de diseño, tester y librerias de sintesis están ubicados
CFLAGS += -I. -I./lib

# Dependencias de los testbenches
DEPS_DESIGN += dut.v tester.v
DEPS_SYNTHESIS += dut_synth.v tester.v

# Archivo utilizado para visualizar las señales en gtkwave
GTKW_FILE = resultados

#Directorios de archivos de compilación y herramientas
BUILD_DIR = build
TOOLS_DIR = tools

# Hacer la compilación de los testbenches
all: tarea

# Generar la simulación de diseño y síntesis
tarea: design.vcd synthesis.vcd

# Generar la simulación de diseño		
design.vcd: design
	vvp $(BUILD_DIR)/$<

# Compila el testbench de diseño a partir de los archivos de diseño y probador
design:  $(DEPS_DESIGN)
	iverilog -o $(BUILD_DIR)/$@ testbenches/design/testbench.v $(CFLAGS)

# Generar la simulación de síntesis
synthesis.vcd: synthesis
	vvp $(BUILD_DIR)/$<
	gtkwave $@ $(GTKW_FILE).gtkw

# Compila el testbench de síntesis a partir de los archivos de diseño sintetizado, 
# biblioteca cmos_cells.v y probador
synthesis: $(DEPS_SYNTHESIS)
	iverilog -o $(BUILD_DIR)/$@ testbenches/synthesis/testbench.v $(CFLAGS)

# Genera el archivo de diseño sintetizado a partir del archivo de diseño y la biblioteca
# cmos_cells.lib utilizando la herramienta "yosys"
dut_synth.v: 
	yosys -s $(TOOLS_DIR)/mdios.ys

#Despleiga la simulación de diseño por comportamiento
view_design_sim: 
	gtkwave design.vcd $(GTKW_FILE).gtkw

# Borra los archivos compilados y generados por las herramientas
# de simulación y síntesis
clean:
	rm -f $(BUILD_DIR)/*
	rm -f *.vcd
	rm -f dut_synth.v
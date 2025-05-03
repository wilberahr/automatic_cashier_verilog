CFLAGS += -I. -I./lib
DEPS_DESIGN += dut.v tester.v
DEPS_SYNTHESIS += dut_synth.v tester.v
GTKW_FILE = resultados
BUILD_DIR = build
TOOLS_DIR = tools

all: tarea

tarea: design.vcd synthesis.vcd
		
design.vcd: design
	vvp $(BUILD_DIR)/$<
#	gtkwave $@ $(GTKW_FILE).gtkw
	
	
design:  $(DEPS_DESIGN)
	iverilog -o $(BUILD_DIR)/$@ testbenches/design/testbench.v $(CFLAGS)

synthesis.vcd: synthesis design.vcd
	vvp $(BUILD_DIR)/$<
	gtkwave $@ $(GTKW_FILE).gtkw


synthesis: $(DEPS_SYNTHESIS)
	iverilog -o $(BUILD_DIR)/$@ testbenches/synthesis/testbench.v $(CFLAGS)

dut_synth.v: 
	yosys -s $(TOOLS_DIR)/mdios.ys

clean:
	rm -f $(BUILD_DIR)/*
	rm -f *.vcd
	rm -f dut_synth.v
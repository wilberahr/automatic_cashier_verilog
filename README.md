# Diseño de cajero automático en Verilog

## Estructura del directorio

El proyecto está organizado de la siguiente manera:

```
/automatic_cashier_verilog
├── src/                    # Código fuente en Verilog.
    ├── design/             # Locación del testbench.v del diseño conductual.
    ├── synthesis/          # Locación del testbench.v del diseño sintetizado.
    ├── tester.v            # archivo de verilog para hacer las pruebas del DUT.
├── lib/                    # Bibliotecas utilizadas para el proceso de sintesis.
├── tools/                  # Archivos de configuración para visualizar simulaciones y hacer sintesis.
├── test/                   # Bancos de prueba para diseño y simulación los diferentes estados y el DUT completo.
    ├──idle                 # Unit test del estado "idle"
    ├──recibiendo_pin       # Unit test del estado "recibiendo_pin", adicionalmente se probaron "comparando_pin" y "sistema_bloqueado"
    ├──transaccion          # Unit test del estado "transaccion".
├── build/                  # Archivos generados durante la compilación.
├── docs/                   # Directorio donde están las imágenes e informe del proyecto.
├── resultados_design.vcd   # Resultado de la simulación del diseño conductual.
├── resultados_synth.vcd    # Resultado de la simulación del diseño sintetizado.
├── Makefile                # Archivo para automatizar tareas de compilación y simulación.
├── README.md               # Archivo README la estructura de los directorios.
├── dut.v                   # archivo de verilog con el diseño conductual del DUT.
├── dut_synth.v             # archivo de verilog con el diseño sintetizado del DUT.
```

## Uso del Makefile

El Makefile incluido en el proyecto permite automatizar varias tareas comunes. A continuación, se describen los comandos principales:

- **Compilar el proyecto**:
    ```bash
    make
    ```
    Este comando compila los archivos Verilog y genera los binarios en el directorio `build/`.

- **Limpiar archivos generados**:
    ```bash
    make clean
    ```
    Elimina los archivos generados durante la compilación y simulación.

Asegúrate de tener `make` instalado en tu sistema antes de ejecutar estos comandos.
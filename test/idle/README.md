# README

## Descripción

Este directorio contiene el archivo `dut.v`, que representa el módulo de prueba principal (Device Under Test, DUT) para el estado `idle` en el proyecto **automatic_cashier_verilog**.

## Contenido

- **`dut.v`**: Este archivo Verilog define el comportamiento del DUT en el estado `idle`. Es utilizado para verificar que el sistema se comporte correctamente cuando no hay actividad o transacciones en curso.

## Detalles del módulo `dut.v`

El módulo `dut.v` incluye:
- **Entradas**: Señales de control y datos necesarias para simular el estado `idle`.
- **Salidas**: Señales que indican el estado del sistema en reposo.
- **Lógica interna**: Implementación del comportamiento esperado en el estado `idle`.

## Uso

1. Asegúrate de tener un entorno de simulación Verilog configurado (por ejemplo, ModelSim o Icarus Verilog).
2. Compila y simula el archivo `dut.v` junto con los módulos de prueba correspondientes.
3. Verifica que las salidas coincidan con el comportamiento esperado para el estado `idle`.

## Nota

- Este archivo es parte de un sistema más grande. Consulta la documentación principal del proyecto para obtener más contexto.

# Proyecto 1 - Diseño Lógico

## 1. Descripción general del proyecto

Este proyecto consiste en el diseño e implementación de un sistema para la transmisión, detección y corrección de errores en palabras binarias mediante el código de Hamming (7,4).

El sistema combina circuitos integrados de lógica combinacional CMOS con dispositivos FPGA. La implementación se divide principalmente en dos partes: un **transmisor** y un **receptor**, los cuales se comunican mediante una palabra de 8 bits.

El transmisor recibe una palabra de información de 4 bits, genera los bits de paridad correspondientes al código de Hamming (7,4) y añade un bit adicional de paridad para la detección de doble error (DED) mediante compuertas XOR alambradas; además, permite introducir uno o dos errores en la palabra antes de su transmisión con otra FPGA.

El receptor recibe la palabra de 8 bits y realiza la verificación de paridad, la determinación del síndrome de Hamming y la corrección de errores simples (SEC) o detección de errores dobles (DED). Finalmente, la palabra recibida o corregida se visualiza mediante LEDs y displays de 7 segmentos.

Además, como parte del proyecto se implementa y caracteriza experimentalmente un oscilador en anillo utilizando compuertas inversoras, con el objetivo de analizar el tiempo de propagación y el comportamiento temporal de las señales digitales.

---

## 2. Abreviaturas y definiciones

- **FPGA:** Field Programmable Gate Array.
- **HDL:** Hardware Description Language.
- **SEC:** Single Error Correction. Corrección de un error en una palabra transmitida.
- **DED:** Double Error Detection. Detección de dos errores en una palabra transmitida.
- **RTL:** Register Transfer Level. Nivel de descripción utilizado para representar el comportamiento del diseño antes de la síntesis.
- **CI:** Circuito Integrado.
- **Hamming (7,4):** Código de detección y corrección de errores que utiliza 4 bits de información y 3 bits de paridad.
- **Síndrome:** Palabra binaria generada a partir de la verificación de los bits de paridad de Hamming y utilizada para determinar la posición de un posible error.
- **Pull-down:** Resistencia utilizada para establecer un nivel lógico bajo definido cuando una entrada no está siendo activada.

---

## 3. Referencias

[1] D. Harris y S. Harris, *Digital Design and Computer Architecture: RISC-V Edition*. Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3.

[2] Escuela de Ingeniería Electrónica, EL-3307 Diseño Lógico, *Proyecto corto I: Diseño digital combinacional mixto*, II Semestre 2026.

---

## 4. Asignación de pines y conexiones

La siguiente tabla presenta la asignación de pines utilizada para las entradas
y salidas externas de la FPGA, así como las conexiones destinadas a la
comunicación entre las FPGA del transmisor y receptor.

| Señal | Pin Tang Nano 9K | Función / Descripción |
|---|---:|---|
| `error_pos1[0]` | 36 | Switch de datos para colocar el primer error, bit 0 de la posición |
| `error_pos1[1]` | 37 | Switch de datos para colocar el primer error, bit 1 de la posición |
| `error_pos1[2]` | 38 | Switch de datos para colocar el primer error, bit 2 de la posición |
| `error_pos2[0]` | 26 | Switch de datos para colocar el segundo error, bit 0 de la posición |
| `error_pos2[1]` | 25 | Switch de datos para colocar el segundo error, bit 1 de la posición |
| `error_pos2[2]` | 39 | Switch de datos para colocar el segundo error, bit 2 de la posición |
| `datos[0]` | 30 | Switch de entrada de datos, bit 0 de la palabra de 4 bits |
| `datos[1]` | 29 | Switch de entrada de datos, bit 1 de la palabra de 4 bits |
| `datos[2]` | 28 | Switch de entrada de datos, bit 2 de la palabra de 4 bits |
| `datos[3]` | 27 | Switch de entrada de datos, bit 3 de la palabra de 4 bits |
| `C0` | 35 | Salida de compuerta XOR correspondiente al bit de Hamming `C0` |
| `C1` | 40 | Salida de compuerta XOR correspondiente al bit de Hamming `C1` |
| `C2` | 33 | Salida de compuerta XOR correspondiente al bit de Hamming `C2` |
| `P` | 34 | Salida de compuerta XOR correspondiente al bit de paridad global `P` |
| `modo` | 48 | Switch de selección del modo de funcionamiento del sistema (Transmisor/Receptor) |
| `display` | 49 | Switch de selección de la información mostrada en los displays |
| `A` | 72 | Señal de control del segmento A del display de 7 segmentos |
| `B` | 71 | Señal de control del segmento B del display de 7 segmentos |
| `C` | 70 | Señal de control del segmento C del display de 7 segmentos |
| `D` | 75 | Señal de control del segmento D del display de 7 segmentos |
| `E` | 76 | Señal de control del segmento E del display de 7 segmentos |
| `F` | 74 | Señal de control del segmento F del display de 7 segmentos |
| `G` | 73 | Señal de control del segmento G del display de 7 segmentos |
| `DIG1` | 63 | Control del ánodo común del primer dígito mediante transistor PNP |
| `DIG2` | 77 | Control del ánodo común del segundo dígito mediante transistor PNP |
| `com[0]` | 41 | Línea 0 de comunicación entre la FPGA transmisora y la FPGA receptora |
| `com[1]` | 42 | Línea 1 de comunicación entre la FPGA transmisora y la FPGA receptora |
| `com[2]` | 51 | Línea 2 de comunicación entre la FPGA transmisora y la FPGA receptora |
| `com[3]` | 53 | Línea 3 de comunicación entre la FPGA transmisora y la FPGA receptora |
| `com[4]` | 54 | Línea 4 de comunicación entre la FPGA transmisora y la FPGA receptora |
| `com[5]` | 55 | Línea 5 de comunicación entre la FPGA transmisora y la FPGA receptora |
| `com[6]` | 56 | Línea 6 de comunicación entre la FPGA transmisora y la FPGA receptora |
| `com[7]` | 57 | Línea 7 de comunicación entre la FPGA transmisora y la FPGA receptora |

---

## 3. Desarrollo

### 3.0 Descripción general del sistema

### 3.1 Módulo 1
#### 1. Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```
#### 2. Parámetros
- Lista de parámetros

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas

### Otros modulos
- agregar informacion siguiendo el ejemplo anterior.


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc

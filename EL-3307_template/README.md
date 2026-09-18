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

## 5. Desarrollo

<details>
<summary><strong>5.1 Subsistema 1 — Transmisor</strong></summary>

<details>
<summary><strong>Módulo: Lectura y visualización de la palabra</strong></summary>

#### 1. Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```

#### 2. Parámetros
-Lista de parámetros

#### 3. Entradas y salidas
- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida
- 
#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas
### Verificación del módulo de codificación binario a 7 segmentos

### 1. Descripción del módulo

El módulo `binario_7seg` forma parte del transmisor del proyecto. Su función es recibir una palabra binaria de 4 bits ingresada mediante los conmutadores y generar las señales necesarias para visualizar dicha palabra en un display de 7 segmentos utilizando notación hexadecimal.

Este subsistema se implementa dentro de la FPGA. El proyecto establece que el usuario debe poder confirmar visualmente la palabra ingresada antes de que sea enviada al codificador Hamming (7,4).

### Señales del módulo

| Señal | Tipo | Ancho | Función |
|:---|:---:|:---:|:---|
| `codigo_bin_pi` | Entrada | 4 bits | Palabra binaria ingresada por el usuario |
| `catodo_po` | Salida | 7 bits | Señales de control de los segmentos del display |

La correspondencia utilizada entre las salidas y los segmentos es:

### Correspondencia de las salidas con los segmentos

| Salida | Segmento |
|:---|:---:|
| `catodo_po[6]` | G |
| `catodo_po[5]` | F |
| `catodo_po[4]` | C |
| `catodo_po[3]` | B |
| `catodo_po[2]` | A |
| `catodo_po[1]` | D |
| `catodo_po[0]` | E |

El display utilizado es de ánodo común, por lo que un `0` en el cátodo permite encender el segmento correspondiente.

### 2. Objetivo del testbench

El testbench `tb_binario_7seg` se desarrolló para verificar mediante
simulación RTL (pre-síntesis) el funcionamiento del módulo
`binario_7seg`.

La prueba busca comprobar las 16 combinaciones posibles de la entrada de
cuatro bits y observar la respuesta generada en `catodo_po[6:0]`.

Además, el testbench genera un archivo `.vcd` para visualizar las
señales mediante GTKWave.

### 3. Estructura del testbench

El archivo utilizado es:

``` text
src/
├── design/
│   └── binario_7seg.sv
└── sim/
    └── tb_binario_7seg.sv
```

El testbench contiene:

1.  La señal de entrada controlada por el testbench.
2.  La señal de salida observada.
3.  La instancia del módulo bajo prueba (DUT).
4.  La generación del archivo VCD.
5.  Un bloque `initial` que aplica las diferentes entradas.
6.  La finalización de la simulación mediante `$finish`.

### 4. Señales del testbench

La entrada se declara como:

``` systemverilog
reg [3:0] codigo_bin_pi;
```

Se utiliza `reg` porque el testbench asigna diferentes valores a esta
señal durante la simulación.

La salida se declara como:

``` systemverilog
wire [6:0] catodo_po;
```

Se utiliza `wire` porque la señal es generada por el módulo bajo prueba
y el testbench solamente la observa.

La relación entre ambos elementos es:

``` text
              TESTBENCH
                  │
                  │ codigo_bin_pi[3:0]
                  ▼
          ┌─────────────────┐
          │  binario_7seg   │
          │      DUT        │
          └────────┬────────┘
                   │
                   │ catodo_po[6:0]
                   ▼
              TESTBENCH
                   │
                   ▼
                GTKWave
```

### 5. Instancia del DUT

El módulo se instancia dentro del testbench mediante:

``` systemverilog
binario_7seg DUT (
    .codigo_bin_pi(codigo_bin_pi),
    .catodo_po(catodo_po)
);
```

`DUT` significa *Device Under Test* y corresponde al circuito que se
desea verificar.

La entrada del DUT queda conectada a la señal `codigo_bin_pi` del
testbench y la salida del DUT queda conectada a `catodo_po`.

### 6. Generación del archivo VCD

El testbench utiliza:

``` systemverilog
initial begin
    $dumpfile("binario_7seg.vcd");
    $dumpvars(0, tb_binario_7seg);
end
```

`$dumpfile` define el nombre del archivo que almacenará la información
de la simulación:

``` text
binario_7seg.vcd
```

`$dumpvars` indica las señales que deben registrarse para poder
visualizarlas posteriormente en GTKWave.

### 7. Aplicación de las entradas

Se probaron las 16 combinaciones posibles de cuatro bits:

``` text
0000 → 0001 → 0010 → 0011 → 0100 → 0101 → 0110 → 0111
1000 → 1001 → 1010 → 1011 → 1100 → 1101 → 1110 → 1111
```

Cada entrada se mantiene durante 10 ns antes de aplicar la siguiente.
Por ejemplo:

``` systemverilog
codigo_bin_pi = 4'd0;
#10;

codigo_bin_pi = 4'd1;
#10;

codigo_bin_pi = 4'd2;
#10;
```

Por lo tanto, el primer valor permanece de 0 a 10 ns, el segundo de 10 a
20 ns, y así sucesivamente.

La simulación observada tuvo una duración total de aproximadamente 160
ns.

### 8. Resultados de la simulación RTL

Al ejecutar `make test` se generó el archivo `binario_7seg.vcd`.
Posteriormente se utilizó `make wv` para abrirlo en GTKWave.

Las señales observadas fueron:

``` text
codigo_bin_pi[3:0]
catodo_po[6:0]
```

GTKWave mostró los buses en representación hexadecimal. Los valores
observados fueron:

    Entrada   `catodo_po[6:0]`
  --------- ------------------
        `0`               `40`
        `1`               `67`
        `2`               `20`
        `3`               `21`
        `4`               `07`
        `5`               `09`
        `6`               `08`
        `7`               `63`
        `8`               `00`
        `9`               `01`
        `A`               `02`
        `B`               `0C`
        `C`               `18`
        `D`               `20`
        `E`               `18`
        `F`               `1A`

La secuencia de entrada observada fue:

``` text
0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9 → A → B → C → D → E → F
```

con cambios cada 10 ns.

### 9. Interpretación de los resultados

Los valores de `catodo_po[6:0]` aparecen en hexadecimal porque GTKWave
utiliza esa representación para el bus.

Por ejemplo:

``` text
40 hexadecimal = 1000000 binario
67 hexadecimal = 1100111 binario
20 hexadecimal = 0100000 binario
```

Por lo tanto, cada valor mostrado corresponde a los siete bits de salida
del decodificador.

La forma de onda permite observar que, cada vez que cambia
`codigo_bin_pi`, el módulo genera el patrón correspondiente en
`catodo_po`.

### 10. Flujo utilizado

La simulación se ejecutó desde:

``` text
src/build
```

mediante:

``` powershell
make test
```

Este comando ejecuta la simulación RTL utilizando el testbench y genera:

``` text
binario_7seg.vcd
```

Para visualizar las ondas se utilizó:

``` powershell
make wv
```

lo cual abre el archivo VCD en GTKWave.

### 11. Conclusión

El testbench permitió verificar mediante simulación RTL el
comportamiento del módulo `binario_7seg` para las 16 combinaciones
posibles de su entrada de cuatro bits.

La simulación se ejecutó correctamente, se generó el archivo VCD y se
visualizaron en GTKWave tanto la entrada `codigo_bin_pi[3:0]` como la
salida `catodo_po[6:0]`.

Los resultados obtenidos permiten comprobar la respuesta del
decodificador para todo el rango de entrada `0`--`F` antes de realizar
la implementación física del módulo en la FPGA.

> **Nota:** Esta sección corresponde a la verificación RTL
> (pre-síntesis). El proyecto también solicita simulaciones posteriores
> con información de temporizado después de síntesis y colocación/ruteo,
> además del análisis de tiempos; esas etapas corresponden a
> verificaciones posteriores del desarrollo.


</details>


<details>
<summary><strong>Módulo: Codificación Hamming (7,4)</strong></summary>

#### 1. Encabezado del módulo

#### 2. Parámetros

#### 3. Entradas y salidas

#### 4. Criterios de diseño

#### 5. Testbench

</details>


<details>
<summary><strong>Módulo: Inserción de paridad para DED</strong></summary>

#### 1. Encabezado del módulo

#### 2. Parámetros

#### 3. Entradas y salidas

#### 4. Criterios de diseño

#### 5. Testbench

</details>


<details>
<summary><strong>Módulo: Generador de error</strong></summary>

#### 1. Encabezado del módulo

#### 2. Parámetros

#### 3. Entradas y salidas

#### 4. Criterios de diseño

#### 5. Testbench

</details>


<details>
<summary><strong>Testbench del transmisor</strong></summary>

</details>

</details>


<details>
<summary><strong>5.2 Subsistema 2 — Receptor</strong></summary>

<details>
<summary><strong>Módulo: Verificación de paridad</strong></summary>

#### 1. Encabezado del módulo

#### 2. Parámetros

#### 3. Entradas y salidas

#### 4. Criterios de diseño

#### 5. Testbench

</details>


<details>
<summary><strong>Módulo: Determinación del síndrome Hamming</strong></summary>

#### 1. Encabezado del módulo

#### 2. Parámetros

#### 3. Entradas y salidas

#### 4. Criterios de diseño

#### 5. Testbench

</details>


<details>
<summary><strong>Módulo: Corrección de error</strong></summary>

#### 1. Encabezado del módulo

#### 2. Parámetros

#### 3. Entradas y salidas

#### 4. Criterios de diseño

#### 5. Testbench

</details>


<details>
<summary><strong>Módulo: Despliegue de la palabra corregida</strong></summary>

#### 1. Encabezado del módulo

#### 2. Parámetros

#### 3. Entradas y salidas

#### 4. Criterios de diseño

#### 5. Testbench

</details>


<details>
<summary><strong>Testbench del receptor</strong></summary>

</details>

</details>


<details>
<summary><strong>5.3 Ejercicio 2 — Oscilador en anillo</strong></summary>

<details>
<summary><strong>Diseño del oscilador</strong></summary>

#### 1. Encabezado

#### 2. Parámetros

#### 3. Conexiones

#### 4. Criterios de diseño

#### 5. Procedimiento

#### 6. Resultados

#### 7. Análisis

</details>


<details>
<summary><strong>Mediciones</strong></summary>

#### 1. Procedimiento de medición

#### 2. Resultados experimentales

#### 3. Cálculos

</details>


<details>
<summary><strong>Análisis de resultados</strong></summary>

</details>


<details>
<summary><strong>Conclusiones</strong></summary>

</details>

</details>

---

## 6. Consumo de recursos

## 7. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc

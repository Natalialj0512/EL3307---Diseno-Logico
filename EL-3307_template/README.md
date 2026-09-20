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

La siguiente tabla presenta la asignación de pines utilizada para las
entradas y salidas externas de la FPGA, así como las conexiones destinadas
a la comunicación entre la FPGA transmisora y la FPGA receptora.

### 4.1 Asignación general de pines

| Señal | Pin Tang Nano 9K | Función / Descripción |
|---|---:|---|
| `codigo_bin_pi[0]` | 30 | Entrada del bit 0 de la palabra de datos mediante DIP switch |
| `codigo_bin_pi[1]` | 29 | Entrada del bit 1 de la palabra de datos mediante DIP switch |
| `codigo_bin_pi[2]` | 28 | Entrada del bit 2 de la palabra de datos mediante DIP switch |
| `codigo_bin_pi[3]` | 27 | Entrada del bit 3 de la palabra de datos mediante DIP switch |
| `error_pos1_pi[0]` | 36 | Bit 0 del switch de selección de posición para la inserción del primer error |
| `error_pos1_pi[1]` | 37 | Bit 1 del switch de selección de posición para la inserción del primer error |
| `error_pos1_pi[2]` | 38 | Bit 2 del switch de selección de posición para la inserción del primer error |
| `error_pos2_pi[0]` | 26 | Bit 0 del switch de selección de posición para la inserción del segundo error |
| `error_pos2_pi[1]` | 25 | Bit 1 del switch de selección de posición para la inserción del segundo error |
| `error_pos2_pi[2]` | 39 | Bit 2 del switch de selección de posición para la inserción del segundo error |
| `c0_pi` | 40 | Entrada proveniente de la compuerta XOR correspondiente al bit de paridad `C0` |
| `c1_pi` | 33 | Entrada proveniente de la compuerta XOR correspondiente al bit de paridad `C1` |
| `c2_pi` | 34 | Entrada proveniente de la compuerta XOR correspondiente al bit de paridad `C2` |
| `p_pi` | 41 | Entrada de la compuerta XOR correspondiente al bit de paridad global `P` para DED |
| `modo_pi` | 69 | Switch de selección del modo de funcionamiento: transmisor o receptor |
| `display_pi` | 48 | Switch de selección de la información mostrada en los displays (palabra recibida o bit de error) |
| `dot_po` | 31 | Salida para el punto decimal del display, utilizada como indicador de doble error (DED) |
| `catodo_po[0]` | 76 | Control del segmento `E` del display de 7 segmentos |
| `catodo_po[1]` | 75 | Control del segmento `D` del display de 7 segmentos |
| `catodo_po[2]` | 72 | Control del segmento `A` del display de 7 segmentos |
| `catodo_po[3]` | 71 | Control del segmento `B` del display de 7 segmentos |
| `catodo_po[4]` | 70 | Control del segmento `C` del display de 7 segmentos |
| `catodo_po[5]` | 74 | Control del segmento `F` del display de 7 segmentos |
| `catodo_po[6]` | 73 | Control del segmento `G` del display de 7 segmentos |
| `dig1_po` | 63 | Control del ánodo del primer display mediante transistor PNP |
| `dig2_po` | 77 | Control del ánodo del segundo display mediante transistor PNP |

### 4.2 Comunicación FPGA ↔ FPGA

La comunicación entre la FPGA transmisora y la FPGA receptora se realiza
mediante un bus bidireccional de 8 bits.

La palabra transmitida se organiza según el orden visto en clase (para que no se pueda introducir un error en la paridad global):

```text
P  i3  i2  i1  C2  i0  C1  C0
```

---

## 5. Desarrollo

<details>
<summary><strong>5.1 Subsistema 1 — Transmisor</strong></summary>

<details>
<summary><strong>Módulo: Lectura y visualización de la palabra</strong></summary>

#### 1. Encabezado del módulo

El módulo `binario_7seg` es parte del transmisor. Su función es recibir una palabra binaria de 4 bits ingresada mediante los dip switches y generar las señales necesarias para visualizar la palabra ingresada en un display de 7 segmentos utilizando notación hexadecimal.

Este subsistema se implementa dentro de la FPGA y permite al usuario confirmar visualmente la palabra ingresada antes de que sea enviada al codificador Hamming (7,4).

##### Código del módulo

```SystemVerilog
module binario_7seg (
    input  wire [3:0] codigo_bin_pi,
    output wire [6:0] catodo_po
);

endmodule
```

#### 2. Parámetros
Este módulo no utiliza parámetros configurables.


#### 3. Entradas y salidas

| Señal | Tipo | Ancho | Función |
|:---|:---:|:---:|:---|
| `codigo_bin_pi` | Entrada | 4 bits | Palabra binaria ingresada por el usuario mediante los dip switches |
| `catodo_po` | Salida | 7 bits | Señales de control de los segmentos del display |

La correspondencia utilizada entre las salidas y los segmentos es:

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


#### 4. Criterios de diseño
El módulo recibe una palabra binaria de 4 bits y genera las señales correspondientes para mostrar su representación hexadecimal en el display de 7 segmentos.

La lógica de control de los segmentos se implementa mediante expresiones booleanas en SystemVerilog.

La visualización permite verificar directamente la palabra introducida mediante los conmutadores antes de continuar con el proceso de codificación Hamming.


#### 5. Testbench
##### 5.1 Objetivo del testbench

El testbench `tb_binario_7seg` se desarrolló para verificar mediante simulación RTL (pre-síntesis) el funcionamiento del módulo `binario_7seg`.

La prueba busca comprobar las 16 combinaciones posibles de la entrada de cuatro bits y observar la respuesta generada en `catodo_po[6:0]`.

Además, el testbench genera un archivo `.vcd` para visualizar las señales mediante GTKWave.

##### 5.2 Estructura del testbench

Los archivos utilizados son:

```text
src/
├── design/
│   └── binario_7seg.sv
└── sim/
    └── tb_binario_7seg.sv
```

El testbench contiene:

1. La señal de entrada controlada por el testbench.
2. La señal de salida observada.
3. La instancia del módulo bajo prueba (DUT).
4. La generación del archivo VCD.
5. Un bloque `initial` que aplica las diferentes entradas.
6. La finalización de la simulación mediante `$finish`.

##### 5.3 Señales del testbench

La entrada se declara como:

```SystemVerilog
reg [3:0] codigo_bin_pi;
```

Se utiliza `reg` porque el testbench asigna diferentes valores a esta señal durante la simulación.

La salida se declara como:

```SystemVerilog
wire [6:0] catodo_po;
```

Se utiliza `wire` porque la señal es generada por el módulo bajo prueba y el testbench solamente la observa.

La relación entre ambos elementos es:

```text
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

##### 5.4 Instancia del DUT

El módulo se instancia dentro del testbench mediante:

```SystemVerilog
binario_7seg DUT (
    .codigo_bin_pi(codigo_bin_pi),
    .catodo_po(catodo_po)
);
```

##### 5.5 Generación del archivo VCD

Para almacenar las señales de la simulación y posteriormente observarlas en GTKWave se utilizan:

```SystemVerilog
$dumpfile("binario_7seg.vcd");
$dumpvars(0, tb_binario_7seg);
```

##### 5.6 Aplicación de las entradas

El testbench prueba las 16 combinaciones posibles de la entrada de 4 bits.

Cada combinación se mantiene durante 10 ns antes de aplicar la siguiente. Por lo tanto, la simulación completa tiene una duración aproximada de 160 ns.

Las entradas corresponden a los valores hexadecimales:

```text
0, 1, 2, 3, 4, 5, 6, 7,
8, 9, A, B, C, D, E, F
```

##### 5.7 Resultados de la simulación RTL

Los valores observados durante la simulación fueron:

| Entrada | `catodo_po` |
|:---:|:---:|
| 0 | `40` |
| 1 | `67` |
| 2 | `20` |
| 3 | `21` |
| 4 | `07` |
| 5 | `09` |
| 6 | `08` |
| 7 | `63` |
| 8 | `00` |
| 9 | `01` |
| A | `02` |
| B | `0C` |
| C | `18` |
| D | `20` |
| E | `18` |
| F | `1A` |

Estos valores corresponden a las señales de control de los siete segmentos según el mapeo definido para el display de ánodo común.

##### 5.8 Flujo de simulación

La simulación se ejecutó utilizando las herramientas del entorno de desarrollo del proyecto.

Desde la carpeta correspondiente a la simulación se utilizaron los comandos:

```text
make test
```

para ejecutar el testbench, y:

```text
make wv
```

para visualizar las señales generadas mediante GTKWave.

El archivo VCD generado permite observar la variación de `codigo_bin_pi` y la respuesta correspondiente de `catodo_po`.

##### 5.9 Resultado del testbench

La simulación RTL permitió comprobar el comportamiento del módulo para las 16 combinaciones posibles de la palabra de entrada.

Las señales observadas en GTKWave mostraron la relación esperada entre la entrada `codigo_bin_pi[3:0]` y la salida `catodo_po[6:0]`.

Por lo tanto, el testbench permitió verificar funcionalmente el módulo `binario_7seg` antes de continuar con las siguientes etapas del transmisor.

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
El módulo `generador_error` es parte del transmisor y tiene como función introducir uno o dos errores en la palabra codificada mediante Hamming (7,4).

La posición de cada error se selecciona mediante dos entradas de 3 bits. Cada entrada permite seleccionar una de las siete posiciones correspondientes a los bits del código Hamming. El valor `000` indica que no se introduce error.

El bit de paridad global `P` no se modifica, ya que corresponde a la paridad utilizada para la detección de doble error (DED).

```SystemVerilog
module generador_error (
    input wire [7:0] palabra_codificada_pi,
    input wire [2:0] error_pos1_pi,
    input wire [2:0] error_pos2_pi,
    output wire [7:0] palabra_error_po
);
```

#### 2. Parámetros
Este módulo no utiliza parámetros configurables.


#### 3. Entradas y salidas
| Señal | Tipo | Ancho | Función |
|:---|:---:|:---:|:---|
| `palabra_codificada_pi` | Entrada | 8 bits | Palabra codificada mediante Hamming (7,4) con el bit de paridad global |
| `error_pos1_pi` | Entrada | 3 bits | Selecciona la posición del primer error |
| `error_pos2_pi` | Entrada | 3 bits | Selecciona la posición del segundo error |
| `palabra_error_po` | Salida | 8 bits | Palabra codificada con los errores seleccionados |

Las posiciones seleccionables mediante `error_pos1_pi` y `error_pos2_pi` son:

| Entrada | Posición |
|:---:|:---:|
| `000` | Sin error |
| `001` | Posición 1 |
| `010` | Posición 2 |
| `011` | Posición 3 |
| `100` | Posición 4 |
| `101` | Posición 5 |
| `110` | Posición 6 |
| `111` | Posición 7 |

Las posiciones 1 a 7 corresponden exclusivamente a los siete bits del código Hamming. El bit `P`, correspondiente al bit de paridad global, permanece sin modificaciones.


#### 4. Criterios de diseño
El módulo utiliza dos entradas de 3 bits para seleccionar independientemente las posiciones donde se introducirán los errores.

Cada entrada se decodifica mediante expresiones booleanas para generar una señal asociada a cada una de las siete posiciones posibles.

La inserción del error se realiza mediante operaciones XOR. Cuando la señal de error correspondiente es `0`, el bit original se conserva; cuando es `1`, el bit se invierte.

La palabra de salida mantiene el mismo orden de bits de la palabra de entrada. Los siete bits correspondientes al código Hamming pueden ser modificados, mientras que el bit de paridad global `P` se conserva directamente:

```text
palabra_error_po[7] = palabra_codificada_pi[7]
```

De esta manera, el generador permite introducir hasta dos errores en las posiciones seleccionadas del código Hamming sin modificar la paridad global.


#### 5. Testbench
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

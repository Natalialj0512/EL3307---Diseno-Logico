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

El objetivo de este ejercicio es caracterizar experimentalmente los parámetros
de temporización de las compuertas lógicas, principalmente el tiempo de retardo
de propagación $t_{PD}$ y los tiempos de subida y caída de la señal,
$t_{rise}$ y $t_{fall}$.

Para esto se construyó un oscilador en anillo utilizando inversores de un
74HC04. El período de oscilación permite relacionar la frecuencia del anillo
con el tiempo de propagación promedio de cada inversor.

El procedimiento experimental se dividió en cuatro configuraciones:

1. Oscilador con cinco inversores.
2. Oscilador con tres inversores.
3. Oscilador con tres inversores y aproximadamente 1 m de cable.
4. Un solo inversor con entrada y salida conectadas.

---

<details>
<summary><strong>5.3.1 Oscilador con cinco inversores</strong></summary>

### Montaje

Se construyó un oscilador en anillo utilizando cinco inversores del 74HC04.
Las cinco compuertas fueron conectadas en cascada y la salida del último
inversor se realimentó hacia la entrada del primero.

Para esta configuración:

```text
N = 5 inversores
```

La señal se observó mediante el osciloscopio, utilizando dos canales para
observar simultáneamente la entrada y salida de una de las etapas.

### Forma de onda experimental

![Oscilador de anillo con cinco inversores](doc/images/DS0001A1.PNG)

### Resultados experimentales

A partir de la medición guardada directamente desde el osciloscopio se
obtuvieron los siguientes valores:

| Parámetro | Resultado |
|---|---:|
| Frecuencia | 2.666 MHz |
| Período | 375.1 ns |
| Vmax | 5.12 V |
| Vpp | 5.12 V |
| trise | 100.8 ns |
| tfall | 100.8 ns |

### Cálculo del período

El período se obtiene a partir de la frecuencia medida:

```math
T = \frac{1}{f}
```

Sustituyendo la frecuencia experimental:

```math
T = \frac{1}{2.666 \times 10^6}
```

Por lo tanto:

```math
\boxed{T \approx 375.1\ \text{ns}}
```

### Cálculo del tiempo de propagación

Para un oscilador en anillo compuesto por N inversores, el período está
relacionado con el tiempo de propagación promedio mediante:

```math
T = 2Nt_{PD}
```

Despejando el tiempo de propagación:

```math
t_{PD} = \frac{T}{2N}
```

Para cinco inversores:

```math
t_{PD} = \frac{375.1\ \text{ns}}{2(5)}
```

Por lo tanto:

```math
\boxed{t_{PD} \approx 37.5\ \text{ns}}
```

### Análisis

La configuración de cinco inversores produjo una señal periódica estable,
con una frecuencia aproximada de 2.666 MHz y un período de 375.1 ns.

A partir de estos valores se obtuvo un tiempo de propagación promedio de
aproximadamente 37.5 ns por inversor.

Los tiempos de subida y caída obtenidos fueron prácticamente iguales:

```math
t_{rise} \approx 100.8\ \text{ns}
```

```math
t_{fall} \approx 100.8\ \text{ns}
```

Por lo tanto, para esta configuración no se observó una diferencia apreciable
entre el tiempo necesario para la transición de subida y el tiempo necesario
para la transición de caída.

El valor de tPD obtenido en esta etapa se utilizará posteriormente para
estimar el período teórico del oscilador cuando se reduzca el número de
inversores a tres.

</details>


<details>
<summary><strong>5.3.2 Oscilador con tres inversores</strong></summary>

### Montaje

Se modificó el circuito anterior para utilizar únicamente tres inversores,
manteniendo la realimentación necesaria para formar el oscilador en anillo.

Para esta configuración:

```text
N = 3 inversores
```

### Forma de onda experimental

![Oscilador de anillo con tres inversores](doc/images/DS0001A2.PNG)

### Resultados experimentales

| Parámetro | Resultado |
|---|---:|
| Frecuencia | 2.648 MHz |
| Período medido | 377.6 ns |
| trise | 105.8 ns |
| tfall | 98.8 ns |
| Vmax | ≈ 4.8 V |

### Cálculo del período esperado

Para calcular el período esperado con tres inversores se utiliza el tiempo
de propagación obtenido anteriormente:

```math
t_{PD} \approx 37.5\ \text{ns}
```

La relación para el oscilador en anillo es:

```math
T = 2Nt_{PD}
```

Para tres inversores:

```math
T_{teórico} = 2(3)(37.5\ \text{ns})
```

Por lo tanto:

```math
\boxed{T_{teórico} \approx 225.0\ \text{ns}}
```

La frecuencia teórica correspondiente es:

```math
f_{teórico} = \frac{1}{T_{teórico}}
```

```math
f_{teórico} = \frac{1}{225.0 \times 10^{-9}}
```

Por lo tanto:

```math
\boxed{f_{teórico} \approx 4.44\ \text{MHz}}
```

### Cálculo del período experimental

La frecuencia medida experimentalmente fue:

```math
f_{medido} = 2.648\ \text{MHz}
```

Por lo tanto:

```math
T_{medido} = \frac{1}{2.648 \times 10^6}
```

```math
\boxed{T_{medido} \approx 377.6\ \text{ns}}
```

### Comparación entre el resultado teórico y experimental

| Magnitud | Teórico | Experimental |
|---|---:|---:|
| Período | 225.0 ns | 377.6 ns |
| Frecuencia | 4.44 MHz | 2.648 MHz |

La diferencia porcentual entre los períodos es:

```math
\%\text{ diferencia} =
\frac{T_{medido}-T_{teórico}}{T_{teórico}}\times100
```

```math
\%\text{ diferencia} =
\frac{377.6-225.0}{225.0}\times100
```

```math
\boxed{\%\text{ diferencia}\approx67.8\%}
```

### Análisis

Al reducir el número de inversores de cinco a tres, el modelo ideal predice
una reducción del período de oscilación, ya que:

```math
T = 2Nt_{PD}
```

indica una dependencia directa entre el período y el número de etapas del
anillo.

Sin embargo, el resultado experimental no coincidió con esta predicción.

El modelo produjo un período esperado de aproximadamente 225.0 ns, mientras
que el osciloscopio registró aproximadamente 377.6 ns.

Por lo tanto, no se obtuvo experimentalmente el período esperado.

La diferencia puede estar relacionada con las condiciones reales del montaje.
El cálculo supone que el tiempo de propagación promedio obtenido para cinco
inversores puede utilizarse directamente como un valor constante para la
configuración de tres inversores.

En el circuito real existen además efectos asociados al alambrado, las
conexiones de la protoboard, la carga de las sondas del osciloscopio y las
condiciones eléctricas de las diferentes etapas.

Por esta razón, el resultado obtenido debe interpretarse como una diferencia
entre el comportamiento ideal utilizado para el cálculo y el comportamiento
real observado experimentalmente.

</details>


<details>
<summary><strong>5.3.3 Tres inversores con aproximadamente 1 m de cable</strong></summary>

### Montaje

A partir del oscilador de tres inversores se incorporó aproximadamente un
metro de cable en la trayectoria de realimentación del anillo.

La conexión de realimentación se realizó entre el pin 6 y el pin 1 del
74HC04 mediante el tramo adicional de cable.

La finalidad de esta modificación fue observar experimentalmente cómo una
mayor longitud de interconexión afecta las características temporales de
la señal.

### Forma de onda experimental

![Oscilador de anillo con tres inversores y 1 m de cable](doc/images/DS0001A3.PNG)

### Resultados experimentales

| Parámetro | Sin cable | Con 1 m de cable |
|---|---:|---:|
| Frecuencia | 2.648 MHz | 2.778 MHz |
| Período | 377.6 ns | 360.0 ns |
| trise | 105.8 ns | 78 ns |
| tfall | 98.8 ns | 75 ns |
| Vmax | ≈ 4.8 V | ≈ 4.96 V |

### Cálculo del período con el cable

La frecuencia medida con el cable fue:

```math
f_{cable} = 2.778\ \text{MHz}
```

Por lo tanto:

```math
T_{cable} = \frac{1}{2.778 \times 10^6}
```

```math
\boxed{T_{cable} \approx 360.0\ \text{ns}}
```

### Cambio en la frecuencia

El cambio porcentual de la frecuencia se calculó mediante:

```math
\%\Delta f =
\frac{f_{cable}-f_{sin\ cable}}{f_{sin\ cable}}\times100
```

```math
\%\Delta f =
\frac{2.778-2.648}{2.648}\times100
```

```math
\boxed{\%\Delta f \approx +4.9\%}
```

Por lo tanto, experimentalmente la frecuencia aumentó aproximadamente un
4.9 %.

### Cambio en el período

El cambio porcentual del período fue:

```math
\%\Delta T =
\frac{T_{cable}-T_{sin\ cable}}{T_{sin\ cable}}\times100
```

```math
\%\Delta T =
\frac{360.0-377.6}{377.6}\times100
```

```math
\boxed{\%\Delta T \approx -4.7\%}
```

Por lo tanto, el período disminuyó aproximadamente un 4.7 %.

### Análisis

La incorporación del metro adicional de cable produjo una modificación
observable en la señal.

Experimentalmente se observó:

- Un aumento de la frecuencia de 2.648 MHz a 2.778 MHz.
- Una disminución del período de 377.6 ns a 360.0 ns.
- Una disminución de trise de 105.8 ns a 78 ns.
- Una disminución de tfall de 98.8 ns a 75 ns.

Por lo tanto, el resultado experimental no mostró un aumento del período al
agregar el cable. Bajo las condiciones particulares de este montaje, el
período disminuyó.

La longitud adicional del conductor modifica las condiciones eléctricas de
la trayectoria de realimentación y puede introducir efectos parásitos
asociados al conductor y a sus conexiones. Estos efectos pueden modificar
la forma de onda y la temporización observada.

Sin embargo, a partir de esta medición no se puede atribuir el cambio a un
único efecto físico de manera aislada, ya que también intervienen las
condiciones de la protoboard, las conexiones, la ubicación de las sondas y
las características del circuito.

Por lo tanto, el resultado experimental permite concluir que la longitud
adicional del alambrado sí produjo un cambio medible en la señal, aunque el
sentido y magnitud del cambio corresponden específicamente a las condiciones
del montaje realizado.

</details>


<details>
<summary><strong>5.3.4 Un solo inversor con entrada y salida conectadas</strong></summary>

### Montaje

Finalmente se utilizó un solo inversor del 74HC04, conectando directamente
su salida con su entrada.

De esta manera, la entrada y la salida del inversor quedan conectadas al
mismo nodo.

```text
          ┌───────────┐
          │           │
          │    NOT    │
          │           │
          └───────────┘
             ↑     │
             └─────┘
```

El instructivo indica que la tensión debería ser estable. En caso de que no
lo fuera, se recomienda conectar un capacitor de 0.01 µF entre este nodo y
tierra para estabilizarlo.

### Forma de onda experimental

![Un inversor con entrada y salida conectadas](doc/images/DS0001A4.PNG)

### Resultados experimentales

La señal observada fue esencialmente estable y se encontró alrededor de una
tensión intermedia.

De la medición se obtuvieron aproximadamente:

```math
V_{max} \approx 2.68\ \text{V}
```

```math
V_{min} \approx 2.50\ \text{V}
```

La excursión de la señal es:

```math
V_{pp} = V_{max}-V_{min}
```

```math
V_{pp} \approx 2.68-2.50
```

```math
\boxed{V_{pp}\approx0.18\ \text{V}}
```

El valor medio aproximado del nodo es:

```math
V_{nodo} \approx
\frac{V_{max}+V_{min}}{2}
```

```math
V_{nodo} \approx
\frac{2.68+2.50}{2}
```

```math
\boxed{V_{nodo}\approx2.59\ \text{V}}
```

Por lo tanto, se puede considerar experimentalmente:

```math
\boxed{V_{nodo}\approx2.6\ \text{V}}
```

### Análisis

A diferencia de las configuraciones anteriores, el circuito con un solo
inversor realimentado no presentó una oscilación periódica.

La entrada y la salida se encuentran conectadas al mismo nodo, por lo que el
inversor intenta establecer en su salida el complemento de la misma tensión
que recibe como entrada.

Como consecuencia, el circuito se establece alrededor de una tensión
intermedia en lugar de permanecer en uno de los niveles lógicos extremos.

Experimentalmente se obtuvo:

```math
V_{nodo}\approx2.6\ \text{V}
```

Este valor representa el punto de operación del inversor bajo esta condición
de realimentación.

La medición también muestra una pequeña variación alrededor de este valor,
con una excursión aproximada de:

```math
V_{pp}\approx0.18\ \text{V}
```

El instructivo establece que, si la tensión no fuera estable, se debe agregar
un capacitor de 0.01 µF entre el nodo y tierra. En la medición realizada la
señal fue suficientemente estable para realizar la medición.

</details>


<details>
<summary><strong>5.3.5 Resumen de resultados</strong></summary>

Los principales resultados obtenidos durante las cuatro configuraciones se
resumen en la siguiente tabla:

| Configuración | Frecuencia | Período | trise | tfall |
|---|---:|---:|---:|---:|
| 5 inversores | 2.666 MHz | 375.1 ns | 100.8 ns | 100.8 ns |
| 3 inversores | 2.648 MHz | 377.6 ns | 105.8 ns | 98.8 ns |
| 3 inversores + 1 m | 2.778 MHz | 360.0 ns | 78 ns | 75 ns |

El tiempo de propagación promedio obtenido a partir del oscilador de cinco
inversores fue:

```math
\boxed{t_{PD}\approx37.5\ \text{ns}}
```

Utilizando este valor, el período esperado para tres inversores fue:

```math
\boxed{T_{teórico}\approx225.0\ \text{ns}}
```

Sin embargo, el período medido experimentalmente fue:

```math
\boxed{T_{medido}\approx377.6\ \text{ns}}
```

Por lo tanto, el modelo ideal y el resultado experimental presentaron una
diferencia considerable.

Al introducir aproximadamente un metro de cable en el anillo de tres
inversores, la frecuencia aumentó aproximadamente un 4.9 %, mientras que el
período disminuyó aproximadamente un 4.7 %.

Finalmente, la configuración de un único inversor con entrada y salida
conectadas produjo una tensión estable de aproximadamente:

```math
\boxed{V_{nodo}\approx2.6\ \text{V}}
```

</details>


<details>
<summary><strong>5.3.6 Conclusiones</strong></summary>

- Para el anillo de cinco inversores se obtuvo una frecuencia de
  aproximadamente 2.666 MHz y un período de 375.1 ns.

- A partir del período del oscilador de cinco inversores se obtuvo un tiempo
  de propagación promedio de aproximadamente 37.5 ns.

- Al utilizar tres inversores, el período teórico calculado a partir del
  tiempo de propagación anterior fue de aproximadamente 225.0 ns, pero
  experimentalmente se obtuvo un período de aproximadamente 377.6 ns.
  Por lo tanto, el resultado experimental no coincidió con el modelo ideal.

- La incorporación de aproximadamente un metro de cable en la trayectoria
  de realimentación modificó las características temporales de la señal.
  En las condiciones del experimento, la frecuencia aumentó y el período
  disminuyó.

- La configuración de un solo inversor con entrada y salida conectadas
  produjo un punto de operación estable cercano a 2.6 V.

- En conjunto, las mediciones permitieron observar experimentalmente la
  influencia de las características reales del circuito y de sus
  interconexiones sobre los parámetros de temporización de las compuertas
  lógicas.

</details>

</details>

---

## 6. Consumo de recursos

## 7. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc

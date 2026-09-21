module top (
    // SWITCHES DE CONTROL

    // 0 = transmisor
    // 1 = receptor
    input wire modo_pi,

    // 0 = palabra recibida
    // 1 = posición del error / síndrome
    input wire display_pi,


    // ========================================================
    // ENTRADAS DEL TRANSMISOR
    // ========================================================

    // Palabra de datos de 4 bits del transmisor
    input wire [3:0] codigo_bin_pi,

    // Posiciones de error de los dos switches
    input wire [2:0] error_pos1_pi,
    input wire [2:0] error_pos2_pi,

    // Bits generados por las compuertas XOR externas de C0, C1, C2, y P
    input wire c0_pi,
    input wire c1_pi,
    input wire c2_pi,
    input wire p_pi,


    // ========================================================
    // BITS ENTRE FPGA PARA CONECTAR ENTRE TRANSMISOR Y RECEPTOR p, i3, i2, i1, c2, i0, c1, c0

    inout wire [7:0] datos_io,


    // ========================================================
    // DISPLAY DE 7 SEGMENTOS
    // ========================================================

    output wire [6:0] catodo_po, // Segmentos
    output wire dig1_po, // Transistor 1 para dígito 1
    output wire dig2_po, // Transistor 2 para dígito 2


    // ========================================================
    // DOT POINT DE DOBLE ERROR
    // ========================================================

    output wire dot_po // para activar el dop point
);


    // ========================================================
    // TRANSMISOR
    // ========================================================

    // Palabra Hamming + paridad global
    // [7] [6] [5] [4] [3] [2] [1] [0]
    //  P   i3  i2  i1  C2  i0  C1  C0

    wire [7:0] palabra_codificada;

    // Palabra después de insertar los errores
    wire [7:0] palabra_error;


    assign palabra_codificada[7] = p_pi;
    assign palabra_codificada[6] = codigo_bin_pi[3];
    assign palabra_codificada[5] = codigo_bin_pi[2];
    assign palabra_codificada[4] = codigo_bin_pi[1];
    assign palabra_codificada[3] = c2_pi;
    assign palabra_codificada[2] = codigo_bin_pi[0];
    assign palabra_codificada[1] = c1_pi;
    assign palabra_codificada[0] = c0_pi;


    // --------------------------------------------------------
    // Generador de error
    // --------------------------------------------------------

    generador_error u_generador_error (
        .palabra_codificada_pi(palabra_codificada), // puerto del módulo con la señal del top
        .error_pos1_pi(error_pos1_pi),
        .error_pos2_pi(error_pos2_pi),
        .palabra_error_po(palabra_error)
    );


    // --------------------------------------------------------
    // TX -> FPGA coloca la palabra en los 8 pines
    // RX -> FPGA deja los pines en alta impedancia para recibir
    // --------------------------------------------------------

    assign datos_io = (modo_pi == 1'b0) ?
                      palabra_error :
                      8'bz;


    // ========================================================
    // DISPLAY DEL TRANSMISOR
    // ========================================================

    wire [6:0] catodo_tx;

    binario_7seg u_binario_7seg (
        .codigo_bin_pi(codigo_bin_pi),
        .catodo_po(catodo_tx)
    );


    // ========================================================
    // RECEPTOR
    // ========================================================

    // Palabra Hamming recibida
    // [6:0] = C0 C1 i0 C2 i1 i2 i3
    // El bit 7 es la paridad global.

    wire [6:0] palabra_rx;
    wire       paridad_mal;
    wire [2:0] sindrome;

    // Palabra de información recibida SIN corregir
    wire [3:0] palabra_recibida;

    // Palabra corregida por el módulo de corrección
    wire [3:0] datos_corregidos;

    // Indicador de doble error
    wire DED;


    // --------------------------------------------------------
    // Separación de los datos recibidos
    // --------------------------------------------------------

    assign palabra_rx = datos_io[6:0];


    // Palabra recibida directamente de los pines del otro grupo
    // Esta es la que se muestra cuando display_pi = 0.
    // No se corrige antes de mostrarla

    assign palabra_recibida[3] = datos_io[6]; // i3
    assign palabra_recibida[2] = datos_io[5]; // i2
    assign palabra_recibida[1] = datos_io[4]; // i1
    assign palabra_recibida[0] = datos_io[2]; // i0


    // --------------------------------------------------------
    // Verificador de paridad
    // --------------------------------------------------------

    verificador_paridad u_verificador_paridad (
        .palabra_pi(datos_io),
        .error_paridad_po(paridad_mal)
    );


    // --------------------------------------------------------
    // Determinación del síndrome
    // --------------------------------------------------------

    sindrome_hamming u_sindrome_hamming (
        .palabra_pi(palabra_rx),
        .sindrome_po(sindrome)
    );


    // --------------------------------------------------------
    // Corrección de error
    // --------------------------------------------------------

    correccion_error u_correccion_error (
        .palabra_rx(palabra_rx),
        .paridad_mal(paridad_mal),
        .sindrome(sindrome),
        .datos_corregidos(datos_corregidos),
        .DED(DED)
    );


    // ========================================================
    // DESPLIEGUE DEL RECEPTOR
    // ========================================================

    wire [3:0] codigo_bin_led_rx;
    wire [6:0] catodo_rx;
    wire [1:0] anodo_rx;


    despliegue_receptor u_despliegue_receptor (
        // Palabra recibida directamente de los pines
        .palabra_pi(palabra_recibida),

        // Síndrome calculado
        .sindrome_pi(sindrome),

        // Indicador de doble error
        .doble_error_pi(DED),

        // 0 = palabra
        // 1 = síndrome
        .display_pi(display_pi),

        // LEDs de palabra
        .codigo_bin_led_po(codigo_bin_led_rx),

        // Segmentos
        .catodo_po(catodo_rx),

        // Selección de display
        .anodo_po(anodo_rx)
    );


    // ========================================================
    // SELECCIÓN TX / RX
    // ========================================================

    // --------------------------------------------------------
    // Segmentos
    // TX -> binario_7seg
    // RX -> despliegue_receptor
    // --------------------------------------------------------

    assign catodo_po = (modo_pi == 1'b0) ?
                       catodo_tx :
                       catodo_rx;


    // --------------------------------------------------------
    // Selección de display
    //
    // TX:
    //   dig1 encendido
    //   dig2 apagado
    //
    // RX:
    //   lo controla display_pi
    // --------------------------------------------------------

    assign dig1_po = (modo_pi == 1'b0) ?
                     1'b0 :
                     anodo_rx[0];

    assign dig2_po = (modo_pi == 1'b0) ?
                     1'b1 :
                     anodo_rx[1];


// ========================================================
// DOT POINT - INDICADOR DE DOBLE ERROR
//
// Display de ánodo común:
// 0 = encendido
// 1 = apagado
//
// DED = 1 -> dot point encendido
// DED = 0 -> dot point apagado
// ========================================================

assign dot_po = (modo_pi == 1'b1) ?
                ~DED :
                1'b1;


endmodule
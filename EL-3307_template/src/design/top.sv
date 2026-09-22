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
    //Señal binaria receptor - display

    // TODO Solo descomentar para hacer simulación: 
    output wire [3:0] palabra_pi_d,
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

    wire [7:0] palabra_codificada; // Palabra de 8 bits codificada con Hamming + paridad global

    // Palabra después de insertar los errores
    wire [7:0] palabra_error; // Palabra de 8 bits codificada con Hamming + paridad global + errores

    //Se asignan los bits de la palabra codificada con Hamming + paridad global
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

    generador_error u_generador_error ( // Instancia del módulo generador_error
        .palabra_codificada_pi(palabra_codificada), // Palabra codificada con Hamming + paridad global que viaja a la otra FPGA
        .error_pos1_pi(error_pos1_pi), // Posición de error del primer switch
        .error_pos2_pi(error_pos2_pi), // Posición de error del segundo switch
        .palabra_error_po(palabra_error) // Palabra codificada con Hamming + paridad global + errores
    );


    // --------------------------------------------------------
    // TX -> FPGA coloca la palabra en los 8 pines
    // RX -> FPGA deja los pines en alta impedancia para recibir
    // --------------------------------------------------------

    assign datos_io = (modo_pi == 1'b0) ? // Si modo_pi = 0, se está transmitiendo
                      palabra_error : // Se coloca la palabra con errores en los pines
                      8'bz; // Si modo_pi = 1, se está recibiendo, por lo que los pines se dejan en alta impedancia


    // ========================================================
    // DISPLAY DEL TRANSMISOR
    // ========================================================

    wire [6:0] catodo_tx; // Segmentos del display del transmisor

    binario_7seg u_binario_7seg ( // Instancia del módulo binario_7seg
        .codigo_bin_pi(codigo_bin_pi), // Palabra de 4 bits del transmisor
        .catodo_po(catodo_tx) // Segmentos del display del transmisor
    );


    // ========================================================
    // RECEPTOR
    // ========================================================

    // Palabra Hamming recibida
    // [6:0] = C0 C1 i0 C2 i1 i2 i3
    // El bit 7 es la paridad global.

    wire [6:0] palabra_rx; // Palabra de 7 bits recibida por los pines de la FPGA, sin la paridad global
    wire       paridad_mal; // Indica si la paridad global es incorrecta, viene del módulo de verificador_paridad
    wire [2:0] sindrome; // Síndrome de Hamming que indica la posición del error (si hay uno), viene del módulo de sindrome_hamming

    // Palabra de información recibida SIN corregir
    wire [3:0] palabra_recibida; // Palabra de 4 bits recibida directamente de los pines, sin corregir

    // Palabra corregida por el módulo de corrección
    wire [3:0] datos_corregidos; // Palabra de 4 bits corregida por el módulo de corrección

    // Indicador de doble error
    wire DED;


    // --------------------------------------------------------
    // Separación de los datos recibidos
    // --------------------------------------------------------

    assign palabra_rx = datos_io[6:0]; // Palabra de 7 bits recibida por los pines de la FPGA, sin la paridad global


    // Palabra recibida directamente de los pines del otro grupo
    // Esta es la que se muestra cuando display_pi = 0.
    // EN ESTA VERSION YA NO SE USA, SE USA LA PALABRA CORREGIDA PARA MOSTRAR EN LOS LEDS Y DISPLAY, se me olvido borra esta parte, pero la dejo por si acaso
    assign palabra_recibida[3] = datos_io[6]; // i3
    assign palabra_recibida[2] = datos_io[5]; // i2
    assign palabra_recibida[1] = datos_io[4]; // i1
    assign palabra_recibida[0] = datos_io[2]; // i0


    // --------------------------------------------------------
    // Verificador de paridad
    // --------------------------------------------------------

    verificador_paridad u_verificador_paridad ( // Instancia del módulo verificador_paridad
        .palabra_pi(datos_io), // Palabra de 8 bits recibida por los pines de la FPGA, incluyendo la paridad global
        .error_paridad_po(paridad_mal) // Indica si la paridad global es incorrecta o no
    );


    // --------------------------------------------------------
    // Determinación del síndrome
    // --------------------------------------------------------

    sindrome_hamming u_sindrome_hamming ( // Instancia del módulo sindrome_hamming
        .palabra_pi(palabra_rx), // Palabra de 7 bits recibida por los pines de la FPGA, sin la paridad global
        .sindrome_po(sindrome) // Síndrome de Hamming que indica la posición del error (si hay uno)
    );


    // --------------------------------------------------------
    // Corrección de error
    // --------------------------------------------------------

    correccion_error u_correccion_error ( // Instancia del módulo correccion_error
        .palabra_rx(palabra_rx), // Palabra de 7 bits recibida por los pines de la FPGA, sin la paridad global
        .paridad_mal(paridad_mal), // Indica si la paridad global es incorrecta, viene del módulo de verificador_paridad
        .sindrome(sindrome), // Síndrome de Hamming que indica la posición del error (si hay uno), viene del módulo de sindrome_hamming
        .datos_corregidos(datos_corregidos), // Palabra de 4 bits corregida por el módulo de corrección
        .DED(DED) // Indicador de doble error
    );


    // ========================================================
    // DESPLIEGUE DEL RECEPTOR
    // ========================================================

    wire [3:0] codigo_bin_led_rx; // LEDs de la palabra corregida
    wire [6:0] catodo_rx; // Segmentos del display del receptor
    wire [1:0] anodo_rx; // Selección de display del receptor, si el digito 1 o el digito 2 está encendido


    despliegue_receptor u_despliegue_receptor ( // Instancia del módulo despliegue_receptor
        // Palabra con los 4 bits de información corregidos
        .palabra_pi(datos_corregidos), 

        // Síndrome calculado
        .sindrome_pi(sindrome), // Posición del error que se muestra cuando display_pi = 1

        // Indicador de doble error
        .doble_error_pi(DED), // Si hay doble error, se muestra E en el display con el dot point encendido

        // 0 = palabra
        // 1 = síndrome
        .display_pi(display_pi),

        // LEDs de palabra
        .codigo_bin_led_po(codigo_bin_led_rx), // Se muestran los 4 bits de la palabra corregida

        // Segmentos
        .catodo_po(catodo_rx), // Dice que segmentos se encienden para mostrar la palabra o el síndrome

        // Selección de display
        .anodo_po(anodo_rx) // Dice que display se enciende para mostrar la palabra o el síndrome
    );

     assign palabra_pi_d = datos_corregidos; //PARA LA SIMULACIÓN


    // ========================================================
    // SELECCIÓN TX / RX
    // ========================================================

    // --------------------------------------------------------
    // Segmentos
    // TX -> binario_7seg
    // RX -> despliegue_receptor
    // --------------------------------------------------------

    assign catodo_po = (modo_pi == 1'b0) ? // Si modo_pi = 0, se está transmitiendo
                       catodo_tx : // Se muestran los segmentos del display del transmisor, o sea, la palabra de 4 bits del transmisor de los dip switches
                       catodo_rx; // Si modo_pi = 1, se está recibiendo, por lo que se muestran los segmentos del display del receptor, o sea, la palabra de 4 bits corregida o el síndrome


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

    assign dig1_po = (modo_pi == 1'b0) ? // Si modo_pi = 0, se está transmitiendo
                     1'b0 : // Se enciende el display 1 del transmisor
                     anodo_rx[0]; // Si modo_pi = 1, se está recibiendo, por lo que se enciende el display 0 del receptor si display_pi = 0, o el display 1 del receptor si display_pi = 1

    assign dig2_po = (modo_pi == 1'b0) ? // Si modo_pi = 0, se está transmitiendo
                     1'b1 : // Se apaga el display 2 del transmisor
                     anodo_rx[1]; // Si modo_pi = 1, se está recibiendo, por lo que se enciende el display 1 del receptor si display_pi = 1, o el display 0 del receptor si display_pi = 0


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

assign dot_po = (modo_pi == 1'b1) ? // Si modo_pi = 1, se está recibiendo
                ~DED : // Se enciende el dot point si hay doble error
                1'b1; // Si modo_pi = 0, se está transmitiendo, por lo que se apaga el dot point


endmodule
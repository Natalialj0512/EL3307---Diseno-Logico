module despliegue_receptor (

    input  wire [3:0] palabra_pi,        // Palabra recibida
    input  wire [2:0] sindrome_pi,       // Síndrome / posición del error
    input  wire       doble_error_pi,    // 1 = doble error (DED)
    input  wire       display_pi,        // 0 = palabra, 1 = síndrome

    output wire [3:0] codigo_bin_led_po, // LEDs de la palabra
    output wire [6:0] catodo_po,         // Segmentos
    output wire [1:0] anodo_po           // Selección de display

);

    // ========================================================
    // DATO A MOSTRAR
    //
    // display_pi = 0 -> palabra recibida
    // display_pi = 1 -> síndrome
    //
    // Si hay doble error -> 1110 = E
    // ========================================================

    wire [3:0] dato_mostrar;


    // --------------------------------------------------------
    // Bit 0
    // --------------------------------------------------------

    assign dato_mostrar[0] =
        ~doble_error_pi & //solo se hace esto si no hay doble error
        (
            (~display_pi & palabra_pi[0]) | // Si no hay doble error y display = 0, se muestra la palabra
            ( display_pi & sindrome_pi[0]) // Si no hay doble error y display = 1, se muestra el síndrome
        );


    // --------------------------------------------------------
    // Bit 1
    // --------------------------------------------------------

    assign dato_mostrar[1] =
        doble_error_pi | // Si hay doble error, se pone en 1
        (
            ~doble_error_pi & //solo se hace esto si no hay doble error
            (
                (~display_pi & palabra_pi[1]) | // Si no hay doble error y display = 0, se muestra la palabra
                ( display_pi & sindrome_pi[1]) // Si no hay doble error y display = 1, se muestra el síndrome
            )
        );


    // --------------------------------------------------------
    // Bit 2
    // --------------------------------------------------------

    assign dato_mostrar[2] =
        doble_error_pi |
        (
            ~doble_error_pi &
            (
                (~display_pi & palabra_pi[2]) |
                ( display_pi & sindrome_pi[2])
            )
        );


    // --------------------------------------------------------
    // Bit 3
    //
    // En DED se pone en 1.
    // Resultado final en DED:
    //
    // dato_mostrar = 1110 = E
    // --------------------------------------------------------

    assign dato_mostrar[3] =
        doble_error_pi |
        (
            ~doble_error_pi &
            ~display_pi &
            palabra_pi[3]
        );


    // ========================================================
    // LEDs
    //
    // Los LEDs muestran la palabra corregida.
    // El switch display NO afecta estos LEDs, solo cambia lo que se muestra en el display.
    // ========================================================

    assign codigo_bin_led_po = palabra_pi; // Se muestran los 4 bits de la palabra corregida


    // ========================================================
    // DECODIFICADOR HEXADECIMAL A 7 SEGMENTOS
    //
    // Las ecuaciones generan segmentos:
    //
    // a,b,c,d,e,f,g
    //
    // activos en alto.
    // ========================================================

    wire a;
    wire b;
    wire c;
    wire d;
    wire e;
    wire f;
    wire g;


    // --------------------------------------------------------
    // Segmento A
    // --------------------------------------------------------

    assign a = // Se enciende el segmento A si se cumple alguna de estas condiciones
          (dato_mostrar[1] & dato_mostrar[2]) |
          (dato_mostrar[1] & ~dato_mostrar[3]) |
          (dato_mostrar[3] & ~dato_mostrar[0]) |
          (~dato_mostrar[0] & ~dato_mostrar[2]) |
          (dato_mostrar[0] & dato_mostrar[2] & ~dato_mostrar[3]) |
          (dato_mostrar[3] & ~dato_mostrar[1] & ~dato_mostrar[2]);


    // --------------------------------------------------------
    // Segmento B
    // --------------------------------------------------------

    assign b =
          (~dato_mostrar[0] & ~dato_mostrar[2]) |
          (~dato_mostrar[2] & ~dato_mostrar[3]) |
          (dato_mostrar[0] & dato_mostrar[1] & ~dato_mostrar[3]) |
          (dato_mostrar[0] & dato_mostrar[3] & ~dato_mostrar[1]) |
          (~dato_mostrar[0] & ~dato_mostrar[1] & ~dato_mostrar[3]);


    // --------------------------------------------------------
    // Segmento C
    // --------------------------------------------------------

    assign c =
          (dato_mostrar[0] & ~dato_mostrar[1]) |
          (dato_mostrar[0] & ~dato_mostrar[3]) |
          (dato_mostrar[2] & ~dato_mostrar[3]) |
          (dato_mostrar[3] & ~dato_mostrar[2]) |
          (~dato_mostrar[1] & ~dato_mostrar[3]);


    // --------------------------------------------------------
    // Segmento D
    // --------------------------------------------------------

    assign d =
          (dato_mostrar[3] & ~dato_mostrar[1]) |
          (dato_mostrar[0] & dato_mostrar[1] & ~dato_mostrar[2]) |
          (dato_mostrar[0] & dato_mostrar[2] & ~dato_mostrar[1]) |
          (dato_mostrar[1] & dato_mostrar[2] & ~dato_mostrar[0]) |
          (~dato_mostrar[0] & ~dato_mostrar[2] & ~dato_mostrar[3]);


    // --------------------------------------------------------
    // Segmento E
    // --------------------------------------------------------

    assign e =
          (dato_mostrar[1] & dato_mostrar[3]) |
          (dato_mostrar[2] & dato_mostrar[3]) |
          (dato_mostrar[1] & ~dato_mostrar[0]) |
          (~dato_mostrar[0] & ~dato_mostrar[2]);


    // --------------------------------------------------------
    // Segmento F
    // --------------------------------------------------------

    assign f =
          (dato_mostrar[1] & dato_mostrar[3]) |
          (dato_mostrar[2] & ~dato_mostrar[0]) |
          (dato_mostrar[3] & ~dato_mostrar[2]) |
          (~dato_mostrar[0] & ~dato_mostrar[1]) |
          (dato_mostrar[2] & ~dato_mostrar[1] & ~dato_mostrar[3]);


    // --------------------------------------------------------
    // Segmento G
    // --------------------------------------------------------

    assign g =
          (dato_mostrar[0] & dato_mostrar[3]) |
          (dato_mostrar[1] & ~dato_mostrar[0]) |
          (dato_mostrar[1] & ~dato_mostrar[2]) |
          (dato_mostrar[3] & ~dato_mostrar[2]) |
          (dato_mostrar[2] & ~dato_mostrar[1] & ~dato_mostrar[3]);


    // ========================================================
    // MAPEO DE SEGMENTOS
    //
    // CABLEADO FÍSICO ACTUAL:
    //
    // FPGA 76 -> A
    // FPGA 75 -> B
    // FPGA 72 -> E
    // FPGA 71 -> D
    // FPGA 70 -> G
    // FPGA 74 -> F
    // FPGA 73 -> C
    //
    // Display de ánodo común:
    // 0 = encendido
    // 1 = apagado
    // ========================================================

    assign catodo_po[0] = ~a;    // Pin 76 -> A
    assign catodo_po[1] = ~b;    // Pin 75 -> B
    assign catodo_po[2] = ~e;    // Pin 72 -> E
    assign catodo_po[3] = ~d;    // Pin 71 -> D
    assign catodo_po[4] = ~g;    // Pin 70 -> G
    assign catodo_po[5] = ~f;    // Pin 74 -> F
    assign catodo_po[6] = ~c;    // Pin 73 -> C


    // ========================================================
    // SELECCIÓN DEL DISPLAY
    //
    // PNP:
    // 0 = display encendido
    // 1 = display apagado
    //
    // display_pi = 0 -> display 0
    // display_pi = 1 -> display 1
    // ========================================================

    assign anodo_po[0] = display_pi; // Se enciende el display 0 si display_pi = 0
    assign anodo_po[1] = ~display_pi; // Se enciende el display 1 si display_pi = 1


endmodule
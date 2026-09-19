module despliegue_receptor (
    input  wire [3:0] palabra_pi,       // Palabra recibida/corregida
    input  wire [2:0] sindrome_pi,      // Posición del error
    input  wire       doble_error_pi,   // 1 = doble error (DED)
    input  wire       display_pi,       // 0 = palabra, 1 = síndrome

    output wire [3:0] codigo_bin_led_po, // LEDs de la palabra
    output wire [6:0] catodo_po,          // Segmentos a-g
    output wire [1:0] anodo_po            // Selección de display
);

    // ---------------------------------------------------------
    // Selección del dato que se va a mostrar
    // ---------------------------------------------------------
    // display = 0 -> palabra recibida/corregida
    // display = 1 -> síndrome
    // Si hay doble error -> se muestra E
    // ---------------------------------------------------------

    wire [3:0] dato_mostrar;

    // Bits 0, 1 y 2 del síndrome
    // El bit 3 solamente se utiliza para formar la E.
    assign dato_mostrar[0] = doble_error_pi |
                             (~doble_error_pi & ((~display_pi & palabra_pi[0]) |
                                                ( display_pi & sindrome_pi[0])));

    assign dato_mostrar[1] = doble_error_pi |
                             (~doble_error_pi & ((~display_pi & palabra_pi[1]) |
                                                ( display_pi & sindrome_pi[1])));

    assign dato_mostrar[2] = doble_error_pi |
                             (~doble_error_pi & ((~display_pi & palabra_pi[2]) |
                                                ( display_pi & sindrome_pi[2])));

    // Si hay doble error se fuerza 1110 = E.
    // Si no hay doble error, el bit 3 viene de la palabra
    // o queda en 0 cuando se muestra el síndrome.
    assign dato_mostrar[3] = doble_error_pi |
                             (~doble_error_pi & ~display_pi & palabra_pi[3]);


    // ---------------------------------------------------------
    // LEDs
    // ---------------------------------------------------------
    // Los LEDs siempre muestran la palabra recibida/corregida.
    // El switch display solo afecta los 7 segmentos.

    assign codigo_bin_led_po = palabra_pi;


    // ---------------------------------------------------------
    // Decodificador hexadecimal a 7 segmentos
    // ---------------------------------------------------------
    // Estas ecuaciones generan segmentos activos en alto.
    // Luego se invierten porque el display es de ánodo común.
    // ---------------------------------------------------------

    wire a;
    wire b;
    wire c;
    wire d;
    wire e;
    wire f;
    wire g;

    // Segmento A
    assign a = (dato_mostrar[1] & dato_mostrar[2]) |
               (dato_mostrar[1] & ~dato_mostrar[3]) |
               (dato_mostrar[3] & ~dato_mostrar[0]) |
               (~dato_mostrar[0] & ~dato_mostrar[2]) |
               (dato_mostrar[0] & dato_mostrar[2] & ~dato_mostrar[3]) |
               (dato_mostrar[3] & ~dato_mostrar[1] & ~dato_mostrar[2]);

    // Segmento B
    assign b = (~dato_mostrar[0] & ~dato_mostrar[2]) |
               (~dato_mostrar[2] & ~dato_mostrar[3]) |
               (dato_mostrar[0] & dato_mostrar[1] & ~dato_mostrar[3]) |
               (dato_mostrar[0] & dato_mostrar[3] & ~dato_mostrar[1]) |
               (~dato_mostrar[0] & ~dato_mostrar[1] & ~dato_mostrar[3]);

    // Segmento C
    assign c = (dato_mostrar[0] & ~dato_mostrar[1]) |
               (dato_mostrar[0] & ~dato_mostrar[3]) |
               (dato_mostrar[2] & ~dato_mostrar[3]) |
               (dato_mostrar[3] & ~dato_mostrar[2]) |
               (~dato_mostrar[1] & ~dato_mostrar[3]);

    // Segmento D
    assign d = (dato_mostrar[3] & ~dato_mostrar[1]) |
               (dato_mostrar[0] & dato_mostrar[1] & ~dato_mostrar[2]) |
               (dato_mostrar[0] & dato_mostrar[2] & ~dato_mostrar[1]) |
               (dato_mostrar[1] & dato_mostrar[2] & ~dato_mostrar[0]) |
               (~dato_mostrar[0] & ~dato_mostrar[2] & ~dato_mostrar[3]);

    // Segmento E
    assign e = (dato_mostrar[1] & dato_mostrar[3]) |
               (dato_mostrar[2] & dato_mostrar[3]) |
               (dato_mostrar[1] & ~dato_mostrar[0]) |
               (~dato_mostrar[0] & ~dato_mostrar[2]);

    // Segmento F
    assign f = (dato_mostrar[1] & dato_mostrar[3]) |
               (dato_mostrar[2] & ~dato_mostrar[0]) |
               (dato_mostrar[3] & ~dato_mostrar[2]) |
               (~dato_mostrar[0] & ~dato_mostrar[1]) |
               (dato_mostrar[2] & ~dato_mostrar[1] & ~dato_mostrar[3]);

    // Segmento G
    assign g = (dato_mostrar[0] & dato_mostrar[3]) |
               (dato_mostrar[1] & ~dato_mostrar[0]) |
               (dato_mostrar[1] & ~dato_mostrar[2]) |
               (dato_mostrar[3] & ~dato_mostrar[2]) |
               (dato_mostrar[2] & ~dato_mostrar[1] & ~dato_mostrar[3]);


    // ---------------------------------------------------------
    // Cátodos
    // ---------------------------------------------------------
    // Ánodo común -> 0 enciende el segmento.
    //
    // catodo_po[6] = G
    // catodo_po[5] = F
    // catodo_po[4] = C
    // catodo_po[3] = B
    // catodo_po[2] = A
    // catodo_po[1] = D
    // catodo_po[0] = E
    // ---------------------------------------------------------

    assign catodo_po[6] = ~g;
    assign catodo_po[5] = ~f;
    assign catodo_po[4] = ~c;
    assign catodo_po[3] = ~b;
    assign catodo_po[2] = ~a;
    assign catodo_po[1] = ~d;
    assign catodo_po[0] = ~e;


    // ---------------------------------------------------------
    // Selección del display
    // ---------------------------------------------------------
    // PNP -> nivel bajo enciende el display.
    //
    // display = 0 -> display 0 encendido
    // display = 1 -> display 1 encendido
    // ---------------------------------------------------------

    assign anodo_po[0] = display_pi;
    assign anodo_po[1] = ~display_pi;

endmodule
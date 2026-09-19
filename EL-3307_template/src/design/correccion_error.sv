module correccion_error (
    input  wire [6:0] palabra_rx,
    input  wire       paridad_mal,
    input  wire [2:0] sindrome,

    output wire [3:0] datos_corregidos,
    output wire       DED
);

    // Detecta si el síndrome es diferente de cero
    wire sindrome_error;

    assign sindrome_error = sindrome[2] | sindrome[1] | sindrome[0];

    // Doble error: paridad correcta pero síndrome diferente de cero
    assign DED = ~paridad_mal & sindrome_error;


    // SEC: paridad mala y síndrome diferente de cero
    wire SEC;

    assign SEC = paridad_mal & sindrome_error;


    // Señales para invertir cada bit de Hamming
    wire error_1;
    wire error_2;
    wire error_3;
    wire error_4;
    wire error_5;
    wire error_6;
    wire error_7;

    assign error_1 = SEC & ~sindrome[2] & ~sindrome[1] &  sindrome[0];
    assign error_2 = SEC & ~sindrome[2] &  sindrome[1] & ~sindrome[0];
    assign error_3 = SEC & ~sindrome[2] &  sindrome[1] &  sindrome[0];
    assign error_4 = SEC &  sindrome[2] & ~sindrome[1] & ~sindrome[0];
    assign error_5 = SEC &  sindrome[2] & ~sindrome[1] &  sindrome[0];
    assign error_6 = SEC &  sindrome[2] &  sindrome[1] & ~sindrome[0];
    assign error_7 = SEC &  sindrome[2] &  sindrome[1] &  sindrome[0];


    // Corrección de los bits recibidos
    wire [6:0] palabra_corregida;

    assign palabra_corregida[0] = palabra_rx[0] ^ error_1;
    assign palabra_corregida[1] = palabra_rx[1] ^ error_2;
    assign palabra_corregida[2] = palabra_rx[2] ^ error_3;
    assign palabra_corregida[3] = palabra_rx[3] ^ error_4;
    assign palabra_corregida[4] = palabra_rx[4] ^ error_5;
    assign palabra_corregida[5] = palabra_rx[5] ^ error_6;
    assign palabra_corregida[6] = palabra_rx[6] ^ error_7;


    // Extraemos solamente los 4 bits de información
    assign datos_corregidos[3] = palabra_corregida[6]; // i3
    assign datos_corregidos[2] = palabra_corregida[5]; // i2
    assign datos_corregidos[1] = palabra_corregida[4]; // i1
    assign datos_corregidos[0] = palabra_corregida[2]; // i0

endmodule
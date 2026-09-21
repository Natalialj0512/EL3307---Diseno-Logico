module generador_error (
    input wire [7:0] palabra_codificada_pi, // Entrada de las XOR: P i3 i2 i1 c2 i0 c1 c0
    input wire [2:0] error_pos1_pi, // Entrada de la posición de error 1
    input wire [2:0] error_pos2_pi, // Entrada de la posición de error 2
    output wire [7:0] palabra_error_po // Salida 8 bits con la palabra codificada de hamming
);

    // Bits de los dos switches de posición
    wire e1_2;
    wire e1_1;
    wire e1_0;

    wire e2_2;
    wire e2_1;
    wire e2_0;

    // Señales que indican qué posición seleccionó cada switch
    wire error1_bit1;
    wire error1_bit2;
    wire error1_bit3;
    wire error1_bit4;
    wire error1_bit5;
    wire error1_bit6;
    wire error1_bit7;

    wire error2_bit1;
    wire error2_bit2;
    wire error2_bit3;
    wire error2_bit4;
    wire error2_bit5;
    wire error2_bit6;
    wire error2_bit7;


    // Se separan los bits de los switches y copia el valor que venga de la entrada
    assign e1_2 = error_pos1_pi[2];
    assign e1_1 = error_pos1_pi[1];
    assign e1_0 = error_pos1_pi[0];

    assign e2_2 = error_pos2_pi[2];
    assign e2_1 = error_pos2_pi[1];
    assign e2_0 = error_pos2_pi[0];


    // Decodificación del primer switch
    // 000 = sin error, 001-111 = posición 1-7

    assign error1_bit1 = ~e1_2 & ~e1_1 &  e1_0;
    assign error1_bit2 = ~e1_2 &  e1_1 & ~e1_0;
    assign error1_bit3 = ~e1_2 &  e1_1 &  e1_0;
    assign error1_bit4 =  e1_2 & ~e1_1 & ~e1_0;
    assign error1_bit5 =  e1_2 & ~e1_1 &  e1_0;
    assign error1_bit6 =  e1_2 &  e1_1 & ~e1_0;
    assign error1_bit7 =  e1_2 &  e1_1 &  e1_0;


    // Decodificación del segundo switch

    assign error2_bit1 = ~e2_2 & ~e2_1 &  e2_0;
    assign error2_bit2 = ~e2_2 &  e2_1 & ~e2_0;
    assign error2_bit3 = ~e2_2 &  e2_1 &  e2_0;
    assign error2_bit4 =  e2_2 & ~e2_1 & ~e2_0;
    assign error2_bit5 =  e2_2 & ~e2_1 &  e2_0;
    assign error2_bit6 =  e2_2 &  e2_1 & ~e2_0;
    assign error2_bit7 =  e2_2 &  e2_1 &  e2_0;


    // XOR con 0 conserva el bit y con 1 lo invierte
    // Posición Hamming 1-7 corresponde a índices [0]-[6]

    assign palabra_error_po[0] =
        palabra_codificada_pi[0] ^ error1_bit1 ^ error2_bit1;

    assign palabra_error_po[1] =
        palabra_codificada_pi[1] ^ error1_bit2 ^ error2_bit2;

    assign palabra_error_po[2] =
        palabra_codificada_pi[2] ^ error1_bit3 ^ error2_bit3;

    assign palabra_error_po[3] =
        palabra_codificada_pi[3] ^ error1_bit4 ^ error2_bit4;

    assign palabra_error_po[4] =
        palabra_codificada_pi[4] ^ error1_bit5 ^ error2_bit5;

    assign palabra_error_po[5] =
        palabra_codificada_pi[5] ^ error1_bit6 ^ error2_bit6;

    assign palabra_error_po[6] =
        palabra_codificada_pi[6] ^ error1_bit7 ^ error2_bit7;


    // El bit de paridad global P no se cambia, siempre queda igual
    assign palabra_error_po[7] = palabra_codificada_pi[7];

endmodule
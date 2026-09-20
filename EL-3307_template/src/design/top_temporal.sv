module top_temporal (

    // DIP de 4 bits
    input wire [3:0] codigo_bin_pi,

    // Switches de posición de error
    input wire [2:0] error_pos1_pi,
    input wire [2:0] error_pos2_pi,

    // Señales provenientes de las compuertas XOR externas
    input wire c0_pi,
    input wire c1_pi,
    input wire c2_pi,
    input wire p_pi,

    // Display de 7 segmentos
    output wire [6:0] catodo_po,
    output wire dig1_po,
    output wire dig2_po
);

    // Palabra Hamming + paridad global
    wire [7:0] palabra_codificada;

    // Palabra después de introducir los errores
    wire [7:0] palabra_error;


    // ========================================================
    // CONSTRUCCIÓN DE LA PALABRA CODIFICADA
    //
    // [7:0] = P i3 i2 i1 C2 i0 C1 C0
    //
    // Posición Hamming:
    // 1 -> C0
    // 2 -> C1
    // 3 -> i0
    // 4 -> C2
    // 5 -> i1
    // 6 -> i2
    // 7 -> i3
    // 8 -> P
    // ========================================================

    assign palabra_codificada[7] = p_pi;
    assign palabra_codificada[6] = codigo_bin_pi[3];
    assign palabra_codificada[5] = codigo_bin_pi[2];
    assign palabra_codificada[4] = codigo_bin_pi[1];
    assign palabra_codificada[3] = c2_pi;
    assign palabra_codificada[2] = codigo_bin_pi[0];
    assign palabra_codificada[1] = c1_pi;
    assign palabra_codificada[0] = c0_pi;


    // ========================================================
    // GENERADOR DE ERROR
    // ========================================================

    generador_error u_generador_error (
        .palabra_codificada_pi(palabra_codificada),
        .error_pos1_pi(error_pos1_pi),
        .error_pos2_pi(error_pos2_pi),
        .palabra_error_po(palabra_error)
    );


    // ========================================================
    // PRUEBA DEL GENERADOR
    //
    // Queremos mostrar:
    //
    // i0 C1 C0 P
    //
    // i0  -> palabra_error[2]
    // C1  -> palabra_error[1]
    // C0  -> palabra_error[0]
    // P   -> palabra_error[7]
    //
    // P permanece sin modificar aunque se introduzcan errores.
    // ========================================================

    wire [3:0] prueba_display;

    assign prueba_display[3] = palabra_error[0]; // C0
    assign prueba_display[2] = palabra_error[1]; // C1
    assign prueba_display[1] = palabra_error[3]; // C2
    assign prueba_display[0] = palabra_error[7]; // P


    // ========================================================
    // DISPLAY
    // ========================================================

    binario_7seg u_binario_7seg (
        .codigo_bin_pi(prueba_display),
        .catodo_po(catodo_po)
    );


    // ========================================================
    // SELECCIÓN DEL DISPLAY
    // ========================================================

    assign dig1_po = 1'b0;
    assign dig2_po = 1'b1;

endmodule
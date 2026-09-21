module binario_7seg (
    //Entradas y salidas del modulo
    input  wire [3:0] codigo_bin_pi, // Entrada de los 4 datos
    output wire [6:0] catodo_po // Salida de los 7 bits para el 7 segmentos

);
    // Conexión con las entradas dentro de la FPGA
    wire i3;
    wire i2;
    wire i1;
    wire i0;
    
    // Conexión con las salidas dentro de la FPGA
    wire a;
    wire b;
    wire c;
    wire d;
    wire e;
    wire f;
    wire g;
    
    // Asigna el valor que tenga la entrada de los datos a i3, i2, i1, i0
    assign i3 = codigo_bin_pi[3];
    assign i2 = codigo_bin_pi[2];
    assign i1 = codigo_bin_pi[1];
    assign i0 = codigo_bin_pi[0];

    // Segmento A
    // 0 = encendido, 1 = apagado
    assign a =
          (i0 & i1 & i3 & ~i2) |
          (i0 & i2 & i3 & ~i1) |
          (i0 & ~i1 & ~i2 & ~i3) |
          (i2 & ~i0 & ~i1 & ~i3);

    // Segmento B
    assign b =
          (i0 & i1 & i3) |
          (i1 & i2 & ~i0) |
          (i2 & i3 & ~i0) |
          (i0 & i2 & ~i1 & ~i3);

    // Segmento C
    assign c =
          (i1 & i2 & i3) |
          (i2 & i3 & ~i0) |
          (i1 & ~i0 & ~i2 & ~i3);

    // Segmento D
    assign d =
          (i0 & i1 & i2) |
          (i1 & i3 & ~i0 & ~i2) |
          (i0 & ~i1 & ~i2 & ~i3) |
          (i2 & ~i0 & ~i1 & ~i3);

    // Segmento E
    assign e =
          (i0 & ~i3) |
          (i0 & ~i1 & ~i2) |
          (i2 & ~i1 & ~i3);

    // Segmento F
    assign f =
          (i0 & i1 & ~i3) |
          (i0 & ~i2 & ~i3) |
          (i1 & ~i2 & ~i3) |
          (i0 & i2 & i3 & ~i1);

    // Segmento G
    assign g =
          (i0 & i1 & i2 & ~i3) |
          (~i1 & ~i2 & ~i3) |
          (i2 & i3 & ~i0 & ~i1);


    // ========================================================
    // ORDEN DE PIN CON SEGMENTO
    //
    // FPGA 76 -> A
    // FPGA 75 -> B
    // FPGA 74 -> F
    // FPGA 73 -> C
    // FPGA 72 -> E
    // FPGA 71 -> D
    // FPGA 70 -> G
    // ========================================================

    // Enciende o apaga el catodo del 7 segmentos
    assign catodo_po[0] = a;
    assign catodo_po[1] = b;
    assign catodo_po[2] = e;
    assign catodo_po[3] = d;
    assign catodo_po[4] = g;
    assign catodo_po[5] = f;
    assign catodo_po[6] = c;

endmodule
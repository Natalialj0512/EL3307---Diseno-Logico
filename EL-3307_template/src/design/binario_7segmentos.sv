module binario_7seg (
    input  wire [3:0] codigo_bin_pi,
    output wire [6:0] catodo_po
);

    wire i3;
    wire i2;
    wire i1;
    wire i0;

    wire a;
    wire b;
    wire c;
    wire d;
    wire e;
    wire f;
    wire g;

    assign i3 = codigo_bin_pi[3];
    assign i2 = codigo_bin_pi[2];
    assign i1 = codigo_bin_pi[1];
    assign i0 = codigo_bin_pi[0];

    // Segmento A
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

    // Orden de los cátodos
    assign catodo_po[6] = g;
    assign catodo_po[5] = f;
    assign catodo_po[4] = c;
    assign catodo_po[3] = b;
    assign catodo_po[2] = a;
    assign catodo_po[1] = d;
    assign catodo_po[0] = e;

endmodule
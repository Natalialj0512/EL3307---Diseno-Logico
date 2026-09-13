module binario_7seg (
    input wire [3:0] codigo_bin_pi,
    output wire [6:0] catodo_po
);

    wire i3 = codigo_bin_pi[3];
    wire i2 = codigo_bin_pi[2];
    wire i1 = codigo_bin_pi[1];
    wire i0 = codigo_bin_pi[0];

    // Segmento a
    assign catodo_po[2] =
        (i0 & i1 & i3 & ~i2) |
        (i0 & ~i1 & ~i2 & ~i3) |
        (i2 & ~i0 & ~i1 & ~i3);

    // Segmento b
    assign catodo_po[3] =
        (i0 & i1 & i3) |
        (i1 & i2 & ~i0) |
        (i2 & i3 & ~i0) |
        (i0 & i2 & ~i1 & ~i3);

    // Segmento c
    assign catodo_po[4] =
        (i1 & i2 & i3) |
        (i2 & i3 & ~i0);

    // Segmento d
    assign catodo_po[1] =
        (i0 & i1 & i2) |
        (i1 & i3 & ~i0 & ~i2) |
        (i0 & ~i1 & ~i2 & ~i3) |
        (i2 & ~i0 & ~i1 & ~i3);

    // Segmento e
    assign catodo_po[0] =
        (i0 & ~i3) |
        (i0 & ~i1 & ~i2) |
        (i2 & ~i1 & ~i3);

    // Segmento f
    assign catodo_po[5] =
        (i0 & i1 & ~i3) |
        (i0 & ~i2 & ~i3) |
        (i1 & ~i2 & ~i3) |
        (i0 & i2 & i3 & ~i1);

    // Segmento g
    assign catodo_po[6] =
        (i0 & i1 & i2 & ~i3) |
        (~i1 & ~i2 & ~i3);

endmodule

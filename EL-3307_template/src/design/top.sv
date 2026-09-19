module top (
    input wire [3:0] codigo_bin_pi,
    output wire [6:0] catodo_po,
    output wire dig1_po,
    output wire dig2_po
);

    binario_7seg u_binario_7seg (
        .codigo_bin_pi(codigo_bin_pi),
        .catodo_po(catodo_po)
    );

    assign dig1_po = 1'b0; //para probar siempre en 0 el primer digito del display
    assign dig2_po = 1'b1; //para probar siempre en 1 el segundo digito del display

endmodule
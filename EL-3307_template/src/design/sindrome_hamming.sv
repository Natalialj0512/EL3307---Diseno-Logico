module sindrome_hamming (
    input  wire [6:0] palabra_pi,
    output wire [2:0] sindrome_po
);

    // S0 que revisa C0, i0, i1 e i3
    assign sindrome_po[0] = palabra_pi[0] ^ palabra_pi[2] ^
                            palabra_pi[4] ^ palabra_pi[6];

    // S1 que revisa C1, i0, i2 e i3
    assign sindrome_po[1] = palabra_pi[1] ^ palabra_pi[2] ^
                            palabra_pi[5] ^ palabra_pi[6];

    // S2 que revisa C2, i1, i2 e i3
    assign sindrome_po[2] = palabra_pi[3] ^ palabra_pi[4] ^
                            palabra_pi[5] ^ palabra_pi[6];

endmodule
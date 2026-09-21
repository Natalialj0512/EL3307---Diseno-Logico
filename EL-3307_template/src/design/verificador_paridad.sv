module verificador_paridad (
    input  wire [7:0] palabra_pi, // Recibe la palabra de hamming 
    output wire       error_paridad_po // Sale un bit de paridad
);
    // Revisa si la cantidad de bits recibidos es par o impar
    assign error_paridad_po = palabra_pi[7] ^
                              palabra_pi[6] ^
                              palabra_pi[5] ^
                              palabra_pi[4] ^
                              palabra_pi[3] ^
                              palabra_pi[2] ^
                              palabra_pi[1] ^
                              palabra_pi[0];

                              

endmodule
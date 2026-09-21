`timescale 1ns/1ps

module tb_sindrome_hamming;

    // Entrada del DUT
    reg [6:0] palabra_pi;

    // Salida del DUT
    wire [2:0] sindrome_po;

    // Instancia del módulo a probar
    sindrome_hamming DUT (
        .palabra_pi(palabra_pi),
        .sindrome_po(sindrome_po)
    );

    initial begin
        $dumpfile("sindrome_hamming.vcd");
        $dumpvars(0, tb_sindrome_hamming);

        $display("==============================================");
        $display("      TESTBENCH - SINDROME HAMMING (7,4)");
        $display("==============================================");

        // ------------------------------------------
        // Prueba 1: Sin error
        // ------------------------------------------
        palabra_pi = 7'b0000000;
        #10;

        $display("Prueba 1 - Sin error");
        $display("Entrada  : %b", palabra_pi);
        $display("Sindrome : %b", sindrome_po);
        $display("----------------------------------------------");


        // ------------------------------------------
        // Prueba 2: Error en bit 1
        // ------------------------------------------
        palabra_pi = 7'b0000001;
        #10;

        $display("Prueba 2 - Error en bit 1");
        $display("Entrada  : %b", palabra_pi);
        $display("Sindrome : %b", sindrome_po);
        $display("----------------------------------------------");


        // ------------------------------------------
        // Prueba 3: Error en bit 2
        // ------------------------------------------
        palabra_pi = 7'b0000010;
        #10;

        $display("Prueba 3 - Error en bit 2");
        $display("Entrada  : %b", palabra_pi);
        $display("Sindrome : %b", sindrome_po);
        $display("----------------------------------------------");


        // ------------------------------------------
        // Prueba 4: Error en bit 3
        // ------------------------------------------
        palabra_pi = 7'b0000100;
        #10;

        $display("Prueba 4 - Error en bit 3");
        $display("Entrada  : %b", palabra_pi);
        $display("Sindrome : %b", sindrome_po);
        $display("----------------------------------------------");


        // ------------------------------------------
        // Prueba 5: Error en bit 4
        // ------------------------------------------
        palabra_pi = 7'b0001000;
        #10;

        $display("Prueba 5 - Error en bit 4");
        $display("Entrada  : %b", palabra_pi);
        $display("Sindrome : %b", sindrome_po);
        $display("----------------------------------------------");


        // ------------------------------------------
        // Prueba 6: Error en bit 5
        // ------------------------------------------
        palabra_pi = 7'b0010000;
        #10;

        $display("Prueba 6 - Error en bit 5");
        $display("Entrada  : %b", palabra_pi);
        $display("Sindrome : %b", sindrome_po);
        $display("----------------------------------------------");


        // ------------------------------------------
        // Prueba 7: Error en bit 6
        // ------------------------------------------
        palabra_pi = 7'b0100000;
        #10;

        $display("Prueba 7 - Error en bit 6");
        $display("Entrada  : %b", palabra_pi);
        $display("Sindrome : %b", sindrome_po);
        $display("----------------------------------------------");


        // ------------------------------------------
        // Prueba 8: Error en bit 7
        // ------------------------------------------
        palabra_pi = 7'b1000000;
        #10;

        $display("Prueba 8 - Error en bit 7");
        $display("Entrada  : %b", palabra_pi);
        $display("Sindrome : %b", sindrome_po);
        $display("----------------------------------------------");


        // ------------------------------------------
        // Prueba 9: Varios bits en 1
        // ------------------------------------------
        palabra_pi = 7'b1010101;
        #10;

        $display("Prueba 9 - Caso general");
        $display("Entrada  : %b", palabra_pi);
        $display("Sindrome : %b", sindrome_po);
        $display("----------------------------------------------");


        $display("==============================================");
        $display("             FIN DE SIMULACION :DDD");
        $display("==============================================");

        $finish;
    end

endmodule
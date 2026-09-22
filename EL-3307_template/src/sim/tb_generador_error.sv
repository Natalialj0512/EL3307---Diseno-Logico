`timescale 1ns/1ps

module generador_error_tb;

    // ========================================================
    // ENTRADAS DEL DUT
    // ========================================================

    logic [7:0] palabra_codificada_pi;
    logic [2:0] error_pos1_pi;
    logic [2:0] error_pos2_pi;

    // ========================================================
    // SALIDA DEL DUT
    // ========================================================

    logic [7:0] palabra_error_po;

    // ========================================================
    // INSTANCIA DEL MÓDULO A PROBAR
    // ========================================================

    generador_error DUT (
        .palabra_codificada_pi(palabra_codificada_pi),
        .error_pos1_pi(error_pos1_pi),
        .error_pos2_pi(error_pos2_pi),
        .palabra_error_po(palabra_error_po)
    );

    // ========================================================
    // SIMULACIÓN
    // ========================================================

    initial begin

        $dumpfile("generador_error_tb.vcd");
        $dumpvars(0, generador_error_tb);

        $display("==============================================");
        $display("      TESTBENCH - GENERADOR DE ERROR");
        $display("==============================================");

        // ------------------------------------------------
        // PRUEBA 1: Sin errores
        // ------------------------------------------------

        palabra_codificada_pi = 8'b10101010;
        error_pos1_pi = 3'b000;
        error_pos2_pi = 3'b000;

        #10;

        $display("Prueba 1 - Sin errores");
        $display("Entrada : %b", palabra_codificada_pi);
        $display("Error 1 : %b", error_pos1_pi);
        $display("Error 2 : %b", error_pos2_pi);
        $display("Salida  : %b", palabra_error_po);


        // ------------------------------------------------
        // PRUEBA 2: Un error en posición 1
        // ------------------------------------------------

        palabra_codificada_pi = 8'b10101010;
        error_pos1_pi = 3'b001;
        error_pos2_pi = 3'b000;

        #10;

        $display("Prueba 2 - Error en posicion 1");
        $display("Entrada : %b", palabra_codificada_pi);
        $display("Error 1 : %b", error_pos1_pi);
        $display("Error 2 : %b", error_pos2_pi);
        $display("Salida  : %b", palabra_error_po);


        // ------------------------------------------------
        // PRUEBA 3: Un error en posición 3
        // ------------------------------------------------

        palabra_codificada_pi = 8'b10101010;
        error_pos1_pi = 3'b011;
        error_pos2_pi = 3'b000;

        #10;

        $display("Prueba 3 - Error en posicion 3");
        $display("Entrada : %b", palabra_codificada_pi);
        $display("Error 1 : %b", error_pos1_pi);
        $display("Error 2 : %b", error_pos2_pi);
        $display("Salida  : %b", palabra_error_po);


        // ------------------------------------------------
        // PRUEBA 4: Un error en posición 7
        // ------------------------------------------------

        palabra_codificada_pi = 8'b10101010;
        error_pos1_pi = 3'b111;
        error_pos2_pi = 3'b000;

        #10;

        $display("Prueba 4 - Error en posicion 7");
        $display("Entrada : %b", palabra_codificada_pi);
        $display("Error 1 : %b", error_pos1_pi);
        $display("Error 2 : %b", error_pos2_pi);
        $display("Salida  : %b", palabra_error_po);


        // ------------------------------------------------
        // PRUEBA 5: Dos errores en posiciones diferentes
        // Posiciones 2 y 5
        // ------------------------------------------------

        palabra_codificada_pi = 8'b10101010;
        error_pos1_pi = 3'b010;
        error_pos2_pi = 3'b101;

        #10;

        $display("Prueba 5 - Dos errores: posiciones 2 y 5");
        $display("Entrada : %b", palabra_codificada_pi);
        $display("Error 1 : %b", error_pos1_pi);
        $display("Error 2 : %b", error_pos2_pi);
        $display("Salida  : %b", palabra_error_po);


        // ------------------------------------------------
        // PRUEBA 6: Dos errores en posiciones 3 y 7
        // ------------------------------------------------

        palabra_codificada_pi = 8'b10101010;
        error_pos1_pi = 3'b011;
        error_pos2_pi = 3'b111;

        #10;

        $display("Prueba 6 - Dos errores: posiciones 3 y 7");
        $display("Entrada : %b", palabra_codificada_pi);
        $display("Error 1 : %b", error_pos1_pi);
        $display("Error 2 : %b", error_pos2_pi);
        $display("Salida  : %b", palabra_error_po);


        // ------------------------------------------------
        // PRUEBA 7: Ambos switches en la misma posición
        // Los errores se cancelan
        // ------------------------------------------------

        palabra_codificada_pi = 8'b10101010;
        error_pos1_pi = 3'b011;
        error_pos2_pi = 3'b011;

        #10;

        $display("Prueba 7 - Ambos errores en posicion 3");
        $display("Entrada : %b", palabra_codificada_pi);
        $display("Error 1 : %b", error_pos1_pi);
        $display("Error 2 : %b", error_pos2_pi);
        $display("Salida  : %b", palabra_error_po);


        // ========================================================
        // FINAL DE PRUEBAS
        // ========================================================

        $display("==============================================");
        $display("              FINAL DE PRUEBAS :DD");
        $display("==============================================");

        $finish;

    end

endmodule
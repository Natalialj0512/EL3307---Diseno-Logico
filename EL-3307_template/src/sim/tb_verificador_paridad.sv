`timescale 1ns/1ps

module tb_verificador_paridad;

    // ========================================================
    // ENTRADAS DEL DUT
    // ========================================================

    logic [7:0] palabra_pi;

    // ========================================================
    // SALIDA DEL DUT
    // ========================================================

    logic error_paridad_po;

    // ========================================================
    // INSTANCIA DEL MODULO
    // ========================================================

    verificador_paridad DUT (
        .palabra_pi(palabra_pi),
        .error_paridad_po(error_paridad_po)
    );

    // ========================================================
    // SIMULACION
    // ========================================================

    initial begin

        $dumpfile("verificador_paridad.vcd");
        $dumpvars(0, tb_verificador_paridad);

        $display("==============================================");
        $display("       TESTBENCH - VERIFICADOR DE PARIDAD");
        $display("==============================================");


        // ----------------------------------------------------
        // PRUEBA 1: 0 unos -> paridad par
        // Resultado esperado: error = 0
        // ----------------------------------------------------

        palabra_pi = 8'b00000000;
        #10;

        $display("Prueba 1: Entrada: %b | Error obtenido: %b | Error esperado: 0",
                 palabra_pi, error_paridad_po);


        // ----------------------------------------------------
        // PRUEBA 2: 1 uno -> paridad impar
        // Resultado esperado: error = 1
        // ----------------------------------------------------

        palabra_pi = 8'b00000001;
        #10;

        $display("Prueba 2: Entrada: %b | Error obtenido: %b | Error esperado: 1",
                 palabra_pi, error_paridad_po);


        // ----------------------------------------------------
        // PRUEBA 3: 2 unos -> paridad par
        // Resultado esperado: error = 0
        // ----------------------------------------------------

        palabra_pi = 8'b00000011;
        #10;

        $display("Prueba 3: Entrada: %b | Error obtenido: %b | Error esperado: 0",
                 palabra_pi, error_paridad_po);


        // ----------------------------------------------------
        // PRUEBA 4: 4 unos -> paridad par
        // Resultado esperado: error = 0
        // ----------------------------------------------------

        palabra_pi = 8'b10101010;
        #10;

        $display("Prueba 4: Entrada: %b | Error obtenido: %b | Error esperado: 0",
                 palabra_pi, error_paridad_po);


        // ----------------------------------------------------
        // PRUEBA 5: 3 unos -> paridad impar
        // Resultado esperado: error = 1
        // ----------------------------------------------------

        palabra_pi = 8'b00000111;
        #10;

        $display("Prueba 5: Entrada: %b | Error obtenido: %b | Error esperado: 1",
                 palabra_pi, error_paridad_po);


        // ----------------------------------------------------
        // PRUEBA 6: 8 unos -> paridad par
        // Resultado esperado: error = 0
        // ----------------------------------------------------

        palabra_pi = 8'b11111111;
        #10;

        $display("Prueba 6: Entrada: %b | Error obtenido: %b | Error esperado: 0",
                 palabra_pi, error_paridad_po);


        // ====================================================
        // FINAL
        // ====================================================

        $display("==============================================");
        $display("              FIN DEL TESTBENCH :DD");
        $display("==============================================");

        $finish;

    end

endmodule
`timescale 1ns/1ps

module tb_verificador_paridad;

    reg  [7:0] palabra_pi;
    wire       error_paridad_po;

    verificador_paridad DUT (
        .palabra_pi(palabra_pi),
        .error_paridad_po(error_paridad_po)
    );

    initial begin

        $dumpfile("verificador_paridad.vcd");
        $dumpvars(0, tb_verificador_paridad);

        $display("==============================================");
        $display("       TESTBENCH - VERIFICADOR DE PARIDAD");
        $display("==============================================");

        // Prueba 1: 0 unos -> paridad par
        palabra_pi = 8'b00000000;
        #10;

        if (error_paridad_po == 1'b0)
            $display("Prueba 1: PASS | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);
        else
            $display("Prueba 1: FAIL | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);


        // Prueba 2: 1 uno -> paridad impar
        palabra_pi = 8'b00000001;
        #10;

        if (error_paridad_po == 1'b1)
            $display("Prueba 2: PASS | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);
        else
            $display("Prueba 2: FAIL | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);


        // Prueba 3: 2 unos -> paridad par
        palabra_pi = 8'b00000011;
        #10;

        if (error_paridad_po == 1'b0)
            $display("Prueba 3: PASS | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);
        else
            $display("Prueba 3: FAIL | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);


        // Prueba 4: 4 unos -> paridad par
        palabra_pi = 8'b10101010;
        #10;

        if (error_paridad_po == 1'b0)
            $display("Prueba 4: PASS | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);
        else
            $display("Prueba 4: FAIL | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);


        // Prueba 5: 3 unos -> paridad impar
        palabra_pi = 8'b00000111;
        #10;

        if (error_paridad_po == 1'b1)
            $display("Prueba 5: PASS | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);
        else
            $display("Prueba 5: FAIL | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);


        // Prueba 6: 8 unos -> paridad par
        palabra_pi = 8'b11111111;
        #10;

        if (error_paridad_po == 1'b0)
            $display("Prueba 6: PASS | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);
        else
            $display("Prueba 6: FAIL | Entrada: %b | Error: %b",
                     palabra_pi, error_paridad_po);


        $display("==============================================");
        $display("              FIN DEL TESTBENCH :DD");
        $display("==============================================");

        $finish;
    end

endmodule
`timescale 1ns/1ps

module tb_despliegue_receptor;

    // ========================================================
    // ENTRADAS DEL DUT
    // ========================================================

    reg [3:0] palabra_pi;
    reg [2:0] sindrome_pi;
    reg       doble_error_pi;
    reg       display_pi;

    // ========================================================
    // SALIDAS DEL DUT
    // ========================================================

    wire [3:0] codigo_bin_led_po;
    wire [6:0] catodo_po;
    wire [1:0] anodo_po;

    // ========================================================
    // INSTANCIA DEL MODULO
    // ========================================================

    despliegue_receptor DUT (

        .palabra_pi(palabra_pi),
        .sindrome_pi(sindrome_pi),
        .doble_error_pi(doble_error_pi),
        .display_pi(display_pi),

        .codigo_bin_led_po(codigo_bin_led_po),
        .catodo_po(catodo_po),
        .anodo_po(anodo_po)

    );

    // ========================================================
    // ARCHIVO DE ONDAS
    // ========================================================

    initial begin
        $dumpfile("tb_despliegue_receptor.vcd");
        $dumpvars(0, tb_despliegue_receptor);
    end


    // ========================================================
    // PRUEBAS
    // ========================================================

    initial begin

        $display("==============================================");
        $display(" TESTBENCH - DESPLIEGUE RECEPTOR");
        $display("==============================================");


        // ----------------------------------------------------
        // INICIALIZACION
        // ----------------------------------------------------

        palabra_pi     = 4'b0000;
        sindrome_pi    = 3'b000;
        doble_error_pi = 1'b0;
        display_pi     = 1'b0;

        #10;


        // ====================================================
        // PRUEBA 1
        // Mostrar palabra 0
        // ====================================================

        palabra_pi     = 4'b0000;
        sindrome_pi    = 3'b000;
        doble_error_pi = 1'b0;
        display_pi     = 1'b0;

        #10;

        $display("");
        $display("Prueba 1 - Mostrar palabra 0");
        $display("Palabra       : %b", palabra_pi);
        $display("Sindrome      : %b", sindrome_pi);
        $display("DED           : %b", doble_error_pi);
        $display("Display       : %b", display_pi);
        $display("LEDs          : %b", codigo_bin_led_po);
        $display("Catodos       : %b", catodo_po);
        $display("Anodos        : %b", anodo_po);


        // ====================================================
        // PRUEBA 2
        // Mostrar palabra 5
        // ====================================================

        palabra_pi     = 4'b0101;
        sindrome_pi    = 3'b000;
        doble_error_pi = 1'b0;
        display_pi     = 1'b0;

        #10;

        $display("");
        $display("Prueba 2 - Mostrar palabra 5");
        $display("Palabra       : %b", palabra_pi);
        $display("Sindrome      : %b", sindrome_pi);
        $display("DED           : %b", doble_error_pi);
        $display("Display       : %b", display_pi);
        $display("LEDs          : %b", codigo_bin_led_po);
        $display("Catodos       : %b", catodo_po);
        $display("Anodos        : %b", anodo_po);


        // ====================================================
        // PRUEBA 3
        // Mostrar palabra A
        // ====================================================

        palabra_pi     = 4'b1010;
        sindrome_pi    = 3'b000;
        doble_error_pi = 1'b0;
        display_pi     = 1'b0;

        #10;

        $display("");
        $display("Prueba 3 - Mostrar palabra A");
        $display("Palabra       : %b", palabra_pi);
        $display("Sindrome      : %b", sindrome_pi);
        $display("DED           : %b", doble_error_pi);
        $display("Display       : %b", display_pi);
        $display("LEDs          : %b", codigo_bin_led_po);
        $display("Catodos       : %b", catodo_po);
        $display("Anodos        : %b", anodo_po);


        // ====================================================
        // PRUEBA 4
        // Mostrar palabra F
        // ====================================================

        palabra_pi     = 4'b1111;
        sindrome_pi    = 3'b000;
        doble_error_pi = 1'b0;
        display_pi     = 1'b0;

        #10;

        $display("");
        $display("Prueba 4 - Mostrar palabra F");
        $display("Palabra       : %b", palabra_pi);
        $display("Sindrome      : %b", sindrome_pi);
        $display("DED           : %b", doble_error_pi);
        $display("Display       : %b", display_pi);
        $display("LEDs          : %b", codigo_bin_led_po);
        $display("Catodos       : %b", catodo_po);
        $display("Anodos        : %b", anodo_po);


        // ====================================================
        // PRUEBA 5
        // Mostrar sindrome 001
        // ====================================================

        palabra_pi     = 4'b1010;
        sindrome_pi    = 3'b001;
        doble_error_pi = 1'b0;
        display_pi     = 1'b1;

        #10;

        $display("");
        $display("Prueba 5 - Mostrar sindrome 1");
        $display("Palabra       : %b", palabra_pi);
        $display("Sindrome      : %b", sindrome_pi);
        $display("DED           : %b", doble_error_pi);
        $display("Display       : %b", display_pi);
        $display("LEDs          : %b", codigo_bin_led_po);
        $display("Catodos       : %b", catodo_po);
        $display("Anodos        : %b", anodo_po);


        // ====================================================
        // PRUEBA 6
        // Mostrar sindrome 011
        // ====================================================

        palabra_pi     = 4'b0101;
        sindrome_pi    = 3'b011;
        doble_error_pi = 1'b0;
        display_pi     = 1'b1;

        #10;

        $display("");
        $display("Prueba 6 - Mostrar sindrome 3");
        $display("Palabra       : %b", palabra_pi);
        $display("Sindrome      : %b", sindrome_pi);
        $display("DED           : %b", doble_error_pi);
        $display("Display       : %b", display_pi);
        $display("LEDs          : %b", codigo_bin_led_po);
        $display("Catodos       : %b", catodo_po);
        $display("Anodos        : %b", anodo_po);


        // ====================================================
        // PRUEBA 7
        // Mostrar sindrome 111
        // ====================================================

        palabra_pi     = 4'b0011;
        sindrome_pi    = 3'b111;
        doble_error_pi = 1'b0;
        display_pi     = 1'b1;

        #10;

        $display("");
        $display("Prueba 7 - Mostrar sindrome 7");
        $display("Palabra       : %b", palabra_pi);
        $display("Sindrome      : %b", sindrome_pi);
        $display("DED           : %b", doble_error_pi);
        $display("Display       : %b", display_pi);
        $display("LEDs          : %b", codigo_bin_led_po);
        $display("Catodos       : %b", catodo_po);
        $display("Anodos        : %b", anodo_po);


        // ====================================================
        // PRUEBA 8
        // DOBLE ERROR
        // ====================================================

        palabra_pi     = 4'b1010;
        sindrome_pi    = 3'b011;
        doble_error_pi = 1'b1;
        display_pi     = 1'b0;

        #10;

        $display("");
        $display("Prueba 8 - DOBLE ERROR");
        $display("Palabra       : %b", palabra_pi);
        $display("Sindrome      : %b", sindrome_pi);
        $display("DED           : %b", doble_error_pi);
        $display("Display       : %b", display_pi);
        $display("LEDs          : %b", codigo_bin_led_po);
        $display("Catodos       : %b", catodo_po);
        $display("Anodos        : %b", anodo_po);


        // ====================================================
        // PRUEBA 9
        // Verificar que los LEDs NO dependan de display_pi
        // ====================================================

        palabra_pi     = 4'b1100;
        sindrome_pi    = 3'b010;
        doble_error_pi = 1'b0;
        display_pi     = 1'b0;

        #10;

        $display("");
        $display("Prueba 9 - LEDs con display = 0");
        $display("Palabra       : %b", palabra_pi);
        $display("LEDs          : %b", codigo_bin_led_po);

        display_pi = 1'b1;

        #10;

        $display("");
        $display("Prueba 9 - LEDs con display = 1");
        $display("Palabra       : %b", palabra_pi);
        $display("LEDs          : %b", codigo_bin_led_po);


        // ====================================================
        // FINAL
        // ====================================================

        $display("");
        $display("==============================================");
        $display(" FIN DEL TESTBENCH :DD");
        $display("==============================================");

        #10;

        $finish;

    end

endmodule
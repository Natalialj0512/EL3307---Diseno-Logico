`timescale 1ns/1ps

module tb_correccion_error;

    // Entradas del DUT
    reg [6:0] palabra_rx;
    reg       paridad_mal;
    reg [2:0] sindrome;

    // Salidas del DUT
    wire [3:0] datos_corregidos;
    wire       DED;

    // Instancia del módulo a probar
    correccion_error DUT (
        .palabra_rx(palabra_rx),
        .paridad_mal(paridad_mal),
        .sindrome(sindrome),
        .datos_corregidos(datos_corregidos),
        .DED(DED)
    );

    initial begin
        $dumpfile("correccion_error.vcd");
        $dumpvars(0, tb_correccion_error);

        $display("==============================================");
        $display("       TESTBENCH - CORRECCION DE ERROR");
        $display("==============================================");

        // --------------------------------------------------
        // PRUEBA 1: SIN ERROR
        // --------------------------------------------------

        palabra_rx  = 7'b1010101;
        paridad_mal = 1'b0;
        sindrome    = 3'b000;

        #10;

        $display("");
        $display("Prueba 1 - Sin error");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        // --------------------------------------------------
        // PRUEBA 2: ERROR EN POSICION 1
        // --------------------------------------------------

        palabra_rx  = 7'b1010100;
        paridad_mal = 1'b1;
        sindrome    = 3'b001;

        #10;

        $display("");
        $display("Prueba 2 - Error en posicion 1");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        // --------------------------------------------------
        // PRUEBA 3: ERROR EN POSICION 2
        // --------------------------------------------------

        palabra_rx  = 7'b1010111;   
        paridad_mal = 1'b1;
        sindrome    = 3'b010;

        #10;

        $display("");
        $display("Prueba 3 - Error en posicion 2");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        // --------------------------------------------------
        // PRUEBA 4: ERROR EN POSICION 3
        // --------------------------------------------------

        palabra_rx  = 7'b1010001;
        paridad_mal = 1'b1;
        sindrome    = 3'b011;

        #10;

        $display("");
        $display("Prueba 4 - Error en posicion 3");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        // --------------------------------------------------
        // PRUEBA 5: ERROR EN POSICION 4
        // --------------------------------------------------

        palabra_rx  = 7'b1011101;
        paridad_mal = 1'b1;
        sindrome    = 3'b100;

        #10;

        $display("");
        $display("Prueba 5 - Error en posicion 4");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        // --------------------------------------------------
        // PRUEBA 6: ERROR EN POSICION 5
        // --------------------------------------------------

        palabra_rx  = 7'b1000101;
        paridad_mal = 1'b1;
        sindrome    = 3'b101;

        #10;

        $display("");
        $display("Prueba 6 - Error en posicion 5");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        // --------------------------------------------------
        // PRUEBA 7: ERROR EN POSICION 6
        // --------------------------------------------------

        palabra_rx  = 7'b1110101;
        paridad_mal = 1'b1;
        sindrome    = 3'b110;

        #10;

        $display("");
        $display("Prueba 7 - Error en posicion 6");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        // --------------------------------------------------
        // PRUEBA 8: ERROR EN POSICION 7
        // --------------------------------------------------

        palabra_rx  = 7'b0010101;
        paridad_mal = 1'b1;
        sindrome    = 3'b111;

        #10;

        $display("");
        $display("Prueba 8 - Error en posicion 7");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        // --------------------------------------------------
        // PRUEBA 9: DOBLE ERROR
        // --------------------------------------------------

        palabra_rx  = 7'b1100101;
        paridad_mal = 1'b0;
        sindrome    = 3'b011;

        #10;

        $display("");
        $display("Prueba 9 - Doble error");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        // --------------------------------------------------
        // PRUEBA 10: ERROR SOLO EN PARIDAD GLOBAL
        // --------------------------------------------------

        palabra_rx  = 7'b1010101;
        paridad_mal = 1'b1;
        sindrome    = 3'b000;

        #10;

        $display("");
        $display("Prueba 10 - Error en paridad global");
        $display("Palabra RX     : %b", palabra_rx);
        $display("Paridad mal    : %b", paridad_mal);
        $display("Sindrome       : %b", sindrome);
        $display("Datos correg.  : %b", datos_corregidos);
        $display("DED            : %b", DED);


        $display("");
        $display("==============================================");
        $display("              FIN DE SIMULACION :DD");
        $display("==============================================");

        $finish;
    end

endmodule
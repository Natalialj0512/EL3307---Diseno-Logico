`timescale 1ns/1ps

module top_tb;

    // ENTRADAS DEL TOP
    

    reg modo_pi;
    reg display_pi;

    reg [3:0] codigo_bin_pi;

    reg [2:0] error_pos1_pi;
    reg [2:0] error_pos2_pi;

    reg c0_pi;
    reg c1_pi;
    reg c2_pi;
    reg p_pi;


    // ========================================================
    // BUS BIDIRECCIONAL
    // ========================================================

    tri [7:0] datos_io;

    // Datos que simulan la otra FPGA, para poder respresntar bien el receptor y el transmisor
    reg [7:0] datos_externos;

    // 1 = la FPGA externa conduce el bus
    // 0 = la FPGA externa libera el bus
    reg habilitar_externo;


    // SALIDAS DEL TOP
    

    wire [6:0] catodo_po;
    wire dig1_po;
    wire dig2_po;
    wire dot_po;


    wire [3:0] palabra_pi_d;
    // ========================================================
    // DRIVER EXTERNO DEL BUS
    // ========================================================

    assign datos_io = habilitar_externo ?
                      datos_externos :
                      8'bz;


    // ========================================================
    // INSTANCIA DEL TOP
    // ========================================================

    top DUT (

        .modo_pi(modo_pi),
        .display_pi(display_pi),

        .codigo_bin_pi(codigo_bin_pi),

        .error_pos1_pi(error_pos1_pi),
        .error_pos2_pi(error_pos2_pi),

        .c0_pi(c0_pi),
        .c1_pi(c1_pi),
        .c2_pi(c2_pi),
        .p_pi(p_pi),

        .datos_io(datos_io),
        .palabra_pi_d(palabra_pi_d),

        .catodo_po(catodo_po),
        .dig1_po(dig1_po),
        .dig2_po(dig2_po),

        .dot_po(dot_po)
    );


    // ========================================================
    // PRUEBAS :p (son 5 pruebas en total de 5 diferentes casos)
    // ========================================================


    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end


    initial begin

        // ----------------------------------------------------
        // VALORES INICIALES (son los valores que se usaran para las pruebas)
        // ----------------------------------------------------

        modo_pi = 1'b0;
        display_pi = 1'b0;

        codigo_bin_pi = 4'b1010;

        error_pos1_pi = 3'b000;
        error_pos2_pi = 3'b000;

        c0_pi = 1'b0;
        c1_pi = 1'b1;
        c2_pi = 1'b0;
        p_pi  = 1'b1;

        datos_externos = 8'b00000000;
        habilitar_externo = 1'b0;

        #10;


        // ====================================================
        // PRUEBA 1
        // TRANSMISOR SIN ERROR
        // ====================================================

        $display("==============================================");
        $display("PRUEBA 1 - TRANSMISOR SIN ERROR");
        $display("==============================================");

        modo_pi = 1'b0;

        error_pos1_pi = 3'b000;
        error_pos2_pi = 3'b000;

        #10;

        $display("Codigo de entrada : %b", codigo_bin_pi);
        $display("Datos en el bus   : %b", datos_io);
        $display("Esperado          : 11010010");
        $display("==============================================");



        // ====================================================
        // PRUEBA 2
        // TRANSMISOR CON UN ERROR EN POSICION 3
        // ====================================================

        $display("");
        $display("==============================================");
        $display("PRUEBA 2 - TRANSMISOR CON ERROR EN POSICION 3");
        $display("==============================================");

        modo_pi = 1'b0;

        error_pos1_pi = 3'b011;
        error_pos2_pi = 3'b000;

        #1000;

        $display("Palabra original    : 11010010");
        $display("Palabra con error   : %b", datos_io);
        $display("Esperado con error  : 11010110");
        $display("Bit invertido       : posicion Hamming %0d (indice %0d)",
                 error_pos1_pi, error_pos1_pi - 1);
        $display("Palabra corregida   : %b", palabra_pi_d);
        $display("Esperado corregida  : 1010");
        $display("==============================================");



        // ====================================================
        // PRUEBA 3
        // RECEPTOR SIN ERROR
        // ====================================================

        $display("");
        $display("==============================================");
        $display("PRUEBA 3 - RECEPTOR SIN ERROR");
        $display("==============================================");

        // El TOP deja de conducir el bus
        modo_pi = 1'b1;

        // La FPGA externa transmite D2
        datos_externos = 8'b11010010;
        habilitar_externo = 1'b1;

        // Mostrar palabra recibida
        display_pi = 1'b0;

        #10;

        $display("Datos recibidos : %b", datos_io);
        $display("Palabra recibida: %b",
                 {datos_io[6], datos_io[5],
                  datos_io[4], datos_io[2]});

        $display("Paridad mal     : %b", DUT.paridad_mal);
        $display("Sindrome        : %b", DUT.sindrome);
        $display("DED             : %b", DUT.DED);

        $display("Esperado palabra: 1010");
        $display("Esperado sindrome: 000");
        $display("Esperado DED     : 0");
        $display("==============================================");



        // ====================================================
        // PRUEBA 4
        // RECEPTOR CON UN ERROR EN POSICION 3
        // ====================================================

        $display("");
        $display("==============================================");
        $display("PRUEBA 4 - RECEPTOR CON UN ERROR");
        $display("==============================================");

        // D2 con error en posicion Hamming 3
        datos_externos = 8'b11010110;

        modo_pi = 1'b1;

        // Primero mostrar palabra recibida
        display_pi = 1'b0;

        #10;

        $display("Datos recibidos : %b", datos_io);

        $display("Palabra recibida: %b",
                 {datos_io[6], datos_io[5],
                  datos_io[4], datos_io[2]});

        $display("Paridad mal     : %b", DUT.paridad_mal);
        $display("Sindrome        : %b", DUT.sindrome);
        $display("Datos corregidos: %b", DUT.datos_corregidos);
        $display("DED             : %b", DUT.DED);

        $display("Esperado sindrome: 011");
        $display("Esperado DED     : 0");



        // Ahora mostrar el sindrome
        display_pi = 1'b1;

        #10;

        $display("Display cambiado a SINDROME");
        $display("==============================================");



        // ====================================================
        // PRUEBA 5
        // RECEPTOR CON DOS ERRORES
        // ====================================================

        $display("");
        $display("==============================================");
        $display("PRUEBA 5 - RECEPTOR CON DOS ERRORES");
        $display("==============================================");

        // D2 = 11010010
        // Errores en posiciones 3 y 5
        // Resultado = 11000110

        datos_externos = 8'b11000110;

        modo_pi = 1'b1;
        display_pi = 1'b1;

        #10;

        $display("Datos recibidos : %b", datos_io);
        $display("Paridad mal     : %b", DUT.paridad_mal);
        $display("Sindrome        : %b", DUT.sindrome);
        $display("DED             : %b", DUT.DED);
        $display("DOT             : %b", dot_po);

        $display("Esperado sindrome: 110");
        $display("Esperado DED     : 1");
        $display("==============================================");



        #20;

        habilitar_externo = 1'b0;

        $display("");
        $display("==============================================");
        $display("FIN DE LA SIMULACION :DD");
        $display("==============================================");

        $finish;

    end

endmodule
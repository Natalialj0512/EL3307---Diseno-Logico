`timescale 1ns/1ps

module binario_7seg_tb;

    // Entradas del DUT
    reg [3:0] codigo_bin_pi;

    // Salidas del DUT
    wire [6:0] catodo_po;

    // Instancia del módulo bajo prueba
    binario_7seg DUT (
        .codigo_bin_pi(codigo_bin_pi),
        .catodo_po(catodo_po)
    );

    // Archivo de ondas
    initial begin
        $dumpfile("binario_7seg.vcd");
        $dumpvars(0, binario_7seg_tb);
    end

    // Pruebas
    initial begin

        // 0
        codigo_bin_pi = 4'd0;
        #10;
        if (catodo_po != 7'b1000000)
            $display("ERROR: entrada 0, salida = %b, esperada = 1000000", catodo_po);

        // 1
        codigo_bin_pi = 4'd1;
        #10;
        if (catodo_po != 7'b1111011)
            $display("ERROR: entrada 1, salida = %b, esperada = 1111011", catodo_po);

        // 2
        codigo_bin_pi = 4'd2;
        #10;
        if (catodo_po != 7'b0100100)
            $display("ERROR: entrada 2, salida = %b, esperada = 0100100", catodo_po);

        // 3
        codigo_bin_pi = 4'd3;
        #10;
        if (catodo_po != 7'b0110000)
            $display("ERROR: entrada 3, salida = %b, esperada = 0110000", catodo_po);

        // 4
        codigo_bin_pi = 4'd4;
        #10;
        if (catodo_po != 7'b0011001)
            $display("ERROR: entrada 4, salida = %b, esperada = 0011001", catodo_po);

        // 5
        codigo_bin_pi = 4'd5;
        #10;
        if (catodo_po != 7'b0010010)
            $display("ERROR: entrada 5, salida = %b, esperada = 0010010", catodo_po);

        // 6
        codigo_bin_pi = 4'd6;
        #10;
        if (catodo_po != 7'b0000010)
            $display("ERROR: entrada 6, salida = %b, esperada = 0000010", catodo_po);

        // 7
        codigo_bin_pi = 4'd7;
        #10;
        if (catodo_po != 7'b1111000)
            $display("ERROR: entrada 7, salida = %b, esperada = 1111000", catodo_po);

        // 8
        codigo_bin_pi = 4'd8;
        #10;
        if (catodo_po != 7'b0000000)
            $display("ERROR: entrada 8, salida = %b, esperada = 0000000", catodo_po);

        // 9
        codigo_bin_pi = 4'd9;
        #10;
        if (catodo_po != 7'b0010000)
            $display("ERROR: entrada 9, salida = %b, esperada = 0010000", catodo_po);

        // A
        codigo_bin_pi = 4'd10;
        #10;
        if (catodo_po != 7'b0001000)
            $display("ERROR: entrada A, salida = %b, esperada = 0001000", catodo_po);

        // B
        codigo_bin_pi = 4'd11;
        #10;
        if (catodo_po != 7'b0000011)
            $display("ERROR: entrada B, salida = %b, esperada = 0000011", catodo_po);

        // C
        codigo_bin_pi = 4'd12;
        #10;
        if (catodo_po != 7'b1000110)
            $display("ERROR: entrada C, salida = %b, esperada = 1000110", catodo_po);

        // D
        codigo_bin_pi = 4'd13;
        #10;
        if (catodo_po != 7'b0100001)
            $display("ERROR: entrada D, salida = %b, esperada = 0100001", catodo_po);

        // E
        codigo_bin_pi = 4'd14;
        #10;
        if (catodo_po != 7'b0000110)
            $display("ERROR: entrada E, salida = %b, esperada = 0000110", catodo_po);

        // F
        codigo_bin_pi = 4'd15;
        #10;
        if (catodo_po != 7'b0001110)
            $display("ERROR: entrada F, salida = %b, esperada = 0001110", catodo_po);

        $finish;

    end

endmodule
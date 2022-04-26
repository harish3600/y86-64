`timescale 1ns/1ps

module SUB_64_test;

    parameter n = 64;
    reg signed[n-1:0] a,b;
    wire signed[n-1:0] diff;

    SUB_64 s1(diff, a, b);

    genvar i;

    initial begin

        $dumpfile("SUB_64_test.vcd");
        $dumpvars(0, SUB_64_test);

         a = 999999999;
         b = 12345;
         #100;
        $display("%d - %d = %d", a, b, diff);
        
         a = 10;
         b = 3;
         #1000;
        
        $display("%d - %d = %d", a, b,diff);

         a = 3;
         b = 10;
         #100;
        
        $display("%d - %d = %d", a, b,diff);

         a = 3;
         b = 0;
         #100;
        
        $display("%d - %d = %d", a, b,diff);


        $display("Test Completed");
    end

endmodule
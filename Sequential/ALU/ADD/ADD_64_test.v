`timescale 1ns/1ps

module ADD_64_test;

    parameter n = 64;
    reg signed[n-1:0] a,b;
    wire signed[n-1:0] sum, carry;

    ADD_64 a1(sum, carry, a, b);

    initial begin

        $dumpfile("ADD_64_test.vcd");
        $dumpvars(0, ADD_64_test);

         a = 999999999;
         b = 12345;
         #100;
        $display("%d + %d = %d %d", a, b,carry[n-1], sum);
        $display("Test Completed");
        
         a = 10;
         b = 3;
         #100;
        $display("%d + %d = %d %d", a, b,carry[n-1], sum);
        $display("Test Completed");
        
    end

endmodule
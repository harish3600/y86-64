`timescale 1ns/1ps
`include "XOR_1.v"

module XOR_64_test;

    parameter n = 64;
    reg[n-1:0] a,b;
    wire[n-1:0] out;

    XOR_64 x1(out, a, b);

    initial begin

        $dumpfile("XOR_64_test.vcd");
        $dumpvars(0, XOR_64_test);

         a = 10; //1010
         b = 3; //0011
         #100;

        
        $display("%b XOR %b = %b", a, b,out);
        $display("Test Completed");
    end

    
endmodule
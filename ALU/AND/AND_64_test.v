`timescale 1ns/1ps

module AND_64_test;

    parameter n = 64;
    reg[n-1:0] a,b;
    wire[n-1:0] out;

    AND_64 a1(out, a, b);

    genvar i;
    initial begin

        $dumpfile("AND_64_test.vcd");
        $dumpvars(0, AND_64_test);

         a = 4;
         b = 4;
         #100;
        $display("%b & %b = %b", a, b, out);
        $display("Test Completed");

    end

endmodule
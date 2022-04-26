`timescale 1ns/1ps

module NOT_64_test;

    parameter n = 64;
    reg signed[n-1:0] a;
    wire signed[n-1:0] out;

    NOT_64 n1(out, a);

    initial begin

        $dumpfile("NOT_64_test.vcd");
        $dumpvars(0, NOT_64_test);

        a = 4; #100;
        $display("%b , %b", a, out);
        $display("Test Completed");

        //  a = 64'b1111111111111111111111111111111111111111111111111111111111111111;
        //  b = 64'b1111111111111111111111111111111111111111111111111111111111111111;
        //  #100;
        // $display("%d + %d = %d %d", a, b,carry[n-1], sum);
        // $display("Test Completed");
        
        //  a = 10;
        //  b = 3;
        //  #100;
        
        // $display("%d + %d = %d %d", a, b,carry[n-1], sum);
        // $display("Test Completed");
    end

endmodule


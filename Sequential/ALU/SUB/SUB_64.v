`timescale 1ns/1ps

// 64 bit subtractor using 2s complement
module SUB_64(diff, a,b);

    parameter n = 64;
    input signed[n-1:0] a,b;
    output signed[n-1:0] diff;

    wire signed[n-1: 0] b1; // 1s completement of b
    wire signed[n-1: 0] b2; // 2s comp of b
    wire signed[n-1: 0] dummy; // random dummy variables
    wire signed[n-1: 0] dummy2;

    NOT_64 g1(b1, b); // generating the 1s complement using 64 bit NOT operation
    ADD_64 g2(b2, dummy, b1, 64'b1); // generating 2s complement by adding 1 to the 1s complement using 64 bit adder

    ADD_64 g3(diff , dummy2, a, b2); // adding the 2s complement to a in order to obtain a - b

endmodule
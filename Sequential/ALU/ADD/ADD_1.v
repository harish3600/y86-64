`timescale 1ns/1ps

// 1 bit adder
module ADD_1(sum, carry, a,b, cin);

    input signed a,b, cin;
    output signed sum;
    output carry;

    wire p1, p2, p3, p4, p5;

    //SUM
    xor xg1(sum, a, b, cin);

    //CARRY
    and ag1(p2, a, b);
    and ag2(p3, b, cin);
    and ag3(p4, a, cin);

    or og1(carry, p2, p3, p4);
    
endmodule

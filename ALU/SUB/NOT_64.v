`timescale 1ns/1ps

// 64 bit NOT operation
module NOT_64(out, a);

    parameter n = 64;
    input signed[n-1:0] a;
    output signed[n-1:0] out;

    genvar i ;
    generate // Using generate statement to instantiate NOT gate 64 times to implement the 64 bit NOT operation
        for(i = 0; i<n; i =  i + 1)
        begin
            not n1(out[i], a[i]);
        end    
    endgenerate
    
endmodule
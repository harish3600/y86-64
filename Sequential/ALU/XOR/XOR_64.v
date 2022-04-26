`timescale 1ns/1ps

// 64 bit XOR operation
module XOR_64(out, a,b);

    parameter n = 64;
    input signed[n-1:0] a,b;
    output signed[n-1:0] out;

    genvar i;
    generate // Using generate statement to instantiate XOR gate 64 times to implement the 64 bit XOR operation
        for(i = 0; i<n; i = i+1)
        begin
            xor f(out[i], a[i], b[i]);
        end    
    endgenerate

endmodule
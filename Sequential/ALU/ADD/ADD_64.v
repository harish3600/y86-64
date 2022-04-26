`timescale 1ns/1ps

// 64 bit adder using the 1 bit adder
module ADD_64(sum, carry, a,b);

    parameter n = 64;
    input signed [n-1:0] a,b;
    output signed [n-1:0] sum, carry;

    genvar i;
    generate // Using generate statement to generate 64 instances of the 1 bit adder in order to implement the 64 bit adder
        for(i = 0; i<n; i = i+1)
        begin
            if(i == 0)
                begin
                    ADD_1 f(sum[0], carry[0], a[0], b[0], 1'b0);
                end
            else
                begin
                    ADD_1 f(sum[i], carry[i], a[i], b[i], carry[i-1]);
                end
        end    
    endgenerate
    
endmodule
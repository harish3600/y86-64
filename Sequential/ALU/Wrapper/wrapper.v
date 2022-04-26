`timescale 1ns/1ps

// Include the required modules
`include "./ALU/SUB/SUB_64.v"
`include "./ALU/AND/AND_64.v"
`include "./ALU/XOR/XOR_64.v"
`include "./ALU/ADD/ADD_64.v"
`include "./ALU/ADD/ADD_1.v"
`include "./ALU/SUB/NOT_64.v"

module wrapper(result, carry, x, y, control);

    // Define the various inputs, outputs and parameters
    parameter n = 64;
    
    input signed[n-1:0] x, y;
    input signed[2:0] control;
    output signed[n-1:0] result, carry;
    
    wire signed[n-1:0] result1, result2, result3, result4;
    reg signed[n-1:0] net;

    // Initialize all the modules and store the outputs in separate variables
    ADD_64 g1(result1, carry, x,y);   
    SUB_64 g2(result2, x,y); 
    AND_64 g3(result3, x,y);
    XOR_64 g4(result4, x,y);

    always @(*)
    begin
        case(control) // case statement to conditionally assign net register to the correct operation output (Kind of like a MUX)
            0: net = result1;
            1: net = result2;
            2: net = result3;
            3: net = result4;
        endcase
    end 

    assign result = net; // assign final result as the value stored in net register

endmodule
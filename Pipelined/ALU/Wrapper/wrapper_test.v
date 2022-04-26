`timescale 1ns/1ps

module wrapper_test;

    // Define the various inputs, outputs and parameters
    parameter n = 64; 
    reg signed[2:0] control; // Main control input which specifies the operation to be carried out
    reg signed[n-1:0] x, y;
    wire signed[n-1:0] result, carry;
    integer i, j;

    wrapper g1(result, carry,x,y, control); // Call the wrapper module

    initial begin

        $dumpfile("wrapper_test.vcd");
        $dumpvars(0, wrapper_test);

        for (i = 0; i < 4; i = i + 1) // Iterate through the loop to generate testcases
            begin

                control = i; #10;
                $display("\n---------- Control = %0d ----------\n", control);

                for (j = 0; j < 8; j = j + 1)
                    begin
                        x = j;
                        y = 8 - j;
                        #5;

                        case(control) // case statement to conditionally print the correct message based on the operation (Kind of like a MUX)
                            0: $display("%0d + %0d = %0d %0d",x,y,carry[n-1], result);
                            1: $display("%0d - %0d = %0d",x,y,result);
                            2: $display("%b & %b = %b", x, y, result);
                            3: $display("%b ^ %b = %b",x,y,result);
                            default: $display("Invalid");
                        endcase

                    end
            end       
    end

endmodule
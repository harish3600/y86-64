`timescale 1ps/1ps

module memory_test;

    parameter n = 64;
    reg clk;
    reg [3:0] icode;
    reg [n-1:0] valA, valB, valE, valP;
    wire [n-1:0] valM;
    wire [n-1:0] memadr;

    integer i;

    memory m1(clk, icode, valA, valB, valE, valP, valM, memadr);

    initial begin

        clk = 1; #10;
        clk = ~clk; #10;

        for (i=4; i<12; i=i+1)
        begin
            if (i != 6 && i != 7)
            begin
                icode = i;
                valE = 10 + i;
                valA = 25 + i;
                valB = 20 + i;
                valP = 32 + i;
                #100;

                clk = ~clk; #10;
                clk = ~clk; #10;

                $display("%0d \t %0d", valM, memadr);                
            end
        end

    end

endmodule
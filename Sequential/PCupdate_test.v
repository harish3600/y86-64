`timescale 1ps/1ps

module PCupdate_test;

    parameter n = 64;
    reg clk;
    reg jmpcnd;
    reg [3:0] icode;
    reg [n-1:0] valP, valC, valM;
    wire [n-1:0] PC;

    PCupdate m1(clk, icode, valP, valC, valM, jmpcnd, PC);

    integer i;

    initial begin

        clk = 1; #10;
        clk = ~clk; #10;

        for (i=0; i<12; i=i+1)
        begin
            icode = i;
            valP = PC + i;
            if (i==0)
            begin
                valP = 5;
            end
            valC = 25 + i;
            valM = 32 + i;
            jmpcnd = 1;
            #100;

            clk = ~clk; #10;
            clk = ~clk; #10;

            $display("%0d %0d", PC, valP);                
        end

    end

endmodule
`timescale 1ps/1ps

module execute_test;

    reg clk;
    reg [3:0] icode;
    reg [3:0] ifun;
    reg signed [63:0] valA;
    reg signed [63:0] valB;
    reg signed [63:0] valC;

    wire signed [63:0] valE;

    wire [2:0] cnd; // cnd takes values in CC[0/1/2]
    wire jumcnd;

    execute g1(clk, icode, ifun, valA, valB, valC, valE, cnd, jmpcnd);

    initial begin
        
        clk = 1; #10;
        clk = ~clk; #10;

        icode = 6;
        ifun = 0;
        valA = 25; 
        // valB = 9223372036854775807; // Overflow case
        valB = 20;
        valC = 1;
        #100;

        clk = ~clk; #10;
        clk = ~clk; #10;

        $display("%0d \t %0d \t = \t %0d, \t %b", valA, valB, valE, cnd);

        icode = 2;
        ifun = 6;
        valA = 15; 
        valB = 20;
        valC = 1;
        #100;

        clk = ~clk; #10;
        clk = ~clk; #10;

        $display("%0d \t %0d, \t %b", valA, valE, cnd);

        icode = 7;
        ifun = 6;
        valA = 15; 
        valB = 20;
        valC = 1;
        #100;

        clk = ~clk; #10;
        clk = ~clk; #10;

        $display("%b \t %b", jmpcnd, cnd);

    end

endmodule
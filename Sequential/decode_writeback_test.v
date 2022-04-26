`timescale 1ns/1ps

module decode_writeback_test; // Ask TA why some things work while others don't

    parameter n = 64;
    reg clk;
    reg [3:0] icode;
    reg [3:0] rA, rB;
    reg [n-1:0] valE, valM;

    wire [n-1:0] valA, valB;

    integer j;

    decode_writeback m1(clk, icode, rA, rB, valE, valM, valA, valB);

    initial begin
    
        $dumpfile("decode_writeback_test.vcd");
        $dumpvars(0, decode_writeback_test);

        clk = 1; #10;
        clk = ~clk; #10;

        valE = 500;
        valM = 501;

        icode = 10;
        rA = 5;
        rB = 3;
        #10;

        clk = ~clk; #10; // Posedge
        clk = ~clk; #10; // Negedge

        $display("%0d %0d %0d %0d", valA, valB, valE, valM);

        valE = 250;
        valM = 251;

        icode = 11;
        rA = 7;
        rB = 2;

        clk = ~clk; #10; // Posedge
        clk = ~clk; #10; // Negedge

        $display("%0d %0d %0d %0d", valA, valB, valE, valM);

    end

endmodule
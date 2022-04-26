`timescale 1ns/1ps

module fetch_test;

    parameter n = 64;
    reg clk;
    reg [n-1:0] PC;
    wire [3:0] icode, ifun;
    wire [3:0] rA, rB;
    wire [n-1:0] valC;
    wire [n-1:0] valP;
    wire instr_valid;
    wire imem_error;
    wire halt;

    integer i;

    fetch m1(clk, PC, icode, ifun, rA, rB, valC, valP, instr_valid, imem_error, halt);

    initial begin

        $dumpfile("fetch_test.vcd");
        $dumpvars(0, fetch_test);

        $display("clk \t PC \t icode \t ifun \t rA \t rB \t valC \t valP \t instr_valid \t imem_error \t halt\n");

        clk = 0; #100;
        clk = ~clk;
        PC = 0; #100;

        for (i = 0; i<10; i = i + 1)
        begin
            clk = ~clk; #100;
            $display("%0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d", clk, PC, icode, ifun, rA, rB, valC, valP, instr_valid, imem_error, halt);
            PC = valP; #10;
        end
        
    end

endmodule
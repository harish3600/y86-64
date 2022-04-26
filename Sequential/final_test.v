`timescale 1ps/1ps

`include "fetch.v"
`include "decode_writeback.v"
`include "execute.v"
`include "memory.v"
`include "PCupdate.v"

module final_test;

    parameter n = 64;
    reg clk;
    reg [n-1:0] PC;
    wire [3:0] icode, ifun;
    wire [3:0] rA, rB;
    wire signed [n-1:0] valC;
    wire [n-1:0] valP;
    wire instr_valid;
    wire imem_error;
    wire halt;
    wire signed [n-1:0] valE, valM;
    wire signed [n-1:0] valA, valB;
    wire jmpcnd;
    wire [n-1:0] memadr;
    wire [2:0] cnd;
    wire [n-1:0] PC_new;

    fetch m1(
        .clk(clk),
        .PC(PC),
        .icode(icode),
        .ifun(ifun),
        .rA(rA),
        .rB(rB),
        .valC(valC),
        .valP(valP),
        .instr_valid(instr_valid),
        .imem_error(imem_error),
        .halt(halt));

    decode_writeback m2(
        .clk(clk),
        .icode(icode),
        .rA(rA),
        .rB(rB),
        .valE(valE),
        .valM(valM),
        .valA(valA),
        .valB(valB));

    execute m3(
        .clk(clk),
        .icode(icode),
        .ifun(ifun),
        .valA(valA),
        .valB(valB),
        .valC(valC),
        .valE(valE),
        .cnd(cnd),
        .jmpcnd(jmpcnd));

    memory m4(
        .clk(clk),
        .icode(icode),
        .valA(valA),
        .valB(valB),
        .valE(valE),
        .valP(valP),
        .valM(valM),
        .memadr(memadr));

    PCupdate m5(
        .clk(clk),
        .icode(icode),
        .valP(valP),
        .valC(valC),
        .valM(valM),
        .jmpcnd(jmpcnd),
        .PC_new(PC_new));
    
    initial begin

        $dumpfile("final_test.vcd");
		$dumpvars(0,final_test);
        
        clk = 0;
        PC = 1;
    end

    always #500 clk = ~clk;

    always @(*)
        begin
            PC = PC_new; // AOK
        end

    initial begin

        $display("clk \t PC \t icode \t ifun \t rA \t rB \t valA \t valB \t valC \t valP \t valM \t valE \t instr_valid \t imem_error \t halt \t jmpcnd \t cnd \t memadr");
        $monitor("%0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %b \t %0d", clk, PC, icode, ifun, rA, rB, valA, valB, valC, valP, valM, valE, instr_valid, imem_error, halt, jmpcnd, cnd, memadr);

    end

    always @(*)
    begin
        if (halt == 1) // HLT
            begin
                $finish;
            end
        if (instr_valid == 0) // INS
            begin
                $finish;
            end
        if (imem_error == 1) // ADR
            begin
                $finish;
            end
    end


endmodule
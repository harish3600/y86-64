`timescale 1ps/1ps

`include "fetch_pipe.v"
`include "decode_writeback_pipe.v"
`include "execute_pipe.v"
`include "memory_pipe.v"
`include "f_pipereg.v"
`include "d_pipereg.v"
`include "e_pipereg.v"
`include "m_pipereg.v"
`include "w_pipereg.v"

module final_test_pipe;

    parameter n = 64;
    reg clk;
    wire [n-1:0] f_PC;
    reg [n-1:0] predPC; 
    wire [3:0] f_icode, f_ifun;
    wire [3:0] f_rA, f_rB;
    wire [n-1:0] f_valC;
    wire [n-1:0] f_valP;
    wire instr_valid;
    wire imem_error;
    wire halt;
    wire [3:0] d_icode, d_ifun;
    wire [3:0] d_rA, d_rB;
    wire [n-1:0] d_valC;
    wire [n-1:0] d_valP;
    wire [n-1:0] d_valA;
    wire [n-1:0] d_valB;
    wire [3:0] e_icode, e_ifun;
    wire [3:0] e_rA;
    wire [3:0] e_rB;
    wire [n-1:0] e_valA;
    wire [n-1:0] e_valB;
    wire [n-1:0] e_valC;
    wire [n-1:0] e_valP;
    wire [n-1:0] e_valE;
    wire [3:0] m_icode, m_ifun;
    wire [3:0] m_rA;
    wire [3:0] m_rB;
    wire [n-1:0] m_valA;
    wire [n-1:0] m_valB;
    wire [n-1:0] m_valC;
    wire [n-1:0] m_valP;
    wire [n-1:0] m_valE;
    wire [n-1:0] m_valM;
    wire [3:0] w_icode, w_ifun;
    wire [3:0] w_rA;
    wire [3:0] w_rB;
    wire [n-1:0] w_valA;
    wire [n-1:0] w_valB;
    wire [n-1:0] w_valC;
    wire [n-1:0] w_valP;
    wire [n-1:0] w_valE;
    wire [n-1:0] w_valM;
    wire jmpcnd;
    wire [2:0] cnd;
    wire [n-1:0] memadr;

    fetch_pipe m1(clk, f_PC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, instr_valid, imem_error, halt);
    decode_writeback_pipe m2(clk, d_icode, d_rA, d_rB, w_valE, w_valM, d_valA, d_valB, e_rA, e_rB, m_rA, m_rB, w_rA, w_rB, e_valE, m_valE, m_valM);
    execute_pipe m3(clk, e_icode, e_ifun, e_valA, e_valB, e_valC, e_valE, cnd, e_jmpcnd);
    memory_pipe m4(clk, m_icode, m_ifun, m_valB, m_valE, m_valP, m_valM, memadr);

    f_pipereg m6(clk, f_icode, f_valP, f_valC, m_icode, jmpcnd, m_valA, w_icode, w_valM, f_PC);
    d_pipereg m7(clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, d_icode, d_ifun, d_rA, d_rB, d_valC, d_valP);
    e_pipereg m8(clk, d_icode, d_ifun, d_rA, d_rB, d_valC, d_valP, d_valA, d_valB, e_icode, e_ifun, e_rA, e_rB, e_valC, e_valP, e_valA, e_valB);
    m_pipereg m9(clk, e_icode, e_ifun, e_rA, e_rB, e_valC, e_valP, e_valA, e_valB, e_valE, m_icode, m_ifun, m_rA, m_rB, m_valC, m_valP, m_valA, m_valB, m_valE);
    w_pipereg m10(clk, m_icode, m_ifun, m_rA, m_rB, m_valC, m_valP, m_valA, m_valB, m_valE, m_valM, w_icode, w_ifun, w_rA, w_rB, w_valC, w_valP, w_valA, w_valB, w_valE, w_valM);
    
    
    initial begin

        $dumpfile("final_test_pipe.vcd");
		$dumpvars(0,final_test_pipe);
        
        clk = 0;
    end

    always #500 clk = ~clk;

    // always @(*)
    //     begin
    //         assign f_PC = predPC; // AOK
    //     end

    initial begin

        $display("CLK \t f_PC \t f_icode \t d_icode \t e_icode \t m_icode \t w_icode");
        $monitor("%0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d", clk, f_PC, f_icode, d_icode, e_icode, m_icode, w_icode);
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
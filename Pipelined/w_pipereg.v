`timescale 1ps/1ps

module w_pipereg(clk, m_icode, m_ifun, m_rA, m_rB, m_valC, m_valP, m_valA, m_valB, m_valE, m_valM, w_icode, w_ifun, w_rA, w_rB, w_valC, w_valP, w_valA, w_valB, w_valE, w_valM);

    parameter n = 64;
    input clk;
    input [3:0] m_icode, m_ifun;
    input [3:0] m_rA;
    input [3:0] m_rB;
    input [n-1:0] m_valA;
    input [n-1:0] m_valB;
    input [n-1:0] m_valC;
    input [n-1:0] m_valP;
    input [n-1:0] m_valE;
    input [n-1:0] m_valM;
    output reg [3:0] w_icode, w_ifun;
    output reg [3:0] w_rA;
    output reg [3:0] w_rB;
    output reg [n-1:0] w_valA;
    output reg [n-1:0] w_valB;
    output reg [n-1:0] w_valC;
    output reg [n-1:0] w_valP;
    output reg [n-1:0] w_valE;
    output reg [n-1:0] w_valM;

    always @(posedge clk) 
    begin
    w_icode <= m_icode;
    w_ifun <= m_ifun;
    w_rA <= m_rA;
    w_rB <= m_rB;
    w_valC <= m_valC;
    w_valP <= m_valP;
    w_valA <= m_valA;
    w_valB <= m_valB;
    w_valE <= m_valE;
    w_valM <= m_valM;
    end

endmodule

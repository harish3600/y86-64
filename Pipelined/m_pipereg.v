`timescale 1ps/1ps

module m_pipereg(clk, e_icode, e_ifun, e_rA, e_rB, e_valC, e_valP, e_valA, e_valB, e_valE, m_icode, m_ifun, m_rA, m_rB, m_valC, m_valP, m_valA, m_valB, m_valE);

    parameter n = 64;
    input clk;
    input [3:0] e_icode, e_ifun;
    input [3:0] e_rA;
    input [3:0] e_rB;
    input [n-1:0] e_valA;
    input [n-1:0] e_valB;
    input [n-1:0] e_valC;
    input [n-1:0] e_valP;
    input [n-1:0] e_valE;
    output reg [3:0] m_icode, m_ifun;
    output reg [3:0] m_rA;
    output reg [3:0] m_rB;
    output reg [n-1:0] m_valA;
    output reg [n-1:0] m_valB;
    output reg [n-1:0] m_valC;
    output reg [n-1:0] m_valP;
    output reg [n-1:0] m_valE;

    always @(posedge clk)  
    begin
    m_icode <= e_icode;
    m_ifun <= e_ifun;
    m_rA <= e_rA;
    m_rB <= e_rB;
    m_valC <= e_valC;
    m_valP <= e_valP;
    m_valA <= e_valA;
    m_valB <= e_valB;
    m_valE <= e_valE;
    end

endmodule

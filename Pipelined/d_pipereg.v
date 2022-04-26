`timescale 1ps/1ps

module d_pipereg(clk, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, d_icode, d_ifun, d_rA, d_rB, d_valC, d_valP);

    parameter n = 64;
    input clk;
    input [3:0] f_icode, f_ifun;
    input [3:0] f_rA, f_rB;
    input [n-1:0] f_valC;
    input [n-1:0] f_valP;
    output reg [3:0] d_icode, d_ifun;
    output reg [3:0] d_rA, d_rB;
    output reg [n-1:0] d_valC;
    output reg [n-1:0] d_valP;

    always @(posedge clk) 
    begin
        d_icode <= f_icode;
        d_ifun <= d_ifun;
        d_rA <= f_rA;
        d_rB <= f_rB;
        d_valC <= f_valC;
        d_valP <= f_valP;
    end

endmodule

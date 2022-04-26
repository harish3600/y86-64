`timescale 1ns/1ps
`include "ALU/Wrapper/wrapper.v"

module execute_pipe(clk, e_icode, e_ifun, e_valA, e_valB, e_valC, e_valE, cnd, e_jmpcnd);

    input clk;
    input [3:0] e_icode;
    input [3:0] e_ifun;
    input signed[63:0] e_valA;
    input signed[63:0] e_valB;
    input signed [63:0] e_valC;

    output reg signed [63:0] e_valE;
    output reg e_jmpcnd;

    wire [63:0] carry;
    wire signed [63:0] result1, result2, result3, result4;

    reg CC[0:2];
    /*
        ZF = CC[0]
        SF = CC[1]
        OF = CC[2]
    */
    initial begin
        CC[0] = 0;
        CC[1] = 0;
        CC[2] = 0;
        #10;
    end

    output reg [2:0] cnd; // cnd takes values in CC[0/1/2]

    wrapper m1(result1, carry, e_valA, e_valB, 3'd0);
    wrapper m2(result2, carry, e_valA, e_valB, 3'd1);
    wrapper m3(result3, carry, e_valA, e_valB, 3'd2);
    wrapper m4(result4, carry, e_valA, e_valB, 3'd3);

    always @(*) // Always block for setting condition codes
    begin
        if (e_valE == 0)
        begin
            CC[0] = 1;
        end
        else if (e_valE < 0)
        begin
            CC[1] = 1;
        end
        CC[2] = ((e_valA < 0 == e_valB < 0) && (e_valE < 0 != e_valA < 0));
        cnd = {CC[0], CC[1], CC[2]};
    end

    always@(*)
    begin

        if (e_icode == 2) // cmovXX
        begin
            case (e_ifun)

                0: begin // rrmovq
                    e_valE = e_valA;
                end

                1: begin // cmovqle
                    if ((CC[1] ^ CC[2]) | CC[0])
                    begin
                        e_valE = e_valA;
                    end
                end

                2: begin // cmovl
                    if ((CC[1] ^ CC[2]))
                    begin
                        e_valE = e_valA;
                    end
                end

                3: begin // cmove
                    if (CC[0])
                    begin
                        e_valE = e_valA;
                    end
                end

                4: begin // cmovne
                    if (~CC[0])
                    begin
                        e_valE = e_valA;
                    end
                end

                5: begin // cmovge
                    if (~(CC[1] ^ CC[2]))
                    begin
                        e_valE = e_valA;
                    end
                end

                6: begin // cmovg
                    if (~(CC[1] ^ CC[2]) & (~CC[0]))
                    begin
                        e_valE = e_valA;
                    end
                end

            endcase
        end

        else if (e_icode == 3) // irmovq
        begin
            e_valE = e_valC;
        end

        else if (e_icode == 4) // rmmovq
        begin
            e_valE = e_valB + e_valC;
        end

        else if (e_icode == 5) // mrmovq
        begin
            e_valE = e_valB + e_valC;
        end

        else if(e_icode == 6) // OPq
        begin
            case (e_ifun)

                0: begin // addq
                    e_valE = result1;
                end

                1: begin // subq
                    e_valE = result2;
                end

                2: begin // andq
                    e_valE = result3;
                end

                3: begin // xorq
                    e_valE = result4;
                end

            endcase
        end

        else if (e_icode == 7) // jXX
        begin
            case (e_ifun)

                0: begin // jmp
                    e_jmpcnd = 1;
                end

                1: begin // jle
                    if ((CC[1] ^ CC[2]) | CC[0])
                    begin
                        e_jmpcnd = 1;
                    end
                end

                2: begin // jl
                    if ((CC[1] ^ CC[2]))
                    begin
                        e_jmpcnd = 1;
                    end
                end

                3: begin // je
                    if (CC[0])
                    begin
                        e_jmpcnd = 1;
                    end
                end

                4: begin // jne
                    if (~CC[0])
                    begin
                        e_jmpcnd = 1;
                    end
                end

                5: begin // jge
                    if (~(CC[1] ^ CC[2]))
                    begin
                        e_jmpcnd = 1;
                    end
                end

                6: begin // jg
                    if (~(CC[1] ^ CC[2]) & (~CC[0]))
                    begin
                        e_jmpcnd = 1;
                    end
                end

            endcase
        end

        else if (e_icode == 8) // call
        begin
            e_valE = e_valB - 8;
        end

        else if (e_icode == 9) // ret
        begin
            e_valE = e_valB + 8;
        end

        else if (e_icode == 10) // pushq
        begin
            e_valE = e_valB - 8;
        end

        else if (e_icode == 11) // popq
        begin
            e_valE = e_valB + 8;
        end

    end

endmodule
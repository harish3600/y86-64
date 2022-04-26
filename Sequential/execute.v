`timescale 1ns/1ps
`include "ALU/Wrapper/wrapper.v"

module execute(clk, icode, ifun, valA, valB, valC, valE, cnd, jmpcnd);

    input clk;
    input [3:0] icode;
    input [3:0] ifun;
    input signed[63:0] valA;
    input signed[63:0] valB;
    input signed [63:0] valC;

    output reg signed [63:0] valE;
    output reg jmpcnd;

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

    wrapper m1(result1, carry, valA, valB, 3'd0);
    wrapper m2(result2, carry, valA, valB, 3'd1);
    wrapper m3(result3, carry, valA, valB, 3'd2);
    wrapper m4(result4, carry, valA, valB, 3'd3);

    always @(*) // Always block for setting condition codes
    begin
        if (valE == 0)
        begin
            CC[0] = 1;
        end
        else if (valE < 0)
        begin
            CC[1] = 1;
        end
        CC[2] = ((valA < 0 == valB < 0) && (valE < 0 != valA < 0));
        cnd = {CC[0], CC[1], CC[2]};
    end

    always@(*)
    begin

        if (icode == 2) // cmovXX
        begin
            case (ifun)

                0: begin // rrmovq
                    valE = valA;
                end

                1: begin // cmovqle
                    if ((CC[1] ^ CC[2]) | CC[0])
                    begin
                        valE = valA;
                    end
                end

                2: begin // cmovl
                    if ((CC[1] ^ CC[2]))
                    begin
                        valE = valA;
                    end
                end

                3: begin // cmove
                    if (CC[0])
                    begin
                        valE = valA;
                    end
                end

                4: begin // cmovne
                    if (~CC[0])
                    begin
                        valE = valA;
                    end
                end

                5: begin // cmovge
                    if (~(CC[1] ^ CC[2]))
                    begin
                        valE = valA;
                    end
                end

                6: begin // cmovg
                    if (~(CC[1] ^ CC[2]) & (~CC[0]))
                    begin
                        valE = valA;
                    end
                end

            endcase
        end

        else if (icode == 3) // irmovq
        begin
            valE = valC;
        end

        else if (icode == 4) // rmmovq
        begin
            valE = valB + valC;
        end

        else if (icode == 5) // mrmovq
        begin
            valE = valB + valC;
        end

        else if(icode == 6) // OPq
        begin
            case (ifun)

                0: begin // addq
                    valE = result1;
                end

                1: begin // subq
                    valE = result2;
                end

                2: begin // andq
                    valE = result3;
                end

                3: begin // xorq
                    valE = result4;
                end

            endcase
        end

        else if (icode == 7) // jXX
        begin
            case (ifun)

                0: begin // jmp
                    jmpcnd = 1;
                end

                1: begin // jle
                    if ((CC[1] ^ CC[2]) | CC[0])
                    begin
                        jmpcnd = 1;
                    end
                end

                2: begin // jl
                    if ((CC[1] ^ CC[2]))
                    begin
                        jmpcnd = 1;
                    end
                end

                3: begin // je
                    if (CC[0])
                    begin
                        jmpcnd = 1;
                    end
                end

                4: begin // jne
                    if (~CC[0])
                    begin
                        jmpcnd = 1;
                    end
                end

                5: begin // jge
                    if (~(CC[1] ^ CC[2]))
                    begin
                        jmpcnd = 1;
                    end
                end

                6: begin // jg
                    if (~(CC[1] ^ CC[2]) & (~CC[0]))
                    begin
                        jmpcnd = 1;
                    end
                end

            endcase
        end

        else if (icode == 8) // call
        begin
            valE = valB - 8;
        end

        else if (icode == 9) // ret
        begin
            valE = valB + 8;
        end

        else if (icode == 10) // pushq
        begin
            valE = valB - 8;
        end

        else if (icode == 11) // popq
        begin
            valE = valB + 8;
        end

    end

endmodule
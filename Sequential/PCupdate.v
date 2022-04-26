`timescale 1ps/1ps

module PCupdate(clk, icode, valP, valC, valM, jmpcnd, PC_new);

    parameter n = 64;
    input clk;
    input jmpcnd;
    input [3:0] icode;
    input [n-1:0] valP, valC, valM;
    output reg [n-1:0] PC_new;

    always @(posedge clk)
    begin
        case(icode)

            7: begin // jXX
                if (jmpcnd == 1)
                begin
                    PC_new = valC;
                end
                else
                begin
                    PC_new = valP;
                end
            end

            8: begin // call
                PC_new = valC;
            end

            9: begin // ret
                PC_new = valM;
            end

            default: begin // all others
                PC_new = valP;
            end

        endcase
    end

endmodule
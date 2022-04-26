`timescale 1ps/1ps

module f_pipereg(clk, f_icode, f_valP, f_valC, m_icode, jmpcnd, m_valA, w_icode, w_valM, f_PC);

    parameter n = 64;
    input clk;
    input [3:0] f_icode, m_icode, w_icode;
    input jmpcnd;
    input [n-1:0] f_valP, f_valC, m_valA, w_valM;
    output reg [n-1:0] f_PC;

    reg [n-1:0] predPC;

    initial begin
        predPC = 1;
    end

    always @(*) 
    begin
        case(f_icode)

            7: begin // jXX
               predPC = f_valC;
            end

            8: begin // call
                predPC = f_valC;
            end

            default: begin // all others
                predPC = f_valP;
            end

        endcase
    end

    always @(posedge clk)
    begin
        f_PC <= predPC;

        if (m_icode == 7)
        begin
            if (jmpcnd == 0)
            begin
                f_PC <= m_valA;
            end
        end
        if (w_icode == 9)
        begin
            f_PC <= w_valM;
        end
        
    end

endmodule

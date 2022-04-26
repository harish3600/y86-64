`timescale 1ns/1ps

module decode_writeback_pipe(clk, d_icode, d_rA, d_rB, w_valE, w_valM, d_valA, d_valB, e_rA, e_rB, m_rA, m_rB, w_rA, w_rB, e_valE, m_valE, m_valM);

    parameter n = 64;
    input clk;
    input [3:0] d_icode;
    input [3:0] d_rA, e_rA, m_rA, w_rA;
    input [3:0] d_rB, e_rB, m_rB, w_rB;
    output reg [n-1:0] d_valA;
    output reg [n-1:0] d_valB;

    input [3:0] w_icode;
    input [n-1:0] w_valE, w_valM, e_valE, m_valE, m_valM;

    integer i;

    reg [n-1:0] reg_data[0:14]; // Register memory
    // %rsp = reg_data[4]

    initial begin
        for (i=0; i<15; i=i+1)
        begin
            reg_data[i] = i; 
        end
            reg_data[4] = 10;
    end

    always @(*)
    begin
        
        case (d_icode) 

                2: begin // cmovXX or rrmovq
                    d_valA = reg_data[d_rA];
                    d_valB = reg_data[d_rB];
                end

                4: begin // rmmovq
                    d_valA = reg_data[d_rA];
                    d_valB = reg_data[d_rB];
                end

                5: begin // mrmovq
                    d_valB = reg_data[d_rB];
                end

                6: begin // OPq
                    d_valA = reg_data[d_rA];
                    d_valB = reg_data[d_rB];
                end

                8: begin // call
                    d_valB = reg_data[4]; // stack pointer
                end

                9: begin // ret
                    d_valA = reg_data[4];
                    d_valB = reg_data[4]; // stack pointer
                end

                10: begin // pushq
                    d_valA = reg_data[d_rA];
                    d_valB = reg_data[4]; // stack pointer
                end

                11: begin // popq
                    d_valA = reg_data[4];
                    d_valB = reg_data[4]; // stack pointer
                end
            endcase

            if (d_rA == e_rB)
                d_valA = e_valE;
            else if (d_rA == m_rA)
                d_valA = m_valM;
            else if (d_rA == m_rB)
                d_valA = m_valE;
            else if (d_rA == w_rA)
                d_valA = w_valM;
            else if (d_rA == w_rB)
                d_valA = w_valE;

            if (d_rA == e_rB)
                d_valB = e_valE;
            else if (d_rA == m_rA)
                d_valB = m_valM;
            else if (d_rA == m_rB)
                d_valB = m_valE;
            else if (d_rA == w_rA)
                d_valB = w_valM;
            else if (d_rA == w_rB)
                d_valB = w_valE;
        
    end

    always @ (negedge clk)
    begin

        case (w_icode)
        
        2: begin // cmovxx
            reg_data[w_rB] = w_valE;
        end

        3: begin // irmovq
            reg_data[w_rB] = w_valE;
        end

        5: begin // mrmovq
            reg_data[w_rA] = w_valM;
        end

        6: begin // OPq
            reg_data[w_rB] = w_valE;
        end

        8: begin // call
            reg_data[4] = w_valE; // stack pointer
        end

        9: begin // ret
            reg_data[4] = w_valE; // stack pointer
        end

        10: begin // pushq
            reg_data[4] = w_valE; // stack pointer
        end

        11: begin // popq
            reg_data[4] = w_valE; // stack pointer
            reg_data[w_rA] = w_valM;
        end

        endcase

    end
    

endmodule

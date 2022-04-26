`timescale 1ps/1ps

module memory_pipe(clk, m_icode, m_ifun, m_valB, m_valE, m_valP, m_valM, memadr);

    parameter n = 64;
    input clk;
    input [3:0] m_icode, m_ifun;
    input [n-1:0] m_valB, m_valE, m_valP;
    output reg [n-1:0] m_valM;
    output reg [n-1:0] memadr;

    reg [n-1:0] data_mem [0:1023]; // data memory array with 1024 elements and each element having n bits

    integer i;
    initial begin
        for (i=0; i<1024; i = i+1)
        begin
            data_mem[i] = i;
        end
    end

    always @(*)
    begin
        case(m_icode)
            4: begin //rmmovq
                data_mem[m_valE] = m_ifun;
            end

            5: begin // mrmovq
                m_valM = data_mem[m_valE];
            end

            8: begin // call
                data_mem[m_valE] = m_valP;
            end

            9: begin // ret
                m_valM = data_mem[m_valE];
            end

            10: begin // pushq
                data_mem[m_valE] = m_ifun;
            end

            11: begin // popq
                m_valM = data_mem[m_ifun];
            end
        endcase

        memadr = data_mem[m_valE];

    end

endmodule
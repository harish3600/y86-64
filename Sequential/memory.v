`timescale 1ps/1ps

module memory(clk, icode, valA, valB, valE, valP, valM, memadr);

    parameter n = 64;
    input clk;
    input [3:0] icode;
    input [n-1:0] valA, valB, valE, valP;
    output reg [n-1:0] valM;
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
        case(icode)
            4: begin //rmmovq
                data_mem[valE] = valA;
            end

            5: begin // mrmovq
                valM = data_mem[valE];
            end

            8: begin // call
                data_mem[valE] = valP;
            end

            9: begin // ret
                valM = data_mem[valE];
            end

            10: begin // pushq
                data_mem[valE] = valA;
            end

            11: begin // popq
                valM = data_mem[valA];
            end
        endcase

        memadr = data_mem[valE];

    end

endmodule
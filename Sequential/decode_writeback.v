`timescale 1ns/1ps

module decode_writeback(clk, icode, rA, rB, valE, valM, valA, valB);

    parameter n = 64;
    input clk;
    input [3:0] icode;
    input [3:0] rA;
    input [3:0] rB;
    input [n-1:0] valE, valM;

    output reg [n-1:0] valA;
    output reg [n-1:0] valB;

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
        
        case (icode) 

                2: begin // cmovXX or rrmovq
                    valA = reg_data[rA];
                    valB = reg_data[rB];
                end

                4: begin // rmmovq
                    valA = reg_data[rA];
                    valB = reg_data[rB];
                end

                5: begin // mrmovq
                    valB = reg_data[rB];
                end

                6: begin // OPq
                    valA = reg_data[rA];
                    valB = reg_data[rB];
                end

                8: begin // call
                    valB = reg_data[4]; // stack pointer
                end

                9: begin // ret
                    valA = reg_data[4];
                    valB = reg_data[4]; // stack pointer
                end

                10: begin // pushq
                    valA = reg_data[rA];
                    valB = reg_data[4]; // stack pointer
                end

                11: begin // popq
                    valA = reg_data[4];
                    valB = reg_data[4]; // stack pointer
                end
            endcase

    end

    always @ (negedge clk)
    begin

        case (icode)
        
        2: begin // cmovxx
            reg_data[rB] = valE;
        end

        3: begin // irmovq
            reg_data[rB] = valE;
        end

        5: begin // mrmovq
            reg_data[rA] = valM;
        end

        6: begin // OPq
            reg_data[rB] = valE;
        end

        8: begin // call
            reg_data[4] = valE; // stack pointer
        end

        9: begin // ret
            reg_data[4] = valE; // stack pointer
        end

        10: begin // pushq
            reg_data[4] = valE; // stack pointer
        end

        11: begin // popq
            reg_data[4] = valE; // stack pointer
            reg_data[rA] = valM;
        end

        endcase

    end
    

endmodule
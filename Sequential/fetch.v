`timescale 1ns/1ps

module fetch(clk, PC, icode, ifun, rA, rB, valC, valP, instr_valid, imem_error, halt);

    parameter n = 64;
    input clk;
    input [n-1:0] PC;
    output reg [3:0] icode, ifun;
    output reg [3:0] rA, rB;
    output reg [n-1:0] valC;
    output reg [n-1:0] valP;
    output reg instr_valid;
    output reg imem_error;
    output reg halt;

    integer i;

    reg [7:0] instr_mem[0:1023]; //1024 Byte Array with each element(1 Byte) having 8 bits

    // Initialize the instruction memory to some value (Otherwise the all the registers will have 'x')
    initial begin
        instr_mem[0] = 8'b01100000;
        instr_mem[1] = 8'b01100000;
        instr_mem[2] = 8'b01101100;
        instr_mem[3] = 8'b01110000; 
        instr_mem[4] = 8'b00000000; 
        instr_mem[5] = 8'b00000000; 
        instr_mem[6] = 8'b00000000; 
        instr_mem[7] = 8'b00000000; 
        instr_mem[8] = 8'b00000000; 
        instr_mem[9] = 8'b00000000; 
        instr_mem[10] = 8'b00000000; 
        instr_mem[11] = 8'b00001100;
        instr_mem[12] = 8'b00100000;
        instr_mem[13] = 8'b01101100;
        instr_mem[14] = 8'b00110000; 
        instr_mem[15] = 8'b00000000; 
        instr_mem[16] = 8'b00000000; 
        instr_mem[17] = 8'b00000000; 
        instr_mem[18] = 8'b00000000; 
        instr_mem[19] = 8'b00000000; 
        instr_mem[20] = 8'b00000000; 
        instr_mem[21] = 8'b00000000; 
        instr_mem[22] = 8'b00000000; 
        instr_mem[23] = 8'b00000000; 
        instr_mem[24] = 8'b10101000; 
        instr_mem[25] = 8'b00000000; 
        instr_mem[26] = 8'b00001010; 
        for (i=27; i<1024; i=i+1)
        begin
            instr_mem[i] = i%5 + 2;
        end
    end

    reg [0:79] instr; // 1 instruction of size 10 bytes

    // 1 instruction != instr_mem[PC]
    // 1 instruction = instr_mem[PC] + instr_mem[PC+1] + instr_mem[PC+2] + ... instr_mem[PC+9]

    always @(posedge clk)
    begin

            imem_error = 0;
            instr_valid = 1;
            halt = 0;

            if (PC > 1023) 
            begin
                instr_valid = 0; // Not valid
                imem_error = 1; // Memory error
            end

            instr = {
                instr_mem[PC], 
                instr_mem[PC + 1], 
                instr_mem[PC + 2], 
                instr_mem[PC + 3], 
                instr_mem[PC + 4], 
                instr_mem[PC + 5], 
                instr_mem[PC + 6], 
                instr_mem[PC + 7], 
                instr_mem[PC + 8],
                instr_mem[PC + 9] 
            };

            icode = instr[0:3];
            ifun = instr[4:7];

            case(icode) 
                0: begin // halt
                    halt = 1;
                    valP = PC + 1;
                end

                1: begin // nop
                    valP = PC + 1;
                end

                2: begin // cmovXX or rrmovq
                    rA = instr[8:11];
                    rB = instr[12:15];
                    valP = PC + 2;
                end

                3: begin // irmovq
                    rA = instr[8:11];
                    rB = instr[12:15];
                    valC = instr[16:79];
                    valP = PC + 10;
                end

                4: begin // rmmovq
                    rA = instr[8:11];
                    rB = instr[12:15];
                    valC = instr[16:79];
                    valP = PC + 10;
                end

                5: begin // mrmovq
                    rA = instr[8:11];
                    rB = instr[12:15];
                    valC = instr[16:79];
                    valP = PC + 10;
                end

                6: begin // OPq
                    rA = instr[8:11];
                    rB = instr[12:15];
                    valP = PC + 2;
                end

                7: begin // jXX
                    valC = instr[8:71];
                    valP = PC + 9;
                end

                8: begin // call
                    valC = instr[8:71];
                    valP = PC + 9;
                end

                9: begin // ret
                    valP = PC + 1;
                end

                10: begin // pushq
                    rA = instr[8:11];
                    rB = instr[12:15];
                    valP = PC + 2;
                end

                11: begin // popq
                    rA = instr[8:11];
                    rB = instr[12:15];
                    valP = PC + 2;
                end
            endcase

    end
endmodule
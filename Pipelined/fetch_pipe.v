`timescale 1ns/1ps

module fetch_pipe(clk, f_PC, f_icode, f_ifun, f_rA, f_rB, f_valC, f_valP, instr_valid, imem_error, halt);

    parameter n = 64;
    input clk;
    input [n-1:0] f_PC;
    output reg [3:0] f_icode, f_ifun;
    output reg [3:0] f_rA, f_rB;
    output reg [n-1:0] f_valC;
    output reg [n-1:0] f_valP;
    output reg instr_valid;
    output reg imem_error;
    output reg halt;

    integer i;

    reg [7:0] instr_mem[0:1023]; //1024 Byte Array with each element(1 Byte) having 8 bits

    // Initialize the instruction memory to some value (Otherwise the all the registers will have 'x')
    initial begin
        // for (i=0; i<1024; i=i+1)
        // begin
        //     instr_mem[i] = 8'b01110000;
        // end
        instr_mem[0] = 8'b00010000;
        instr_mem[1] = 8'b00110000;
        instr_mem[2] = 8'b01101100;
        instr_mem[3] = 8'b00000000; 
        instr_mem[4] = 8'b00000000; 
        instr_mem[5] = 8'b00000000; 
        instr_mem[6] = 8'b00000000; 
        instr_mem[7] = 8'b00000000; 
        instr_mem[8] = 8'b00000000; 
        instr_mem[9] = 8'b00000000; 
        instr_mem[10] = 8'b00001010; 
        instr_mem[11] = 8'b01000000;
        instr_mem[12] = 8'b10110000;
        instr_mem[13] = 8'b01101100;
        instr_mem[14] = 8'b00000000; 
        instr_mem[15] = 8'b00000000; 
        instr_mem[16] = 8'b00000000; 
        instr_mem[17] = 8'b00000000; 
        instr_mem[18] = 8'b00000000; 
        instr_mem[19] = 8'b00000000; 
        instr_mem[20] = 8'b00000000; 
        instr_mem[21] = 8'b01011010;
        instr_mem[22] = 8'b01100000;
        instr_mem[23] = 8'b10110000;
        instr_mem[24] = 8'b01101100;
        instr_mem[25] = 8'b00000000; 
        instr_mem[26] = 8'b00000000; 
        instr_mem[27] = 8'b00000000; 
        instr_mem[28] = 8'b00000000; 
        instr_mem[29] = 8'b00000000; 
        instr_mem[30] = 8'b00000000; 
        instr_mem[31] = 8'b01100000; 
        instr_mem[32] = 8'b00001010;
        instr_mem[33] = 8'b01110000;
        instr_mem[34] = 8'b00000000;
        instr_mem[35] = 8'b00000000;
        instr_mem[36] = 8'b00000000; 
        instr_mem[37] = 8'b00000000; 
        instr_mem[38] = 8'b00000000; 
        instr_mem[39] = 8'b00000000; 
        instr_mem[40] = 8'b00000000; 
        instr_mem[41] = 8'b01000010; 
        instr_mem[42] = 8'b00000001; 
        instr_mem[43] = 8'b00001010;
        instr_mem[44] = 8'b01100000;
        instr_mem[45] = 8'b10110000;
        instr_mem[46] = 8'b01101100;
        instr_mem[47] = 8'b00000000; 
        instr_mem[48] = 8'b00000000; 
        instr_mem[49] = 8'b00000000; 
        instr_mem[50] = 8'b00000000; 
        instr_mem[51] = 8'b01000000; 
        instr_mem[52] = 8'b00000000; 
        instr_mem[53] = 8'b00000000; 
        instr_mem[54] = 8'b00001010;
        instr_mem[55] = 8'b01100000;
        instr_mem[56] = 8'b10110000;
        instr_mem[57] = 8'b01101100;
        instr_mem[58] = 8'b00000000; 
        instr_mem[59] = 8'b00000000; 
        instr_mem[60] = 8'b00000000; 
        instr_mem[61] = 8'b10010000; 
        instr_mem[62] = 8'b00000000; 
        instr_mem[63] = 8'b00000000; 
        instr_mem[64] = 8'b00000000; 
        instr_mem[65] = 8'b00001010;
        instr_mem[66] = 8'b01010000; 
        instr_mem[67] = 8'b01101010;
        instr_mem[68] = 8'b01100000;
        instr_mem[69] = 8'b10110000;
        instr_mem[70] = 8'b01101100;
        instr_mem[71] = 8'b00100000; 
        instr_mem[72] = 8'b00000000; 
        instr_mem[73] = 8'b01100000; 
        instr_mem[74] = 8'b10010000; 
        instr_mem[75] = 8'b00000000; 
        instr_mem[76] = 8'b00010000; 
        instr_mem[77] = 8'b00110000; 
        instr_mem[78] = 8'b00001010;
        for (i=79; i<1024; i=i+1)
        begin
            instr_mem[i] = i%5 + 3;
        end
    end

    reg [0:79] instr; // 1 instruction of size 10 bytes

    // 1 instruction != instr_mem[f_PC]
    // 1 instruction = instr_mem[f_PC] + instr_mem[f_PC+1] + instr_mem[f_PC+2] + ... instr_mem[f_PC+9]

    always @(*)
    begin

            imem_error = 0;
            instr_valid = 1;
            halt = 0;

            if (f_PC > 1023)
            begin
                instr_valid = 0; // Not valid
                imem_error = 1; // Memory error
            end

            instr = {
                instr_mem[f_PC], 
                instr_mem[f_PC + 1], 
                instr_mem[f_PC + 2], 
                instr_mem[f_PC + 3], 
                instr_mem[f_PC + 4], 
                instr_mem[f_PC + 5], 
                instr_mem[f_PC + 6], 
                instr_mem[f_PC + 7], 
                instr_mem[f_PC + 8],
                instr_mem[f_PC + 9] 
            };

            f_icode = instr[0:3];
            f_ifun = instr[4:7];

            case(f_icode)

                0: begin // halt
                    halt = 1;
                    f_valP = f_PC + 1;
                end

                1: begin // nop
                    f_valP = f_PC + 1;
                end

                2: begin // cmovXX or rrmovq
                    f_rA = instr[8:11];
                    f_rB = instr[12:15];
                    f_valP = f_PC + 2;
                end

                3: begin // irmovq
                    f_rA = instr[8:11];
                    f_rB = instr[12:15];
                    f_valC = instr[16:79];
                    f_valP = f_PC + 10;
                end

                4: begin // rmmovq
                    f_rA = instr[8:11];
                    f_rB = instr[12:15];
                    f_valC = instr[16:79];
                    f_valP = f_PC + 10;
                end

                5: begin // mrmovq
                    f_rA = instr[8:11];
                    f_rB = instr[12:15];
                    f_valC = instr[16:79];
                    f_valP = f_PC + 10;
                end

                6: begin // OPq
                    f_rA = instr[8:11];
                    f_rB = instr[12:15];
                    f_valP = f_PC + 2;
                end

                7: begin // jXX
                    f_valC = instr[8:71];
                    f_valP = f_PC + 9;
                end

                8: begin // call
                    f_valC = instr[8:71];
                    f_valP = f_PC + 9;
                end

                9: begin // ret
                    f_valP = f_PC + 1;
                end

                10: begin // pushq
                    f_rA = instr[8:11];
                    f_rB = instr[12:15];
                    f_valP = f_PC + 2;
                end

                11: begin // popq
                    f_rA = instr[8:11];
                    f_rB = instr[12:15];
                    f_valP = f_PC + 2;
                end
            endcase

    end
endmodule

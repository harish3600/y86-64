`timescale 1ns/1ps

module ADD_1_test;

    reg a,b, cin;
    wire sum, carry;

    ADD_1 a1(sum, carry, a, b, cin);

    integer i;

    initial begin

        $dumpfile("ADD_1_test.vcd");
        $dumpvars(0, ADD_1_test);

        
        for(i = 0; i<8; i = i+1)
            begin
                {a ,b, cin} = i; #5;
                $display("%d + %d + %d = %d %d", a,b,cin, carry, sum);
            end
            $finish;

        $display("Test Completed");
    end

endmodule

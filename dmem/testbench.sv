`timescale 1ns / 1ps

module tb_dmem;

    reg clk;
    reg we;
    reg [31:0] a, wd;
    wire [31:0] rd;

    dmem dut (clk, we, a, wd, rd);

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        we = 0;
        a = 0;
        wd = 0;
        

        #10;
        a = 32'h4;
        wd = 32'hA5A5A5A5;
        we = 1;
        #10;
        we = 0;
        #10;
       $display("%0d, %0d, %0h, %0h, %0h", clk, we, a, wd, rd);

        a = 32'h8;
        wd = 32'h5A5A5A5A;
        we = 1;
        #10;
        we = 0;
        #10;
        $display("%0d, %0d, %0h, %0h, %0h", clk, we, a, wd, rd);

        a = 32'hC;
        wd = 32'hDEADBEAF;
        we = 1;
        #10;
        we = 0;
        #10;
        $display("%0d, %0d, %0h, %0h, %0h", clk, we, a, wd, rd);

        $finish;
    end

    initial begin
        $dumpfile("tb_dmem.vcd");
        $dumpvars(0, tb_dmem);
    end

endmodule

`timescale 1ns/1ps

module adder_tb;
    reg [31:0] a, b;
    wire [31:0] y;

  adder dut (a,b,y);

    int i;
    initial begin
        for (i = 0; i < 10; i = i + 1) begin
            a = $random; 
            b = $random; 
            #10;         
          $display("Time: %0t | a: %d | b: %d | y: %d", $time, a, b, y);
        end

        $finish;
    end

endmodule

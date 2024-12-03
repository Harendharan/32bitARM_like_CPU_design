`timescale 1ns/1ps

module flopr_tb;

  reg clk;                   // Clock signal
  reg reset;                 // Reset signal
  reg [31:0] d;              // Data input
  wire [31:0] q;             // Data output

  flopr uut (clk,reset,d,q);

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  initial begin
    reset = 1;     //reset
    d = 0;
    #20;        
    reset = 0; 
    repeat (10) begin
      d = $random; 
      #20;          
    end

    reset = 1;     //reset
    #20;
    
    reset = 0;
    d = $random;
    #20;

    $dumpfile("flopr_tb.vcd");
    $dumpvars(0, flopr_tb);
    $finish;
  end

endmodule

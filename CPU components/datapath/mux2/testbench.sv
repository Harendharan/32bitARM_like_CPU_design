module mux2_tb;

  parameter WIDTH = 8;

  reg  [WIDTH-1:0] d0, d1; // Inputs to the multiplexer
  reg  s;                 // Select signal
  wire [WIDTH-1:0] y;     // Output from the multiplexer

 
  mux2 #(WIDTH) dut (d0,d1,s,y);

  initial begin
    d0 = 8'h00; d1 = 8'hFF; s = 0;
    #10; 
    
    s = 0;
    #10;
    $display("s=%b, d0=%h, d1=%h, y=%h", s, d0, d1, y);

    s = 1;
    #10;
    $display("s=%b, d0=%h, d1=%h, y=%h", s, d0, d1, y);

    d0 = 8'hAA; d1 = 8'h55; s = 0;
    #10;
    $display("s=%b, d0=%h, d1=%h, y=%h", s, d0, d1, y);

    s = 1;
    #10;
    $display("s=%b, d0=%h, d1=%h, y=%h", s, d0, d1, y);

    $finish;
  end

endmodule

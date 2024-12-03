module mux2 #(parameter WIDTH = 8) (
  input  wire [WIDTH-1:0] d0,   // Input 0
  input  wire [WIDTH-1:0] d1,   // Input 1
  input  wire s,                // Select signal
  output reg  [WIDTH-1:0] y     // Output
);

  always @(*) begin
    if (s) 
      y = d1; 
    else 
      y = d0;
  end

endmodule

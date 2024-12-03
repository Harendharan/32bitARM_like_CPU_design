module flopr (
  input clk,                 // Clock signal
  input reset,               // Reset signal
  input  [31:0] d,           // Data input
  output reg [31:0] q        // Data output
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 32'b0;            // Reset the output to 0
    end else begin
      q <= d;                // Capture the input data on the rising edge of clk
    end
  end

endmodule

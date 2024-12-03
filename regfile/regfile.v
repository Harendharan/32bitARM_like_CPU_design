module regfile (
  input clk,                  // Clock signal
  input we3,                  // Write enable signal
  input  [3:0] ra1, ra2, wa3, // Read and write addresses
  input  [31:0] wd3, r15,     // Write data and special register value (r15)
  output [31:0] rd1, rd2      // Read data outputs
);

 
  reg [31:0] rf[14:0];  // 32 X 15 Register file 

  // Read 
  assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1]; 
  assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
  
  // Write
  always @(posedge clk) begin
    if (we3) begin
      rf[wa3] <= wd3; // Write data to register 
    end
  end

endmodule

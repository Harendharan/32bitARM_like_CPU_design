module imem(
  input logic [31:0] a, //address
  output wire [31:0] rd //content
);
  reg [31:0] RAM[63:0]; // 62 X 32
  initial begin
	$readmemh("memfile.dat",RAM);
   end
   assign rd = RAM[a[31:2]]; 
endmodule

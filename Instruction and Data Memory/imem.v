module imem (
    input [31:0] a,
    output reg [31:0] rd
);
    
   reg [31:0] RAM[63:0]; // 32 X 64

    initial begin
         $readmemh("memfile.dat", RAM);
         rd = RAM[a[31:2]]; 
    end

endmodule

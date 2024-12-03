`timescale 1ns / 1ps

module alu_tb;
  reg [31:0] SrcA, SrcB;
  reg [1:0] ALUControl;
  wire [31:0] ALUResult;
  wire [3:0] ALUFlag;

  alu dut (
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .ALUFlag(ALUFlag)
  );

  initial begin
    
    repeat (20) begin
      SrcA = $random;
      SrcB = $random;
      ALUControl = $random % 4; // ALUControl range: 0 to 3
      #10; 
      //$display("SrcA=%h ; SrcB=%h ; ALUControl=%b ; ALUResult=%h ; ALUFlag=%b", SrcA, SrcB, ALUControl, ALUResult, ALUFlag);
      $display("SrcA=%b ; SrcB=%b ; ALUControl=%b ; ALUResult=%b ; ALUFlag=%b", SrcA, SrcB, ALUControl, ALUResult, ALUFlag); 
    end
    
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);
    $finish;
  end

endmodule

`include "extender.v"
`include "alu.v"
`include "regfile.v"
`include "mux2.v"
`include "flop.v"
`include "adder.v"

module datapath (
  input         clk,
  input         reset,
  input  [1:0]  RegSrc,
  input         RegWrite,
  input  [1:0]  ImmSrc,
  input         ALUSrc,
  input  [1:0]  ALUControl,
  input         MemtoReg,
  input         PCSrc,
  output reg [3:0]  ALUFlags,
  output reg [31:0] PC,
  input  [31:0] Instr,
  output reg [31:0] ALUResult,
  output reg [31:0] WriteData,
  input  [31:0] ReadData
);

  // Internal wires
  wire [31:0] PCNext, PCPlus4, PCPlus8;
  wire [31:0] ExtImm, SrcA, SrcB, Result;
  wire [3:0]  RA1, RA2;

  // PC logic
  mux2 #(.WIDTH(32)) pcmux (
    .d0(PCPlus4),
    .d1(Result),
    .s(PCSrc),
    .y(PCNext)
  );

  flopr pcreg (
    .clk(clk),
    .reset(reset),
    .d(PCNext),
    .q(PC)
  );

  adder pcadd1 (
    .a(PC),
    .b(32'b100),
    .y(PCPlus4)
  );

  adder pcadd2 (
    .a(PCPlus4),
    .b(32'b100),
    .y(PCPlus8)
  );

  // Register file logic
  mux2 #(.WIDTH(4)) ra1mux (
    .d0(Instr[19:16]),
    .d1(4'b1111),
    .s(RegSrc[0]),
    .y(RA1)
  );

  mux2 #(.WIDTH(4)) ra2mux (
    .d0(Instr[3:0]),
    .d1(Instr[15:12]),
    .s(RegSrc[1]),
    .y(RA2)
  );

  regfile rf (
    .clk(clk),
    .we3(RegWrite),
    .ra1(RA1),
    .ra2(RA2),
    .wa3(Instr[15:12]),
    .wd3(Result),
    .r15(PCPlus8),
    .rd1(SrcA),
    .rd2(WriteData)
  );

  mux2 #(.WIDTH(32)) resmux (
    .d0(ALUResult),
    .d1(ReadData),
    .s(MemtoReg),
    .y(Result)
  );

  extend ext (
    .instr(Instr[23:0]),
    .immsrc(ImmSrc),
    .extimm(ExtImm)
  );

  // ALU logic
  mux2 #(.WIDTH(32)) srcbmux (
    .d0(WriteData),
    .d1(ExtImm),
    .s(ALUSrc),
    .y(SrcB)
  );

  alu alu (
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .ALUFlag(ALUFlags)
  );

endmodule

`timescale 1ns / 1ps

module decoder_tb;

  // Testbench signals
  reg [1:0] Op;
  reg [5:0] Funct;
  reg [3:0] Rd;
  wire [1:0] FlagW;
  wire PCS, RegW, MemW;
  wire MemtoReg, ALUSrc;
  wire [1:0] ImmSrc, RegSrc, ALUControl;

 
  decoder dut (
    .Op(Op),
    .Funct(Funct),
    .Rd(Rd),
    .FlagW(FlagW),
    .PCS(PCS),
    .RegW(RegW),
    .MemW(MemW),
    .MemtoReg(MemtoReg),
    .ALUSrc(ALUSrc),
    .ImmSrc(ImmSrc),
    .RegSrc(RegSrc),
    .ALUControl(ALUControl)
  );


  initial begin
    // Initialize signals
    Op = 2'b00; Funct = 6'b000000; Rd = 4'b0000;
    
    #10;
    
    // Test Case 1: Data processing-register (Op = 00, Funct = 000000)
    Op = 2'b00; Funct = 6'b000000; Rd = 4'b0001;
    #10;
    $display("Op: %b, Funct: %b, Rd: %b => FlagW: %b, PCS: %b, RegW: %b, MemW: %b, MemtoReg: %b, ALUSrc: %b, ImmSrc: %b, RegSrc: %b, ALUControl: %b", 
             Op, Funct, Rd, FlagW, PCS, RegW, MemW, MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);
    
    // Test Case 2: Data processing-immediate (Op = 00, Funct = 100000)
    Op = 2'b00; Funct = 6'b100000; Rd = 4'b0010;
    #10;
    $display("Op: %b, Funct: %b, Rd: %b => FlagW: %b, PCS: %b, RegW: %b, MemW: %b, MemtoReg: %b, ALUSrc: %b, ImmSrc: %b, RegSrc: %b, ALUControl: %b", 
             Op, Funct, Rd, FlagW, PCS, RegW, MemW, MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);

    // Test Case 3: LDR (Op = 01, Funct = 000001)
    Op = 2'b01; Funct = 6'b000001; Rd = 4'b0011;
    #10;
    $display("Op: %b, Funct: %b, Rd: %b => FlagW: %b, PCS: %b, RegW: %b, MemW: %b, MemtoReg: %b, ALUSrc: %b, ImmSrc: %b, RegSrc: %b, ALUControl: %b", 
             Op, Funct, Rd, FlagW, PCS, RegW, MemW, MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);
    
    // Test Case 4: STR (Op = 01, Funct = 000000)
    Op = 2'b01; Funct = 6'b000000; Rd = 4'b0100;
    #10;
    $display("Op: %b, Funct: %b, Rd: %b => FlagW: %b, PCS: %b, RegW: %b, MemW: %b, MemtoReg: %b, ALUSrc: %b, ImmSrc: %b, RegSrc: %b, ALUControl: %b", 
             Op, Funct, Rd, FlagW, PCS, RegW, MemW, MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);

    // Test Case 5: Branch instruction (Op = 10)
    Op = 2'b10; Funct = 6'b000000; Rd = 4'b1111;
    #10;
    $display("Op: %b, Funct: %b, Rd: %b => FlagW: %b, PCS: %b, RegW: %b, MemW: %b, MemtoReg: %b, ALUSrc: %b, ImmSrc: %b, RegSrc: %b, ALUControl: %b", 
             Op, Funct, Rd, FlagW, PCS, RegW, MemW, MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);

    // Test Case 6: Unimplemented operation (Op = xx)
    Op = 2'b11; Funct = 6'b111111; Rd = 4'b1111;
    #10;
    $display("Op: %b, Funct: %b, Rd: %b => FlagW: %b, PCS: %b, RegW: %b, MemW: %b, MemtoReg: %b, ALUSrc: %b, ImmSrc: %b, RegSrc: %b, ALUControl: %b", 
             Op, Funct, Rd, FlagW, PCS, RegW, MemW, MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl);

    //$dumpfile("dump.vcd"); $dumpvars;
    $finish;
  end

endmodule

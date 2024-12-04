`timescale 1ns/1ps

module condlogic_tb;
  reg clk, reset;
  reg [3:0] Cond, ALUFlags;
  reg [1:0] FlagW;
  reg PCS, RegW, MemW;
  wire PCSrc, RegWrite, MemWrite;

  condlogic dut (
    .clk(clk),
    .reset(reset),
    .Cond(Cond),
    .ALUFlags(ALUFlags),
    .FlagW(FlagW),
    .PCS(PCS),
    .RegW(RegW),
    .MemW(MemW),
    .PCSrc(PCSrc),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;
    Cond = 4'b0000;
    ALUFlags = 4'b0000;
    FlagW = 2'b00;
    PCS = 0;
    RegW = 0;
    MemW = 0;

    // Reset the DUT
    #10 reset = 0;

    // Test 1: EQ (Equal) condition
    $display("\n--- Test 1: EQ Condition ---");
    Cond = 4'b0000; // EQ
    ALUFlags = 4'b0100; // Zero flag set
    FlagW = 2'b11; // Update all flags
    PCS = 1; RegW = 1; MemW = 1;
    #10 $display("Cond=%b, Flags=%b, PCSrc=%b, RegWrite=%b, MemWrite=%b", Cond, ALUFlags, PCSrc, RegWrite, MemWrite);

    // Test 2: NE (Not Equal) condition
    $display("\n--- Test 2: NE Condition ---");
    Cond = 4'b0001; // NE
    ALUFlags = 4'b0000; // Zero flag clear
    PCS = 1; RegW = 1; MemW = 0;
    #10 $display("Cond=%b, Flags=%b, PCSrc=%b, RegWrite=%b, MemWrite=%b", Cond, ALUFlags, PCSrc, RegWrite, MemWrite);

    // Test 3: GE (Signed Greater or Equal)
    $display("\n--- Test 3: GE Condition ---");
    Cond = 4'b1010; // GE
    ALUFlags = 4'b1100; // N = 1, V = 1 (N == V)
    PCS = 0; RegW = 0; MemW = 1;
    #10 $display("Cond=%b, Flags=%b, PCSrc=%b, RegWrite=%b, MemWrite=%b", Cond, ALUFlags, PCSrc, RegWrite, MemWrite);

    // Test 4: LT (Signed Less Than)
    $display("\n--- Test 4: LT Condition ---");
    Cond = 4'b1011; // LT
    ALUFlags = 4'b1001; // N != V
    PCS = 1; RegW = 1; MemW = 1;
    #10 $display("Cond=%b, Flags=%b, PCSrc=%b, RegWrite=%b, MemWrite=%b", Cond, ALUFlags, PCSrc, RegWrite, MemWrite);

    $finish;
  end

  initial begin
    $dumpfile("condlogic_tb.vcd");
    $dumpvars(0, condlogic_tb);
  end

endmodule

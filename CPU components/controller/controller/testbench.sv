`timescale 1ns/1ps

module controller_tb;
    reg clk, reset;
    reg [31:12] Instr;
    reg [3:0] ALUFlags;
    wire [1:0] RegSrc, ImmSrc, ALUControl;
    wire RegWrite, ALUSrc, MemWrite, MemtoReg, PCSrc;

    controller dut(
        .clk(clk),
        .reset(reset),
        .Instr(Instr),
        .ALUFlags(ALUFlags),
        .RegSrc(RegSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .PCSrc(PCSrc)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    // Testbench logic
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        Instr = 20'b0;
        ALUFlags = 4'b0;

        #10 reset = 0; // De-assert reset after 10ns

        // Test Case 1: Data processing (ADD immediate)
        #10 Instr = 20'b00000000000010000000; // ADD immediate encoding
        #10 $display("--- Test Case 1: Data processing (ADD immediate) ---");
        $display("Instr=%b, RegSrc=%b, RegWrite=%b, ImmSrc=%b, ALUSrc=%b, ALUControl=%b, MemWrite=%b, MemtoReg=%b, PCSrc=%b", 
                 Instr, RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl, MemWrite, MemtoReg, PCSrc);

        // Test Case 2: Load instruction (LDR)
        #10 Instr = 20'b01101000000000000000; // LDR encoding
        #10 $display("--- Test Case 2: Load instruction (LDR) ---");
        $display("Instr=%b, RegSrc=%b, RegWrite=%b, ImmSrc=%b, ALUSrc=%b, ALUControl=%b, MemWrite=%b, MemtoReg=%b, PCSrc=%b", 
                 Instr, RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl, MemWrite, MemtoReg, PCSrc);

        // Test Case 3: Branch instruction (B)
        #10 Instr = 20'b10101000000000000000; // Branch encoding
        #10 $display("--- Test Case 3: Branch instruction (B) ---");
        $display("Instr=%b, RegSrc=%b, RegWrite=%b, ImmSrc=%b, ALUSrc=%b, ALUControl=%b, MemWrite=%b, MemtoReg=%b, PCSrc=%b", 
                 Instr, RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl, MemWrite, MemtoReg, PCSrc);

        // Test Case 4: Store instruction (STR)
        #10 Instr = 20'b01100000000000000000; // STR encoding
        #10 $display("--- Test Case 4: Store instruction (STR) ---");
        $display("Instr=%b, RegSrc=%b, RegWrite=%b, ImmSrc=%b, ALUSrc=%b, ALUControl=%b, MemWrite=%b, MemtoReg=%b, PCSrc=%b", 
                 Instr, RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl, MemWrite, MemtoReg, PCSrc);

        #10 $finish;
    end
  initial begin
    $dumpfile("controller_tb.vcd");
    $dumpvars(0, controller_tb);
  end
endmodule

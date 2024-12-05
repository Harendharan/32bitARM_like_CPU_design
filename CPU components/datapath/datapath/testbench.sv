module datapath_tb;
    reg clk, reset, RegWrite, ALUSrc, MemtoReg, PCSrc;
    reg [1:0] RegSrc, ImmSrc, ALUControl;
    reg [31:0] Instr, ReadData;

    wire [31:0] PC, ALUResult, WriteData;
    wire [3:0] ALUFlags;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10-time unit clock period

    // Instantiate the DUT
    datapath DUT (
        .clk(clk), .reset(reset), .RegWrite(RegWrite), .ALUSrc(ALUSrc), 
        .MemtoReg(MemtoReg), .PCSrc(PCSrc), 
        .RegSrc(RegSrc), .ImmSrc(ImmSrc), .ALUControl(ALUControl),
        .Instr(Instr), .ReadData(ReadData),
        .PC(PC), .ALUResult(ALUResult), .WriteData(WriteData), .ALUFlags(ALUFlags)
    );

    initial begin
        // Reset and Initialization
        reset = 1;
        #10 reset = 0;

        // Test sequences
        #10 RegSrc = 2'b01; RegWrite = 1; ImmSrc = 2'b01; ALUSrc = 1;
            Instr = 32'h12345678; ReadData = 32'hAABBCCDD;
            $display("PC: %h, ALUResult: %h, WriteData: %h, ALUFlags: %b", PC, ALUResult, WriteData, ALUFlags);

        #10 ALUControl = 2'b10; MemtoReg = 1; PCSrc = 1;
            $display("PC: %h, ALUResult: %h, WriteData: %h, ALUFlags: %b", PC, ALUResult, WriteData, ALUFlags);

        #10 RegSrc = 2'b10; RegWrite = 0; ImmSrc = 2'b10; ALUSrc = 0;
            Instr = 32'h87654321; ReadData = 32'h11223344;
            $display("PC: %h, ALUResult: %h, WriteData: %h, ALUFlags: %b", PC, ALUResult, WriteData, ALUFlags);

        #10 ALUControl = 2'b11; MemtoReg = 0; PCSrc = 0;
            $display("PC: %h, ALUResult: %h, WriteData: %h, ALUFlags: %b", PC, ALUResult, WriteData, ALUFlags);

        $finish;
    end

  initial  begin
  
    $dumpfile("datapath_tb.vcd");
    $dumpvars(0, datapath_tb);
    //#100 $finish;
 
  end
endmodule

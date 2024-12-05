module testbench;

  reg [31:0] a;
  wire [31:0] rd;

  imem dut (a,rd);

  initial begin
    $dumpfile("imem_tb.vcd");
    $dumpvars(0, testbench);

    // Test Case 1: Address 0
    a = 32'h00000000;
    #10;
    $display("Address: %h, Data: %h", a, rd);

    // Test Case 2: Address 4
    a = 32'h00000004;
    #10;
    $display("Address: %h, Data: %h", a, rd);

    // Test Case 3: Address 8
    a = 32'h00000008;
    #10;
    $display("Address: %h, Data: %h", a, rd);

    // Test Case 4: Address 12
    a = 32'h0000000C;
    #10;
    $display("Address: %h, Data: %h", a, rd);

    
    $finish;
  end
  initial
    begin
    $dumpfile("imem_tb.vcd");
    $dumpvars(0, testbench);
    end

endmodule

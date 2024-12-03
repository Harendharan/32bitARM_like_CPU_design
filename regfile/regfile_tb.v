`timescale 1ns / 1ps

module regfile_tb;
  reg clk;
  reg we3;
  reg [3:0] ra1, ra2, wa3;
  reg [31:0] wd3, r15;
  wire [31:0] rd1, rd2;

  regfile dut (
    .clk(clk),
    .we3(we3),
    .ra1(ra1),
    .ra2(ra2),
    .wa3(wa3),
    .wd3(wd3),
    .r15(r15),
    .rd1(rd1),
    .rd2(rd2)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk; // 10ns clock period

   initial begin
    we3 = 0;
    ra1 = 0;
    ra2 = 0;
    wa3 = 0;
    wd3 = 0;
    r15 = 32'hCAFEBABE; 

     // Test Case 1: Write to register 1
    #10;
    we3 = 1;
    wa3 = 4'd1;
    wd3 = 32'h12345678;
    $display("Writing %h to register %d at time %t", wd3, wa3, $time);

    // Test Case 2: Write to register 2
    #10;
    wa3 = 4'd2;
    wd3 = 32'h87654321;
    $display("Writing %h to register %d at time %t", wd3, wa3, $time);

    // Test Case 3: Read from registers 1 and 2
    #10;
    we3 = 0;
    ra1 = 4'd1;
    ra2 = 4'd2;
    #5; // Wait for outputs to stabilize
    $display("Read from registers %d and %d at time %t: rd1=%h, rd2=%h", 
             ra1, ra2, $time, rd1, rd2);

    // Test Case 4: Read from special register r15
    #10;
    ra1 = 4'b1111;
    ra2 = 4'b1111;
    #5; // Wait for outputs to stabilize
    $display("Read from special register r15 at time %t: rd1=%h, rd2=%h", 
             $time, rd1, rd2);

    // Test Case 5: Write and overwrite register 1
    #10;
    we3 = 1;
    wa3 = 4'd1;
    wd3 = 32'hABCDEF00;
    $display("Writing %h to register %d at time %t", wd3, wa3, $time);

    // Test Case 6: Read from register 1 after overwrite
    #10;
    we3 = 0;
    ra1 = 4'd1;
    #5; // Wait for outputs to stabilize
    $display("Read from register %d at time %t: rd1=%h", ra1, $time, rd1);


    #10;
    $finish;
  end

endmodule


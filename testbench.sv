`include "top.v"

module testbench();
	reg clk=1;
	reg reset;

top dut(clk, reset);
  

initial begin
	reset <= 1; 
  	#10;
    reset <= 0;
end
  
  
// Clock
always #5 clk=~clk;

initial begin 
#10000
  
  //  SUB R0, R15, R15 ; R0 = 0                           // Test Case 1
  if (dut.cpu.dp.rf.rf[0] === 32'd0) begin
    $display("Test Passed: R0 contains 0");
  end
  else $display("Test Failed: R0 = %0d, expected 0",dut.cpu.dp.rf.rf[0]);

    
  // ADD R3, R0, #12 ; R3 = 12                           // Test Case 2 
  if (dut.cpu.dp.rf.rf[3] === 32'd12) begin
    $display("Test Passed: R3 contains 12");
  end
  else $display("Test Failed: R3 = %0d, expected 12",dut.cpu.dp.rf.rf[3]);
  

  // ORR R4, R7, R2 ; R4 = 3 OR 5 = 7                     // Test Case 3
  if (dut.cpu.dp.rf.rf[4] === 32'd7) begin
    $display("Test Passed: R4 contains 7");
  end
  else $display("Test Failed: R4 = %0d, expected 7",dut.cpu.dp.rf.rf[4]);

	
  // ADD R5, R5, R4 ; R5 = 4 + 7 = 11                     // Test Case 4
  if (dut.cpu.dp.rf.rf[5] === 32'd11) begin
    $display("Test Passed: R5 contains 11");
  end
  else $display("Test Failed: R5 = %0d, expected 11",dut.cpu.dp.rf.rf[5]);

	
  // SUB R7, R7, R2 ; R7 = 12 - 5 = 7                     // Test Case 5
  if (dut.cpu.dp.rf.rf[7] === 32'd7) begin
    $display("Test Passed: R7 contains 7");
  end
  else $display("Test Failed: R7 = %0d, expected 7",dut.cpu.dp.rf.rf[7]);

	
   // STR R7, [R3, #84] ; mem[12+84] = 7                     // Test Case 6
  if (dut.dmem.RAM[24] === 32'd7) begin
    $display("Test Passed: RAM[24] contains 7");
  end
  else $display("Test Failed: RAM[24] = %0d, expected 7",dut.dmem.RAM[24]);

	
   // LDR R2, [R0, #96] ; R2 = mem[96] = 7                    // Test Case 7
  if (dut.cpu.dp.rf.rf[2] === 32'd7) begin
    $display("Test Passed: R2 contains 7");
  end
  else $display("Test Failed: R2 = %0d, expected 7",dut.cpu.dp.rf.rf[2]);

	
   //STR R2, [R0, #100] ; mem[100] = 7                        // Test Case 8
  if (dut.dmem.RAM[25] === 32'd7) begin
    $display("Test Passed: RAM[25] contains 7");
  end
  else $display("Test Failed: RAM[25] = %0d, expected 7",dut.dmem.RAM[25]);
  
$finish;
end
 
  
endmodule



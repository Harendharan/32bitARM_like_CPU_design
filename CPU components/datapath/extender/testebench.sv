module extend_tb;
    reg [23:0] Instr;
    reg [1:0] ImmSrc;
    wire [31:0] ExtImm;

    extend dut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ExtImm(ExtImm)
    );

    reg clk;
    always #5 clk = ~clk;  
  
    initial begin
        Instr = 24'b0;
        ImmSrc = 2'b0;
        clk = 0;
        
        #100;
        repeat (10) begin
            Instr = $random;
            ImmSrc = $random & 2'b11;  // Ensure ImmSrc is 2 bits
            #10;
          //$display("Instr = %h, ImmSrc = %b, ExtImm = %h", Instr, ImmSrc, ExtImm);
          $display("Instr = %b, ImmSrc = %b, ExtImm = %b", Instr, ImmSrc, ExtImm);
        end
        
  
        $finish;
    end

endmodule


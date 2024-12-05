module condlogic(input logic clk, reset, input [3:0] Cond, input [3:0] ALUFlags, input [1:0] FlagW, input PCS, RegW, MemW, output reg PCSrc, RegWrite, MemWrite);

  wire [1:0] FlagWrite;
  wire [3:0] Flags;
  reg CondEx;

  flopenr #(.WIDTH(2)) flagreg1(clk, reset, FlagWrite[1], ALUFlags[3:2], Flags[3:2]);
  flopenr #(.WIDTH(2)) flagreg0(clk, reset, FlagWrite[0], ALUFlags[1:0], Flags[1:0]);
  
  condcheck cc(Cond, Flags, CondEx);

  assign FlagWrite = FlagW & {2{CondEx}};
  assign RegWrite = RegW & CondEx;
  assign MemWrite = MemW & CondEx;
  assign PCSrc = PCS & CondEx;

endmodule

//flopenr
module flopenr #(parameter WIDTH = 8) (input clk, reset, en, input [WIDTH-1:0] d, output reg [WIDTH-1:0] q);

  always@(posedge clk, posedge reset)
    if (reset) q <= 0;
    else if (en) q <= d;

endmodule


//concheck
module condcheck(input [3:0] Cond, input [3:0] Flags, output reg CondEx);

  wire neg, zero, carry, overflow, ge;
  assign {neg, zero, carry, overflow} = Flags;
  assign ge = ~(neg ^ overflow);

  always@(*) begin
    case(Cond)
      4'b0000: CondEx = zero;              // EQ (Equal)
      4'b0001: CondEx = ~zero;             // NE (Not Equal)
      4'b0010: CondEx = carry;             // CS (Carry Set)
      4'b0011: CondEx = ~carry;            // CC (Carry Clear)
      4'b0100: CondEx = neg;               // MI (Minus)
      4'b0101: CondEx = ~neg;              // PL (Plus)
      4'b0110: CondEx = overflow;          // VS (Overflow Set)
      4'b0111: CondEx = ~overflow;         // VC (Overflow Clear)
      4'b1000: CondEx = carry & ~zero;     // HI (Unsigned Higher)
      4'b1001: CondEx = ~(carry & ~zero);  // LS (Unsigned Lower or Same)
      4'b1010: CondEx = ge;                // GE (Signed Greater or Equal)
      4'b1011: CondEx = ~ge;               // LT (Signed Less Than)
      4'b1100: CondEx = ~zero & ge;        // GT (Signed Greater Than)
      4'b1101: CondEx = ~(~zero & ge);     // LE (Signed Less Than or Equal)
      4'b1110: CondEx = 1'b1;              // AL (Always)
      default: CondEx = 1'bx;              // Undefined condition

    endcase
  end

endmodule


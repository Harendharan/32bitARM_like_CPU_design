
module alu (
  input  [31:0] SrcA,           // 32-bit input A
  input  [31:0] SrcB,           // 32-bit input B
  input  [1:0] ALUControl,      // ALU control signal to select operation
  output reg [31:0] ALUResult,  // 32-bit result
  output reg [3:0] ALUFlag      // ALU flag 
);

  reg Negative, Zero, Carry, Overflow;

  always @(*) begin
    Carry=0;
    Overflow=0;
    case (ALUControl)
      2'b10: begin // AND
        ALUResult = SrcA & SrcB;
      end
      2'b11: begin // OR
        ALUResult = SrcA | SrcB;
      end
      2'b00: begin // ADD
        {Carry, ALUResult} = SrcA + SrcB; 
        Overflow = (SrcA[31] == SrcB[31]) && (ALUResult[31] != SrcA[31]);
      end
      2'b01: begin // SUB
        {Carry, ALUResult} = SrcA - SrcB;
        Overflow = (SrcA[31] != SrcB[31]) && (ALUResult[31] != SrcA[31]);
      end
      default: begin
        ALUResult = 32'b0;
      end
    endcase
  end


  assign Zero = (ALUResult == 32'b0);
  assign Negative = ALUResult[31];
  assign ALUFlag = {Negative, Zero, Carry, Overflow};

endmodule


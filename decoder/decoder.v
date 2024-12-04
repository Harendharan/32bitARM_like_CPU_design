module decoder (
  input [1:0] Op,
  input [5:0] Funct,
  input [3:0] Rd,
  output reg [1:0] FlagW,
  output reg PCS, RegW, MemW,
  output reg MemtoReg, ALUSrc,
  output reg [1:0] ImmSrc, RegSrc, ALUControl
);
  reg Branch, ALUOp;
  reg [9:0] controls;
  
  assign {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp} = controls;

  // Main decoder
  always @(*) begin
    case (Op)
      2'b00: begin
        if (Funct[5]) 
          controls = 10'b0001001001; // Data processing-immediate
        else 
          controls = 10'b0000001001; // Data processing-register
      end

      2'b01: begin
        if (Funct[0]) 
          controls = 10'b0101011000; // LDR
        else 
          controls = 10'b0011010100; // STR
      end

      2'b10: begin
        controls = 10'b1001100010; // B 
      end

      default: begin
        controls = 10'bx; 
      end
    endcase
  end

  // ALU Decoder 
  always @(*) begin
    if (ALUOp) begin 
      case (Funct[4:1])
        4'b0100: ALUControl = 2'b00; // ADD
        4'b0010: ALUControl = 2'b01; // SUB
        4'b0000: ALUControl = 2'b10; // AND
        4'b1100: ALUControl = 2'b11; // ORR
        default: ALUControl = 2'bx;  // Unimplemented operation
      endcase

      // Update flags if S bit is set (C & V only for arithmetic instructions)
      FlagW[1] = Funct[0]; // C flag (for arithmetic)
      FlagW[0] = Funct[0] & (ALUControl == 2'b00 || ALUControl == 2'b01); // V flag (for arithmetic)
    end else begin
      ALUControl = 2'b00; // Default to ADD for non-DP instructions
      FlagW = 2'b00; // Do not update flags for non-DP instructions
    end
  end

  // PC Logic
  assign PCS = ((Rd == 4'b1111) && RegW) || Branch;

endmodule

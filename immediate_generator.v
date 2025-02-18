// Code your design here
module immediate_generator(
  input [31:0] instruction,
  output reg [31:0] imm,
  output reg [3:0] sel
);
  always @(*) begin
    casez (instruction[6:0])
      7'b0010011: sel = 4'b0000; // I-type
      7'b0100011: sel = 4'b0001; // S-type
      7'b1100011: sel = 4'b0010; // B-type
      7'b0010111: sel = 4'b0011; // U-type (AUIPC)
      7'b1101111: sel = 4'b0100; // J-type (JAL)
      7'b0110011: sel = 4'b0101; // R-type
      7'b0000011: sel = 4'b0110; // I-type (Load)
      7'b1100111: sel = 4'b0111; // JALR (I-type format)
      default: sel = 4'b1111; // Default case
    endcase
  end

  always @(*) begin
    case (sel)
      4'b0000: imm = {{20{instruction[31]}}, instruction[31:20]}; // I-type
      4'b0001: imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type
      4'b0010: imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type
      4'b0011: imm = {instruction[31:12], 12'b0}; // U-type (LUI/AUIPC, no sign extension)
      4'b0100: imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-type (JAL)
      4'b0101: imm = 32'b0; // R-type (no immediate)
      4'b0110: imm = {{20{instruction[31]}}, instruction[31:20]}; // I-type (Load)
      4'b0111: imm = {{20{instruction[31]}}, instruction[31:20]}; // JALR (same as I-type)
      default: imm = 32'b0; // Default case
    endcase
  end
endmodule
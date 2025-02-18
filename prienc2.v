module prienc2(
    input wire [4:0] in,  // 5-bit input
    output reg [2:0] out  // 3-bit select output
);
    always @(*) begin
        casez (in)
            5'b1????: out = 3'b100; // IMM for B-type
            5'b01???: out = 3'b011; // PC + IMM
            5'b001??: out = 3'b010; // PC + 4
            5'b0001?: out = 3'b001; // Load Result
            5'b00001: out = 3'b000; // ALU Result
            default:  out = 3'b000; // Default case (ALU Result)
        endcase
    end
endmodule
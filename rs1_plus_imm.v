module rs1_plus_imm(
	input [31:0] rs1, imm_input,
	output reg [31:0] rs1_plus_im
);
	assign rs1_plus_im = rs1+imm_input;
endmodule
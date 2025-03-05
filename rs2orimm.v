module rs2orimm(
	input [31:0] rs2, imm,
	input select,
	output reg [31:0] dataB
);
	always @(*)
	begin
		dataB = select ? imm : rs2;
	end
endmodule
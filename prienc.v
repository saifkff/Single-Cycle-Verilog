module prienc(
	input wire enable,
	output wire mux_select
);
	assign mux_select = enable;
endmodule
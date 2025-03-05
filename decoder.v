module decoder(
    input [31:0] instruction,
    output [4:0] rs1, rs2, rdi
);
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rdi = instruction[11:7];
endmodule
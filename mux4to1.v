module mux_4to1(
    input [1:0] sel,
    input [31:0] pc_plus_4,
    input [31:0] pc_plus_imm,
    input [31:0] rs1_plus_imm_for_jalr,
    output reg [31:0] out
);

    always @(*) begin
        case (sel)
            2'b00: out = pc_plus_4;
            2'b01: out = pc_plus_imm;
            2'b10: out = rs1_plus_imm_for_jalr;
            2'b11: out = pc_plus_imm; 
            default: out = 32'b0; 
        endcase
    end

endmodule
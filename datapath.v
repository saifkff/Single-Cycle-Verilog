module datapath(
    input clk, reset,
    input [31:0] instruction,
    output [4:0] rs1, rs2, rdi,
    output [31:0] reg_input, alu_result, load_result, pc_plus_4, pc_plus_imm, imm_for_b_type,
    output reg [31:0] data_out1, data_out2, imm_out,
    output reg [3:0] sel_bit,
    output wenb, rs2_imm_sel, jal_enb, load_enb, branch_enb, auipc_wenb, lui_enb, branch_taken,
    input enable, select, pc_write, 
    output reg [2:0] sel_bit_mux,
    output wire inp, // 
    output reg [31:0] alu_out, output_data_forstore, pc_plus_imm_for_auipc,
    output reg [2:0] input_to_mux
    output sb, sh, sw, lb, lh, lw, lbu, lhu
);

    wire [31:0] imm;
    wire priority_out;
    wire mux_select;
    wire [31:0] pc_out, pc_next;
    
    assign inp = {~(load_enb | jal_enb), load_enb, jal_enb, lui_enb, auipc_wenb};
    
    pc pc(
        .clk(clk),
        .rst(reset),
        .pc_next(pc_next),
        .pc_write(pc_write),
        .pc_out(pc_out)	
    );
    
    instruction_memo imem(
        .addr(pc_out),
        .instruction(instruction)
    );
    
    decoder decoder(
        .data_in(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rdi(rdi)
    );
    
    regfile reg_file(
        .data_in(reg_input),
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd_select(rdi),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );
    
    immediate_generator imm_gen(
        .instruction(instruction),
        .imm(imm),
        .priority_out(priority_out)
    );
    
    prienc encoder(
        .enable(priority_out),
        .mux_select(mux_select)
    );
    
    mux2to1 mux(
        .imm_input(imm),
        .reg_input(reg_input),
        .select(mux_select),
        .out(imm_out)
    );
    
    rs2orimm control_for_imm(
        .rs2(data_out2),
        .imm(imm_out),
        .dataB(data_out2),
        .select(rs2_imm_sel)
    );
    
    control_unit cu (
        .data_in(instruction),
        .sel_bit(sel_bit),
        .wenb(wenb),
        .rs2_imm_sel(rs2_imm_sel),
        .jal_enb(jal_enb),
        .load_enb(load_enb),
        .branch_enb(branch_enb),
        .auipc_wenb(auipc_wenb),
        .sel_bit_mux(sel_bit_mux),
        .lui_enb(lui_enb)
    );
    
    mux_rs2_to_store mux2(
        .rs2(data_out2),
        .sel_bit(sel),
        .output_data_forstore(output_data_forstore)
    );
    
    adder_for_auipc adder(
        .pc_for_auipc(pc_out),
        .imm_for_btype(imm_out),
        .pc_plus_imm_for_auipc(pc_plus_imm_for_auipc) 
    );
    
    data_mem dmem(
        .clk(clk),
        .load_enb(load_enb),
        .sb(sb),
        .sh(sh),
        .sw(sw),
        .lb(lb),
        .lh(lh),
        .lw(lw),
        .lbu(lbu),
        .lhu(lhu),
        .address(alu_out),
        .write_data(output_data_forstore),
        .read_data(load_result) 
    );
    
    alu ALU(
        .dataA(data_out1),
        .dataB(data_out2),
        .out(alu_out),
        .selector(sel_bit),
        .branch_taken(branch_taken)
    );
    
    prienc2 encoderr(
        .in(inp),
        .out(input_to_mux)
    );
    
    mux8to1 mux(
        .alu_result(alu_out),
        .load_result(load_result), 
        .pc_plus_4(pc_plus_4), 
        .pc_plus_imm(pc_plus_imm_for_auipc),
        .imm_for_b_type(imm_out),
        .sel(input_to_mux),
        .out(reg_input) 
    );

endmodule
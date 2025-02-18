module datapath(
	input clk, enable, reset, select, pc_write
	input [31:0] instruction,
	input [4:0] rs1,rs2,rdi,
	input [31:0] reg_input,
	output reg [31:0] data_out1, data_out2,imm_out,
	output reg [3:0] sel_bit,
	output wenb, rs2_imm_sel, jal_enb, load_enb, branch_enb, auipc_wenb, lui_enb, branch_taken,
	output reg [2:0] sel_bit_mux
	output reg [31:0] alu_out
);
	wire [31:0] imm;
    	wire priority_out;
    	wire mux_select;
    	wire [31:0] pc_out;
    	wire [31:0] pc_next;
    	
    	
    pc pc(
    		.clk(clk),
    		.rst(reset),
    		.pc_next(pc_next),
    		.pc_write(pc_write),
    		.pc_out(pc_out)	
    	);
    	
    instruction_mem imem(
    		.addr(pc_out),
    		.instruction(instruction)
    	);
	
	regfile reg_file(
		.data_in(instruction),
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
	priority_encoder encoder(
		.enable(priority_out),
		.mux_select(mux_select)
	);
	mux_2to1 mux(
		.imm_input(imm),
		.reg_input(reg_input),
		.select(mux_select),
		.out(imm_out)
	);
		
	rs2_or_imm control_for_imm(
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
	
	alu ALU(
		.dataA(data_out1),
		.dataB(data_out2),
		.out(alu_out),
		.selector(sel_bit),
		.branch_taken(branch_taken)
	);
	
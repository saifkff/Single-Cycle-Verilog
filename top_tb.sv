module top_tb;
	reg clk;
	reg rst,enable;
  wire [31:0] pc,pc_imm,pc_plus4,rs1_plus_imm,out_1;
  wire [31:0] instruction,rs2orimmdata,address,write_data;
  wire [4:0] rs1,rs2,rdi;
  wire [31:0] imm;
  wire [3:0] sel,sel_imm,sel_bit;
  wire [31:0] alu_out;
  wire [7:0] in;
  wire [2:0] out_for;
  wire[31:0] data1,data2,outdata_store,read_data,outputt;
  wire select,branch_taken;
  wire [1:0] sel_bit_mux;
    wire addr, sub, sllr, sltr, sltur, xorr, srlr, srar, orr, andr,addi,addi2, slli, slti, sltui, xori, srli, srai, ori, andi,sw, sh, sb, lb, lh, lw, lbu, lhu,jal, jalr,jalreverse,beq, bne, blt, bge, bltu, bgeu,add, sll, slt, sltu, xorrr, srl, sra, orrr, andd,out0, out1, out2, out3,wenb, rs2_imm_sel,lui_enb, auipc_wenb, load_enb, jal_enb, branch_enb, in_to_pr, i0, i1, i2, i3, i4, i5, i6, i7, i8;
  
  fetch uut(
    .clk(clk),
    .rst(rst),
    .sel(sel_bit_mux),
    .pc_plus_4(pc_plus4),
    .pc_plus_imm(pc_imm),
    .pc_plus_imm_2(pc_imm),
    .rs1_plus_imm_for_jalr(rs1_plus_imm)
  );
  decoder dec(
    .instruction(uut.IM.instruction),
    .rs1(rs1),
    .rs2(rs2),
    .rdi(rdi)
  );
  immediate_generator imm_gen(
    .instruction(uut.IM.instruction),
    .imm(imm),
    .sel(sel_imm)
  );
  alu alu(
    .dataA(data1),
    .dataB(out_1),
    .out(alu_out),
    .sel(sel),
    .branch_taken(branch_taken)
  );
  regfile regfile(
    .clk(clk),
    .reset(rst),
    .enable(enable),
    .data_in(outputt),
    .rs1(rs1),
    .rs2(rs2),
    .rd_select(rdi),
    .data_out1(data1),
    .data_out2(data2)
  );
  mux2to1 mux2to1(
    .imm_input(imm),
    .reg_input(data2),
    .select(rs2_imm_sel),
    .out(out_1)
  );
 control_unit control_inst (
   		.addr(addr),
    .sub(sub),
    .sllr(sllr),
    .sltr(sltr),
    .sltur(sltur),
    .xorr(xorr),
    .srlr(srlr),
    .srar(srar),
    .orr(orr),
    .andr(andr),
    .addi(addi),
   .addi2(addi2),
    .slli(slli),
    .slti(slti),
    .sltui(sltui),
    .xori(xori),
    .srli(srli),
    .srai(srai),
    .ori(ori),
    .andi(andi),
    .sw(sw),
    .sh(sh),
    .sb(sb),
    .lb(lb),
    .lh(lh),
    .lw(lw),
    .lbu(lbu),
    .lhu(lhu),
    .jal(jal),
    .jalr(jalr),
   .jalreverse(jalreverse),
    .beq(beq),
    .bne(bne),
    .blt(blt),
    .bge(bge),
    .bltu(bltu),
    .bgeu(bgeu),
    .add(add),
    .sll(sll),
    .slt(slt),
    .sltu(sltu),
    .xorrr(xorrr),
    .srl(srl),
    .sra(sra),
    .orrr(orrr),
    .andd(andd),
    .out0(out0),
    .out1(out1),
    .out2(out2),
    .out3(out3),
   .instruction(uut.IM.instruction),
   .sel(sel),
        .sel_bit_mux(sel_bit_mux),
        .wenb(wenb),
        .rs2_imm_sel(rs2_imm_sel),
        .lui_enb(lui_enb),
        .auipc_wenb(auipc_wenb),
        .load_enb(load_enb),
        .jal_enb(jal_enb),
        .branch_enb(branch_enb),
        .in_to_pr(in_to_pr)
    );
  mux_rs2 muxx(
    .rs2(data2),
    .sel_bit(sel_bit),
    .output_data_forstore(outdata_store)
  );
  data_mem DM(
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
    .write_data(data2),
    .read_data(read_data)
  );
  adder_for_auipc adder_auipc(
    .pc_for_auipc(uut.PC.pc_out),
    .imm_for_btype(imm),
    .pc_plus_imm_for_auipc(pc_imm)
  );
  priority_encoder_8to3 prienc2(
    .alu_result(1'b1),
    .load_enable(load_enb),
    .jal_enb(jal_enb),
    .enable_for_auipc(branch_taken),
    .lui_enable(lui_enb),
    .sel(out_for)
  );
  mux8to1 mux_8to1(
    .sel(out_for),
    .alu_result(alu_out),
    .load_result(read_data),
    .pc_plus_4(uut.PC.pc_out),
    .pc_plus_imm(pc_imm),
    .imm_for_b_type(imm),
    .out(outputt)
  );
  
  pc_plus_4 pc_4(
    .pc(uut.PC.pc_out),
    .pc_plus4(pc_plus4)
  );
  rs1_plus_imm rs1_imm(
    .rs1(data1),
    .imm_input(imm),
    .rs1_plus_im(rs1_plus_imm)
  );
  mux_4to1 mux4to1(
    .sel(sel_bit_mux),
    .pc_plus_4(pc_plus4),
    .pc_plus_imm(pc_imm),
    .rs1_plus_imm_for_jalr(rs1_plus_imm),
    .pc_plus_imm_2(pc_imm),
    .out(pc)
  );
  
  
  always #5 clk = ~clk;
  initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);
	clk = 0;
    rst = 1;
    enable=1;
    #10 rst = 0;
    #100;
    $finish;
  end
  initial begin
    $monitor("Time: %t | PC: %d | Instruction: %h | rs1: %d | rs2: %d | rdi: %d | Imm: %h | Sel: %b | ALU Out: %h | Branch Taken: %b | Reg1: %h | Reg2: %h | sel_bit_mux: %b | wenb: %b | rs2_imm_sel: %b | rd_data: %d", 
                $time, uut.PC.pc_out, uut.IM.instruction, rs1, rs2, rdi, imm, sel_imm, alu_out, branch_taken, data1, data2, sel_bit_mux, wenb, rs2_imm_sel,outputt);
  end
endmodule
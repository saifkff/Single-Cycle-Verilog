module fetch (
    input wire clk,
    input wire rst
);
    wire [31:0] pc, instruction, pc_next;

    assign pc_next = pc + 4;

    program_counter PC (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc_write(1'b1),
        .pc_out(pc)
    );

    instruction_memory IM (
        .addr(pc),
        .instruction(instruction)
    );

endmodule
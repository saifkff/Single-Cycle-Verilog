module instruction_mem (
    input wire [31:0] addr,
    output wire [31:0] instruction
);
    reg [31:0] memory [0:255];

    initial begin
        $readmemh("instructions.hex", memory); 
    end

    assign instruction = memory[addr >> 2]; 

endmodule
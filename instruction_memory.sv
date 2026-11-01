`timescale 1ns / 1ps

module instruction_memory (
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255];

    // Instruction memory read
    always_comb begin
        instruction = memory[address[9:2]];
    end

    // Initialize memory with program instructions
    initial begin
    // Default all locations to NOP
    for (int i = 0; i < 256; i++)
        memory[i] = 32'h00000013;

    // Test program
    memory[0] = 32'h00500093; // ADDI x1, x0, 5
    memory[1] = 32'h00A00113; // ADDI x2, x0, 10
    memory[2] = 32'h002081B3; // ADD  x3, x1, x2
    memory[3] = 32'h00302023; // SW   x3, 0(x0)
    memory[4] = 32'h00002203; // LW   x4, 0(x0)
    end

endmodule
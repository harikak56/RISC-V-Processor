`timescale 1ns / 1ps

module riscv_top (
    input logic clk,
    input logic reset
);

    logic [31:0] pc, instruction, pc_next;
    logic [31:0] rs1_data, rs2_data, imm_out;
    logic [31:0] alu_result, mem_data, wb_data;
    logic [31:0] pc_plus4, wb_result;

    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode;
    logic [2:0] fn3;
    logic fn7_5;

    logic reg_write, alu_src, mem_write;
    logic mem_to_reg, branch, jump;
    logic [2:0] alu_op;
    logic branch_taken;

    // Instruction Fetch
    instruction_fetch IF (
        .clk(clk),
        .reset(reset),
        .stall(1'b0),
        .and_out(branch_taken),
        .pc_signed_offset(pc_next),
        .address(pc)
    );

    assign pc_plus4 = pc + 32'd4;

    // Instruction Memory
    instruction_memory IM (
        .address(pc),
        .instruction(instruction)
    );

    // Instruction Decode
    ID ID_STAGE (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .wb_rd(rd),
        .wb_data(wb_data),
        .wb_reg_write(reg_write),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .fn3(fn3),
        .fn7_5(fn7_5),
        .imm_out(imm_out),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op)
    );

    // Execution
    EX EX_STAGE (
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm_out(imm_out),
        .alu_op(alu_op),
        .fn3(fn3),
        .fn7_5(fn7_5),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .alu_result(alu_result),
        .branch_taken(branch_taken)
    );

    // Branch target
    assign pc_next = (opcode == 7'b1100111)
                   ? ((rs1_data + imm_out) & 32'hFFFF_FFFE)
                   : (pc + imm_out);

    // Memory
    MEM MEM_STAGE (
        .clk(clk),
        .mem_read(mem_to_reg),
        .mem_write(mem_write),
        .alu_result(alu_result),
        .rs2_data(rs2_data),
        .mem_data(mem_data)
    );

    // Write-back select
    assign wb_result = mem_to_reg ? mem_data : alu_result;
    assign wb_data   = jump ? pc_plus4 : wb_result;

endmodule
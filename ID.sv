`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 15:04:02
// Design Name: 
// Module Name: ID
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns / 1ps

module ID (
    input  logic        clk,
    input  logic        reset,

    // Instruction from IF stage
    input  logic [31:0] instruction,

    // Write-back inputs for register file
    input  logic [4:0]  wb_rd,
    input  logic [31:0] wb_data,
    input  logic        wb_reg_write,

    // Register file outputs
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,

    // Decoded instruction fields
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [6:0]  opcode,
    output logic [2:0]  fn3,
    output logic        fn7_5,

    // Immediate output
    output logic [31:0] imm_out,

    // Control signals
    output logic        reg_write,
    output logic        alu_src,
    output logic        mem_write,
    output logic        mem_to_reg,
    output logic        branch,
    output logic        jump,
    output logic [2:0]  alu_op
);

    // Internal signals
    logic [11:0]  imm_12;
    logic [19:0]  imm_20;

    // 1. Instruction Decoder
    instruction_decoder decoder (
        .instruction (instruction),
        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),
        .opcode      (opcode),
        .fn3         (fn3),
        .fn7_5       (fn7_5),
        .imm         ()
    );

    // Extract immediate fields for the immediate generator
    assign imm_12 = instruction[31:20];
    assign imm_20 = instruction[31:12];

    // 2. Main Control Unit
    control_unit control (
        .opcode      (opcode),
        .reg_write   (reg_write),
        .alu_src     (alu_src),
        .mem_write   (mem_write),
        .mem_to_reg  (mem_to_reg),
        .branch      (branch),
        .jump        (jump),
        .alu_op      (alu_op)
    );

    // 3. Immediate Generator
    imm_generator immediate (
        .imm_input    (imm_12),
        .fn3          (fn3),
        .opcode       (opcode),
        .imm_input_uj (imm_20),
        .imm_output   (imm_out)
    );

    // 4. Register File
    reg_file registers (
        .clk       (clk),
        .reset     (reset),
        .rs1_sel   (rs1),
        .rs2_sel   (rs2),
        .rd_sel    (wb_rd),
        .wb_data   (wb_data),
        .reg_write (wb_reg_write),
        .rs1_data  (rs1_data),
        .rs2_data  (rs2_data)
    );

endmodule


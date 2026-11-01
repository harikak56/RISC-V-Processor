`timescale 1ns / 1ps

module EX (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] imm_out,

    input  logic [2:0]  alu_op,
    input  logic [2:0]  fn3,
    input  logic        fn7_5,
    input  logic        alu_src,
    input  logic        branch,
    input  logic        jump,

    output logic [31:0] alu_result,
    output logic        branch_taken
);

    logic [31:0] alu_operand_b;
    logic [4:0]  alu_control_out;
    logic        zero;

    // Select ALU second operand
    mux32 operand_mux (
        .a   (rs2_data),
        .b   (imm_out),
        .sel (alu_src),
        .y   (alu_operand_b)
    );

    // Generate ALU control signals
    alu_control alu_ctrl (
        .alu_op     (alu_op),
        .fn3        (fn3),
        .fn7_5      (fn7_5),
        .imm11_5    (fn7_5),
        .control_out(alu_control_out)
    );

    // Arithmetic and logic operations
    alu alu_unit (
        .operand_a  (rs1_data),
        .operand_b  (alu_operand_b),
        .control_out(alu_control_out),
        .alu_result (alu_result),
        .zero       (zero)
    );

    // Branch and jump decision
    branch_unit branch_logic (
        .fn3         (fn3),
        .rs1_data    (rs1_data),
        .rs2_data    (rs2_data),
        .branch      (branch),
        .jump        (jump),
        .branch_taken(branch_taken)
    );

endmodule
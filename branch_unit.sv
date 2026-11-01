`timescale 1ns / 1ps

module branch_unit (
    input  logic [2:0]  fn3,
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic        branch,
    input  logic        jump,

    output logic        branch_taken
);

    logic comparison;

    always_comb begin
        comparison = 1'b0;

        case (fn3)
            3'b000: comparison = (rs1_data == rs2_data); // BEQ
            3'b001: comparison = (rs1_data != rs2_data); // BNE
            3'b100: comparison = ($signed(rs1_data) < $signed(rs2_data)); // BLT
            3'b101: comparison = ($signed(rs1_data) >= $signed(rs2_data)); // BGE
            3'b110: comparison = (rs1_data < rs2_data); // BLTU
            3'b111: comparison = (rs1_data >= rs2_data); // BGEU
            default: comparison = 1'b0;
        endcase
    end

    assign branch_taken = jump | (branch & comparison);

endmodule
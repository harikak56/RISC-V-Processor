`timescale 1ns / 1ps

module alu (
    input  logic [31:0] operand_a,
    input  logic [31:0] operand_b,
    input  logic [4:0]  control_out,

    output logic [31:0] alu_result,
    output logic        zero
);

    always_comb begin
        alu_result = 32'd0;

        case (control_out)

            5'b00000: alu_result = operand_a + operand_b; // ADD
            5'b00001: alu_result = operand_a - operand_b; // SUB
            5'b00010: alu_result = operand_a & operand_b; // AND
            5'b00011: alu_result = operand_a | operand_b; // OR
            5'b00100: alu_result = operand_a ^ operand_b; // XOR

            5'b00101: alu_result = operand_a << operand_b[4:0]; // SLL
            5'b00110: alu_result = operand_a >> operand_b[4:0]; // SRL
            5'b00111: alu_result = $signed(operand_a) >>> operand_b[4:0]; // SRA

            5'b01000: begin // SLT (signed)
                alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
            end

            5'b01001: begin // SLTU (unsigned)
                alu_result = (operand_a < operand_b) ? 32'd1 : 32'd0;
            end

            5'b01010: alu_result = (operand_a == operand_b) ? 32'd1 : 32'd0; // BEQ
            5'b01011: alu_result = (operand_a != operand_b) ? 32'd1 : 32'd0; // BNE

            5'b01100: begin // BLT
                alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
            end

            5'b01101: begin // BGE
                alu_result = ($signed(operand_a) >= $signed(operand_b)) ? 32'd1 : 32'd0;
            end

            5'b01110: begin // BLTU
                alu_result = (operand_a < operand_b) ? 32'd1 : 32'd0;
            end

            5'b01111: begin // BGEU
                alu_result = (operand_a >= operand_b) ? 32'd1 : 32'd0;
            end

            default: alu_result = 32'd0;

        endcase
    end

    assign zero = (alu_result == 32'd0);

endmodule
`timescale 1ns / 1ps

module control_unit (
    input  logic [6:0] opcode,
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_write,
    output logic       mem_to_reg,
    output logic       branch,
    output logic       jump,
    output logic [2:0] alu_op
);

    always_comb begin
        // Default signal values
        reg_write  = 1'b0;
        alu_src    = 1'b0;
        mem_write  = 1'b0;
        mem_to_reg = 1'b0;
        branch     = 1'b0;
        jump       = 1'b0;
        alu_op = 3'b000;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1'b1;
                alu_op    = 2'b10;
            end

            7'b0010011: begin // I-type ALU
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b10;
            end

            7'b0000011: begin // Load
                reg_write  = 1'b1;
                alu_src    = 1'b1;
                mem_to_reg = 1'b1;
                alu_op     = 2'b00; // ADD for address calculation
            end

            7'b0100011: begin // Store
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 2'b00; // ADD for address calculation
            end

            7'b1100011: begin // Branch
                branch = 1'b1;
                alu_op = 2'b01; // SUB for comparison
            end

            7'b1101111: begin // JAL
                reg_write = 1'b1;
                jump      = 1'b1;
            end

            7'b1100111: begin // JALR
                reg_write = 1'b1;
                alu_src   = 1'b1;
                jump      = 1'b1;
            end

            7'b0110111, 7'b0010111: begin // LUI, AUIPC
                reg_write = 1'b1;
                alu_src   = 1'b1;
            end

            default: ;
        endcase
    end

endmodule
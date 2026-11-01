`timescale 1ns / 1ps

module alu_control (
    input  logic [2:0] alu_op,
    input  logic [2:0] fn3,
    input  logic       fn7_5,
    input  logic       imm11_5,

    output logic [4:0] control_out
);

    always_comb begin
        control_out = 5'b00000;

        case (alu_op)

            // R-type instructions
            3'b000: begin
                case ({fn7_5, fn3})
                    4'b0000: control_out = 5'b00000; // ADD
                    4'b1000: control_out = 5'b00001; // SUB
                    4'b0111: control_out = 5'b00010; // AND
                    4'b0110: control_out = 5'b00011; // OR
                    4'b0100: control_out = 5'b00100; // XOR
                    4'b0001: control_out = 5'b00101; // SLL
                    4'b0101: control_out = 5'b00110; // SRL
                    4'b1101: control_out = 5'b00111; // SRA
                    4'b0010: control_out = 5'b01000; // SLT
                    4'b0011: control_out = 5'b01001; // SLTU
                    default: control_out = 5'b00000;
                endcase
            end

            // I-type ALU instructions
            3'b001: begin
                case (fn3)
                    3'b000: control_out = 5'b00000; // ADDI
                    3'b111: control_out = 5'b00010; // ANDI
                    3'b110: control_out = 5'b00011; // ORI
                    3'b100: control_out = 5'b00100; // XORI
                    3'b001: control_out = 5'b00101; // SLLI
                    3'b101: begin
                        if (imm11_5)
                            control_out = 5'b00111; // SRAI
                        else
                            control_out = 5'b00110; // SRLI
                    end
                    3'b010: control_out = 5'b01000; // SLTI
                    3'b011: control_out = 5'b01001; // SLTIU
                    default: control_out = 5'b00000;
                endcase
            end

            // Load
            3'b010: control_out = 5'b00000; // ADD

            // Store
            3'b011: control_out = 5'b00000; // ADD

            // Branch
            3'b100: begin
                case (fn3)
                    3'b000: control_out = 5'b00001; // BEQ: SUB
                    3'b001: control_out = 5'b00001; // BNE: SUB
                    3'b100: control_out = 5'b01000; // BLT
                    3'b101: control_out = 5'b01000; // BGE
                    3'b110: control_out = 5'b01001; // BLTU
                    3'b111: control_out = 5'b01001; // BGEU
                    default: control_out = 5'b00000;
                endcase
            end

            // JAL, LUI, AUIPC
            3'b110: control_out = 5'b00000;

            default: control_out = 5'b00000;

        endcase
    end

endmodule
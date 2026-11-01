`timescale 1ns / 1ps

module imm_generator (
    input  logic [11:0] imm_input,     // 12-bit immediate bus (I, S, B types)
    input  logic [2:0]  fn3,           // 3-bit funct3 for shift case detection
    input  logic [6:0]  opcode,        // 7-bit opcode
    input  logic [19:0] imm_input_uj,  // 20-bit immediate bus (U, J types)[cite: 3]
    output logic [31:0] imm_output     // 32-bit constructed output immediate[cite: 3]
);

    always_comb begin
        case (opcode)
            // I-type ALU (addi, slli, srli, srai, andi, ori, xori, slti, sltiu)
            7'b0010011: begin
                if (fn3 == 3'b001 || fn3 == 3'b101) begin
                    // Shift instructions (SLLI, SRLI, SRAI): zero-extend the 5-bit shift amount[cite: 3]
                    imm_output = {27'b0, imm_input[4:0]};
                end else begin
                    // Standard I-type: 12-bit sign extension
                    imm_output = {{20{imm_input[11]}}, imm_input};
                end
            end

            // Load (lb, lh, lw, lbu, lhu) & JALR
            7'b0000011, 7'b1100111: begin
                imm_output = {{20{imm_input[11]}}, imm_input};
            end

            // S-type Store (sb, sh, sw)
            7'b0100011: begin
                imm_output = {{20{imm_input[11]}}, imm_input};
            end

            // B-type Branch (beq, bne, blt, bge, bltu, bgeu)
            7'b1100011: begin
                // Appends 1'b0 LSB to form a 13-bit branch offset before sign-extending
                imm_output = {{19{imm_input[11]}}, imm_input, 1'b0};
            end

            // U-type (LUI, AUIPC)
            7'b0110111, 7'b0010111: begin
                // Shifts 20-bit input to the upper 20 bits
                imm_output = {imm_input_uj, 12'b0};
            end

            // J-type (JAL)
            7'b1101111: begin
                // Appends 1'b0 LSB to form a 21-bit jump offset before sign-extending
                imm_output = {{11{imm_input_uj[19]}}, imm_input_uj, 1'b0};
            end

            default: begin
                imm_output = 32'd0;
            end
        endcase
    end

endmodule
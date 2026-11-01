`timescale 1ns / 1ps

module instruction_decoder (
    input  logic [31:0] instruction,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [6:0]  opcode,
    output logic [2:0]  fn3,
    output logic        fn7_5,
    output logic [31:0] imm
);

    always_comb begin
        // Common field extraction
        opcode = instruction[6:0];
        rd     = instruction[11:7];
        fn3    = instruction[14:12];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        fn7_5  = instruction[30];
        imm    = 32'd0;

        case (opcode)
            7'b0110011: begin // R-type
                // Fully decoded by common fields
            end

            7'b0010011, 7'b0000011, 7'b1100111: begin // I-type (ALU, Load, JALR)
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end

            7'b0100011: begin // S-type (Store)
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end

            7'b1100011: begin // B-type (Branch)
                imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end

            7'b0110111, 7'b0010111: begin // U-type (LUI, AUIPC)
                imm = {instruction[31:12], 12'b0};
            end

            7'b1101111: begin // J-type (JAL)
                imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end

            default: ;
        endcase
    end

endmodule
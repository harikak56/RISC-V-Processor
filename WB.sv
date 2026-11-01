`timescale 1ns / 1ps

module WB (
    input  logic [31:0] alu_result,
    input  logic [31:0] mem_data,
    input  logic        mem_to_reg,

    output logic [31:0] wb_data
);

    mux32 wb_mux (
        .a   (alu_result),
        .b   (mem_data),
        .sel (mem_to_reg),
        .y   (wb_data)
    );

endmodule
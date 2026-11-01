`timescale 1ns / 1ps

module MEM (
    input  logic        clk,
    input  logic        mem_read,
    input  logic        mem_write,
    input  logic [31:0] alu_result,
    input  logic [31:0] rs2_data,
    output logic [31:0] mem_data
);

    data_memory DM (
        .clk       (clk),
        .mem_read  (mem_read),
        .mem_write (mem_write),
        .address   (alu_result),
        .write_data(rs2_data),
        .read_data (mem_data)
    );

endmodule
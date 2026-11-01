`timescale 1ns / 1ps

module instruction_fetch (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic        and_out,              // Branch/Jump taken flag
    input  logic [31:0] pc_signed_offset,     // Branch target PC

    output logic [31:0] address               // Current PC value
);

    logic [31:0] pc_next;
    logic [31:0] pc_new;

    assign pc_new = address + 32'd4;

    // Next PC selection logic
    always_comb begin
        if (and_out)
            pc_next = pc_signed_offset;
        else
            pc_next = pc_new;
    end

    // Sequential Program Counter update
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            address <= 32'h8000_0000;
        else if (!stall)
            address <= pc_next;
    end

endmodule
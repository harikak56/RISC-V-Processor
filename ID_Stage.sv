`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2026 14:58:17
// Design Name: 
// Module Name: ID_Stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns / 1ps

module reg_file (
    input  logic        clk,
    input  logic        reset,
    input  logic [4:0]  rs1_sel,
    input  logic [4:0]  rs2_sel,
    input  logic [4:0]  rd_sel,
    input  logic [31:0] wb_data,
    input  logic        reg_write,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    // 32 registers, each 32 bits wide
    logic [31:0] rf [0:31];

    integer i;

    // Initialize registers on reset
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                rf[i] <= 32'b0;
        end
        else begin
            // Write data into the destination register
            if (reg_write && (rd_sel != 5'd0))
                rf[rd_sel] <= wb_data;
        end
    end

    // Asynchronous read from source registers
    always_comb begin
        if (rs1_sel == 5'd0)
            rs1_data = 32'b0;
        else
            rs1_data = rf[rs1_sel];

        if (rs2_sel == 5'd0)
            rs2_data = 32'b0;
        else
            rs2_data = rf[rs2_sel];
    end

endmodule


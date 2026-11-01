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

    logic [31:0] rf [31:0];

    // Asynchronous read logic (Register 0 is hardwired to 0)
    always_comb begin
        rs1_data = (rs1_sel == 5'b0) ? 32'b0 : rf[rs1_sel];
        rs2_data = (rs2_sel == 5'b0) ? 32'b0 : rf[rs2_sel];
    end

    // Synchronous write logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            rf <= '{default: 0};
        end else begin
            if (reg_write && (rd_sel != 5'b0))
                rf[rd_sel] <= wb_data;
        end
    end

endmodule
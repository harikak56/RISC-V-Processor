`timescale 1ns / 1ps

module mux32 (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic        sel,
    output logic [31:0] y
);

    always_comb begin
        if (sel)
            y = b;
        else
            y = a;
    end

endmodule
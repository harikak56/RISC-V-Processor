`timescale 1ns / 1ps

module riscv_tb;

    logic clk;
    logic reset;

    // Instantiate processor
    riscv_top uut (
        .clk   (clk),
        .reset (reset)
    );

    // 10 ns clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset and run
    initial begin
        reset = 1;
        #20;
        reset = 0;

        // Run for 200 ns
        #200;
        $finish;
    end

endmodule
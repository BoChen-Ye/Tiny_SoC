`timescale 1ns / 1ps

module Tiny_SoC_TB();

logic        clk;
logic        reset;
logic 		 dout;


Tiny_SoC dut(
	.clk,
	.reset,
	.dout
);
// initialize test
initial
  begin
    reset <= 1; 
	# 22; 
	reset <= 0;
end

// generate clock to sequence tests
always
  begin
    clk <= 1; 
	# 5; 
	clk <= 0; 
	# 5;
end

endmodule

`timescale 1ns / 1ps

module Adder(
	input [31:0] a,b,
	
	output[31:0] out
);

assign #1 out = a + b;

endmodule
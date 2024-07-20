`timescale 1ns / 1ps

module Mux2
#(parameter WIDTH = 8)
(
	input [WIDTH-1:0] d0,d1,
	input 			  sel,
	
	output[WIDTH-1:0] out
);

assign #1 out = sel ? d1 : d0;

endmodule
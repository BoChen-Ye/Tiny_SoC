`timescale 1ns / 1ps

module Mux3
#(parameter WIDTH = 8)
(
	input [WIDTH-1:0] d0,d1,d2,
	input [1:0]		  sel,
	
	output[WIDTH-1:0] out
);

assign #1 out = sel[1] ? d2 : (sel[0] ? d1 : d0);

endmodule
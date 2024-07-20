`timescale 1ns / 1ps

module Flopr
#(parameter WIDTH = 8)
(	
	input 			  clk,reset,
	input [WIDTH-1:0] d,
	
	output reg [WIDTH-1:0] q
);

always@(posedge clk or posedge reset)
begin
	if (reset)
		q <= #1 0;
	else
		q <= #1 d;
end	

endmodule
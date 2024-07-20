`timescale 1ns / 1ps

module Flopenr
#(parameter WIDTH = 8)
(	
	input 			  clk,reset,en,
	input 	   [WIDTH-1:0] d,
	
	output reg [WIDTH-1:0] q
);

always@(posedge clk or posedge reset)
begin
	if (reset)
		q <= #1 0;
	else if(en)
		q <= #1 d;
end	

endmodule
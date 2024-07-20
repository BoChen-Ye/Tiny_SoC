`timescale 1ns / 1ps

module Flopenrc 
#(parameter WIDTH = 8)
(
	input                  clk, reset,
	input                  en, clear,
	input      [WIDTH-1:0] d, 
	output reg [WIDTH-1:0] q
);
 
always @(posedge clk, posedge reset)
    if      (reset) q <= #1 0;
    else if (clear) q <= #1 0;
    else if (en)    q <= #1 d;

endmodule
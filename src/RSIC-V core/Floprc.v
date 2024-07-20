`timescale 1ns / 1ps

module Floprc 
#(parameter WIDTH = 8)
(
	input                  clk, reset, clear,
	input      [WIDTH-1:0] d, 
	output reg [WIDTH-1:0] q
);

always @(posedge clk, posedge reset)
    if (reset)      q <= #1 0;
    else if (clear) q <= #1 0;
    else            q <= #1 d;

endmodule
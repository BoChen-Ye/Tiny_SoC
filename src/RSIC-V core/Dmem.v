`timescale 1ns / 1ps

module DMEM(
	input         clk, w_en,
    input  [31:0] addr, w_data,
	
    output [31:0] r_data
);

reg  [31:0] RAM[63:0];

assign r_data = RAM[addr[31:2]]; // word aligned

always @(posedge clk)
  if (w_en)
    RAM[addr[31:2]] <= w_data;

endmodule
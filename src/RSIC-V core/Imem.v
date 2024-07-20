`timescale 1ns / 1ps

module Imem(
	input  [31:0] a,
	
    output [31:0] rd
);

reg  [31:0] RAM[63:0];

initial
begin
	$readmemh("D:/Verilog_Project/Tiny_SoC/Tiny_SoC.srcs/sources_1/cpu/instruction.txt",RAM);
end

assign rd = RAM[a[31:2]]; // word aligned

endmodule
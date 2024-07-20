`timescale 1ns / 1ps
//This is the memory Unit

module MEMS(
input 		 clk,reset,
input [31:0] ALUResultE,WriteDataE,PCplus4E,
input [4:0] RdE,

output [31:0] ALUResultM,WriteDataM,PCplus4M,
output [4:0] RdM
);

Flopr #(32) r1M(
	.clk(clk), 
	.reset(reset), 
	.d(ALUResultE), 
	
	.q(ALUResultM)
);
Flopr #(32) r2M(
	.clk(clk), 
	.reset(reset), 
	.d(WriteDataE), 
	
	.q(WriteDataM)
);
Flopr #(32) r3M(
	.clk(clk), 
	.reset(reset), 
	.d(RdE), 
	
	.q(RdM)
);
Flopr #(32) r4M(
	.clk(clk), 
	.reset(reset), 
	.d(PCplus4E), 
	
	.q(PCplus4M)
);

endmodule
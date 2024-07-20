`timescale 1ns / 1ps
//This is the Write Back Unit

module WBU(
input 		 clk,reset,
input [4:0]  RdM,
input [31:0] ALUResultM,
input [31:0] ReadDataM,PCplus4M,
input [1:0]  ResultSrcW,

output [4:0] RdW,
output [31:0] ResultW
);

wire [31:0] ALUResultW,ReadDataW,PCplus4W;	

Flopr #(32) r1W(
	.clk(clk), 
	.reset(reset), 
	.d(ALUResultM), 
	
	.q(ALUResultW)
);
Flopr #(32) r2W(
	.clk(clk), 
	.reset(reset), 
	.d(ReadDataM), 
	
	.q(ReadDataW)
);
Flopr #(32) r3W(
	.clk(clk), 
	.reset(reset), 
	.d(RdM), 
	
	.q(RdW)
);
Flopr #(32) r4W(
	.clk(clk), 
	.reset(reset), 
	.d(PCplus4M), 
	
	.q(PCplus4W)
);
Mux3 #(32) resultmux(
	.d0(ALUResultW),
	.d1(ReadDataW),
	.d2(PCplus4W),
    .sel(ResultSrcW),
    
    .out(ResultW)
);	
	
endmodule

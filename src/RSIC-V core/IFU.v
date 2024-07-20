`timescale 1ns / 1ps
// This is the Instruction Fetch Unit

module IFU(
input 		 clk,reset,
input 		 PCSrcE,
input  [31:0] PCtargetE,
input stallF,

output [31:0] PCF,
output [31:0] PCplus4F
);

wire [31:0] PCnextF;

Mux2 #(32) PCmux(
	.d0(PCplus4F),
	.d1(PCtargetE),
	.sel(PCSrcE),
	
	.out(PCnextF)
);
Flopenr #(32) PCreg(
	.clk(clk),
	.reset(reset),
	.en(~stallF),
	.d(PCnextF),
	
	.q(PCF)
);
Adder PCadd4(
	.a(PCF),
	.b(32'd4),
	
	.out(PCplus4F)
);

endmodule
`timescale 1ns / 1ps
//This is the instruction decode unit

module IDU(
input 		 clk,reset,
input [31:0] PCplus4F,PCF,InstrF,
input 		 flushD,stallD,
input [2:0]  ImmSrcD,
input [31:0] RegWriteW,ResultW,
input [4:0]  RdW,

output [31:0] InstrD,PCplus4D,ImmExtD,
output [31:0] PCD,RD1D,RD2D
);

Flopenr #(32) r1D(
	.clk(clk), 
	.reset(reset), 
	.en(~stallD), 
	.d(PCplus4F), 
	
	.q(PCplus4D)
);
Flopenrc #(32) r2D(
	.clk(clk), 
	.reset(reset), 
	.en(~stallD), 
	.clear(flushD), 
	.d(InstrF),
	
	.q(InstrD)
);
Flopenrc #(32) r3D(
	.clk(clk), 
	.reset(reset), 
	.en(~stallD), 
	.clear(flushD), 
	.d(PCF),
	
	.q(PCD)
);

Regfile rf(
	.clk(clk),
	.reset(reset),
	.we3(RegWriteW),
    .ra1(InstrD[19:15]),
	.ra2(InstrD[24:20]),
	.wa3(RdW),
    .wd3(ResultW),
	
    .rd1(RD1D),
    .rd2(RD2D)
);
Extend ext(
	.instr(InstrD[31:7]),
	.immsrc(ImmSrcD),
    
    .immext(ImmExtD)
);

endmodule
`timescale 1ns / 1ps

module miniRISCVpipe(
	input 		 clk,reset,
	input [31:0] InstrF,
	input [31:0] ReadDataM,
	
	output[31:0] PCF,
	output		 MemWriteM,
	output[31:0] ALUResultM,WriteDataM
);

wire 	   ALUSrcE,RegWriteW,JumpE,ZeroE,PCSrcE;
wire   	   flushE,RegWriteM;
wire [1:0] ResultSrcE,ResultSrcW;
wire [2:0] ALUControlE,ImmSrcD;
wire [31:0]InstrD;

Controller u_control(
	.clk(clk),
	.reset(reset),
	.opD(InstrD[6:0]),
    .funct3D(InstrD[14:12]),
    .funct7b5D(InstrD[30]),
    .ZeroE(ZeroE),
	.flushE(flushE),
    
    .ResultSrcE(ResultSrcE),
	.ResultSrcW(ResultSrcW),
    .MemWriteM(MemWriteM),
    .PCSrcE(PCSrcE),
	.ALUSrcE(ALUSrcE),
	.RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
	.JumpE(JumpE),
    .ImmSrcD(ImmSrcD),
    .ALUControlE(ALUControlE)
);
Datapath u_dp(
	.clk(clk),
	.reset(reset),
    .ResultSrcW(ResultSrcW),
    .PCSrcE(PCSrcE),
	.ALUSrcE(ALUSrcE),
	.RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .ImmSrcD(ImmSrcD),
    .ALUControlE(ALUControlE),
    .InstrF(InstrF),
    .ReadDataM(ReadDataM),
	.ResultSrcE(ResultSrcE),
	
	.ZeroE(ZeroE),
	.InstrD(InstrD),
	.flushE(flushE),
	.PCF(PCF),
	.ALUResultM(ALUResultM),
	.WriteDataM(WriteDataM)
);	

endmodule
	
	
	
	
	
	
	
	
	
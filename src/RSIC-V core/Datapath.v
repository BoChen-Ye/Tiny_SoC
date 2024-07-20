`timescale 1ns / 1ps

module Datapath(
	input 		 clk,reset,
	input [1:0]  ResultSrcW,
	input 		 PCSrcE,ALUSrcE,
	input 		 RegWriteM,RegWriteW,
	input [2:0]  ImmSrcD,
	input [2:0]  ALUControlE,
	input [31:0] InstrF,
	input [31:0] ReadDataM,
	input [1:0]  ResultSrcE,
	
	output 		  ZeroE,
	output [31:0] InstrD,
	output		  flushE,
	output [31:0] PCF,
	output [31:0] ALUResultM,WriteDataM
);

wire [1:0]  forwardAE, forwardBE;
wire 		stallD,stallF;
wire [4:0]  Rs1D, Rs2D, Rs1E, Rs2E, RdM, RdW, RdE,RdD;
wire 		flushD;
wire [31:0] PCplus4F,PCplus4D,PCplus4E,PCplus4M,PCplus4W;
wire [31:0] PCD,PCE;
wire [31:0] PCtargetE;
wire [31:0] RD1D,RD2D,RD1E,RD2E;
wire [31:0] ImmExtD,ImmExtE;
wire [31:0] SrcAE,SrcBE;
wire [31:0] ALUResultE,ALUResultW,WriteDataE,ReadDataW;
wire [31:0] ResultW;

//Fetch stage
IFU u_IFU(
	.clk(clk),
	.reset(reset),
	.PCSrcE(PCSrcE),
	.PCtargetE(PCtargetE),
	.stallF(stallF),
	
	.PCF(PCF),
	.PCplus4F(PCplus4F)
);
//Decode stage
IDU u_IDU(
	.clk(clk),
	.reset(reset),
	.PCF(PCF),
	.PCplus4F(PCplus4F),
	.InstrF(InstrF),
	.flushD(flushD),
	.ImmSrcD(ImmSrcD),
	.RdW(RdW),
	.stallD(stallD),
	.RegWriteW(RegWriteW),
	.ResultW(ResultW),
	
	.InstrD(InstrD),
	.PCplus4D(PCplus4D),
	.ImmExtD(ImmExtD),
	.PCD(PCD),
	.RD1D(RD1D),
	.RD2D(RD2D)
);

assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];
assign RdD = InstrD[11:7];

//Execute stage
EXU u_EXU(
	.clk(clk),
	.reset(reset),
	.Rs1D(Rs1D),
	.Rs2D(Rs2D),
	.RdD(RdD),
	.RD1D(RD1D),
	.RD2D(RD2D),
	.PCD(PCD),
	.PCplus4D(PCplus4D),
	.ImmExtD(ImmExtD),
	.flushE(flushE),
	.ALUSrcE(ALUSrcE),
	.forwardAE(forwardAE),
	.forwardBE(forwardBE),
	.ALUControlE(ALUControlE),
	.ResultW(ResultW),
	.ALUResultM(ALUResultM),
	
	.ZeroE(ZeroE),
	.RdE(RdE),
	.Rs1E(Rs1E),
	.Rs2E(Rs2E),
	.PCplus4E(PCplus4E),
	.PCtargetE(PCtargetE),
	.WriteDataE(WriteDataE),
	.ALUResultE(ALUResultE)
);

//Memory stage
MEMS u_MEMS(
	.clk(clk),
	.reset(reset),
	.ALUResultE(ALUResultE),
	.WriteDataE(WriteDataE),
	.PCplus4E(PCplus4E),
	.RdE(RdE),
	
	.ALUResultM(ALUResultM),
	.WriteDataM(WriteDataM),
	.PCplus4M(PCplus4M),
	.RdM(RdM)
);

//Writeback stage
WBU u_WBU(
	.clk(clk),
	.reset(reset),
	.RdM(RdM),
	.ALUResultM(ALUResultM),
	.ReadDataM(ReadDataM),
	.PCplus4M(PCplus4M),
	.ResultSrcW(ResultSrcW),
	
	.RdW(RdW),
	.ResultW(ResultW)
);

//hazard detection
Hazard H(
	.Rs1D(Rs1D), 
	.Rs2D(Rs2D), 
	.Rs1E(Rs1E), 
	.Rs2E(Rs2E), 
	.RdM(RdM), 
	.RdW(RdW), 
	.RdE(RdE),
	.RegwriteM(RegWriteM), 
	.RegwriteW(RegWriteM),
	.ResultSrcE(ResultSrcE),
	.PCSrcE(PCSrcE),

	.forwardAE(forwardAE), 
	.forwardBE(forwardBE),
	.stallF(stallF), 
	.stallD(stallD), 
	.flushD(flushD), 
	.flushE(flushE)	
);

endmodule



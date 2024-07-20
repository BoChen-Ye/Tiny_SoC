`timescale 1ns / 1ps

module Controller(
	input		clk,reset,
	input [6:0] opD,
	input [2:0] funct3D,
	input  		funct7b5D,
	input  		ZeroE,
	input		flushE,
	
	output[1:0] ResultSrcE,ResultSrcW,
	output 		MemWriteM,
	output 		PCSrcE,ALUSrcE,
	output 		RegWriteM,RegWriteW,JumpE,
	output[2:0] ImmSrcD,
	output[2:0] ALUControlE
);

  wire [1:0] ALUopD;
  wire		 MemWriteD,BranchD,ALUSrcD,RegWriteD,JumpD;
  wire 		 BranchE;
  wire 		 RegWriteE,MemWriteE;
  wire [1:0] ResultSrcD,ResultSrcM,ResultSrcW;
  wire [2:0] ALUControlD;
  
Maindec u_decode(
  	.op(opD),
	
    .ResultSrc(ResultSrcD),
    .MemWrite(MemWriteD),
    .Branch(BranchD),
  	.ALUSrc(ALUSrcD),
    .RegWrite(RegWriteD),
  	.Jump(JumpD),
    .ImmSrc(ImmSrcD),
    .ALUop(ALUopD)
  );
  ALUdec u_ALUdecode(
  	.opb5(opD[5]),
    .funct3(funct3D),
    .funct7b5(funct7b5D),
    .ALUOp(ALUopD),
      
    .ALUControl(ALUControlD)
  );
  
  assign PCSrcE = (BranchE & ZeroE )|JumpE;
//piepelined register
Floprc #(10) regE(
	.clk(clk), 
	.reset(reset), 
	.clear(flushE),
	.d({RegWriteD,ResultSrcD,MemWriteD,JumpD,BranchD,ALUControlD,ALUSrcD}), 
	
	.q({RegWriteE,ResultSrcE,MemWriteE,JumpE,BranchE,ALUControlE,ALUSrcE})
);
Flopr #(4) regM(
	.clk(clk), 
	.reset(reset), 
	.d({RegWriteE,ResultSrcE,MemWriteE}), 
	
	.q({RegWriteM,ResultSrcM,MemWriteM})
);
Flopr #(3) regW(
	.clk(clk), 
	.reset(reset), 
	.d({RegWriteM,ResultSrcM}), 
	
	.q({RegWriteW,ResultSrcW})
);
endmodule
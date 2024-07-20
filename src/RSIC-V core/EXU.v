`timescale 1ns / 1ps
//This is the excute unit

module EXU(
input 		 clk,reset,
input [4:0]  Rs1D,Rs2D,RdD,
input [31:0] RD1D,RD2D,
input [31:0] PCD,PCplus4D,ImmExtD,
input		 flushE,ALUSrcE,
input [1:0]  forwardAE, forwardBE,
input [2:0]  ALUControlE,

input [31:0] ResultW,ALUResultM,

output 		  ZeroE,
output [4:0] RdE,Rs1E,Rs2E,
output [31:0]PCplus4E,
output [31:0]PCtargetE,ALUResultE,WriteDataE
);

wire [31:0] ImmExtE;
wire [31:0] RD1E,RD2E;
wire [31:0] PCE;
wire [31:0] SrcAE,SrcBE;
wire [31:0] ImmExtE;

Floprc #(32) r1E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(RD1D),
	
	.q(RD1E)
);
Floprc #(32) r2E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(RD2D),
	
	.q(RD2E)
);
Floprc #(32) r3E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(PCD),
	
	.q(PCE)
);
Floprc #(32) r4E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(Rs1D),
	
	.q(Rs1E)
);
Floprc #(32) r5E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(Rs2D),
	
	.q(Rs2E)
);
Floprc #(32) r6E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(RdD),
	
	.q(RdE)
);
Floprc #(32) r7E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(ImmExtD),
	
	.q(ImmExtE)
);
Floprc #(32) r8E(
	.clk(clk), 
	.reset(reset),  
	.clear(flushE), 
	.d(PCplus4D),
	
	.q(PCplus4E)
);
Mux3 #(32) SrcAmux(
	.d0(RD1E),
	.d1(ResultW),
	.d2(ALUResultM),
    .sel(forwardAE),
    
    .out(SrcAE)
);
Mux3 #(32) SrcBmux(
	.d0(RD2E),
	.d1(ResultW),
	.d2(ALUResultM),
    .sel(forwardBE),
    
    .out(WriteDataE)
);
Adder PCaddBranch(
	.a(PCE),
	.b(ImmExtE),
	
	.out(PCtargetE)
);
Mux2 #(32) Srcmux(
	.d0(WriteDataE),
	.d1(ImmExtE),
	.sel(ALUSrcE),
	
	.out(SrcBE)
);
ALU alu(
	.A(SrcAE),
	.B(SrcBE),
    .ALUControl(ALUControlE),
    
    .Zero(ZeroE),
    .Result(ALUResultE)
);

endmodule
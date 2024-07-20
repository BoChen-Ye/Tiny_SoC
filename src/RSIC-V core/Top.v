`timescale 1ns / 1ps

module RSICV_Top(
	input 		  clk,reset,
	
	output [31:0] WriteDataM,DataAdrM,
	output 		  MemWriteM
);

wire [31:0] PCF,InstrF,ReadDataM;

//instantiate processor and memories
miniRISCVpipe rvpipe(
	.clk(clk),
	.reset(reset),
    .InstrF(InstrF),
    .ReadDataM(ReadDataM),
    
    .PCF(PCF),
    .MemWriteM(MemWriteM),
    .ALUResultM(DataAdrM),
	.WriteDataM(WriteDataM)
);
Imem imem(
	.a(PCF),
	
	.rd(InstrF)
);
DMEM dmem(
	.clk(clk), 
	.w_en(MemWriteM),
    .addr(DataAdrM), 
	.w_data(WriteDataM),
    
    .r_data(ReadDataM)
);

endmodule
`timescale 1ns / 1ps

module RISCV_subsystem(
	input 		  clk,reset,
	input  [31:0] HRDATA,
	input         HREADY,
	//ram intf
	output [31:0] HADDR,
	output [2:0]  HSIZE,
	output [1:0]  HTRANS,
	output [31:0] HWDATA,
	output 		  HWRITE,
	//ai intf
	output [31:0] HADDR_AI,
	output [2:0]  HSIZE_AI,
	output [1:0]  HTRANS_AI,
	output [31:0] HWDATA_AI,
	output 		  HWRITE_AI
    );
	
	wire [31:0] PCF,InstrF,ReadDataM,WriteDataM,DataAdrM;
	wire MemWriteM;
//instantiate processor and memories
miniRISCVpipe u_rvcore(
	.clk,
	.reset,
    .InstrF,
    .ReadDataM,
    
    .PCF,
    .MemWriteM,
    .ALUResultM(DataAdrM),
	.WriteDataM
);

Imem u_imem(
	.a(PCF),
	
	.rd(InstrF)
);

RV_to_AHB u_RV_intf(
	.clk,
	.reset,
	.ram_addr(DataAdrM),
	.ram_w_en(MemWriteM),
    .ram_w_data(WriteDataM),
	.HADDR,
	.HSIZE,
	.HTRANS,
	.HWDATA,
	.HWRITE,
	
	.HRDATA,
	.HREADY,
	.ram_r_data(ReadDataM),
	//rv to ai
	.HADDR_AI,
	.HSIZE_AI,
	.HTRANS_AI,
	.HWDATA_AI,
	.HWRITE_AI
);

endmodule

`timescale 1ns / 1ps

module RV_to_AHB(
	input clk, reset,
	//rv ahb ram
	input [31:0] ram_addr,
	input 		 ram_w_en,
	input [31:0] ram_w_data,
	output [31:0] HADDR,
	output [2:0]  HSIZE,
	output [1:0]  HTRANS,
	output [31:0] HWDATA,
	output 		  HWRITE,
	//ram ahb rv
	input  [31:0] HRDATA,
	input         HREADY,
	output [31:0] ram_r_data,
	//rv ahb ai
	output [31:0] HADDR_AI,
	output [2:0]  HSIZE_AI,
	output [1:0]  HTRANS_AI,
	output [31:0] HWDATA_AI,
	output 		  HWRITE_AI
    );
	
	assign HADDR  = ram_addr;
	assign HSIZE  = 3'b010;// Always Word reads
	assign HTRANS = 2'b10;
	assign HWDATA = ram_w_data; 
	assign HWRITE = ram_w_en;
	assign ram_r_data = HRDATA;
	
	assign HSIZE_AI=3'b010;
	assign HTRANS_AI = 2'b10;
	assign HWDATA_AI = ram_w_data; 
	assign HWRITE_AI = ram_w_en;
	assign HADDR_AI  = ram_addr;
	
endmodule

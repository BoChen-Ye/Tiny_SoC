`timescale 1ns / 1ps

module AHB_to_MEM(
	input        clk,reset,
	//ahb to mem
	input        HSEL,
	input        HREADY,
	input [1:0]  HTRANS,
	input [2:0]  HSIZE,
	input        HWRITE,
	input [31:0] HADDR,
	input [31:0] HWDATA,
	output       w_en,
	output[31:0] addr,
	output[31:0] w_data,
	//mem to ahb
	input [31:0] r_data,
	output[31:0] HRDATA,
	output       HREADYOUT
    );
	
	logic ahb_access = HTRANS[1] & HSEL & HREADY;
	logic ahb_write  = ahb_access &  HWRITE;
    logic ahb_read   = ahb_access & (~HWRITE);

	logic tx_byte = (~HSIZE[1]) & (~HSIZE[0]);
    logic tx_half = (~HSIZE[1]) &  HSIZE[0];
    logic tx_word = HSIZE[1];
	
	assign addr   = HSEL?HADDR:32'd0;
	assign w_data = HSEL?HWDATA:32'd0;
	assign w_en	  = HWRITE & HSEL;
	assign HRDATA = r_data;
endmodule

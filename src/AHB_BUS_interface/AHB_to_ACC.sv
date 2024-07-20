`timescale 1ns / 1ps

module AHB_to_ACC(
	input clk,reset,
	//interface
	input        HSEL,
	input        HREADY,
	input [1:0]  HTRANS,
	input [2:0]  HSIZE,
	input        HWRITE,
	input [31:0] HADDR,
	input [31:0] HWDATA,
	output [31:0]addr,
	output 		 en_w,en_r,
	output [31:0]ACC_data_in,
	//accelerator
	input [31:0] ACC_data_out,
	output[31:0] HRDATA,
	output       HREADYOUT
    );
	
	logic ahb_access = HTRANS[1] & HSEL & HREADY;
	logic ahb_write  = ahb_access &  HWRITE;
    logic ahb_read   = ahb_access & (~HWRITE);
	logic [31:0] wdata_d1,addr_d1;
	logic sel_d1;
	
	assign en_w = HSEL;
	assign ACC_data_in= sel_d1 ? wdata_d1:32'd0;
	assign addr = sel_d1 ? addr_d1: 32'd0;
	
	always_ff@(posedge clk, posedge reset) begin
		if(reset)begin
			wdata_d1<=32'd0;
			addr_d1<=32'd0;
			sel_d1<=1'd0;
		end
		else begin
			wdata_d1<=HWDATA;
			addr_d1<=HADDR;
			sel_d1<=HSEL;
		end
	end
endmodule

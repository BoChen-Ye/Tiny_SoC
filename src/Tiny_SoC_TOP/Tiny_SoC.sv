`timescale 1ns / 1ps

module Tiny_SoC(
	input clk,reset,
	output dout
    );
	
logic        HSEL_RAM,HSEL_AI;
logic [31:0] HADDR,HADDR_AI;
logic [31:0] HWDATA,HRDATA,HWDATA_AI;
logic [2:0]  HSIZE,HSIZE_AI;
logic        HWRITE,HWRITE_AI;
logic [1:0]  HTRANS,HTRANS_AI;
logic [31:0] addr,w_data,r_data;
logic        w_en;
logic [31:0] rdata_core,rdata_ram;
logic        ready_core,ready_ram;
logic 		 en_w_AI,en_r_AI;
logic [31:0] addr_AI,odata_AI,idata_AI;

RISCV_subsystem u_RVsys(
	.clk,
	.reset,
	.HRDATA(rdata_core),
	.HREADY(ready_core),
	
	.HADDR,
	.HSIZE,
	.HTRANS,
	.HWDATA,
	.HWRITE,
	
	.HADDR_AI,
	.HSIZE_AI,
	.HTRANS_AI,
	.HWDATA_AI,
	.HWRITE_AI
);
	
AHB_DECODER u_ahb_decoder(
	.HADDR,
	.HSEL_RAM,
	.HSEL_AI
);	

AHB_MUX u_ahb_mux(
	.clk,
	.reset,
	.HSEL_RAM,
	.HSEL_AI,
	
	.HREADY_AI(ready_ai),
	.HRDATA_AI(rdata_ai),
	
    .HREADY_RAM(ready_ram),
	.HRDATA_RAM(rdata_ram),
	
	//output
	.HREADY(ready_core),
	.HRDATA(rdata_core)
); 	

AHB_to_MEM u_RAM_intf(
	.clk,
	.reset,
	.HSEL(HSEL_RAM),
	.HREADY(1'b1),
	.HTRANS,
	.HSIZE,
	.HWRITE,
	.HADDR,
	.HWDATA,
	.w_en,
	.addr,
	.w_data,
	
	.r_data,
	.HRDATA(rdata_ram),
	.HREADYOUT(ready_ram)
);

DMEM u_RAM(
	.clk,
	.w_en,
	.addr,
	.w_data,
	
	.r_data
);

AHB_to_ACC u_ACC_intf(
	.clk,
	.reset,
	.HSEL(HSEL_AI),
    .HREADY(1'b1),
    .HTRANS(HTRANS_AI),
    .HSIZE(HSIZE_AI),
    .HWRITE(HWDATA_AI),
    .HADDR(HADDR_AI),
    .HWDATA(HWDATA_AI),
    .addr(addr_AI),
    .en_w(en_w_AI),
	.en_r(en_r_AI),
    .ACC_data_in(idata_AI),
    .ACC_data_out(odata_AI),
    .HRDATA(rdata_ram),
    .HREADYOUT(ready_ai)
);

Accelerator_warpper u_AI_ACC(
	.clk,
	.reset,
	.addr(addr_AI),
	.en_w(en_w_AI),
	.en_r(en_r_AI),
	.data_in(idata_AI),
	.data_out(odata_AI)
);

endmodule

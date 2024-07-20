`timescale 1ns / 1ps

module Regfile(
	input 		 clk,reset,
	input 		 we3,
	input [4:0]  ra1,ra2,wa3,
	input [31:0] wd3,
	
	output[31:0] rd1,rd2
);

reg [31:0] rf[31:0];
// three ported register file
// read two ports combinationally(RA1/RD1,RA2/RD2)
// write third port on rising edge of clock(WA3/WD3/WE3)
// register 0 hardwired to 0
// note:for pipelined processor,write third port on falling edge of clk
integer i;

always@(negedge clk)
begin
	if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            rf[i] <= 32'b0;
        end
	end
	else if(we3)
		rf[wa3] <= wd3;
end

assign #1 rd1 = (ra1 != 0) ? rf[ra1] : 0;
assign #1 rd2 = (ra2 != 0) ? rf[ra2] : 0;

endmodule
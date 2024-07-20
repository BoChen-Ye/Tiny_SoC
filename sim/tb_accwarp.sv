`timescale 1ns / 1ps

module tb_accwarp();

logic        clk;
logic        reset;
logic [31:0] data_in;
logic [31:0] addr;
logic [63:0] data_out;
logic en_w,en_r;

Accelerator_warpper u_acc(
.clk,
.reset,
.addr,
.en_w,
.en_r,
.data_in,
.data_out
); 
// initialize test
initial begin
    reset <=0;
	en_w<=0;
	en_r<=0;
	data_in<=0;
	addr<=0;
	#5 reset<=1;
	#10 reset <=0;	
	end
// generate clock to sequence tests
always
  begin
    clk <= 1; 
	# 5; 
	clk <= 0; 
	# 5;
end
initial begin
	#20 en_w<=1;
	#10 addr <= 'h1000_0000;
	#10 addr <= 'h1000_0004;
	#10 addr <= 'h1000_0008;
	#10 addr <= 'h1000_000C;
	
	#10 addr <= 'h1000_0010;
	#10 addr <= 'h1000_0014;
	#10 addr <= 'h1000_0018;
	#10 addr <= 'h1000_001C;
	
	#10 addr <= 'h1000_0020;
	#10 addr <= 'h1000_0024;
	#10 addr <= 'h1000_0028;
	#10 addr <= 'h1000_002C;
	
	#10 addr <= 'h1000_0030;
	#10 addr <= 'h1000_0034;
	#10 addr <= 'h1000_0038;
	#10 addr <= 'h1000_003C;
	
	#10 addr <= 'h1000_0040;
	#10 addr <= 'h1000_0044;
	#10 addr <= 'h1000_0048;
	
	#10 addr <= 'h1000_004C;
	#10 addr <= 'h1000_0050;
	#10 addr <= 'h1000_0054;
	
	#10 addr <= 'h1000_0058;
	#10 addr <= 'h1000_005C;
	#10 addr <= 'h1000_0060;
	
	#10 addr <= 0;

end
initial begin	
	#30 data_in <= 'd1;
	#10	data_in <= 'd2;
	#10	data_in <= 'd3;
	#10	data_in <= 'd4;

	#10 data_in <= 'd1;
	#10	data_in <= 'd2;
	#10	data_in <= 'd3;
	#10	data_in <= 'd4;

	#10 data_in <= 'd1;
	#10	data_in <= 'd2;
	#10	data_in <= 'd3;
	#10	data_in <= 'd4;

	#10 data_in <= 'd1;
	#10	data_in <= 'd2;
	#10	data_in <= 'd3;
	#10	data_in <= 'd4;
	
    #10 data_in <= 'd1;
	#10	data_in <= 'd4;
	#10	data_in <= 'd7;
		
    #10 data_in <= 'd2;
	#10	data_in <= 'd5;
	#10	data_in <= 'd8;
		
	#10 data_in <= 'd3;
	#10	data_in <= 'd6;
	#10	data_in <= 'd9;
		
	#10 data_in <= 'd0;
	#10	en_w<=0;
	
	#100 en_r<=1;
	#40 en_r<=0;
end





endmodule

`timescale 1ns / 1ps

module Address_Buffer#(
parameter FIFO_DEPTH = 4,FIFO_WIDTH = 32, ADDR=0
)(
	input clk,reset,
    input [31:0] addr,
    input [31:0] data_in,
    input en_w,en_r,
	output wire [31:0] out_1,out_2,out_3,out_4,
	output full,empty
    );
	
	logic [31:0] fifo_1,fifo_2,fifo_3,fifo_4;
	logic wen1,wen2,wen3,wen4;
	logic empty1,empty2,empty3,empty4;
	logic full1,full2,full3,full4;
	assign full = full4;
	assign empty = empty4;
	
    always_ff @(posedge clk or posedge reset) begin
		if(reset)begin
			fifo_1<='d0;
			fifo_2<='d0;
			fifo_3<='d0;
			fifo_4<='d0;
			wen1<=0;
			wen2<=0;
			wen3<=0;
			wen4<=0;
		end	
        else if (en_w) begin
            if(addr[27:0] <= ADDR && !full1)begin 
                fifo_1 <= data_in;
				wen1<=1'b1;
			end
			else if(addr[27:0] <= (ADDR+FIFO_DEPTH*4)&& !full2)begin 
                fifo_2 <= data_in;
				wen2<=1'b1;
				fifo_1 <= 'd0;
				wen1<=1'b0;
			end
			else if(addr[27:0] <= (ADDR+FIFO_DEPTH*4*2)&& !full3)begin 
                fifo_3 <= data_in;
				wen3<=1'b1;
				fifo_2 <= 'd0;
				wen2<=1'b0;
			end
			else if(addr[27:0] <= (ADDR+FIFO_DEPTH*4*3)&& !full4)begin 
                fifo_4 <= data_in;
				wen4<=1'b1;
				fifo_3 <= 'd0;
				wen3<=1'b0;
			end
			else begin
				fifo_4 <= 'd0;
				wen4<=1'b0;
			end
		end
		else begin
			fifo_1<='d0;
			fifo_2<='d0;
			fifo_3<='d0;
			fifo_4<='d0;
			wen1<=0;
			wen2<=0;
			wen3<=0;
			wen4<=0;
		end
    end

	
	FIFO#(FIFO_DEPTH,FIFO_WIDTH) u_fifo1(
		.clk,
		.rstn(!reset),
		.wr_en(wen1),
		.rd_en(en_r),
		.data_in(fifo_1),
		.data_out(out_1),
		.empty(empty1),
		.full(full1)
	);
	
	FIFO#(FIFO_DEPTH,FIFO_WIDTH) u_fifo2(
		.clk,
		.rstn(!reset),
		.wr_en(wen2),
		.rd_en(en_r),
		.data_in(fifo_2),
		.data_out(out_2),
		.empty(empty2),
		.full(full2)
	);
	
	FIFO#(FIFO_DEPTH,FIFO_WIDTH) u_fifo3(
		.clk,
		.rstn(!reset),
		.wr_en(wen3),
		.rd_en(en_r),
		.data_in(fifo_3),
		.data_out(out_3),
		.empty(empty3),
		.full(full3)
	);
	
	FIFO#(FIFO_DEPTH,FIFO_WIDTH) u_fifo4(
		.clk,
		.rstn(!reset),
		.wr_en(wen4),
		.rd_en(en_r),
		.data_in(fifo_4),
		.data_out(out_4),
		.empty(empty4),
		.full(full4)
	);
	
endmodule

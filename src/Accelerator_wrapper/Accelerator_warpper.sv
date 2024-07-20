`timescale 1ns / 1ps

module Accelerator_warpper(
	input clk,reset,
	input [31:0]addr,
	input en_w,
	input en_r,
	input [31:0] data_in,
	output [63:0]data_out
    );

	logic [31:0] i_r1,i_r2,i_r3,i_r4;
	logic [31:0] i_f1,i_f2,i_f3;
	logic empty_f,full_f;
	logic r_data,r_f;
	logic en_data,en_fliter,en_a;
	logic empty_data,full_data;
	logic [31:0] addr_f;
	logic end_conv4;
	logic [2:0] cnt;
	logic r_flag;
	logic [63:0] acc_out_1,acc_out_2;
	logic [63:0] delay1,delay2;
	
	assign addr_f = (addr[27:0]>60)?addr:32'd0;
	
	//counter buffer_f
	always_ff@(posedge clk, posedge reset) begin
		if(reset)begin
			cnt<=2'd0;
			r_flag<=1'd0;
		end
		else if(cnt == 2'd2)begin
			r_flag<=1'd1;
		end
		else if(r_f&&cs==ACC)begin
			cnt<=cnt+1;
		end
		else begin
			cnt<=2'd0;
			r_flag<=1'd0;
		end
	end
	
	//delay
	always_ff@(posedge clk, posedge reset) begin
		if(reset)begin
			delay1<=32'd0;
			delay2<=32'd0;
		end
		else begin
			delay1<=acc_out_2;
			delay2<=delay1;
		end
	end
	
	//FSM
	enum logic [2:0] {IDLE,DATA,FL,ACC,STORE} cs,ns;
	always_ff@(posedge clk, posedge reset) begin
		if(reset)
			cs <= IDLE;
		else
			cs <= ns;
	end
	always_comb begin
	  ns = cs;
	  en_fliter=1'b0;
	  wen_ob=1'b0;
	  case(cs)
		IDLE: begin
			if(en_w)
				ns = cs.next;
			end
		DATA: begin
			if(full_data)begin
				ns = cs.next;
				en_fliter=1'b1;
			end
		end
		FL  : begin
			en_fliter=1'b1;
			if(full_f)
				ns = cs.next;
			end
		ACC : begin
			if(end_conv4)begin
				ns = cs.next;
				wen_ob=1'b1;
			end
		end
		STORE: begin
			wen_ob=1'b1;
			if(full1_ob)
				ns = IDLE;
		end
		default: ns = ns;
	  endcase
	end
	
	always_comb begin
	  case(cs)
		IDLE:begin
			en_data=1'd0;
			en_a=1'b0;
			r_data=1'b0;
			r_f=1'b0;
			
		end
		DATA: begin			
			en_data=1'd1;
		end
		FL: begin			
			en_data=1'd0;
		end
		ACC:begin			
			en_a=1'b1;
			r_data=1'b1;
			r_f=1'b1;
			if(empty_data)
				r_data=1'b0;
			if(r_flag)
				r_f=1'b0;
		end
		STORE:begin
			en_a=1'b0;
			
		end
        default:begin
			en_data=1'd0;
			en_a=1'b0;
			r_data=1'b0;
			r_f=1'b0;
			end
	  endcase
	end
	
Address_Buffer#(4,32,12)
u_data_buffer(
	.clk,
	.reset,
	.addr,
	.data_in,
	.en_w(en_data&en_w),
	.en_r(r_data),
	.out_1(i_r1),
	.out_2(i_r2),
	.out_3(i_r3),
	.out_4(i_r4),
	.full(full_data),
	.empty(empty_data)
);	

Buffer3#(3,32,60)
u_fliter_buffer(
	.clk,
	.reset,
	.addr(addr_f),
	.data_in,
	.en_w(en_fliter&en_w),
	.en_r(r_f),
	.out_1(i_f1),
	.out_2(i_f2),
	.out_3(i_f3),
	.full(full_f),
	.empty(empty_f)
);

Conv4_core u_conv(
	.clk,
	.rstn(!reset),
	.en(en_a),
	.i_r1,.i_r2,.i_r3,.i_r4,
	.i_f1,.i_f2,.i_f3,
	.end_conv4,
	.o_sum1(acc_out_1),
	.o_sum2(acc_out_2)
);

logic [63:0] out_buffer;
logic full1_ob,empty_ob,wen_ob;
assign out_buffer = acc_out_1 | delay2;
FIFO#(4,64) u_out_buffer(
		.clk,
		.rstn(!reset),
		.wr_en(wen_ob),
		.rd_en(en_r),
		.data_in(out_buffer),
		.data_out(data_out),
		.empty(empty_ob),
		.full(full1_ob)
	);

endmodule

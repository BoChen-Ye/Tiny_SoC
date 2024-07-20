`timescale 1ns / 1ps

module ALU(
	input [31:0] A,B,
	input [2:0]  ALUControl,
	
	output		 Zero,
	output reg [31:0] Result
);

wire [31:0] temp1,Sum;
wire		V,slt; //overflow

assign #1 temp1 = ALUControl[0] ? ~B:B;
assign #1 Sum   = A + temp1 + ALUControl[0];
assign #1 V	 = ((~ALUControl[1]) & (A[31]^Sum[31]) & (~ALUControl[0]^A[31]^B[31]));
assign #1 slt	 = V^Sum[31];

always@(*)
  case(ALUControl)
	3'b000: Result <= #1 Sum; //add
	3'b001: Result <= #1 Sum; //sub
	3'b010: Result <= #1 A&B; //and
	3'b011: Result <= #1 A|B; //or
	3'b101: Result <= #1 {31'b0,slt}; //slt
	//default:Result <= #1 32'b0;
  endcase

assign #1 Zero = (Result == 32'b0)? 1'b1:1'b0;

endmodule
`timescale 1ns / 1ps

module Maindec(
	input [6:0] op,
	
	output[1:0] ResultSrc,
	output		MemWrite,
	output		Branch,ALUSrc,
	output		RegWrite,Jump,
	output[2:0] ImmSrc,
	output[1:0] ALUop
);

reg [11:0] controls;
	
always@(*)
	case(op)
	//RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUop_Jump
	  7'b0000000: controls = 12'b0_000_0_0_00_0_00_0;
	  7'b0000011: controls = 12'b1_000_1_0_01_0_00_0;//lw
	  7'b0100011: controls = 12'b0_001_1_1_00_0_00_0;//sw
	  7'b0110011: controls = 12'b1_xxx_0_0_00_0_10_0;//R-type
	  7'b1100011: controls = 12'b0_010_0_0_00_1_01_0;//beq
	  7'b0010011: controls = 12'b1_000_1_0_00_0_10_0;//I-typr ALU
	  7'b1101111: controls = 12'b1_011_0_0_10_0_00_1;//jal
	  7'b0110111: controls = 12'b1_100_1_0_00_0_00_0;//lui
	  default:    controls = 12'bx_xx_x_0_xx_x_xx_x;//???
    endcase

assign {RegWrite,ImmSrc,ALUSrc,MemWrite,
		ResultSrc,Branch,ALUop,Jump} = controls;	
	
endmodule
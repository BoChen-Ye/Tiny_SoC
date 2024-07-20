`timescale 1ns / 1ps

module Extend(
	input [31:7] instr,
	input [2:0]  immsrc,
	
	output reg [31:0] immext
);

always@(*)
	case(immsrc)		
		3'b000: immext = {{20{instr[31]}},instr[31:20]};//I-type		
		3'b001: immext = #1{{20{instr[31]}},instr[31:25],instr[11:7]};//S-type(stores)		
		3'b010: immext = #1{{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};//B-type(branches)		
		3'b011: immext = #1{{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};//J-type(jal)
		3'b100: immext = {instr[31:12],12'd0}; //U-type
		default: immext = 32'bx; //undefined
	endcase

endmodule
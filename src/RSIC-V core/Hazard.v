`timescale 1ns / 1ps

module Hazard
(
	input  	   [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdM, RdW, RdE, 
	input  	         RegwriteM, RegwriteW,PCSrcE,
	input  	   [1:0] ResultSrcE,
	
	output reg [1:0] forwardAE, forwardBE,
	output       	 stallF, stallD, flushD, flushE
);

  wire lwstallD;

  // forwarding sources to E stage (ALU)
  always @(*)
    begin
      forwardAE = 2'b00; forwardBE = 2'b00;
      if (Rs1E != 0)
        if ((Rs1E == RdM) & RegwriteM) 
			forwardAE = 2'b10;
        else if ((Rs1E == RdW) & RegwriteW) 
			forwardAE = 2'b01;
		else
			forwardAE = 2'b00;
			
      if (Rs2E != 0)
        if ((Rs2E == RdM) & RegwriteM) 
			forwardBE = 2'b10;
        else if ((Rs2E == RdW) & RegwriteW) 
			forwardBE = 2'b01;
		else
			forwardBE = 2'b00;
    end

  // stalls  
  assign #1 lwstallD = ResultSrcE[0] & ((Rs1D == RdE) | (Rs2D == RdE));

  assign #1 stallD = lwstallD;
  assign #1 stallF = lwstallD; // stalling D stalls all previous stages
  
  assign #1 flushD = PCSrcE;
  assign #1 flushE = lwstallD | PCSrcE; // stalling D flushes next stage

  // *** not necessary to stall D stage on store if source comes from load;
  // *** instead, another bypass network could be added from W to M
endmodule
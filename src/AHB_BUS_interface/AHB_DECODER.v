
module AHB_DECODER(
	input [31:0]HADDR,
	output  	HSEL_RAM,
	output  	HSEL_AI
);
	assign HSEL_RAM = ((HADDR & 32'hFF00_0000) == 32'h0100_0000);
	assign HSEL_AI  = ((HADDR & 32'hFF00_0000) == 32'h1000_0000);
		
endmodule


module AHB_MUX(
	input		 clk,
	input 		 reset,
	input 		 HSEL_AI,
	input 		 HSEL_RAM,
	
	input		 HREADY_AI,
	input [31:0] HRDATA_AI,
	

	input 		 HREADY_RAM,
	input [31:0] HRDATA_RAM,
	

	output reg		  HREADY,
	output reg [31:0] HRDATA
	
);

	// LATCH HSEL
	reg hsel_ram_reg, hsel_ai_reg;
	
	always @(posedge clk or negedge reset)begin
		if (~reset) 
		 begin
			hsel_ai_reg <= 0;
			hsel_ram_reg <= 0;
		 end
		else
		 begin
			hsel_ram_reg <= HSEL_RAM;
			hsel_ai_reg  <= HSEL_AI;
		 end	
	end
	
	always @(*)begin
		case({hsel_ram_reg,hsel_ai_reg})
		2'b10:begin
			
			HRDATA=HRDATA_RAM;
			HREADY=HREADY_RAM;
		end
		2'b01:begin
			
			HRDATA=HRDATA_AI;
			HREADY=HREADY_AI;
		end
		default:begin
			
			HRDATA=0;
			HREADY=1;
		end
		endcase
	end
	
endmodule 


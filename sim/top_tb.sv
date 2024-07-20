`timescale 1ns / 1ps

module RISCmini_pip_tb();

reg         clk;
reg         reset;
  
wire [31:0] WriteDataM, DataAdrM;
wire 		MemWriteM;

// instantiate device to be tested
RSICV_Top dut(
	.clk(clk),
	.reset(reset),
	
	.WriteDataM(WriteDataM),
	.DataAdrM(DataAdrM),
	.MemWriteM(MemWriteM)
);
  
// initialize test
initial
  begin
    reset <= 1; 
	# 22; 
	reset <= 0;
end

// generate clock to sequence tests
always
  begin
    clk <= 1; 
	# 5; 
	clk <= 0; 
	# 5;
end

// check that 25 gets written to address 100
always@(negedge clk)
  begin
    if(MemWriteM) begin
      if(DataAdrM === 100 & WriteDataM === 25) begin
        $display("Simulation succeeded");
        $stop;
      end else if (DataAdrM !== 96) begin
        $display("Simulation failed");
        $stop;
      end
    end
  end

endmodule
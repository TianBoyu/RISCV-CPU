`include "defines.v"
`timescale 1ns/1ps

module min_sopc_tb();

  reg     CLOCK_50;
  reg     rst;
  
       
  initial begin
    CLOCK_50 = 1'b0;
    forever #20 CLOCK_50 = ~CLOCK_50;
  end
      
  initial begin
    rst = `RstEnable;
    #195 rst= `RstDisable;
    #5000 $stop;
    #1100 $finish;
  end
       
  min_sopc min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);


endmodule
`include "defines.v"
//用于在if和id模块之间传�?�数�?
module if_id(

	input	wire				    clk,
	input wire						rst,
	

	input wire[`InstAddrBus]		if_pc,
	input wire[`InstBus]            if_inst,
	output reg[`InstAddrBus]        id_pc,
	output reg[`InstBus]            id_inst,  
	
	input wire[5:0]					stall
);
	integer file3;
	initial begin
		// file3 = $fopen("if_id.txt");
		// file3 = $fopen("if_id.txt", "r");
		// file3 = $fopen("if_id1.txt");
		// file3 = $fopen("if_id1.txt", "w");
	end
	always @ (posedge clk) begin
		// $fdisplay(file3, "if_id");
		// $fdisplay(file3, "%d", $time);
		if (rst == `RstEnable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end else if(stall[1] == `Stop) begin
			// $display("still stall in if_id");
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
	  	end else if(stall[1] == `NoStop) begin
		  	// $display("if_id");
		  	// $display("%h", if_inst);
		  	id_pc <= if_pc;
		  	id_inst <= if_inst;
		end
	end

	always @ (posedge clk) begin
	end

endmodule
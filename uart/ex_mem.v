`include "defines.v"

module ex_mem(

	input	wire				    clk,
	input wire						rst,
	
	
	//来自执行阶段的信�?	
	input wire[`RegAddrBus]         ex_wd,
	input wire                      ex_wreg,
	input wire[`RegBus]				ex_wdata, 	
	input wire[`OpBus]				ex_aluop, 
	input wire[`SubOpBus]			ex_sub_aluop, 
	input wire[`RegBus]				ex_mem_address, 
	input wire[`RegBus]				ex_reg2, 
	
	//送到访存阶段的信�?
	output reg[`RegAddrBus]         mem_wd,
	output reg                      mem_wreg,
	output reg[`RegBus]				mem_wdata,
	output reg[`OpBus]				mem_aluop, 
	output reg[`SubOpBus]			mem_sub_aluop, 
	output reg[`RegBus]				mem_mem_address, 
	output reg[`RegBus]				mem_reg2,

	input wire[5:0]					stall
);
	integer file5;
	initial begin
		// file5 = $fopen("ex_mem.txt");
		// file5 = $fopen("ex_mem.txt", "r");
		// file5 = $fopen("ex_mem1.txt");
		// file5 = $fopen("ex_mem1.txt", "w");
	end

	always @ (posedge clk) begin
		// $fdisplay(file5, "ex_mem");
		// $fdisplay(file5, "%d", $time);
		if(rst == `RstEnable) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
		    mem_wdata <= `ZeroWord;	
			mem_aluop <= `EXE_NOP;
			mem_sub_aluop <= `OP_DEFAULT;
			mem_mem_address <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
		end else if(stall[3] == `Stop && stall[4] == `NoStop) begin
			mem_wd <= `NOPRegAddr;
			mem_wreg <= `WriteDisable;
			mem_wdata <= `ZeroWord;
			mem_aluop <= `EXE_NOP;
			mem_sub_aluop <= `OP_DEFAULT;
			mem_mem_address <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
		end else if(stall[3] == `NoStop) begin
			mem_wd <= ex_wd;
			mem_wreg <= ex_wreg;
			mem_wdata <= ex_wdata;
			mem_aluop <= ex_aluop;
			mem_sub_aluop <= ex_sub_aluop;
			mem_mem_address <= ex_mem_address;
			mem_reg2 <= ex_reg2;
			// $display("mem_data");
			// $display("%d", ex_wdata);			
		end    //if
	end      //always
			

endmodule
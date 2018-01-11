`include "defines.v"

module id_ex(

	input wire					  clk,
	input wire				      rst,

	
	//从译码阶段传递的信息
	input wire[`OpBus]            id_aluop,
	input wire[`SubOpBus]         id_sub_aluop,
    input wire[`OpBus]            id_updown_op,
	input wire[`RegBus]           id_reg1,
	input wire[`RegBus]           id_reg2,
	input wire[`RegAddrBus]       id_wd,
	input wire                    id_wreg,
	input wire[`RegBus]			  id_link_address, 
	input wire[`InstBus]		  id_inst, 
	
	//传�?�到执行阶段的信�?
	output reg[`OpBus]            ex_aluop,
	output reg[`SubOpBus]         ex_sub_aluop,
    output reg[`OpBus]            ex_updown_op,
	output reg[`RegBus]           ex_reg1,
	output reg[`RegBus]           ex_reg2,
	output reg[`RegAddrBus]       ex_wd,
	output reg                    ex_wreg,
	output reg[`RegBus]			  ex_link_address, 
	output reg[`InstBus]	 	  ex_inst, 

	input wire[5:0]			      stall
	
);
	integer file4;
	initial begin
		// file4 = $fopen("id_ex.txt");
		// file4 = $fopen("id_ex.txt", "r");
		// file4 = $fopen("id_ex1.txt");
		// file4 = $fopen("id_ex1.txt", "w");
	end
	always @ (posedge clk) begin
		// $fdisplay(file4, "id_ex");
		// $fdisplay(file4, "%d", $time);
		// $fdisplay(file4, "%b", id_aluop);	
		if (rst == `RstEnable) begin
			ex_aluop <= `EXE_NOP;
			ex_sub_aluop <= `OP_DEFAULT;
            ex_updown_op <= `UP_OP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;
			ex_link_address <= `ZeroWord;
			ex_inst <= `ZeroWord;
		end else if(stall[2] == `Stop && stall[3] == `NoStop) begin
			ex_aluop <= `EXE_NOP;
			ex_sub_aluop <= `OP_DEFAULT;
			ex_updown_op <= `UP_OP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;
			ex_link_address <= `ZeroWord;
			ex_inst <= `ZeroWord;
		end else if(stall[2] == `NoStop) begin
			ex_aluop <= id_aluop;
			ex_sub_aluop <= id_sub_aluop;
            ex_updown_op <= id_updown_op;
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_wd <= id_wd;
			ex_wreg <= id_wreg;	
			ex_link_address <= id_link_address;	
			ex_inst <= id_inst;
		end
	end
	
endmodule
`include "defines.v"
//也就是if模块
module pc_reg(

	input	wire				    clk,
	input wire						rst,
	
	output reg[`InstAddrBus]		pc,
	output reg                      ce,

	input[5:0]						stall, 
	input wire						branch_flag_i, 
	input wire[`RegBus]				branch_address_i
);

	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin       //指令存储器禁用时，pc为0
			pc <= 32'h00000000;
		end else if(stall[0] == `NoStop) begin
			if(branch_flag_i == `Branch)  begin
				pc <= branch_address_i;             
			end else begin
				pc <= pc + 4'h4;
			end
		end else if(stall[0] == `Stop) begin
			if(branch_flag_i == `Branch) begin
				pc <= branch_address_i;
			end
		end
	end
	
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin        //复位时指令存储器禁用
			ce <= `ChipDisable;
		end else begin
			ce <= `ChipEnable;
		end
	end

endmodule
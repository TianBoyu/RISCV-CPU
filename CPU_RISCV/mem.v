`include "defines.v"

module mem(

	input wire					    rst,
	
	//来自执行阶段的信�????	
	input wire[`RegAddrBus]         wd_i,
	input wire                      wreg_i,
	input wire[`RegBus]				wdata_i,
	
	input wire[`OpBus]				aluop_i, 
	input wire[`SubOpBus]			sub_aluop_i, 
	input wire[`RegBus] 			mem_addr_i, 
	input wire[`RegBus]				reg2_i, 

	input wire[`RegBus]				mem_data_i, 
	
	//送到回写阶段的信�????
	output reg[`RegAddrBus]         wd_o,
	output reg                      wreg_o,
	output reg[`RegBus]				wdata_o,

	output reg[`RegBus]				addr_o, 
	output reg						we_o, 
	output reg[3:0]					byte_selected, 
	output reg[`RegBus]				data_o,
	output reg						ce_o, 
	
	input wire[5:0]					stall
);
    integer file2;
	wire[`RegBus] zero32;

	assign zero32 = `ZeroWord;

	initial begin
		// file2 = $fopen("mem.txt");
		// file2 = $fopen("mem.txt", "r");                                             
		// file2 = $fopen("mem1.txt");
		// file2 = $fopen("mem1.txt", "r");
	end

	

	always @ (*) begin
		// $fdisplay(file2, "mem");
		// $fdisplay(file2, "%d", $time);
		if(rst == `RstEnable) begin
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		    wdata_o <= `ZeroWord;
			addr_o <= `ZeroWord;
			we_o <= `WriteDisable;
			byte_selected <= 4'b0000;
			data_o <= `ZeroWord;
			ce_o <= `ChipDisable;
		end else begin
		    wd_o <= wd_i;
			wreg_o <= wreg_i;
			wdata_o <= wdata_i;
			addr_o <= `ZeroWord;
			we_o <= `WriteDisable;
			addr_o <= `ZeroWord;
			byte_selected <= 4'b1111;
			ce_o <= `ChipDisable;
			case (aluop_i)
				`EXE_LB:	begin
				addr_o <= mem_addr_i;
				we_o <= `WriteDisable;
				ce_o <= `ChipEnable;
					case(sub_aluop_i)
						`OP_LB:		begin
							case(mem_addr_i[1:0])
								2'b00:	begin
									wdata_o <= {{24{mem_data_i[31]}},mem_data_i[31:24]};
									byte_selected <= 4'b1000;
								end
								2'b01:	begin
									wdata_o <= {{24{mem_data_i[23]}},mem_data_i[23:16]};
									byte_selected <= 4'b0100;
								end
								2'b10:	begin
									wdata_o <= {{24{mem_data_i[15]}},mem_data_i[15:8]};
									byte_selected <= 4'b0010;
								end
								2'b11:	begin
									wdata_o <= {{24{mem_data_i[7]}},mem_data_i[7:0]};
									byte_selected <= 4'b0001;
								end
								default:	begin
									wdata_o <= `ZeroWord;
								end
							endcase
						end
						`OP_LH:		begin
							case (mem_addr_i[1:0])
								2'b00:	begin
									wdata_o <= {{16{mem_data_i[31]}},mem_data_i[31:16]};
									byte_selected <= 4'b1100;
								end
								2'b10:	begin
									wdata_o <= {{16{mem_data_i[15]}},mem_data_i[15:0]};
									byte_selected <= 4'b0011;
								end
								default:	begin
									wdata_o <= `ZeroWord;
								end
							endcase				
						end
						`OP_LW:		begin
							addr_o <= mem_addr_i;
							we_o <= `WriteDisable;
							wdata_o <= mem_data_i;
							byte_selected <= 4'b1111;
							ce_o <= `ChipEnable;
						end
						`OP_LBU:	begin
							case(mem_addr_i[1:0])
								2'b00:	begin
									wdata_o <= {{24{1'b0}},mem_data_i[31:24]};
									byte_selected <= 4'b1000;
								end
								2'b01:	begin
									wdata_o <= {{24{1'b0}},mem_data_i[23:16]};
									byte_selected <= 4'b0100;
								end
								2'b10:	begin
									wdata_o <= {{24{1'b0}},mem_data_i[15:8]};
									byte_selected <= 4'b0010;
								end
								2'b11:	begin
									wdata_o <= {{24{1'b0}},mem_data_i[7:0]};
									byte_selected <= 4'b0001;
								end
								default:	begin
									wdata_o <= `ZeroWord;
								end
							endcase
						end
						`OP_LHU:	begin
							case (mem_addr_i[1:0])
								2'b00:	begin
									wdata_o <= {{16{mem_data_i[31]}},mem_data_i[31:16]};
									byte_selected <= 4'b1100;
								end
								2'b10:	begin
									wdata_o <= {{16{mem_data_i[15]}},mem_data_i[15:0]};
									byte_selected <= 4'b0011;
								end
								default:	begin
									wdata_o <= `ZeroWord;
								end
							endcase			
						end
						default:	begin
						end
					endcase
				end
				`EXE_SB:	begin
					// $display("sb!");
					addr_o <= mem_addr_i;
					we_o <= `WriteEnable;	
					ce_o <= `ChipEnable;				
					case(sub_aluop_i)
						`OP_SB:		begin
							data_o <= {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
							case (mem_addr_i[1:0])
								2'b00:	begin
									byte_selected <= 4'b1000;
								end
								2'b01:	begin
									byte_selected <= 4'b0100;
								end
								2'b10:	begin
									byte_selected <= 4'b0010;
								end
								2'b11:	begin
									byte_selected <= 4'b0001;	
								end
								default:	begin
									byte_selected <= 4'b0000;
								end
							endcase		
						end
						`OP_SH:		begin
							data_o <= {reg2_i[15:0],reg2_i[15:0]};
							case (mem_addr_i[1:0])
								2'b00:	begin
									byte_selected <= 4'b1100;
								end
								2'b10:	begin
									byte_selected <= 4'b0011;
								end
								default:	begin
									byte_selected <= 4'b0000;
								end
							endcase				
						end
						`OP_SW:		begin
							data_o <= reg2_i;
							byte_selected <= 4'b1111;
						end
						default:	begin
						end
					endcase
				end
				default:	begin
				end

			endcase
		end    //if
	end      //always
			

endmodule
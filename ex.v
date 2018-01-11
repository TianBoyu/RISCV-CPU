`include "defines.v"

module ex(

	input wire					  rst,
	
	//送到执行阶段的信�????????
	input wire[`RegBus]			  inst_i, 
	input wire[`OpBus]            aluop_i,
	input wire[`SubOpBus]         sub_aluop_i,
    input wire[`OpBus]            updown_op_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,
	input wire[`RegBus]			  link_address_i, 
	
	output reg[`RegAddrBus]       wd_o,
	output reg                    wreg_o,
	output reg[`RegBus]			  wdata_o,
	output wire[`OpBus]			  aluop_o, 
	output wire[`SubOpBus]		  sub_aluop_o, 
	output reg[`RegBus]		  	  mem_addr_o, 
	output wire[`RegBus]		  reg2_o, 		
	
	output reg					  ex_stall,
	input wire[5:0]				  stall
);
    integer file1;
	reg[`RegBus] out;
	initial begin
		// file1 = $fopen("ex.txt");
		// file1 = $fopen("ex.txt", "r");
		// file1 = $fopen("ex1.txt");
		// file1 = $fopen("ex1.txt", "w");
	end
	assign aluop_o = aluop_i;
	assign sub_aluop_o = sub_aluop_i;
	// assign mem_addr_o = reg1_i + ((aluop_i == `EXE_LB) ? {{20{inst_i[31]}}, inst_i[31:20]} : {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]});
	assign reg2_o = reg2_i;

	always @ (*) begin
		if(rst == `RstEnable) begin
			out <= `ZeroWord;
		end else begin
			mem_addr_o <= `ZeroWord;
			ex_stall <= `NoStop;
			case (aluop_i)
				`EXE_ADDI:			begin
					case(sub_aluop_i)	
						`OP_ADDI:			begin
							out <= reg1_i + reg2_i;
						end
						`OP_SLTI:			begin
							out <= (reg1_i[31] && !reg2_i[31]) ||
									(!reg1_i[31] && !reg2_i[31] && reg1_i < reg2_i) ||
									(reg1_i[31] && reg2_i[31] && reg1_i > reg2_i);
						end
						`OP_SLTIU:			begin
							// $display("SLTIU");
							// $display("%h", {20'b0, reg2_i[11:0]});
							// $display("%h", {1'b0, reg1_i[30:0]});
							out <= reg1_i < reg2_i;
						end
						`OP_ORI:			begin
							out <= reg1_i | reg2_i;
						end
						`OP_XORI:			begin
							out <= reg1_i ^ reg2_i;
						end
						`OP_ANDI:			begin
							out <= reg1_i & reg2_i;
						end
						`OP_SLLI:			begin
							out <= reg1_i << reg2_i[4:0];
						end
						`OP_SRLI:			begin
							if(updown_op_i == `UP_OP) begin
								out <= reg1_i >> reg2_i[4:0];
							end else begin
								out <= ({32{reg1_i[31]}} << (6'd32-{1'b0, reg2_i[4:0]})) 
												| reg1_i >> reg2_i[4:0];
							end
						end
						// `OP_SRAI:			begin
						// 	out <= ({32{reg1_i[4]}} << (6'd32-{1'b0, reg2_i[4:0]})) 
						// 						| reg1_i >> reg2_i[4:0];
						// end
						default:			begin
							out <= `ZeroWord;
						end
					endcase
				end
				`EXE_ADD:			begin
					case(sub_aluop_i)	
						`OP_ADD:			begin
							case(updown_op_i)
								`UP_OP:				begin
									out <= reg1_i + reg2_i;
								end
								`DOWN_OP:			begin
									out <= reg1_i + (~reg2_i + 1'b1);
								end
							endcase
						end
						`OP_SLT:			begin
							out <= reg1_i < reg2_i;
						end
						`OP_SLTU:			begin
							out <= {1'b0, reg1_i[30:0]} < {1'b0, reg2_i[30:0]};
						end
						`OP_XOR:			begin
							out <= reg1_i ^ reg2_i;
						end
						`OP_AND:			begin
							out <= reg1_i & reg2_i;
						end
						`OP_SLL:			begin
							out <= (reg1_i << reg2_i[4:0]);
						end
						`OP_OR:				begin
							out <= reg1_i | reg2_i;
						end
						`OP_SRL:			begin
							if(updown_op_i == `UP_OP) begin
								out <= (reg1_i >> reg2_i[4:0]);
							end else begin
								$display("SRA");
								out <= ({32{reg1_i[31]}} << (6'd32-{1'b0, reg2_i[4:0]})) 
												| reg1_i >> reg2_i[4:0];
							end
						end
						// `OP_SRA:			begin
						// 	out <= ({32{reg1_i[4]}} << (6'd32-{1'b0, reg2_i[4:0]})) 
						// 						| reg1_i >> reg2_i[4:0];
						// end
						default:			begin
						end
					endcase
				end
				`EXE_LUI:			begin
					out <= {reg2_i[31:12], 12'h0};
				end
				//PC相关指令TODO
				`EXE_AUIPC:			begin
					out <= reg2_i;
				end
				`EXE_JAL:			begin
					out <= link_address_i;
				end
				`EXE_JALR:			begin
					out <= link_address_i;
				end
				`EXE_BEQ:			begin
					out <= link_address_i;
					// case(sub_aluop_i)	
					// 	`OP_BEQ:			begin
					// 	end
					// 	`OP_BNE:			begin
					// 	end
					// 	`OP_BLT:			begin
					// 	end
					// 	`OP_BGE:			begin
					// 	end
					// 	`OP_BLTU:			begin
					// 	end
					// 	`OP_BGEU:			begin
					// 	end
					// 	default:			begin
					// 	end
					// endcase 
				end
				//load store 指令TODO
				`EXE_LB:			begin
					mem_addr_o <= reg1_i + {{20{inst_i[31]}}, inst_i[31:20]};
					case(sub_aluop_i)	
						`OP_LB:				begin
						end
						`OP_LH:				begin
						end
						`OP_LW:				begin
						end
						`OP_LBU:			begin
						end
						`OP_LHU:			begin
						end
						default:			begin
						end
					endcase				
				end
				`EXE_SB:			begin
					// $display("ex_sb!");
					// wdata_o <= reg2_i;
					mem_addr_o <= reg1_i +  {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
					case(sub_aluop_i)	
						`OP_SB:				begin
						end
						`OP_SH:				begin
						end
						`OP_SW:				begin
						end
						default:			begin
						end
					endcase
				end
				`EXE_FENCE:			begin
				end
				default:				begin
					out <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always


 always @ (*) begin
	 wd_o <= wd_i;	 	 	
	 wreg_o <= wreg_i;
	 wdata_o <= out;
	//  case (aluop_i) 
	//  	`EXE_ORI:		begin
	//  		wdata_o <= out;
	//  	end
	// 	`EXE_ADD:		begin
	// 		wdata_o <= out;
	// 	end
	//  	default:					begin
	//  		wdata_o <= `ZeroWord;
	//  	end
	//  endcase
 end	

endmodule
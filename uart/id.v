`include "defines.v"

module id(

	input wire					  	rst,
	input wire[`InstAddrBus]      	pc_i,
	input wire[`InstBus]          	inst_i,

	input wire[`RegBus]           	reg1_data_i,
	input wire[`RegBus]           	reg2_data_i,

	//送到regfile的信�??????????
	output reg              		reg1_read_o,
	output reg               		reg2_read_o,     
	output reg[`RegAddrBus]       	reg1_addr_o,
	output reg[`RegAddrBus]       	reg2_addr_o, 	      
	
	//送到执行阶段的信�??????????
	output reg[`OpBus]            	aluop_o,
  	output reg[`SubOpBus]         	sub_aluop_o,
  	output reg[`OpBus]            	updown_op_o,
	output reg[`RegBus]           	reg1_o,
	output reg[`RegBus]           	reg2_o,
	output reg[`RegAddrBus]       	wd_o,
	output reg                    	wreg_o,

	//the wire for forwarding 
	input wire					  	ex_wreg_i,
	input wire[`RegBus]				ex_wdata_i,
	input wire[`RegAddrBus]			ex_wd_i,

	input wire					  	mem_wreg_i,
	input wire[`RegBus]				mem_wdata_i,
	input wire[`RegAddrBus]			mem_wd_i,

	output reg						id_stall,
	output reg						branch_flag_o,
	output reg[`RegBus]				branch_address_o,
	output reg[`RegBus]				link_address_o, 

	output wire[`InstBus]			inst_o,
	input wire[5:0]					stall
);	

  wire[6:0]	opcode; wire[2:0] subopcode; wire[6:0] updownop;
  wire[19:0] jump_offset_JAL; wire[11:0] jump_offset_JALR;
  wire[11:0] offset;
  assign opcode = inst_i[6:0];
  assign subopcode = inst_i[14:12];
  assign updownop = inst_i[31:25];
  assign jump_offset_JAL = inst_i[31:12];
  assign jump_offset_JALR = inst_i[31:20];
  assign offset = inst_i[31:20];
  reg[`RegBus]	imm;
  reg instvalid;                                                                                                                                                                                                                                                                                                                  
  integer file;
 
	initial begin
		// file = $fopen("id.txt");
		// file = $fopen("id.txt", "r");
		// file = $fopen("id1.txt");
		// file = $fopen("id1.txt", "r");
	end
	assign inst_o = inst_i;
	always @ (*) begin
		// $fdisplay(file, "id");
		// $fdisplay(file, "%d", $time);
		// file = $fopen("id.txt", "w");
		// $display("id");
		$display("%h", inst_i);
		// $display("%d", $time);
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP; sub_aluop_o <= `OP_DEFAULT; updown_op_o <= `UP_OP;
			wd_o <= `NOPRegAddr; wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0; reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr; reg2_addr_o <= `NOPRegAddr;
			branch_flag_o <= `NotBranch; branch_address_o <= `ZeroWord; link_address_o <= `ZeroWord;	
			imm <= 32'h0;
			id_stall <= `NoStop;			
	  	end else begin
			aluop_o <= `EXE_NOP; sub_aluop_o <= `OP_DEFAULT; updown_op_o <= `UP_OP;
			wd_o <= inst_i[11:7]; wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0; reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[19:15];
			reg2_addr_o <= inst_i[24:20];		
			imm <= `ZeroWord;
			branch_flag_o <= `NotBranch; branch_address_o <= `ZeroWord; link_address_o <= `ZeroWord;
			id_stall <= `NoStop;			
		  	case (opcode)
				// `EXE_ORI:			begin                        //ORI指令
				// 	// $fdisplay(file, "%b", inst_i);
				// 	wreg_o <= `WriteEnable;	
				// 	aluop_o <= `EXE_ORI;sub_aluop_o <= `OP_ORI; updown_op_o <= `UP_OP;
				// 	reg1_read_o <= 1'b1;	
				// 	reg2_read_o <= 1'b0;	  	
				// 	imm <= {20'h0, inst_i[31:20]};		
				// 	wd_o <= inst_i[11:7];
				// 	instvalid <= `InstValid;
				// 	id_stall <= `NoStop;	
				// end
				`EXE_ADDI:			begin
					aluop_o <= `EXE_ADDI; sub_aluop_o <= subopcode; updown_op_o <= updownop;
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;	  	
					imm <= {{20{inst_i[31]}}, inst_i[31:20]};		
					wd_o <= inst_i[11:7]; wreg_o <= `WriteEnable;	
					instvalid <= `InstValid;
					id_stall <= `NoStop;
					case(subopcode)
						`OP_ADDI: 		begin
						end
						`OP_SLTI:		begin
						end
						`OP_SLTIU:		begin
						end
						`OP_XORI:		begin
						end
						`OP_ANDI: 		begin
						end
						`OP_SLLI:		begin
							imm <= {27'h0, inst_i[24:20]};
						end
						`OP_SRLI:		begin
							imm <= {27'h0, inst_i[24:20]};
						end
						// `OP_SRAI:		begin
						// 	imm <= {27'h0, inst_i[24:20]};
						// end
						default:		begin
						end
					endcase
				end
				`EXE_LUI:			begin
					aluop_o <= `EXE_LUI; sub_aluop_o <= subopcode; updown_op_o <= updownop;
					reg1_read_o <= 1'b0; reg2_read_o <= 1'b0;
					imm <= {inst_i[31:12], 12'h0};
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					instvalid <= `InstValid; 
					id_stall <= `NoStop;
				end
				`EXE_AUIPC:			begin
					aluop_o <= `EXE_AUIPC; sub_aluop_o <= subopcode; updown_op_o <= updownop;
					reg1_read_o <= 1'b0; reg2_read_o <= 1'b0;
					imm <= {inst_i[31:12], 12'h0} + pc_i;
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					instvalid <= `InstValid;
					id_stall <= `NoStop;
				end
				`EXE_JAL:			begin
					aluop_o <= `EXE_JAL; sub_aluop_o <= `OP_DEFAULT; updown_op_o <= `UP_OP;
					reg1_read_o <= 1'b0; reg2_read_o <= 1'b0;
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					instvalid <= `InstValid;
					branch_flag_o <= `Branch;
					// branch_address_o <= {{12{jump_offset_JAL[19]}}, jump_offset_JAL[19:0]} + pc_i;
					branch_address_o <= {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:25], inst_i[24:21], 1'b0} + pc_i;
					link_address_o <= pc_i + 4'h4;
					id_stall <= `Stop;
				end
				`EXE_JALR:			begin
					aluop_o <= `EXE_JALR; sub_aluop_o <= `OP_DEFAULT; updown_op_o <= `UP_OP;
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					instvalid <= `InstValid;
					branch_flag_o <= `Branch; 
					branch_address_o <= {{20{jump_offset_JALR[11]}}, jump_offset_JALR[11:0]} + reg1_o;
					link_address_o <= pc_i + 4'h4;
					id_stall <= `Stop;
				end
				`EXE_BEQ:			begin
					aluop_o <= `EXE_BEQ; sub_aluop_o <= subopcode; updown_op_o <= updownop;
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b1; 
					wreg_o <= `WriteDisable; 
					instvalid <= `InstValid;
					branch_flag_o <= `NotBranch;
					branch_address_o <= {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0} + pc_i;
					link_address_o <= `ZeroWord;
					id_stall <= `NoStop;
					case(subopcode)	
						`OP_BEQ:			begin
							if(reg1_o == reg2_o) begin
								id_stall <= `Stop;
								branch_flag_o <= `Branch;
							end
						end
						`OP_BNE:			begin
							if(reg1_o !== reg2_o) begin
								id_stall <= `Stop;
								branch_flag_o <= `Branch;
							end
						end
						`OP_BLT:			begin
							if((reg1_o[31] && !reg2_o[31]) ||
									(!reg1_o[31] && !reg2_o[31] && reg1_o < reg2_o) ||
									(reg1_o[31] && reg2_o[31] && reg1_o > reg2_o)) begin
									id_stall <= `Stop;
									branch_flag_o = `Branch;
							end
						end
						`OP_BGE:			begin
							if((reg2_o[31] && !reg1_o[31]) || 
									(reg2_o[31] && reg1_o[31] && (reg2_o >= reg1_o)) || 
									(!reg2_o[31] && !reg1_o[31] && (reg2_o <= reg1_o))) begin
								// $display("stop");
								id_stall <= `Stop;
								branch_flag_o <= `Branch;
							end
						end
						`OP_BLTU:			begin
							if(reg1_o < reg2_o) begin
								id_stall <= `Stop;
								branch_flag_o <= `Branch;
							end
						end
						`OP_BGEU:			begin
							if(reg1_o >= reg2_o) begin
								id_stall <= `Stop;
								branch_flag_o <= `Branch;
							end
						end
						default:			begin
							branch_flag_o <= `NotBranch;
						end
					endcase 
				end 
				`EXE_LB:			begin
					aluop_o <= `EXE_LB; sub_aluop_o <= subopcode; updown_op_o <= updownop;
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b0;
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					instvalid <= `InstValid;
					// imm <= {{20{inst_i[31]}}, inst_i[31:20]};
					id_stall <= `Stop;
					case(subopcode)	
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
					// $display("id_sb!");
					aluop_o <= `EXE_SB; sub_aluop_o <= subopcode; updown_op_o <= `UP_OP;
					reg1_read_o <= 1'b1; reg2_read_o <= 1'b1;
					wreg_o <= `WriteDisable;
					instvalid <= `InstValid;
					// imm <= {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
					id_stall <= `Stop;
					case(subopcode)	
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
				`EXE_ADD:			begin
					aluop_o <= `EXE_ADD; sub_aluop_o <= subopcode; updown_op_o <= updownop;
					reg1_read_o <= `ReadEnable; reg2_read_o <= `ReadEnable;
					wreg_o <= `WriteEnable; wd_o <= inst_i[11:7];
					instvalid <= `InstValid;
					id_stall <= `NoStop;
					case(subopcode)	
						`OP_ADD:			begin
						end
						`OP_SLT:			begin
						end
						`OP_SLTU:			begin
						end
						`OP_XOR:			begin
						end
						`OP_AND:			begin
						end
						`OP_SLL:			begin
						end
						`OP_SRL:			begin
						end
						`OP_SRA:			begin
							updown_op_o <= `DOWN_OP;
						end
						default:			begin
						end
					endcase
				end
				`EXE_FENCE:			begin
				end
				default: 			begin
				end
		  	endcase		  //case op			
		end       //if
	end         //always
	
	

	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end else if(reg1_addr_o == 32'h0) begin
			reg1_o <= `ZeroWord;
		end else if((reg1_read_o == 1'b1) && (ex_wreg_i ==  1'b1) && (ex_wd_i == reg1_addr_o)) begin
			reg1_o <= ex_wdata_i;
			// $display("forwarding!");
			// $display("%h", reg1_addr_o);
		end else if((reg1_read_o == 1'b1) && (mem_wreg_i ==  1'b1) && (mem_wd_i == reg1_addr_o)) begin
			reg1_o <= mem_wdata_i;
		end else if(reg1_read_o == 1'b1) begin
			reg1_o <= reg1_data_i;
		end else if(reg1_read_o == 1'b0) begin
			reg1_o <= imm;
		end else begin
			reg1_o <= `ZeroWord;
		end
	end
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end else if(reg2_read_o == 1'b1 && reg2_addr_o == 32'h0) begin
			reg2_o <= `ZeroWord;
		end else if((reg2_read_o == 1'b1) && (ex_wreg_i ==  1'b1) && (ex_wd_i == reg2_addr_o)) begin
			reg2_o <= ex_wdata_i;
		end else if((reg2_read_o == 1'b1) && (mem_wreg_i ==  1'b1) && (mem_wd_i == reg2_addr_o)) begin
			// reg2_o <= mem_wdata_i;
		end else if(reg2_read_o == 1'b1) begin
			// $display("reg2");
			// $display("%d", reg2_data_i);
			reg2_o <= reg2_data_i;
		end else if(reg2_read_o == 1'b0) begin
			reg2_o <= imm;
		end else begin
			reg2_o <= `ZeroWord;
		end
	end 

endmodule
`include "defines.v"

module openriscv(

	input	wire				    clk,
	input wire						rst,
	
 
	input wire[`RegBus]             rom_data_i,//从指令存储器取得的指�?
	output wire[`RegBus]            rom_addr_o,//输出到指令存储器的地�?
	output wire                     rom_ce_o,//指令存储器使能信�????
	
	input wire[`RegBus]				ram_data_i, 
	output wire[`RegBus]			ram_addr_o, 
	output wire[`RegBus]			ram_data_o, 
	output wire						ram_we_o, 
	output wire[3:0]				ram_byte_selected, 
	output wire						ram_ce_o
);

	wire[`InstAddrBus]              pc;
	wire[`InstAddrBus]              id_pc_i;
	wire[`InstBus]                  id_inst_i;
	
	//连接译码阶段ID模块的输出与ID/EX模块的输�????
	wire[`OpBus]                    id_aluop_o;
	wire[`SubOpBus]                 id_sub_aluop_o;   
    wire[`OpBus]                    id_updown_op_o;                                                                                              
	wire[`RegBus]                   id_reg1_o;
	wire[`RegBus]                   id_reg2_o;
	wire                            id_wreg_o;
	wire[`RegAddrBus]               id_wd_o;
	wire							id_branch_flag_o;
	wire[`RegBus]					id_branch_address_o;
	wire[`RegBus]					id_link_address_o;
	wire[`InstBus]					id_inst_o;
	
	//连接ID/EX模块的输出与执行阶段EX模块的输�????
	wire[`OpBus]                    ex_aluop_i;
	wire[`SubOpBus]                 ex_sub_aluop_i;
    wire[`OpBus]                    ex_updown_op_i;
	wire[`RegBus]                   ex_reg1_i;
	wire[`RegBus]                   ex_reg2_i;
	wire                            ex_wreg_i;
	wire[`RegAddrBus]               ex_wd_i;
	wire[`RegBus]					ex_link_address_i;
	wire[`InstBus]					ex_inst_i;
	
	//连接执行阶段EX模块的输出与EX/MEM模块的输�????
	wire                            ex_wreg_o;
	wire[`RegAddrBus]               ex_wd_o;
	wire[`RegBus]                   ex_wdata_o;
	wire[`OpBus]					ex_aluop_o;
	wire[`SubOpBus]					ex_sub_aluop_o;
	wire[`RegBus]					ex_mem_addr_o;
	wire[`RegBus]					ex_reg2_o;

	//连接EX/MEM模块的输出与访存阶段MEM模块的输�????
	wire                            mem_wreg_i;
	wire[`RegAddrBus]               mem_wd_i;
	wire[`RegBus]                   mem_wdata_i;
	wire[`OpBus]					mem_aluop_i;
	wire[`SubOpBus]					mem_sub_aluop_i;
	wire[`RegBus]					mem_mem_addr_i;
	wire[`RegBus]					mem_reg2_i;

	//连接访存阶段MEM模块的输出与MEM/WB模块的输�????
	wire                            mem_wreg_o;
	wire[`RegAddrBus]               mem_wd_o;
	wire[`RegBus]                   mem_wdata_o;
	wire[`RegBus]					mem_addr_o;
	wire							mem_we_o;
	wire[3:0]						mem_byte_selected;
	wire[`RegBus]					mem_data_o;
	wire							mem_ce_o;
	
	//连接MEM/WB模块的输出与回写阶段的输�????	
	wire                            wb_wreg_i;
	wire[`RegAddrBus]               wb_wd_i;
	wire[`RegBus]                   wb_wdata_i;

	wire[5:0]						stall;
	wire[5:0]						id_stall;
	wire[5:0]						ex_stall;
	
	//连接译码阶段ID模块与�?�用寄存器Regfile模块
  wire                              reg1_read;
  wire                              reg2_read;
  wire[`RegBus]                     reg1_data;
  wire[`RegBus]                     reg2_data;
  wire[`RegAddrBus]                 reg1_addr;
  wire[`RegAddrBus]                 reg2_addr;
  
  //pc_reg例化
	pc_reg pc_reg0(
		.clk(clk),
		.rst(rst),
		.pc(pc),
		.ce(rom_ce_o),	
		.stall(stall), 
		.branch_flag_i(id_branch_flag_o),
		.branch_address_i(id_branch_address_o)
	);
	
  assign rom_addr_o = pc;

  //IF/ID模块例化
	if_id if_id0(
		.clk(clk),
		.rst(rst),
		.if_pc(pc),
		.if_inst(rom_data_i),
		.id_pc(id_pc_i),
		.id_inst(id_inst_i),	
		.stall(stall)    	
	);
	
	//译码阶段ID模块
	id id0(
		.rst(rst),
		.pc_i(id_pc_i),
		.inst_i(id_inst_i),

		.reg1_data_i(reg1_data),
		.reg2_data_i(reg2_data),

		//送到regfile的信�????
		.reg1_read_o(reg1_read),
		.reg2_read_o(reg2_read), 	  

		.reg1_addr_o(reg1_addr),
		.reg2_addr_o(reg2_addr), 
	  
		//送到ID/EX模块的信�????
		.aluop_o(id_aluop_o),
		.sub_aluop_o(id_sub_aluop_o),
        .updown_op_o(id_updown_op_o),
		.reg1_o(id_reg1_o),
		.reg2_o(id_reg2_o),
		.wd_o(id_wd_o),
		.wreg_o(id_wreg_o),

		.ex_wreg_i(ex_wreg_o),
		.ex_wdata_i(ex_wdata_o),
		.ex_wd_i(ex_wd_o),

		.mem_wreg_i(mem_wreg_o),
		.mem_wdata_i(mem_wdata_o),
		.mem_wd_i(mem_wd_o),	
		.id_stall(id_stall),
		.branch_flag_o(id_branch_flag_o), 
		.branch_address_o(id_branch_address_o),
		.link_address_o(id_link_address_o), 

		.inst_o(id_inst_o),
		.stall(stall)
	);

  //通用寄存器Regfile例化
	regfile regfile1(
		.clk (clk),
		.rst (rst),
		.we	(wb_wreg_i),
		.waddr (wb_wd_i),
		.wdata (wb_wdata_i),
		.re1 (reg1_read),
		.raddr1 (reg1_addr),
		.rdata1 (reg1_data),
		.re2 (reg2_read),
		.raddr2 (reg2_addr),
		.rdata2 (reg2_data),	
		.stall(stall)
	);

	//ID/EX模块
	id_ex id_ex0(
		.clk(clk),
		.rst(rst),
		
		//从译码阶段ID模块传�?�的信息
		.id_aluop(id_aluop_o),
		.id_sub_aluop(id_sub_aluop_o),
        .id_updown_op(id_updown_op_o),
		.id_reg1(id_reg1_o),
		.id_reg2(id_reg2_o),
		.id_wd(id_wd_o),
		.id_wreg(id_wreg_o),
		.id_link_address(id_link_address_o), 
		.id_inst(id_inst_o), 
	
		//传�?�到执行阶段EX模块的信�????
		.ex_aluop(ex_aluop_i),
		.ex_sub_aluop(ex_sub_aluop_i),
        .ex_updown_op(ex_updown_op_i),
		.ex_reg1(ex_reg1_i),
		.ex_reg2(ex_reg2_i),
		.ex_wd(ex_wd_i),
		.ex_wreg(ex_wreg_i),
		.ex_link_address(ex_link_address_i),
		.ex_inst(ex_inst_i),
		
		.stall(stall)
	);		
	
	//EX模块
	ex ex0(
		.rst(rst),
	
		//送到执行阶段EX模块的信�????
		.inst_i(ex_inst_i), 
		.aluop_i(ex_aluop_i),
        .sub_aluop_i(ex_sub_aluop_i),
        .updown_op_i(ex_updown_op_i),
		.reg1_i(ex_reg1_i),
		.reg2_i(ex_reg2_i),
		.wd_i(ex_wd_i),
		.wreg_i(ex_wreg_i),
	  	.link_address_i(ex_link_address_i),
	  //EX模块的输出到EX/MEM模块信息
		.wd_o(ex_wd_o),
		.wreg_o(ex_wreg_o),
		.wdata_o(ex_wdata_o),	
		.aluop_o(ex_aluop_o), 
		.sub_aluop_o(ex_sub_aluop_o),
		.mem_addr_o(ex_mem_addr_o),
		.reg2_o(ex_reg2_o),

		.ex_stall(ex_stall), 
		.stall(stall)
		
	);

  //EX/MEM模块
  ex_mem ex_mem0(
		.clk(clk),
		.rst(rst),
	  
		//来自执行阶段EX模块的信�????	
		.ex_wd(ex_wd_o),
		.ex_wreg(ex_wreg_o),
		.ex_wdata(ex_wdata_o),
		.ex_aluop(ex_aluop_o),
		.ex_sub_aluop(ex_sub_aluop_o),
		.ex_mem_address(ex_mem_addr_o), 
		.ex_reg2(ex_reg2_o), 

		//送到访存阶段MEM模块的信�????
		.mem_wd(mem_wd_i),
		.mem_wreg(mem_wreg_i),
		.mem_wdata(mem_wdata_i),
		.mem_aluop(mem_aluop_i),
		.mem_sub_aluop(mem_sub_aluop_i),
		.mem_mem_address(mem_mem_addr_i),
		.mem_reg2(mem_reg2_i), 

		.stall(stall)

						       	
	);
	
  //MEM模块例化
	mem mem0(
		.rst(rst),
	
		//来自EX/MEM模块的信�????	
		.wd_i(mem_wd_i),
		.wreg_i(mem_wreg_i),
		.wdata_i(mem_wdata_i),
		.aluop_i(mem_aluop_i), 
		.sub_aluop_i(mem_sub_aluop_i),
		.mem_addr_i(mem_mem_addr_i),
		.reg2_i(mem_reg2_i),
	  
		.mem_data_i(ram_data_i),
		//送到MEM/WB模块的信�????
		.wd_o(mem_wd_o),
		.wreg_o(mem_wreg_o),
		.wdata_o(mem_wdata_o),	

		.addr_o(ram_addr_o),
		.we_o(ram_we_o),
		.byte_selected(ram_byte_selected),
		.data_o(ram_data_o),
		.ce_o(ram_ce_o),


		.stall(stall)
	);

  //MEM/WB模块
	mem_wb mem_wb0(
		.clk(clk),
		.rst(rst),

		//来自访存阶段MEM模块的信�????	
		.mem_wd(mem_wd_o),
		.mem_wreg(mem_wreg_o),
		.mem_wdata(mem_wdata_o),
	
		//送到回写阶段的信�????
		.wb_wd(wb_wd_i),
		.wb_wreg(wb_wreg_i),
		.wb_wdata(wb_wdata_i),	
		
		.stall(stall)
									       	
	);

	ctrl ctrl0(
		.rst(rst),
		.id_stall(id_stall),
		.ex_stall(ex_stall),
		.stall(stall)
	);

endmodule
`include "defines.v"

module min_sopc(

	input	wire									clk,
	input wire										rst,
	input Rx, 
	output wire Tx
	
);

  //连接指令存储�?
  	wire[`InstAddrBus]            	inst_addr;
  	wire[`InstBus]                	inst;
  	wire                          	rom_ce;
 //连接内存
	wire[`RegBus]				  	ram_data_write;
	wire[`RegBus]				  	ram_data_read;
	wire[`RegBus]					ram_addr;
	wire							ram_we;
	wire[3:0]						ram_byte_selected;
	wire							ram_ce;

	wire							busy_inst;
	wire							finish_inst;
	wire							busy_data;
	wire							finish_data;
 	openriscv openriscv0(
		.clk(clk),
		.rst(rst),
	
		.rom_addr_o(inst_addr),
		.rom_data_i(inst),
		.rom_ce_o(rom_ce),

		.ram_data_i(ram_data_read),
		.ram_addr_o(ram_addr),
		.ram_data_o(ram_data_write),
		.ram_we_o(ram_we),
		.ram_byte_selected(ram_byte_selected),
		.ram_ce_o(ram_ce),

		.busy_inst(busy_inst),
		.finish_inst(finish_inst),
		.busy_data(busy_data),
		.finish_data(finish_data) 	
	);

	mem_ctrl mem_ctrl0(
		.CLK(clk),
		.RST(rst),
		.read_op1(rom_ce),
		.read_op2(ram_ce),
		.write_op(ram_we),
		.addr1(inst_addr),
		.addr2(ram_addr),
		.data2_i(ram_data_write),

		.data1_o(inst),
		.data2_o(ram_data_read),
		.mask(ram_byte_selected),
		.busy1(busy_inst),
		.done1(finish_inst),
		.busy2(busy_data),
		.done2(finish_data),

		.Tx(Tx),
		.Rx(Rx)
	);
	
	// inst_rom inst_rom0(
	// 	.addr(inst_addr),
	// 	.inst(inst),
	// 	.ce(rom_ce)
	// );

	// data_ram data_ram0(
	// 	.clk(clk),
	// 	.ce(ram_ce),
	// 	.we(ram_we),
	// 	.addr(ram_addr),
	// 	.byte_selected(ram_byte_selected),
	// 	.data_i(ram_data_write),

	// 	.data_o(ram_data_read)
	// );


endmodule
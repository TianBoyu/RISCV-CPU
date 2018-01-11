`include "defines.v"

module min_sopc(

	input	wire									clk,
	input wire										rst
	
);

  //连接指令存储器
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
		.ram_ce_o(ram_ce)	
	);
	
	inst_rom inst_rom0(
		.addr(inst_addr),
		.inst(inst),
		.ce(rom_ce)
	);

	data_ram data_ram0(
		.clk(clk),
		.ce(ram_ce),
		.we(ram_we),
		.addr(ram_addr),
		.byte_selected(ram_byte_selected),
		.data_i(ram_data_write),

		.data_o(ram_data_read)
	);






endmodule
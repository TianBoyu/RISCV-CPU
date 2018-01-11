`include "defines.v"

module inst_rom(

	input wire                          ce,
	input wire[`InstAddrBus]			addr,
	output reg[`InstBus]				inst
	
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	initial begin
	// $readmemb ( "F:/inst_rom.data", inst_mem );
	$readmemh ("F:/programing/Verilog/testdata/ld_st.data", inst_mem);
	//$display("%b", inst_mem);
	end
	always @ (*) begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;
	  end else begin
	  		// inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
		  inst <= {inst_mem[addr[`InstMemNumLog2+1:2]][7:0], inst_mem[addr[`InstMemNumLog2+1:2]][15:8], 
		  			inst_mem[addr[`InstMemNumLog2+1:2]][23:16], inst_mem[addr[`InstMemNumLog2+1:2]][31:24]};
		  //inst <= inst_mem[addr[16:0]];
		end
	end

endmodule
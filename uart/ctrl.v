`include "defines.v"
module ctrl(
    input wire              rst,
    input wire              id_stall,
    input wire              ex_stall,
    output reg[5:0]         stall
);

    always @ (*)    begin
        if(rst == `RstEnable) begin
            stall <= 6'b000000;
        end else if(ex_stall == `Stop) begin
            stall <= 6'b001111;
        end else if(id_stall == `Stop) begin
            // $display("id_stall");
            // $display("%d", $time);
            stall <= 6'b000011;
        end else begin
            // $display("stall_recover");
            stall <= 6'b000000;
        end 
    end


endmodule // ctrl
`default_nettype none
`timescale 1ns / 1ps
`define CKSUM	32'h1a3a_ccb2
module cksum(
	input wire clk,
	input wire rst,
	input wire axiiv,
	input wire[1:0] axiid,

	output logic done,
	output logic kill
);
logic old_axiiv;
logic crc_rst;
logic axiov;
logic[31:0] axiod;
crc32 crc32_bzip2 (.clk(clk),.rst(crc_reset),.axiiv(axiiv),.axiid(axiid),.axiov(axiov),.axiod(axiod)); 
always_ff @(posedge clk)begin
	if(rst)begin
		crc_reset <= 1;
		axiov <= 0;
		axiod <= 0;
		done <= 0;
		kill <= 0;
	end
	if(old_axiiv == ~axiiv && axiiv == 0)begin
		done <= 1;
		if(axiod == CKSUM)begin
			kill <= 0;
		end else begin
			kill <= 1;
		end
	end
	old_axiiv <= axiiv;
end
assign crc_reset = rst | axiiv;
endmodule
`default_nettype wire

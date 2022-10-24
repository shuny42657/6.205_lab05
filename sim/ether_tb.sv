`default_nettype none
`timescale 1ns / 1ps

module ether_tb;

logic clk;
logic rst;

logic [1:0] rxd;
logic crsdv;

logic [1:0] axiov;
logic axiod;

ether uut(
	.clk(clk),
	.rst(rst),
	.rxd(rxd),
	.crsdv(crsdv),
	.axiov(axiov),
	.axiod(axiod));

always begin
	#10;
	clk = !clk;
end
initial begin
	//two clock cycles
	axiov = 1;
	#20;
	axiov = 0;
	#20;
end
endmodule

`default_nettype wire

`default_nettype none
`timescale 1ns / 1ps
module top_level(
	input wire clk,
	input wire btnc,
	input wire[1:0] eth_rxd,
	input wire eth_crsdv,

	output logic eth_rstn,
	output logic eth_refclk,
	output logic[15:0] led

);
logic axiov;
logic old_axiov;
logic[1:0] axiod;
logic[15:0] axiov_count;
divider refclk(.clk(clk),.ethclk(eth_refclk));
ether eth(.clk(eth_refclk),.rst(btnc),.rxd(eth_rxd),.crsdv(eth_crsdv),.axiov(axiov),.axiod(axiod));

always_ff @(posedge eth_refclk)begin
	old_axiov <= axiov;
	if(old_axiov != axiov && axiov)begin
		axiov_count <= axiov_count + 1;
	end
end

assign led = axiov_count;
assign eth_rstn = ~btnc;
endmodule
`default_nettype wire

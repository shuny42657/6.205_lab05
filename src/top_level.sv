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
logic axiov_ether;
logic old_axiov;
logic[1:0] axiod_ether;
logic[15:0] axiov_count;
logic[13:0] done_count;
divider refclk(.clk(clk),.ethclk(eth_refclk));
ether eth(.clk(eth_refclk),.rst(btnc),.rxd(eth_rxd),.crsdv(eth_crsdv),.axiov(axiov_ether),.axiod(axiod_ether));

logic [1:0] axiod_bitorder;
logic axiov_bitorder;

bitorder bo(.clk(eth_refclk),.rst(btnc),.axiiv(axiov_ether),.axiid(axiod_ether),.axiov(axiov_bitorder),.axiod(axiod_bitorder));

logic axiov_firewall;
logic[1:0] axiod_firewall;

firewall fw(.clk(eth_refclk),.rst(btnc),.axiiv(axiov_bitorder),.axiid(axiod_bitorder),.axiov(axiov_firewall),.axiod(axiod_firewall));


logic done;
logic kill;
logic old_done;
cksum cs(.clk(eth_refclk),.rst(btnc),.axiiv(axiov_ether),.axiid(axiod_ether),.done(done),.kill(kill));

always_ff @(posedge eth_refclk)begin
	/*old_axiov <= axiov;
	if(old_axiov != axiov && axiov)begin
		axiov_count <= axiov_count + 1;
	end*/

       if(done == 1 && done != old_done)begin
	       done_count <= done_count + 1;
       end
       old_done <= done;

end

//assign led = axiov_count;
assign led[13:0] = done_count;
assign led[15] = kill;
assign led[14] = done;
assign eth_rstn = ~btnc;
endmodule
`default_nettype wire

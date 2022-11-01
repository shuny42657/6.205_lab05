`default_nettype none
`timescale 1ns / 1ps
module top_level(
	input wire clk,
	input wire btnc,
	input wire[1:0] eth_rxd,
	input wire eth_crsdv,

	output logic eth_rstn,
	output logic eth_refclk,
	output logic[15:0] led,
	output logic[7:0] an,
	output logic ca,cb,cc,cd,cd,ce,cf,cg

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

logic axiov_aggregate;
logic[1:0] axiod_aggregate;

aggregate ag(.clk(eth_refclk),.rst(btnc),.axiiv(axiov_firewall),.axiid(axiod_firewall),.axiov(axiov_aggregate),.axiod(axiod_aggregate));

logic[6:0] cat_out;
logic[7:0] an_out;
seven_segment_controller ssc(.clk_in(eth_refclk),.rst_in(btnc),.val_in(axiod_aggregate),.cat_out(cat_out),.an_out(an_out));
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
assign {ca,cb,cc,cd,ce,cg,cf} = ~cat_out;
assign an = an_out;
assign led[13:0] = done_count;
assign led[15] = kill;
assign led[14] = done;
assign eth_rstn = ~btnc;
endmodule
`default_nettype wire

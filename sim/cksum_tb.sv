`default_nettype none
`timescale 1ns / 1ps
`define MESSAGE	168'h4261_7272_7921_2042_7265_616b_6661_7374_2074_696d65
`define CKSUM	32'h1a3a_ccb2

module cksum_tb;

logic clk;
logic rst;
logic axiiv;
logic[1:0] axiid;

logic done;
logic kill;


cksum uut(
	.clk(clk),
	.rst(rst),
	.axiiv(axiiv),
	.axiid(axiid),
	.done(done),
	.kill(kill)
);

always begin
        #10;
        clk = !clk;
end

initial begin
        $dumpfile("firewall.vcd");
        $dumpvars(0,firewall_tb);
        $display("Starting Sim");
	clk = 1;
	#20;
	rst = 1;
	#20;
	rst = 0;
	#20;

	axiiv = 1;
	for(int i = 167;i > 0;i = i+2)begin
		axiid = {MESSAGE[i],MESSAGE[i-1]};
		#20;
	end
	axiiv = 0;
	#1000;

        $display("Finishing Sim");
        $finish;
end



endmodule
`default_nettype wire


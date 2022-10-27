
`default_nettype none
`timescale 1ns / 1ps

module bitorder_tb;

logic clk;
logic rst;

logic axiiv;
logic[1:0] axiid;

logic axiov;
logic[1:0] axiod;

bitorder uut(
	.clk(clk),
	.rst(rst),
	.axiiv(axiiv),
	.axiid(axiid),
	.axiov(axiov),
	.axiod(axiod)
);
always begin
	#10;
       	clk = !clk;
end
initial begin
	$dumpfile("bitorder.vcd");
	$dumpvars(0,bitorder_tb);
	$display("Starting Sim");
	clk = 0;
	#20;
	rst = 1;
	#20;
	rst = 0;
	axiiv = 1;
	#10;

	for(int i = 0;i <4;i = i+1)begin
		if(i < 3)begin
			axiid <= 2'b01;
		end else begin
			axiid <= 2'b11;
		end
		#20;
	end
	axiiv = 0;
	#100;
	//test case 1, 1 byte
	$display("Finishing Sim");
	$finish;
end
endmodule
`default_nettype wire
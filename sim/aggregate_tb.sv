`default_nettype none
`timescale 1ns / 1ps
module aggregate_tb;
	logic clk;
	logic rst;
	logic [1:0] axiid;
	logic axiiv;
	logic [31:0] axiod;
	logic axiov;
	// logic[95:0] message;
	aggregate uut(
		.clk(clk),
		.rst(rst),
		.axiid(axiid),
		.axiiv(axiiv),
		.axiod(axiod),
		.axiov(axiov)
	);

	always begin
        #10;
        clk = !clk;
    end
	initial begin
		$display("Starting Sim");
		$dumpfile("aggregate.vcd");
		$dumpvars(0,aggregate_tb);
		clk = 0;
		rst = 0;
		axiid = 0;
		axiiv = 0; 

		rst = 1;
		#20;
		rst = 0;

		//test case 1
		axiiv = 1;
		axiid = 2'b10;
		for(int x = 30; x>=0; x=x-2)begin
			axiid = 2'b10;
			#20;
		end
		axiid = 2'b11;
		for(int x = 62; x>=0; x=x-2)begin
			if(x >= 34)
				axiid = 2'b10;
			else
				axiid = 2'b11;
			#20;
		end
		#100;
		axiid = 2;
		#20;
		axiiv = 0;
		#80
		$display("Finishing Sim");
		$finish;
	end
endmodule
`default_nettype wire

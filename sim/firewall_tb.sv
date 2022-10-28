`default_nettype none
`timescale 1ns / 1ps

module firewall_tb;

logic clk;
logic rst;
logic axiiv;
logic[1:0] axiid;

logic axiov;
logic[1:0] axiod;

firewall uut(
	.clk(clk),
	.rst(rst),
	.axiiv(axiiv),
	.axiid(axiid),
	.axiov(axiov),
	.axiod(axiod)
);

localparam mac_addr = 48'h69_69_5A_06_54_91;

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
	for(int i = 0;i<24;i = i +1)begin
		case(i)
			0:axiid = mac_addr[47:46];
			1:axiid = mac_addr[45:44];
			2:axiid = mac_addr[43:42];
			3:axiid = mac_addr[41:40];
			4:axiid = mac_addr[39:38];
			5:axiid = mac_addr[37:36];
			6:axiid = mac_addr[35:34];
			7:axiid = mac_addr[33:32];
			8:axiid = mac_addr[31:30];
			9:axiid = mac_addr[29:28];
			10:axiid = mac_addr[27:26];
			11:axiid = mac_addr[25:24];
			12:axiid = mac_addr[23:22];
			13:axiid = mac_addr[21:20];
			14:axiid = mac_addr[19:18];
			15:axiid = mac_addr[17:16];
			16:axiid = mac_addr[15:14];
			17:axiid = mac_addr[13:12];
			18:axiid = mac_addr[11:10];
			19:axiid = mac_addr[9:8];
			20:axiid = mac_addr[7:6];
			21:axiid = mac_addr[5:4];
			22:axiid = mac_addr[3:2];
			23:axiid = mac_addr[1:0];
		endcase
		#20;
	end

	for(int i = 0;i<24;i = i + 1)begin
		axiid = 2'b01;
		#20;
	end
	for(int i = 0;i<8;i = i+1)begin
		axiid = 2'b11;
		#20;
	end
	for(int i = 0;i<24;i = i+1)begin
		axiid = i%2 == 0 ? 2'b01:2'b10;
		#20;
	end
	axiiv = 0;
	#1000;
	axiiv = 1;
	for(int i = 0;i<24;i=i+1)begin
		axiid = 2'b11;
		#20;
	end
	for(int i = 0;i<24;i = i + 1)begin
                axiid = 2'b01;
                #20;
        end
        for(int i = 0;i<8;i = i+1)begin
                axiid = 2'b11;
                #20;
        end
        for(int i = 0;i<24;i = i+1)begin
                axiid = i%2 == 0 ? 2'b01:2'b10;
                #20;
        end
	axiiv = 0;
	#1000
	$display("Finishing Sim");
	$finish;
end

endmodule
`default_nettype wire

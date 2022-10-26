`default_nettype none
`timescale 1ns / 1ps

module ether_tb;

logic clk;
logic rst;

logic [1:0] rxd;
logic crsdv;

logic [1:0] axiod;
logic axiov;

logic [47:0] addr_d,addr_s;
logic [15:0] length;
logic [15:0] data;
logic [31:0] fcs;
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
	$dumpfile("ether.vcd");
	$dumpvars(0,ether_tb);
	$display("Starting Sim");
	clk = 0;
	#20;
	rst = 1;
	#10;
	rst = 0;
	crsdv = 1;
	//test case 1: valid packet
	//valid preamble
	for(int i = 0;i<56;i=i+1)begin
		rxd = 2'b01;
		#20;
	end
	//valid sfd
	for(int i = 0;i<4;i = i+1)begin
		if(i < 3)begin
			rxd = 2'b01;
		end else begin
			rxd = 2'b11;
		end
		#20;
	end
	//D.A.
	for(int i = 0;i < 48;i=i+1)begin
		rxd = 2'b11;
		#20;
	end
	//S.A.
	for(int i = 0;i <48;i=i+1)begin
		rxd = 2'b11;
		#20;
	end
	//Data
	for(int i = 0;i < 16;i = i+1)begin
		rxd = 2'b10;
		#20;
	end
	//FCS
	for(int i = 0;i < 16;i = i+1)begin
		rxd = 2'b11;
		#20;
	end
	crsdv = 0;
	#20;
	crsdv = 1;
	#20;
	//test case 2: invalid preamble
	//invalid preamble
        for(int i = 0;i<56;i=i+1)begin
		if(i == 20)begin
			rxd = 2'b10;
		end else begin
			rxd = 2'b01;
		end
                #20;
        end
        //valid sfd
        for(int i = 0;i<4;i = i+1)begin
                if(i < 3)begin
                        rxd = 2'b01;
                end else begin
                        rxd = 2'b11;
                end
                #20;
        end
        //D.A.
        for(int i = 0;i < 48;i=i+1)begin
                rxd = 2'b11;
                #20;
        end
        //S.A.
        for(int i = 0;i <48;i=i+1)begin
                rxd = 2'b11;
                #20;
        end
        //Data
        for(int i = 0;i < 16;i = i+1)begin
                rxd = 2'b10;
                #20;
        end
        //FCS
        for(int i = 0;i < 16;i = i+1)begin
                rxd = 2'b11;
                #20;
        end
        crsdv = 0;
        #20;
	crsdv = 1;
	#20;
	//test case 3: valid preamble, tiny message(2 bits)
	//preamble
        for(int i = 0;i<56;i=i+1)begin
		rxd = 2'b01;
                #20;
        end
        //valid sfd
        for(int i = 0;i<4;i = i+1)begin
		if(i<3)begin
			rxd = 2'b01;
		end else begin
			rxd = 2'b11;
		end
                #20;
        end
	//only two bits
	rxd = 2'b01;
	#20;
	rxd = 2'b01;
	#20;
        crsdv = 0;
        #100;

	crsdv = 1;
	#20;
        //test case 3 :invalid sfd
        //invalid preamble
        for(int i = 0;i<56;i=i+1)begin
                rxd = 2'b01;
                #20;
        end
        //valid sfd
        for(int i = 0;i<4;i = i+1)begin
		if(i < 3)begin
			rxd = 2'b01;
		end else begin
			rxd = 2'b11;
		end
                #20;
        end
        //D.A.
        for(int i = 0;i < 48;i=i+1)begin
                rxd = 2'b11;
                #20;
        end
        //S.A.
        for(int i = 0;i <48;i=i+1)begin
                rxd = 2'b11;
                #20;
        end
        //Data
        for(int i = 0;i < 16;i = i+1)begin
                rxd = 2'b10;
                #20;
        end
        //FCS
        for(int i = 0;i < 16;i = i+1)begin
                rxd = 2'b11;
                #20;
        end
        crsdv = 0;
        #100;

	$display("Finishing Sim");
	$finish;
end
endmodule

`default_nettype wire

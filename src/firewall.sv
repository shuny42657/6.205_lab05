`default_nettype none
`timescale 1ns / 1ps
module firewall(
	input wire clk,
	input wire rst,
	input wire axiiv,
	input wire[1:0] axiid,

	output logic axiov,
	output logic[1:0] axiod
);

//logic [47:0] mac_addr
logic[5:0] bit_count;
logic[47:0] mac;
localparam mac_addr = 48'h69_69_5A_06_54_91;
logic is_broadcast;
logic is_my_addr;
logic can_recieve_data;
//logic[23:0] axiod_pipe[1:0];
//logic [23:0] axiov_pipe;
logic is_data_valid;
assign mac = mac_addr;
always_ff @(posedge clk)begin
	if(rst)begin
		bit_count <= 0;
		can_recieve_data <= 0;
		is_my_addr <= 1;
		is_broadcast <= 1;
	end

	if(axiiv)begin
		if(is_my_addr)begin
			if(bit_count == 0 && mac_addr[47:46] != axiid)
				is_my_addr <= 0;
			else if(bit_count == 1 && mac_addr[45:44] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 2 && mac_addr[43:42] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 3 && mac_addr[41:40] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 4 && mac_addr[39:38] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 5 && mac_addr[37:36] != axiid)
                                is_my_addr <=0;
			else if(bit_count == 6 && mac_addr[35:34] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 7 && mac_addr[33:32] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 8 && mac_addr[31:30] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 9 && mac_addr[29:28] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 10 && mac_addr[27:26] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 11 && mac_addr[25:24] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 12 && mac_addr[23:22] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 13 && mac_addr[21:20] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 14 && mac_addr[19:18] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 15 && mac_addr[17:16] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 16 && mac_addr[15:14] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 17 && mac_addr[13:12] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 18 && mac_addr[11:10] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 19 && mac_addr[9:8] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 20 && mac_addr[7:6] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 21 && mac_addr[5:4] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 22 && mac_addr[3:2] != axiid)
                                is_my_addr <= 0;
			else if(bit_count == 23 && mac_addr[1:0] != axiid)
                                is_my_addr <= 0;
		end
		if(is_broadcast)begin
			if(bit_count < 24 && 2'b11 != axiid)
				is_broadcast <= 0;
		end
		if(bit_count < 56)
			bit_count <= bit_count + 1;

		if(bit_count == 24)begin
			if(is_broadcast || is_my_addr)
				can_recieve_data <= 1;
		end
		/*if(can_recieve_data && bit_count == 56)begin
			is_data_valid <= 1;
		end*/
	end
	else begin
		//is_data_valid <= 0;
		bit_count <= 0;
		is_broadcast <= 1;
		is_my_addr <= 1;
		can_recieve_data <= 0;
		//is_data_valid <= 0;
	end
end


assign axiov = is_data_valid && axiiv;
assign axiod = axiid;
assign is_data_valid = can_recieve_data && bit_count == 56 ? 1:0; 

endmodule
`default_nettype wire

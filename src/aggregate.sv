
`default_nettype none
`timescale 1ns / 1ps
module aggregate(
	input wire clk,
	input wire rst,
	input wire axiiv,
	input wire [1:0] axiid,
	output logic axiov,
	output logic [31:0] axiod
);

logic [2:0] now_state;
logic [4:0] id;
logic[31:0] axiod_buffer_first;
logic[31:0] axiod_buffer_second;
always_ff @(posedge clk)begin
	if(rst)begin
		now_state <= 3'b001;
		id <= 0;
		axiod_buffer_first <= 0;
		axiod_buffer_second <= 0;
		axiov <= 0;
		axiod <= 0;
	end

	if(now_state == 3'b001)begin
		if(axiiv)begin
			now_state <= 3'b010;
			axiod_buffer_first[31:30] <= axiid;
			id <= 28;
		end
		axiov <= 0;
	end
	else if(now_state == 3'b010)begin
		if(axiiv)begin
			axiod_buffer_first[id+:2] <= axiid;
			if(id == 0)begin
				id <= 30;
				now_state <= 3'b100;
			end else begin
				id <= id -2;
			end
		end else begin
			id <= 0;
			axiod_buffer_first <= 0;
			axiov <= 0;
			now_state <= 3'b001;
		end
	end else if(now_state == 3'b100)begin
		if(axiiv)begin
			axiod_buffer_second[id+:2] <= axiid;
			if(id == 0)begin
				axiov <= 1;
				id <= 29;
				axiod <= axiod_buffer_first;
				axiod_buffer_first <= {axiod_buffer_second[31:2],axiid};
			end else begin
				id <= id - 2;
				axiov <= 0;
			end
		end else begin
			id <= 0;
			axiod_buffer_second <= 0;
			axiod_buffer_first <= 0;
			axiov <= 0;
			now_state <= 3'b001;
		end	
	end
end

endmodule
`default_nettype wire

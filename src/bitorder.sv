`default_nettype none
`timescale 1ns / 1ps

module bitorder(
	input wire clk,
	input wire rst,
	input wire axiiv,
	input wire[1:0] axiid,

	output logic axiov,
	output logic[1:0] axiod
);

logic [7:0] axiod_buffer_1;
logic [7:0] axiod_buffer_2;
logic buffer_switch; // if 0, buffer1 reads in. if 1 buffer2 reads in.
logic[1:0] bit_count; //0th~3rd debit
logic [10:0] byte_count; //how many bits 
logic old_axiiv;
always_ff @(posedge clk)begin
	if(rst)begin
		axiov <= 0;
		axiod <= 0;
		buffer_switch <= 0;
		bit_count <= 0;
		byte_count <= 0;
	end
	else if(axiiv)begin
		if(buffer_switch)
			axiod_buffer_1 <= {axiid,axiod_buffer_1[7:2]};
		else
			axiod_buffer_2 <= {axiid,axiod_buffer_2[7:2]};

		if(bit_count == 2'b11)begin //already read dibits three times
			bit_count <= 2'b00;
			byte_count = byte_count + 1;
			buffer_switch <= ~buffer_switch;
		end else begin
			bit_count <= bit_count + 1;
		end
		if(byte_count >= 1)begin
			axiov <= 1;
			case(bit_count)
				2'b00:begin
					axiod <= buffer_switch ? axiod_buffer_2[7:6] : axiod_buffer_1[7:6];
				end
				2'b01:begin
					axiod <= buffer_switch ? axiod_buffer_2[5:4] : axiod_buffer_1[5:4];
				end
				2'b10:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[3:2] : axiod_buffer_1[3:2];
                                end
				2'b11:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[1:0] : axiod_buffer_1[1:0];
                                end

			endcase
		end else if(byte_count == 0)begin
			axiov <= 0;
		end
		old_axiiv <= axiiv;
	end else begin
		if(old_axiiv)begin
			case(bit_count)
                                2'b00:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[7:6] : axiod_buffer_1[7:6];
                                end
                                2'b01:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[5:4] : axiod_buffer_1[5:4];
                                end
                                2'b10:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[3:2] : axiod_buffer_1[3:2];
                                end
                                2'b11:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[1:0] : axiod_buffer_1[1:0];
                                end

                        endcase
			if(bit_count == 2'b11)begin
				old_axiiv <= 0;
				bit_count <= 0;
			end else begin
				old_axiiv <= 1;
				bit_count = bit_count + 1;
			end
		end
		axiov <= 0;
	end
end
endmodule
`default_nettype wire

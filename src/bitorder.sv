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
logic[2:0] bit_count; //0th~3rd debit
logic [10:0] byte_count; //how ma:ny bits 
logic [10:0] byte_count_output; //howmany bits are already output
logic old_axiiv;
logic[1:0] rxd_out;
logic[2:0] end_bit_count; //used for the last byte
always_ff @(posedge clk)begin
	if(rst)begin
		axiov <= 0;
		axiod <= 0;
		buffer_switch <= 0;
		bit_count <= 0;
		byte_count <= 0;
		old_axiiv <= 0;
		axiod_buffer_1 <= 0;
		axiod_buffer_2 <= 0;
		end_bit_count <= 0;
		byte_count_output <= 0;
	end
	else if(axiiv)begin
		rxd_out <= axiid;
		if(buffer_switch)
			axiod_buffer_1 <= {axiid,axiod_buffer_1[7:2]};
		else
			axiod_buffer_2 <= {axiid,axiod_buffer_2[7:2]};

		if(bit_count == 3'd3)begin //already read dibits three times
			bit_count <= 3'd4;
			//end_bit_count <= 3'd3;
			byte_count <= byte_count + 1;
			buffer_switch <= ~buffer_switch;
		end else if(bit_count == 3'd4)begin
			bit_count <= 3'd1;
			//end_bit_count <= 3'd0;
		end else begin
			bit_count <= bit_count + 1;
			//end_bit_count <= bit_count;
		end
		if(byte_count >= 1)begin
			axiov <= 1;
			case(bit_count)
				3'd4:begin
					axiod <= buffer_switch ? axiod_buffer_2[7:6] : axiod_buffer_1[7:6];
				end
				3'd1:begin
					axiod <= buffer_switch ? axiod_buffer_2[5:4] : axiod_buffer_1[5:4];
				end
				3'd2:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[3:2] : axiod_buffer_1[3:2];
                                end
				3'd3:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[1:0] : axiod_buffer_1[1:0];
                                end

			endcase
			if(bit_count == 3'd3)begin
				byte_count_output <= byte_count_output + 1;
			end
		end else if(byte_count == 0)begin
			axiov <= 0;
		end
		old_axiiv <= axiiv;
	end else begin
		if(old_axiiv && byte_count_output != byte_count)begin
			/*case(end_bit_count)
                                3'd0:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[7:6] : axiod_buffer_1[7:6];
                                end
                                3'd1:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[5:4] : axiod_buffer_1[5:4];
                                end
                                3'd2:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[3:2] : axiod_buffer_1[3:2];
                                end
                                3'd3:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[1:0] : axiod_buffer_1[1:0];
                                end

                        endcase*/
		        axiov <= 1;
		        case(bit_count)
                                3'd4:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[7:6] : axiod_buffer_1[7:6];
                                end
                                3'd1:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[5:4] : axiod_buffer_1[5:4];
                                end
                                3'd2:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[3:2] : axiod_buffer_1[3:2];
                                end
                                3'd3:begin
                                        axiod <= buffer_switch ? axiod_buffer_2[1:0] : axiod_buffer_1[1:0];
                                end

                        endcase

			/*if(end_bit_count == 3'd3)begin
				//old_axiiv <= 0;
				//bit_count <= 0;
				end_bit_count <= 0;
				//byte_count <= 0;
				//axiov <= 0;
				//bit_count <= 3'd1;
				byte_count_output <= byte_count_output + 1;
			end else begin
				old_axiiv <= 1;
				end_bit_count <= end_bit_count + 1;
				axiov <= 1;
			end*/
		       if(bit_count == 3'd3)begin
			       byte_count_output <= byte_count_output + 1;
			       bit_count <= 3'd4;
		       end else if(bit_count == 3'd4)begin
			       bit_count <= 3'd1;
		       end
		       else begin
			       bit_count <= bit_count + 1;
		       end
		end
		else begin
			old_axiiv <= 0;
			end_bit_count <= 0;
			bit_count <= 0;
			axiov <= 0;
			byte_count <= 0;
			byte_count_output <= 0;
		end
	end
end
endmodule
`default_nettype wire

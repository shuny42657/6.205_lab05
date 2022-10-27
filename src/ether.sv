`default_nettype none
`timescale 1ns / 1ps

module ether(
	input wire clk,
	input wire rst,
	input wire [1:0] rxd,
	input wire crsdv,

	output logic axiov,
	output logic [1:0] axiod
);


logic[3:0] now_state;
logic [5:0] rxd_count;
logic [2:0] sfd_count;
/*
* 0000: ready state
* 0001: validating preamble
* 0010: validating SFD
* 0100: reading data
*/
always_ff @(posedge clk)begin
	if(rst)begin
		rxd_count <= 0;
		sfd_count <= 0;
		axiov <= 0;
		axiod <= 2'b00; //reset?
		now_state <= 4'b0000;
	end
	else begin
		if(crsdv)begin
			case(now_state)
				4'b0000:begin
					if(rxd == 2'b01)begin
						//shift to preamble validation
						now_state <= 4'b0001;
						rxd_count <= 1;
					end
				end
				4'b0001:begin
					if(rxd == 2'b01)begin
						if(rxd_count == 6'd27)begin
							//preamble validating done
							rxd_count <= 0;
							now_state <= 4'b0010;
						end else begin
							//still validating
							rxd_count <= rxd_count + 1;
						end
					end else begin
						//invalid, back to ready state
						rxd_count <= 0;
						now_state <= 4'b0000;
					end
				end
				4'b0010:begin
					//validate sfd
					if(sfd_count < 3)begin
						if(rxd == 2'b01)begin
							//still validating
							sfd_count <= sfd_count + 1;
						end else begin
							//invalid, back to ready state
							sfd_count <= 0;
							now_state <= 4'b0000;
						end
					end else if(sfd_count == 3)begin
						if(rxd == 2'b11)begin
							//sfd check done, start reading
							sfd_count <= 0;
							now_state <= 4'b0100;
						end else begin
							//invalid, back to ready state
							sfd_count <= 0;
							now_state <= 4'b0000;
						end
					end
				end
				4'b0100:begin
					if(crsdv)begin
						//not finished reading, read more
						axiov <= 1;
						axiod <= rxd;
					end else begin
						//end of packet, back to ready state
						axiov <= 0;
						axiod <= 2'b00;
						now_state <= 4'b0000;
					end
				end
			endcase
		end else begin
			//same as reset
			rxd_count <= 0;
                	sfd_count <= 0;
                	axiov <= 0;
                	axiod <= 2'b00; //reset?
                	now_state <= 4'b0000;
		end
	end


end
endmodule
`default_nettype wire

`default_nettype none
`timescale 1ns / 1ps
`define CKSUM   32'h1a3a_ccb2
module cksum(
        input wire clk,
        input wire rst,
        input wire axiiv,
        input wire[1:0] axiid,

        output logic done,
        output logic kill
);
logic now_check_phase;
logic check_end;
logic crc_rst;
logic[31:0] axiod;
crc32 crc32_bzip2 (.clk(clk),.rst(crc_rst),.axiiv(axiiv),.axiid(axiid),.axiod(axiod));                
always_ff @(posedge clk)begin
        if(rst)begin
                done <= 0;
                kill <= 0;
                now_check_phase <= 0;
		check_end <= 0;
        end
        if(~now_check_phase)begin
                if(axiiv == 1)begin
                        now_check_phase <= 1;
			check_end <= 0;
			done <= 0;
			kill <= 0;
		end else begin
			check_end <= 0;
		end
        end else begin
                if(axiiv == 0)begin
                        now_check_phase <= 0;
                        check_end <= 1;
                        done <= 1;
                        if(axiod == 32'h38_fb_22_84)begin
                                kill <= 0;
                        end else begin
                                kill <= 1;
                        end
                end
        end
end
assign crc_rst = rst || ~axiiv;
endmodule
`default_nettype wire

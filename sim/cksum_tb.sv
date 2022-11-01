`define CKSUM   32'h1a3a_ccb2
module cksum_tb;
        logic clk;
        logic rst;
        logic [1:0] axiid;
        logic axiiv;
        logic done;
        logic kill;
    logic [167:0] message;
        cksum testOrder(
                .clk(clk),
                .rst(rst),
                .axiid(axiid),
                .axiiv(axiiv),
                .done(done),
                .kill(kill)
        );

        always begin
        #10;  //every 5 ns switch...so period of clock is 10 ns...100 MHz clock
        clk = !clk;
    end
        initial begin
                $display("Starting Sim");
                $dumpfile("cksum.vcd");
                $dumpvars(0,cksum_tb);
        message = 168'h4261_7272_7921_2042_7265_616b_6661_7374_2074_696d65;
                clk = 0;
                rst = 0;
                axiid = 0;
                axiiv = 0;

                rst = 1;
                #60;
                rst = 0;

                //TEST 1: VALID BYTE
                axiiv = 1;
        for(int x = 166; x>=0; x=x-2)begin
            axiid = {message[x],message[x+1]};
            #20;
        end
        axiiv = 0;
        axiiv = 0;
        axiiv = 0;
        axiiv = 0;
        #100;
                $display("Finishing Sim");
                $finish;
        end
endmodule
`default_nettype wire


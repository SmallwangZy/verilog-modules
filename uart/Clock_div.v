module Clock_div(clk,rst,clk_tx,clk_rx);

input clk;
input rst;
output clk_tx;
output clk_rx;

reg clk_tx;
reg clk_rx;

localparam sys_clk = 50000000; 
localparam tx_BautRate = 115200;  //波特率
localparam tx_div_cnt = sys_clk/tx_BautRate/2;  //应该是自左向右运算

localparam rx_BautRate = 19200;  //波特率
localparam rx_div_cnt = sys_clk/rx_BautRate/2;  //应该是自左向右运算

reg [11:0] cnt_tx;
reg [11:0] cnt_rx;

always @(posedge clk,negedge rst)begin
	if(!rst)begin
		cnt_tx<=12'd0;
		clk_tx<=1'b1;
		end
	else if(cnt_tx==tx_div_cnt)begin
		cnt_tx<=12'd0;
		clk_tx<=~clk_tx;
		end
	else 
		cnt_tx<=cnt_tx+1'd1;
end


always @(posedge clk,negedge rst)begin
	if(!rst)begin
		cnt_rx<=12'd0;
		clk_rx<=1'b1;
		end
	else if(cnt_rx==rx_div_cnt)begin
		cnt_rx<=12'd0;
		clk_rx<=~clk_rx;
		end
	else
		cnt_rx<=cnt_rx+1'd1;
end



endmodule
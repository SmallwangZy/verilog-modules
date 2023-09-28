module Recv(clk,rx,data_rx);

input clk;
input rx;
output [7:0] data_rx;

reg [7:0] data_rx;

reg rxd;
reg rxd_fall;
reg [7:0] temp;

reg [4:0] cnt=0;

always @(posedge clk)begin    //下降沿检测
	rxd<=rx;
	if((!rx)&rxd)      //下降沿检测语句，由于是电平敏感且要同步，因此时序逻辑
		rxd_fall<=1;
	else 
		rxd_fall<=0;
end

always @(posedge clk)begin
	if((rxd_fall==1)&(cnt==0))   //检测到下降沿（开始信号）
		cnt<=cnt+1;
	else if((cnt>0)&(cnt<19))
		cnt<=cnt+1;
	else if(cnt==19)
		cnt<=0;
end

always @(posedge clk)        //时钟控制接收
	case(cnt)
		2:temp[0]<=rxd;       //0为起始位一定是低，因此没有
		4:temp[1]<=rxd;
		6:temp[2]<=rxd;
		8:temp[3]<=rxd;
		10:temp[4]<=rxd;
		12:temp[5]<=rxd;
		14:temp[6]<=rxd;
		16:temp[7]<=rxd;
		18:data_rx<=temp;     //停止位的时候将数据缓冲区全部移到寄存器
	endcase
	
	
	
endmodule

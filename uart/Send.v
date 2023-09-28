module Send(clk,data,en,tx);

input clk;
input [7:0] data;
input en;
output tx;

reg tx;
reg txd;
reg [3:0] cnt = 0;    //用来计数当前的位数
reg txd_fall;

always @(posedge clk)begin    //下降沿检测
	txd<=en;
	if((!en)&txd)      //当en按下，捕获一个下降沿，就置发射标志为1
		txd_fall<=1;
	else 
		txd_fall<=0;    //当en不，就置发射标志为0
end

always @(posedge clk)begin    
	if((txd_fall==1)&(cnt==0))    //检测到发射位的时候，这个时候是边沿敏感，如果是电平敏感，就会不断发送
		cnt<=cnt+1'd1;
	else if((cnt>0)&(cnt<9))  //这个时候已经不需要发射标志位了，只需要按一次。
		cnt<=cnt+1'd1;
	else if(cnt>8)
		cnt<=0;
end

always @(*)
	case(cnt)
		1:tx<=0;        //起始位
		2:tx<=data[0];  
		3:tx<=data[1];
		4:tx<=data[2];
		5:tx<=data[3];
		6:tx<=data[4];
		7:tx<=data[5];
		8:tx<=data[6];
		9:tx<=data[7];
		default:tx<=1;   //停止位，回到0的时候
	endcase
		
endmodule
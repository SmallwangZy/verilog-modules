module Debounce(clk,rst,in,out);

input clk;
input rst;
input in;

output reg out;   //消抖后的按键信号

parameter Idle = 4'b0001,       //按键未按下的状态
			 Wait = 4'b0010,       //按键刚刚按下的状态(计数)
			 Press = 4'b0100,      //按键已经稳定按下的状态
			 Relase = 4'b1000;     //按键从稳定到松开的状态(计数)
		 
reg [3:0] state;

reg [4:0] cnt;   //用于消抖计数

always @(posedge clk,negedge rst)begin
	if(!rst)begin
		state<=Idle;
		cnt <= 0;
		out <= 1;   
		end
	else begin
		case(state)
			Idle:begin 
				  if(!in)begin  //按键按下
						state<=Wait; 
						cnt <= 0;   //计数值清零，准备开始计数
						end
				  else begin
						state<=Idle;
						out <= 1;   //未按下时为高电平
						end
				  end
			Wait:begin 
				  if(cnt==30)begin    //计数到30ms就认为已经稳定
						state<=Press;  
                  cnt<=0;
						end
				  else 
						cnt<=cnt+1;
				  end
			Press:begin 
						if(in)  //如果按键松开了
							state<=Relase;
						else begin
							state <= Press;
							out<=0;
							end
					end
			Relase:begin 
					 if(cnt==30)begin    //计数到30ms就认为已经稳定
						state<=Idle;  
                  cnt<=0;
						end
				    else 
						cnt<=cnt+1;
					 end
			default: state <= Idle;
		endcase
	end
end



endmodule
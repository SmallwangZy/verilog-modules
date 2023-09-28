module FSM(clk,rst,is_car,A,LEDR,num0,num1);

input clk;
input rst;
input A;
input is_car;

output [5:0] LEDR;
reg [5:0] LEDR;

output [3:0] num0;
output [3:0] num1;

reg [3:0] num0;
reg [3:0] num1;

reg [6:0] cnt;

//LEDR2~0分别代表支干道的红绿黄灯
//LEDR5~3分别代表主干道的红绿黄灯


reg [3:0] current_state;   //保存现态的值
reg [3:0] next_state;   //保存现态的值


parameter state0=4'b0001,
			 state1=4'b0010,
			 state2=4'b0100,
			 state3=4'b1000;   //采用独热码进行编码
	
//每个输出状态的编码，LED为高电平亮
parameter sat0_led=6'b010100,
			 sat1_led=6'b001100,
			 sat2_led=6'b100010,
			 sat3_led=6'b100001;

parameter delay1 = 60,
			 delay2 = 3,
			 delay3 = 30;
			
//采用三段式状态机
//这里实现时序逻辑中的状态转移
always@(posedge clk or negedge rst) begin
  if(!rst)begin
		current_state <= state0;
		cnt <= 0;
		num0 <= 0;
		num1 <= 6;
		end
  else begin
/****************************状态0处理逻辑************************************/
		if(current_state==state0)begin
			if(cnt<delay1)begin        //如果没车，继续自增
				cnt<=cnt+1;
				if(num0==0&&num1!=0)begin     //控制数码管显示逻辑
					num1<=num1-1;
					num0<=9;
					end
//				else if(num0==0&&num1==0)begin
//					num1<=0;
//					num0<=0;
//					end
				else if(num0>0)
					num0<=num0-1;
				end
			else if(is_car&(cnt>59))begin     //如果有车
				current_state <= next_state;
				cnt <= 0;    
				num0 <= 3;
				num1 <= 0;
				end
			end

/*******************************************************************/	

/********************************状态1处理逻辑*************************/			
		else if(current_state==state1)begin
			if(cnt<delay2)begin
				cnt <= cnt + 1;
				num0 <= num0 - 1;
				end 
			else begin
				current_state <= next_state;
				cnt <= 0;
				num0 <= 0;
				num1 <= 3;
				end
			end
/*******************************************************************/	

/********************************状态2处理逻辑*************************/
		else if(current_state==state2)begin
			if((cnt<delay3-1)&is_car)begin
				cnt <= cnt + 1;
				if(num0==0)begin
					num1 <= num1 - 1;
					num0 <= 9;
					end
				else 	
					num0 <= num0 - 1;
				end 
			else if((!is_car)|cnt==delay3-1)begin
				current_state <= next_state;
				cnt <= 0;
				num0 <= 3;
				num1 <= 0;
				end
			end
			
/********************************状态3处理逻辑*************************/			
		else if(current_state==state3)begin
			if(cnt<delay2)begin
				cnt <= cnt + 1;
				num0 <= num0 - 1;
				end
			else begin
				current_state <= next_state;
				cnt <= 0;
				num0 <= 0;
				num1 <= 6;
				end
			end
/*******************************************************************/	
		end
end			 

//产生下一个状态的组合逻辑
always@(current_state)begin
  case(current_state)
		state0:next_state<=state1;
		state1:next_state<=state2;
		state2:next_state<=state3;
		state3:next_state<=state0;
		default: next_state = state0;
  endcase
end

// 这里实现同步组合逻辑的输出		
 always@(posedge clk or negedge rst) begin
  if(!rst) LEDR <= sat0_led;  
  else
	case(current_state)
	 state0:LEDR <= sat0_led; 
	 state1:LEDR <= sat1_led;
	 state2:LEDR <= sat2_led;
	 state3:LEDR <= sat3_led;
	 default:LEDR <= sat0_led;
	endcase
 end
 

endmodule
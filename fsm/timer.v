module timer(clk,rst,signal);

input clk;
input rst;

output signal;

reg [6:0] cnt;
reg signal;

always @(posedge clk,negedge rst)begin
	if(!rst)begin
		cnt<=7'd0;
		signal<=1'b0;
		end
	else if(cnt==60)
		signal<=1'b1;     //记录到六十给一个脉冲，作为状态机的输入
	else if(cnt==63)
		signal<=1'b1;     //记录到六十给一个脉冲，作为状态机的输入
	else if(cnt==93)
		signal<=1'b1;     //记录到六十给一个脉冲，作为状态机的输入
	else if(cnt==96)begin
		signal<=1'b1;     //记录到六十给一个脉冲，作为状态机的输入
		cnt<=7'd0;
		end
	else begin
		cnt<=cnt+1'd1;
		signal<=7'd0;     //正常情况下为低电平
		end
end
endmodule
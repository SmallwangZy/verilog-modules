module clk_div(clk,rst,clk_1s);

input clk;
input rst;
output clk_1s;

reg clk_1s;

reg [24:0] cnt;

always @(posedge clk,negedge rst)begin
   if(!rst)begin
      cnt<=25'd0;
      clk_1s<=1'b1;
      end
   else if(cnt==25'd25_000_0)begin
      clk_1s<=~clk_1s;
      cnt<=25'd0;
      end
   else
      cnt<=cnt+1'd1;
end

endmodule
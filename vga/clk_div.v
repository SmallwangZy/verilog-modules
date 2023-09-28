module clk_div(clk,rst,clk_1s);

input clk;
input rst;
output clk_1s;

reg clk_1s;


always @(posedge clk,negedge rst)begin
   if(!rst)
      clk_1s<=1'b0;
   else 
		clk_1s<=~clk_1s;
end

endmodule
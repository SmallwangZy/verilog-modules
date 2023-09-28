module Door(en,rst,clk_in,clk_out);

input clk_in;
input en;
input rst;
output clk_out;

reg flag;

always @(negedge en,negedge rst)begin
	if(!rst)
		flag <= 1;
	else
		flag <= ~ flag;
end

assign clk_out = flag & clk_in;
  
endmodule
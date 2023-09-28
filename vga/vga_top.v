module vga_top(clk,rst,vga_hs,vga_vs,vga_rgb,dac_clk);

input clk;
input rst;
output vga_hs;   //行同步信号
output vga_vs;   //场同步信号
output [23:0] vga_rgb;    //采用rgb888像素格式，能显示的颜色更多
output dac_clk;

//wire locked;   //pll输出稳定信号。
wire vga_clk;  //vga的像素时钟。
wire rst_new;  //新的复位信号。

//分辨率640*480
wire [23:0]  pixel_data_w;          //像素点数据
wire [ 9:0]  pixel_xpos_w;          //像素点横坐标
wire [ 9:0]  pixel_ypos_w;          //像素点纵坐标 

assign dac_clk = ~vga_clk;

clk_div u_vga_clk(
	.clk(clk),
	.rst(rst),
	.clk_1s(vga_clk)
);

vga_driver u_vga_driver(
    .clk      (vga_clk),    
    .rst      (rst),    

    .hs         (vga_hs),       
    .vs         (vga_vs),       
    .rgb        (vga_rgb),      
    
    .pixel_data  (pixel_data_w), 
    .pixel_x     (pixel_xpos_w), 
    .pixel_y     (pixel_ypos_w)
); 
    	 
	 
vga_display u_vga_display(
    .vga_clk        (vga_clk),
    .sys_rst_n      (rst),
    
    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .pixel_data     (pixel_data_w)
);   
    



endmodule
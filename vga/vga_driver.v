module vga_driver(clk,rst,pixel_data,pixel_x,pixel_y,hs,vs,rgb);

input clk;
input rst;

output hs;
output vs;
output [23:0] rgb;

input [23:0] pixel_data;
output [9:0] pixel_x;
output [9:0] pixel_y;

parameter H_SYNC = 10'd96;      //行同步(默认为高)
parameter H_BACK = 10'd48;    //行显示后沿
parameter H_DISP = 10'd640;   //行有效数据
parameter H_FRONT = 10'd16;   //行显示前沿
parameter H_TOTAL = 10'd800;   //行扫描周期

parameter V_SYNC = 10'd2;      //行同步
parameter V_BACK = 10'd33;    //行显示后沿
parameter V_DISP = 10'd480;   //行有效数据
parameter V_FRONT = 10'd10;   //行显示前沿
parameter V_TOTAL = 10'd525;   //行扫描周期

reg [9:0] cnt_h;
reg [9:0] cnt_v;

wire vga_en;
wire data_req; 


//VGA行场同步信号
assign hs  = (cnt_h <= H_SYNC - 1'b1) ? 1'b0 : 1'b1;  //行同步时间结束就拉高 
assign vs  = (cnt_v <= V_SYNC - 1'b1) ? 1'b0 : 1'b1;  //场同步时间结束就拉高


//使能RGB888数据输出
assign vga_en  = (((cnt_h >= H_SYNC+H_BACK) && (cnt_h < H_SYNC+H_BACK+H_DISP))
                 &&((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                 ?  1'b1 : 1'b0;
                 
//RGB888数据输出                 
assign rgb = vga_en ? pixel_data : 24'd0;

//请求像素点颜色数据输入                
assign data_req = (((cnt_h >= H_SYNC+H_BACK-1'b1) && (cnt_h < H_SYNC+H_BACK+H_DISP-1'b1))
                  && ((cnt_v >= V_SYNC+V_BACK) && (cnt_v < V_SYNC+V_BACK+V_DISP)))
                  ?  1'b1 : 1'b0;

						
//像素点坐标                
assign pixel_x = data_req ? (cnt_h - (H_SYNC + H_BACK - 1'b1)) : 10'd0;
assign pixel_y = data_req ? (cnt_v - (V_SYNC + V_BACK - 1'b1)) : 10'd0;


//行计数器对像素时钟计数
always @(posedge clk or negedge rst) begin         
    if (!rst)
        cnt_h <= 10'd0;                                  
    else begin
        if(cnt_h < H_TOTAL - 1'b1)    //在一行之内                                        
            cnt_h <= cnt_h + 1'b1;                               
        else 
            cnt_h <= 10'd0;  
    end
end


//场计数器对行计数
always @(posedge clk or negedge rst) begin         
    if (!rst)
        cnt_v <= 10'd0;                                  
    else if(cnt_h == H_TOTAL - 1'b1) begin
        if(cnt_v < V_TOTAL - 1'b1)                                               
            cnt_v <= cnt_v + 1'b1;                               
        else 
            cnt_v <= 10'd0;  
    end
end


endmodule
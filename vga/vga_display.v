module vga_display(
    input             vga_clk,                  //VGA驱动时钟
    input             sys_rst_n,                //复位信号
    
    input      [ 9:0] pixel_xpos,               //像素点横坐标
    input      [ 9:0] pixel_ypos,               //像素点纵坐标    
    output     [23:0] pixel_data                //像素点数据
);    
    
	 
parameter  H_DISP = 10'd640;                    //分辨率——行
parameter  V_DISP = 10'd480;                    //分辨率——列

localparam WHITE  = 24'b11111111_11111111_11111111;     //RGB888 白色
localparam BLACK  = 24'b00000000_00000000_00000000;     //RGB888 黑色
localparam RED    = 24'b11111111_00000000_00000000;     //RGB888 红色
localparam GREEN  = 24'b00000000_11111111_00000000;     //RGB888 绿色
localparam BLUE   = 24'b00000000_00000000_11111111;     //RGB888 蓝色

localparam POS_X  = 10'd145;                //图片区域起始点横坐标
localparam POS_Y  = 10'd65;                //图片区域起始点纵坐标
localparam WIDTH  = 10'd350;                //图片区域宽度
localparam HEIGHT = 10'd350;                //图片区域高度
localparam TOTAL = 122500;

wire [23:0] rom_data;
wire rom_rd_en;
reg [16:0] rom_addr;
reg rom_vaild;	 

/*//根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示彩条
always @(posedge vga_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n)
        pixel_data <= 24'd0;                                  
    else begin
        if((pixel_xpos >= 0) && (pixel_xpos <= (H_DISP/5)*1))                                              
            pixel_data <= WHITE;                                  
        else if((pixel_xpos >= (H_DISP/5)*1) && (pixel_xpos < (H_DISP/5)*2))
            pixel_data <= BLACK;  
        else if((pixel_xpos >= (H_DISP/5)*2) && (pixel_xpos < (H_DISP/5)*3))
            pixel_data <= RED;  
        else if((pixel_xpos >= (H_DISP/5)*3) && (pixel_xpos < (H_DISP/5)*4))
            pixel_data <= GREEN;  
        else 
            pixel_data <= BLUE;
    end
end*/


//从ROM中读出的图像数据有效时，将其输出显示
assign pixel_data = rom_vaild ? rom_data : BLACK; 


//当前像素点坐标位于图案显示区域内时，读ROM使能信号拉高
assign rom_rd_en = (pixel_xpos >= POS_X) && (pixel_xpos < POS_X + WIDTH)
                    && (pixel_ypos >= POS_Y) && (pixel_ypos < POS_Y + HEIGHT)
                     ? 1'b1 : 1'b0;
							
//控制读地址
always @(posedge vga_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        rom_addr   <= 17'd0;
    end
    else if(rom_rd_en) begin
        if(rom_addr < TOTAL - 1'b1)
            rom_addr <= rom_addr + 1'b1;    //每次读ROM操作后，读地址加1
        else
            rom_addr <= 1'b0;               //读到ROM末地址后，从首地址重新开始读操作
    end
    else
        rom_addr <= rom_addr;
end

//从发出读使能到ROM输出有效数据存在一个时钟周期的延时
always @(posedge vga_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) 
        rom_vaild <= 1'b0;
    else
        rom_vaild <= rom_rd_en;
end

ip_rom pic_rom_inst(
	.clock(vga_clk),
	.address(rom_addr),
	.rden(rom_rd_en),
	.q(rom_data)
);


endmodule 
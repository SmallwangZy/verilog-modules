module TrafficLights(clk,rst,is_car,LEDR,SEG0,SEG1);

input clk;
input rst;
input is_car;   //标志是否有车的信号

output [5:0] LEDR;
output [6:0] SEG0;
output [6:0] SEG1;

reg [5:0] LEDR;
reg [6:0] SEG0;
reg [6:0] SEG1;


wire clk_1s;
wire sgn;
wire [5:0] led_wires;

wire [3:0] num0_wire;
wire [3:0] num1_wire;

wire [6:0] seg0_wire;
wire [6:0] seg1_wire;


//例化部分			 
clk_div i1(
   .clk(clk),
   .rst(rst),
   .clk_1s(clk_1s)
);

FSM i3(
	.clk(clk_1s),
	.rst(rst),
	.is_car(is_car),
	.LEDR(led_wires),
	.num0(num0_wire),
	.num1(num1_wire)
);

decoder i4(
	.num(num0_wire),
	.seg(seg0_wire)
);

decoder i5(
	.num(num1_wire),
	.seg(seg1_wire)
);
	
	
always @(led_wires) LEDR=led_wires;
always @(seg0_wire) SEG0=seg0_wire;
always @(seg1_wire) SEG1=seg1_wire;

endmodule
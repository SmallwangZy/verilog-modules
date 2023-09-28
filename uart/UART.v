module UART(clk,rst,en,SW,rx,tx,LEDR);

input clk;
input rst;
input [7:0] SW;
input en;

input rx;
output tx;
output [7:0] LEDR;

reg [7:0] LEDR;
reg tx;

/***********wires***********/
wire clk_tx;
wire clk_rx;
wire tx_wire;
wire [7:0] LED_wires;

Clock_div i1(
	.clk(clk),
	.rst(rst),
	.clk_tx(clk_tx),
	.clk_rx(clk_rx)
);

Send i2(
	.clk(clk_tx),
	.data(SW),
	.en(en),
	.tx(tx_wire)
);

Recv i3(
	.clk(clk_rx),
	.data_rx(LED_wires),
	.rx(rx)
);


always @(tx_wire) tx=tx_wire;
always @(LED_wires) LEDR=LED_wires;


endmodule
module decoder(num,seg);

input [3:0] num;
output [6:0] seg;
reg [6:0] seg;

always @(num)begin
   case(num)
      4'd0:seg<=7'b100_0000;
      4'd1:seg<=7'b111_1001;
      4'd2:seg<=7'b010_0100;
      4'd3:seg<=7'b011_0000;
      4'd4:seg<=7'b001_1001;
      4'd5:seg<=7'b001_0010;
      4'd6:seg<=7'b000_0010;
      4'd7:seg<=7'b111_1000;
      4'd8:seg<=7'b000_0000;
      4'd9:seg<=7'b001_0000;
   endcase
end

endmodule
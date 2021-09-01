//smiley_block

module smiley_block(pixelX,
                      pixelY,
                      clk,
                      resetN,
                      startOfFrame,
                      Y_direction,
                      toggleX,
                      collision,
							 smileyDR,
							 smileyRGB);
input [10:0] pixelX;
input [10:0] pixelY;
input clk;
input resetN;
input startOfFrame;
input Y_direction;
input toggleX;
input collision;

output smileyDR;
output [7:0] smileyRGB;





///////// //// 

wire [10:0] SmileyTLX;
wire [10:0] SmileyTLY;
wire [10:0] smileyOffsetX;
wire [10:0] smileyOffsetY;
wire [3:0] HitEdgeCode;
wire smileyRecDR;

smileyface_moveCollision smiley_move(
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.Y_direction(Y_direction),
			.toggleX(toggleX),
			.collision(collision),
			.HitEdgeCode(HitEdgeCode),
			.topLeftX(SmileyTLX),
			.topLeftY(SmileyTLY)
			);


			
square_object 	#(
			.OBJECT_WIDTH_X(64),
			.OBJECT_HEIGHT_Y(32)
)
smiley_sq(
			.clk(clk),
			.resetN(resetN),
			.pixelX(pixelX),
			.pixelY(pixelY),
			.topLeftX(SmileyTLX),
			.topLeftY(SmileyTLY),
			.offsetX(smileyOffsetX),
			.offsetY(smileyOffsetY),
			.drawingRequest(smileyRecDR),
			.RGBout()
			);
			
smileyBitMap smiley_bit(
			.clk(clk),
			.resetN(resetN),
			.offsetX(smileyOffsetX),
			.offsetY(smileyOffsetY),
			.InsideRectangle(smileyRecDR),
			.drawingRequest(smileyDR),
			.RGBout(smileyRGB),
			.HitEdgeCode(HitEdgeCode)
			);
			
endmodule


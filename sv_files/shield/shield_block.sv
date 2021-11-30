// module life

module shield_block(
					input clk,
					input resetN,
					input startOfFrame,
					input standBy,
					input gameEnded,
					input collisionShield,  //player was hit
					input [10:0] pixelX,
					input [10:0] pixelY,
					
					output shieldDR,
					output [7:0] shieldRGB

);

wire playGame;
wire [10:0] shieldOffsetX;
wire [10:0] shieldOffsetY;
wire InsideRectangle;

assign playGame = ~(standBy | gameEnded);


square_object 	#(
			.OBJECT_WIDTH_X(468),
			.OBJECT_HEIGHT_Y(32)
)
shield_life_sq(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd96), // screen is 640 and the shields take 448 : (640-448)/2 
					.topLeftY(11'd356), // player TLY is 420 , we want 32 bit space among them 420 - 32 - 32 = 356
					.offsetX(shieldOffsetX),
					.offsetY(shieldOffsetY),
					.drawingRequest(InsideRectangle),
					.RGBout()
);


shieldBitMap shield_map_inst(
					.clk(clk),
					.resetN(resetN),
					.offsetX(shieldOffsetX),
					.offsetY(shieldOffsetY),
					.InsideRectangle(InsideRectangle),
					.collision(collisionShield),
					.playGame(playGame),
					.drawingRequest(shieldDR),
					.RGBout(shieldRGB)

);
endmodule
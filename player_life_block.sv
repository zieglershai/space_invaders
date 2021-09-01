// module life

module player_life_block(
					input clk,
					input resetN,
					input startOfFrame,
					input standBy,
					input gameEnded,
					input collisionAlienShot_Player,  //player was hit
					input [10:0] pixelX,
					input [10:0] pixelY,
					
					output playerLifeDR,
					output [7:0] playerLifeRGB,
					output gameLose

);

wire playGame;
wire [10:0] playerLifeOffsetX;
wire [10:0] playerLifeOffsetY;
wire InsideRectangle;

assign playGame = ~(standBy | gameEnded);


square_object 	#(
			.OBJECT_WIDTH_X(256),
			.OBJECT_HEIGHT_Y(16)
)
player_life_sq(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd120),
					.topLeftY(11'd450),
					.offsetX(playerLifeOffsetX),
					.offsetY(playerLifeOffsetY),
					.drawingRequest(InsideRectangle),
					.RGBout()
);


playerLifeBitMap life_map_inst(
					.clk(clk),
					.resetN(resetN),
					.offsetX(playerLifeOffsetX),
					.offsetY(playerLifeOffsetY),
					.InsideRectangle(InsideRectangle),
					.playGame(playGame),
					.shotHitPlayer(collisionAlienShot_Player),
					.drawingRequest(playerLifeDR),
					.RGBout(playerLifeRGB),
					.gameLose(gameLose)	
);
endmodule

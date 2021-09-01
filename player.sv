module player(
					input clk,
					input resetN,
					input startOfFrame,
					input leftArrowPressed,
					input rightArrowPressed,
					input enterKeyPressed,
					input collisionPlayerBoarder,
					input standBy,
					input gameEnded,
					input playerHit,
					input [10:0] pixelX,
					input [10:0] pixelY,

					output playerDR,
					output [7:0] playerRGB,
					output [10:0] playerXPosition
);

// wires
wire playGame;
wire [10:0] playerTLX;
wire [10:0] playerTLY;
wire [3:0] HitEdgeCode;
wire [10:0] playerOffsetX;
wire [10:0] playerOffsetY;
wire playerRecDR;

assign playGame = ~(standBy | gameEnded);
assign playerXPosition = playerTLX;

player_moveCollision player_mov_inst(
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.leftArrow(leftArrowPressed),
					.rightArrow(rightArrowPressed),
					.enter(enterKeyPressed),
					.collision(collisionPlayerBoarder),
					.HitEdgeCode(HitEdgeCode),
					.playGame(playGame),	
					.topLeftX(playerTLX),
					.topLeftY(playerTLY)
);

square_object 	#(
			.OBJECT_WIDTH_X(64),
			.OBJECT_HEIGHT_Y(16)
)
player_sq(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(playerTLX),
					.topLeftY(playerTLY),
					.offsetX(playerOffsetX),
					.offsetY(playerOffsetY),
					.drawingRequest(playerRecDR),
					.RGBout()
);

playerBitMap player_bit_inst(		
					.clk(clk),
					.resetN(resetN),
					.offsetX(playerOffsetX),
					.offsetY(playerOffsetY),
					.InsideRectangle(playerRecDR),
					.playGame(playGame),
					.playerHit(playerHit),
					.drawingRequest(playerDR),
					.RGBout(playerRGB),  
					.HitEdgeCode(HitEdgeCode)
);
			
			
endmodule

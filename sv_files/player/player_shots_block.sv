/// moudule for player fire

module player_shots_block(

		input [10:0] pixelX,
		input [10:0] pixelY,
		input clk,
		input resetN,
		input startOfFrame,
		input fireCollision,
		input [10:0] playerXPosition,
		input keyRisingEdge,// fire pressed
		input standBy,
		input gameEnded,
		
		output [7:0] playerShotRGB,
		output playerShotDR,
		output alive // possible debugging output and needed to be internal wire
);
		
		
// wires

wire playGame;
wire [10:0] playerShotTLX;
wire [10:0] playerShotTLY;
wire player_shotRecDR;

// logic and instantions
assign playGame = ~(standBy | gameEnded);
assign playerShotDR = alive & player_shotRecDR;
		
		
player_shot_moveCollision player_shot_mv_inst(
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.fireCollision(fireCollision),
			.playerXPosition(playerXPosition),
			.start(keyRisingEdge),
			.playGame(playGame),
			.topLeftX(playerShotTLX), 
			.topLeftY(playerShotTLY),  
			.alive(alive) 
);

square_object 	#(
			.OBJECT_WIDTH_X(2),
			.OBJECT_HEIGHT_Y(16)
)
player_shot_sq(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(playerShotTLX),
					.topLeftY(playerShotTLY),
					.offsetX(), // not important - all square filled with white 
					.offsetY(), // not important - all square filled with white 
					.drawingRequest(player_shotRecDR),
					.RGBout(playerShotRGB)
);
endmodule

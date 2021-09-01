module high_score(
					input clk,
					input resetN,
					input startOfFrame,
					input startGame,
					input [10:0] pixelX,
					input [10:0] pixelY,
					input [31:0] score,
					
					output newHighScore,
					output highScoreDR,
					output [7:0] highScoreRGB
);






wire [10:0] high_sq_inst_offsetX;
wire [10:0] high_sq_inst_offsetY;
wire high_sq_RecDR;

square_object 	#(
			.OBJECT_WIDTH_X(32), //dec
			.OBJECT_HEIGHT_Y(16),//dec
			.OBJECT_COLOR(8'h5b) //hex
)
high_score_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd592),
					.topLeftY(11'd11),
					.offsetX(high_sq_inst_offsetX),
					.offsetY(high_sq_inst_offsetY),
					.drawingRequest(high_sq_RecDR),
					.RGBout()
);


highScoreBitMap highScore_map_inst	(	
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.offsetX(high_sq_inst_offsetX),// offset from top left  position 
					.offsetY(high_sq_inst_offsetY),
					.score(score),
					.startGame(startGame),
					.InsideRectangle(high_sq_RecDR), //input that the pixel is within a bracket
					.newHighScore(newHighScore), // new high score achived
					.drawingRequest(highScoreDR), //output that the pixel should be dispalyed 
					.RGBout(highScoreRGB)  //rgb value from the bitmap 
);
endmodule

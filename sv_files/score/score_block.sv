// module score for display current score

module score_block(
			input clk,
			input resetN,
			input [10:0] pixelX,
			input [10:0] pixelY,
			input startOfFrame,
			input startGame,
			input [7:0] scoreUpdate,
			
			output scoreDR,
			output [7:0] scoreRGB,
			output [31:0] score			
);


// 
wire [10:0] score_offsetX;
wire [10:0] score_offsetY;
wire scoreRecDR;

square_object 	#(
			.OBJECT_WIDTH_X(32), //dec
			.OBJECT_HEIGHT_Y(16),//dec
			.OBJECT_COLOR(8'h5b) //hex
)
score_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd120),
					.topLeftY(11'd11),
					.offsetX(score_offsetX),
					.offsetY(score_offsetY),
					.drawingRequest(scoreRecDR),
					.RGBout()
);



scoreBitMap	score_map_inst(	
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.offsetX(score_offsetX),
					.offsetY(score_offsetY),
					.InsideRectangle(scoreRecDR), 
					.scoreUpdate(scoreUpdate), 
					.resetScore(startGame),
					.drawingRequest(scoreDR), 
					.RGBout(scoreRGB),
					.score(score)
);

endmodule

module titles_block(
					input clk,
					input resetN,
					input startOfFrame,
					input gameEnded,
					input standBy,
					input [10:0] pixelX,
					input [10:0] pixelY,
					output [7:0] debug, // for debuging porpurse
					output debug_dr,
					output titlesDR,
					output [7:0] titlesRGB

);

wire playGame;
assign playGame = ~(gameEnded | standBy);


// high score title modules:

wire [10:0] high_sq_inst_offsetX;
wire [10:0] high_sq_inst_offsetY;
wire high_sq_RecDR;
wire highDR;
wire [7:0] highRGB;

square_object 	#(
			.OBJECT_WIDTH_X(128), //dec
			.OBJECT_HEIGHT_Y(16),//dec
			.OBJECT_COLOR(8'h5b) //hex
)
high_score_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd408),
					.topLeftY(11'd11),
					.offsetX(high_sq_inst_offsetX),
					.offsetY(high_sq_inst_offsetY),
					.drawingRequest(high_sq_RecDR),
					.RGBout()
);


highScoreTitleBitMap highScore_map_inst	(	
					.clk(clk),
					.resetN(resetN),
					.offsetX(high_sq_inst_offsetX),// offset from top left  position 
					.offsetY(high_sq_inst_offsetY),
					.InsideRectangle(high_sq_RecDR), //input that the pixel is within a bracket 
					.drawingRequest(highDR), //output that the pixel should be dispalyed 
					.RGBout(highRGB),
);


// score title mosules
wire [10:0] score_sq_inst_offsetX;
wire [10:0] score_sq_inst_offsetY;
wire score_sq_RecDR;
wire scoreDR;
wire [7:0] scoreRGB;



assign debug = scoreRGB;
assign debug1 = debug;
assign debug_dr = scoreDR;

square_object 	#(
			.OBJECT_WIDTH_X(64), //dec
			.OBJECT_HEIGHT_Y(16),//dec
			.OBJECT_COLOR(8'h5b) //hex
)
score_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd30),
					.topLeftY(11'd11),
					.offsetX(score_sq_inst_offsetX),
					.offsetY(score_sq_inst_offsetY),
					.drawingRequest(score_sq_RecDR),
					.RGBout()
);


scoreTitleBitMap scorecore_map_inst	(	
					.clk(clk),
					.resetN(resetN),
					.offsetX(score_sq_inst_offsetX),// offset from top left  position 
					.offsetY(score_sq_inst_offsetY),
					.InsideRectangle(score_sq_RecDR), //input that the pixel is within a bracket 
					.drawingRequest(scoreDR), //output that the pixel should be dispalyed 
					.RGBout(scoreRGB),
);



// credit title zone:
wire [10:0] credit_sq_inst_offsetX;
wire [10:0] credit_sq_inst_offsetY;
wire credit_sq_RecDR;
wire creditDR;
wire [7:0] creditRGB;

square_object 	#(
			.OBJECT_WIDTH_X(64), //dec
			.OBJECT_HEIGHT_Y(16),//dec
			.OBJECT_COLOR(8'h5b) //hex
)
credit_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd408),
					.topLeftY(11'd450),
					.offsetX(credit_sq_inst_offsetX),
					.offsetY(credit_sq_inst_offsetY),
					.drawingRequest(credit_sq_RecDR),
					.RGBout()
);


creditsTitleBitMap credit_map_inst	(	
					.clk(clk),
					.resetN(resetN),
					.offsetX(credit_sq_inst_offsetX),// offset from top left  position 
					.offsetY(credit_sq_inst_offsetY),
					.InsideRectangle(credit_sq_RecDR), //input that the pixel is within a bracket 
					.drawingRequest(creditDR), //output that the pixel should be dispalyed 
					.RGBout(creditRGB),
);


// lives title zone:

wire [10:0] lives_sq_inst_offsetX;
wire [10:0] lives_sq_inst_offsetY;
wire lives_sq_RecDR;
wire livesDR;
wire [7:0] livesRGB;

square_object 	#(
			.OBJECT_WIDTH_X(64), //dec
			.OBJECT_HEIGHT_Y(16),//dec
			.OBJECT_COLOR(8'h5b) //hex
)
lives_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd50),
					.topLeftY(11'd450),
					.offsetX(lives_sq_inst_offsetX),
					.offsetY(lives_sq_inst_offsetY),
					.drawingRequest(lives_sq_RecDR),
					.RGBout()
);


livesTitleBitMap lives_map_inst	(	
					.clk(clk),
					.resetN(resetN),
					.offsetX(lives_sq_inst_offsetX),// offset from top left  position 
					.offsetY(lives_sq_inst_offsetY),
					.InsideRectangle(lives_sq_RecDR), //input that the pixel is within a bracket
					.playGame(playGame), // game mode
					.drawingRequest(livesDR), //output that the pixel should be dispalyed 
					.RGBout(livesRGB),
);

titles_mux title_mux_inst(
					.clk(clk),
					.resetN(resetN),
					.highDR(highDR), // two set of inputs per unit
					.highRGB(highRGB),	
					.scoreDR(scoreDR), // two set of inputs per unit
					.scoreRGB(scoreRGB),
					.creditDR(creditDR), // two set of inputs per unit
					.creditRGB(creditRGB),
					.livesDR(livesDR), // two set of inputs per unit
					.livesRGB(livesRGB),					
					.RGBOut(titlesRGB),
					.titlesDR(titlesDR)
);
endmodule

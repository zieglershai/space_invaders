module end_screen(
					input clk,
					input resetN,
					input startOfFrame,
					input gameEnded,
					input newHighScore,
					input [10:0] pixelX,
					input [10:0] pixelY,
					
					output endScreenDR,
					output [7:0] endScreenRGB

);
//keyStart moudule wires
wire [10:0] keyStart_sq_inst_offsetX;
wire [10:0] keyStart_sq_inst_offsetY;
wire keyStart_sq_RecDR;
wire startDR;
wire [7:0] startRGB;

square_object 	#(
			.OBJECT_WIDTH_X(128), //dec
			.OBJECT_HEIGHT_Y(128),//dec
			.OBJECT_COLOR(0) //hex
)
keyStart_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd70),
					.topLeftY(11'd230),
					.offsetX(keyStart_sq_inst_offsetX),
					.offsetY(keyStart_sq_inst_offsetY),
					.drawingRequest(keyStart_sq_RecDR),
					.RGBout()
);

keyStartBitMap key_map_inst(
					.clk(clk), 
					.resetN(resetN), 
					.offsetX(keyStart_sq_inst_offsetX), 
					.offsetY(keyStart_sq_inst_offsetY), 
					.InsideRectangle(keyStart_sq_RecDR),
					.standBy(gameEnded),
					.drawingRequest(startDR), 
					.RGBout(startRGB)
);



//gameOver image moudule wires
wire [10:0] gameOver_sq_inst_offsetX;
wire [10:0] gameOver_sq_inst_offsetY;
wire gameOver_sq_RecDR;
//wire gameOverspaceDR;
wire gameOverDR; // typo

wire [7:0] gameOverRGB;

square_object 	#(
			.OBJECT_WIDTH_X(256), //dec
			.OBJECT_HEIGHT_Y(128),//dec
			.OBJECT_COLOR(0) //hex
)
gameover_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd192),
					.topLeftY(11'd80),
					.offsetX(gameOver_sq_inst_offsetX),
					.offsetY(gameOver_sq_inst_offsetY),
					.drawingRequest(gameOver_sq_RecDR),
					.RGBout()
);

gameOverBitMap gameOver_map_inst(

					.clk(clk), 
					.resetN(resetN), 
					.offsetX(gameOver_sq_inst_offsetX),// offset from top left  position 
					.offsetY(gameOver_sq_inst_offsetY), 
					.InsideRectangle(gameOver_sq_RecDR), //input that the pixel is within a bracket 
					.gameEnded(gameEnded),
					.highScore(newHighScore),
					.drawingRequest(gameOverDR), //output that the pixel should be dispalyed 
					.RGBout(gameOverRGB)  //rgb value from the bitmap 
 ) ;



//key credit invaders moudule wires
wire [10:0] credit_sq_inst_offsetX;
wire [10:0] credit_sq_inst_offsetY;
wire credit_sq_RecDR;
wire creditDR;
wire [7:0] creditRGB;

square_object 	#(
			.OBJECT_WIDTH_X(128), //dec
			.OBJECT_HEIGHT_Y(128),//dec
			.OBJECT_COLOR(0) //hex
)
credit_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd448),
					.topLeftY(11'd230),
					.offsetX(credit_sq_inst_offsetX),
					.offsetY(credit_sq_inst_offsetY),
					.drawingRequest(credit_sq_RecDR),
					.RGBout()
);

keyCreditBitMap credit_map_inst(
					.clk(clk), 
					.resetN(resetN), 
					.offsetX(credit_sq_inst_offsetX), 
					.offsetY(credit_sq_inst_offsetY), 
					.InsideRectangle(credit_sq_RecDR),
					.standBy(gameEnded),
					.drawingRequest(creditDR), 
					.RGBout(creditRGB)
);

start_screen_mux start_mux_inst
(
					.clk(clk),
					.resetN(resetN),
					.startDrawingRequest(startDR), 
					.startRGB(startRGB),
					.spaceDrawingRequest(gameOverDR), 
					.spaceRGB(gameOverRGB), 
					.creditDrawingRequest(creditDR), 
					.creditRGB(creditRGB),		
					.RGBOut(endScreenRGB),
					.startScreenDR(endScreenDR) 
);
endmodule

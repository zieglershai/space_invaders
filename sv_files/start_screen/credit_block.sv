
/// responnsible for displaying coins on the right bottom part of the screen
/// add one coin for each press on the button up to 4 coins
/// decrease one coin for each new game					
module credit_block(
					input clk,
					input resetN,
					input standBy,
					input [10:0] pixelX,
					input [10:0] pixelY,
					input keyCoinN,
					input startGame,
					
					output creditCoinDR,
					output [7:0] creditCoinRGB,
					output [3:0] credits
);

wire [10:0] credit_offsetX;
wire [10:0] credit_offsetY;
wire credit_sq_RecDR;
wire add_coin_n;



square_object 	#(
			.OBJECT_WIDTH_X(64),
			.OBJECT_HEIGHT_Y(16),
			.OBJECT_COLOR(91) 

)
credit_sq(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd488),
					.topLeftY(11'd450),
					.offsetX(credit_offsetX),
					.offsetY(credit_offsetY),
					.drawingRequest(credit_sq_RecDR),
					.RGBout()
);

credit_shmidth smidth_inst(
	 .clk(clk),
	 .resetN(resetN),
	 .i_addCoin(keyCoinN),
	 .o_addCoin(add_coin_n)
);


creditBitMap credit_map_inst(
					.clk(clk), 
					.resetN(resetN), 
					.offsetX(credit_offsetX), 
					.offsetY(credit_offsetY), 
					.InsideRectangle(credit_sq_RecDR),
					.addCoin(add_coin_n),
					.gameStart(startGame), 
					.drawingRequest(creditCoinDR),
					.RGBout(creditCoinRGB),
					.credits(credits)
);


endmodule

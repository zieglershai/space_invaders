module bonus_ship(
					input clk,
					input resetN,
					input startOfFrame,
					input standBy,
					input gameEnded,
					
					input bonusFireCollision,
					input rise,
					
					input [10:0]alienMatrixYPosition,
					input [10:0] pixelX,
					input [10:0] pixelY,
					
					output bonus_ship_alive,
					output bonus_ship_DR,
					output [7:0] bonus_ship_RGB
);


wire [10:0] bonus_shipTLX;
wire [10:0] bonus_shipTLY;
wire [10:0] bonusShipOffsetX;
wire [10:0] bonusShipOffsetY;

wire bonus_shipRecDR;
wire [9:0] o_rnd;

wire playGame;
wire alive;
wire insideRectangle;

assign playGame = ~(standBy | gameEnded);
assign insideRectangle = alive & bonus_shipRecDR;
assign bonus_ship_alive = alive;


random 	
 #(
				.SIZE_BITS(10),
				.MIN_VAL(320),  //set the min and max values 
				.MAX_VAL(500)
)
rnd_inst ( 
				.clk(clk),
				.resetN(resetN), 
				.rise(rise),
				.dout(o_rnd)	
);


bonusShip_moveCollision #(
				.INITIAL_X(0),
				.INITIAL_Y(64),
				.INITIAL_X_SPEED(100),
				.INITIAL_Y_SPEED(0),
				.MAX_Y_SPEED(0)
)

bonus_mov_inst(    
				.clk(clk),
				.resetN(resetN),
				.startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
				.bonusFireCollision(bonusFireCollision),  //collision if smiley hits an object
				.alienMatrixYPosition(alienMatrixYPosition) ,
				.pixelX(pixelX),
				.pixelY(pixelY),
				.randX(o_rnd),
				.playGame(playGame),
				.topLeftX(bonus_shipTLX), // output the top left corner 
				.topLeftY(bonus_shipTLY),  // can be negative , if the object is partliy outside 
				.alive(alive)                     
);

square_object 	#(
			.OBJECT_WIDTH_X(64),
			.OBJECT_HEIGHT_Y(32),
			.OBJECT_COLOR(8'hff)
)
bonus_ship_sq(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(bonus_shipTLX),
					.topLeftY(bonus_shipTLY),
					.offsetX(bonusShipOffsetX),
					.offsetY(bonusShipOffsetY),
					.drawingRequest(bonus_shipRecDR),
					.RGBout()
);

bonusShipBitMap bonus_ship_map_inst(   
					.clk(clk),
					.resetN(resetN),
					.offsetX(bonusShipOffsetX),// offset from top left  position 
					.offsetY(bonusShipOffsetY),
					.InsideRectangle(insideRectangle), //if inside the image and spaceship is alive 
					.playGame(playGame),
					.drawingRequest(bonus_ship_DR), //output that the pixel should be dispalyed 
					.RGBout(bonus_ship_RGB)  //rgb value from the bitmap 
 ) ;
 
 
endmodule 
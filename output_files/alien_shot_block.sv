
//alien shot from matrix
module alien_shot_block (
					input clk,
					input resetN,
					input startOfFrame,
					input alienFireCollision,
					input bottomaAlien,
					input standBy,
					input gameEnded,				
					input [10:0] alienXPosition,
					input [10:0] alienYPosition,
					input [10:0] pixelX,
					input [10:0] pixelY,	
					
					output alienShotDR,
					output [7:0] alienShotRGB
);

// wires

wire [9:0] o_rand;
wire playGame;
wire [10:0] alienShotTLX;
wire [10:0] alienShotTLY;
logic fire_alive;
logic sq_dr_req;

assign playGame =  ~(standBy | gameEnded); // if in the game level
assign alienShotDR = fire_alive & sq_dr_req; // request to draw if fire alive and in the zone of fire


random 	
 #(
				.SIZE_BITS(10),
				.MIN_VAL(0),  //set the min and max values 
				.MAX_VAL(1023)
)
rnd_inst ( 
				.clk(clk),
				.resetN(resetN), 
				.rise(bottomaAlien),
				.dout(o_rand)	
);

alien_shot_moveCollision alien_shot_mv_inst(
				.clk(clk),
				.resetN(resetN),
				.startOfFrame(startOfFrame),  
				.alienFireCollision(alienFireCollision),  
				.alienXPosition(alienXPosition),
				.alienYPosition(alienYPosition),
				.pixelX(pixelX),
				.pixelY(pixelY),
				.bottomAlien(o_rand),
				.playGame(playGame),
				.topLeftX(alienShotTLX), 
				.topLeftY(alienShotTLY), 
				.fireAlive(fire_alive)
);

square_object 	#(
			.OBJECT_WIDTH_X(2),
			.OBJECT_HEIGHT_Y(16),
			.OBJECT_COLOR(8'hff)
)
alien_shot_sq(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(alienShotTLX),
					.topLeftY(alienShotTLY),
					.offsetX(), // no need fill whole square
					.offsetY(), // no need fill whole square
					.drawingRequest(sq_dr_req),
					.RGBout(alienShotRGB)
);

endmodule

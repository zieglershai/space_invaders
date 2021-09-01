module alien_matrix_block (
					input clk,
					input resetN,
					input startOfFrame,
					input collision,
					input fireCollision,
					input standBy,
					input gameEnded,
					input [10:0] pixelX,
					input [10:0] pixelY,

					output [10:0] alienMiddleX,
					output [10:0] alienMiddleY,
					output alienMatrixDR,
					output [7:0] alienMatrixRGB,
					output matrixDefeated,
					output bottomAlien,
					output [1:0] alienType,
					output [10:0] alienMatrixTLY

);


wire playGame;
wire [10:0] alienMatrixTLX;
wire [3:0] HitEdgeCode;
wire [10:0] alienMatrixOffsetX;
wire [10:0] alienMatrixOffsetY;
wire alienMatrixRecDR;


assign playGame = ~(standBy | gameEnded);

alien_matrix_moveCollision alien_mov_inst(
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.collision(collision), 
					.HitEdgeCode(HitEdgeCode),
					.playGame(playGame),
					.matrixDefeated(matrixDefeated),
					.topLeftX(alienMatrixTLX),
					.topLeftY(alienMatrixTLY)
); 

square_object 	#(
			.OBJECT_WIDTH_X(256),
			.OBJECT_HEIGHT_Y(128)
)
alien_sq(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(alienMatrixTLX),
					.topLeftY(alienMatrixTLY),
					.offsetX(alienMatrixOffsetX),
					.offsetY(alienMatrixOffsetY),
					.drawingRequest(alienMatrixRecDR),
					.RGBout()
			);
			
alien_matrixBitMap alien_bit_inst(		
					.clk(clk),
					.resetN(resetN),
					.offsetX(alienMatrixOffsetX),
					.offsetY(alienMatrixOffsetY),
					.InsideRectangle(alienMatrixRecDR),
					.fireCollision(fireCollision),
					.playGame(playGame),
					.startOfFrame(startOfFrame),
					.drawingRequest(alienMatrixDR),
					.RGBout(alienMatrixRGB),  
					.HitEdgeCode(HitEdgeCode),
					.matrixDefeated(matrixDefeated),
					.bottomAlien(bottomAlien),
					.alienType(alienType)		
);

alienMiddle alien_middle_inst (
					.clk(clk),
					.resetN(resetN),
					.offsetX(alienMatrixOffsetX),
					.offsetY(alienMatrixOffsetY),
					.alienMatrixTLX(alienMatrixTLX),
					.alienMatrixTLY(alienMatrixTLY),
					.alienMiddleX(alienMiddleX),
					.alienMiddleY(alienMiddleY)

);
endmodule



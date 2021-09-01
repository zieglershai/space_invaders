
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // alienMatrix 
					input		logic	alienMatrixDR, // two set of inputs per unit
					input		logic	[7:0] alienMatrixRGB, 
					     
		  // player
					input		logic	playerDR, // two set of inputs per unit
					input		logic	[7:0] playerRGB, 
					
			// player playerShot
					input		logic	playerShotDR, // two set of inputs per unit
					input		logic	[7:0] playerShotRGB, 
					
			// player alienrShot
					input		logic	alienShotDR, // two set of inputs per unit
					input		logic	[7:0] alienShotRGB, 
			 
			 // score
					input    logic scoreDR, // box of numbers
					input		logic	[7:0] scoreRGB,   

			// score title
					input    logic scoreTitleDR, // box of numbers
					input		logic	[7:0] scoreTitleRGB,
					
			 // high score
					input    logic highScoreDR, // box of numbers
					input		logic	[7:0] highScoreRGB,
					
			 // high score title
					input    logic highScoreTitleDR, // box of numbers
					input		logic	[7:0] highScoreTitleRGB,
					
			 // life
					input    logic lifeDR, // box of numbers
					input		logic	[7:0] lifeRGB,   
					
			 // life title
					input    logic lifeTitleDR, // box of numbers
					input		logic	[7:0] lifeTitleRGB,   
					
			// start screen
					input    logic startScreenDR, // box of numbers
					input		logic	[7:0] startScreenRGB,   

			// end screen
					input    logic endScreenDR, // box of numbers
					input		logic	[7:0] endScreenRGB,  
					
			// credit Coins
					input    logic creditCoinsDR, // box of numbers
					input		logic	[7:0] creditCoinsRGB,   
			  
			// credit title
					input    logic creditTitleDR, // box of numbers
					input		logic	[7:0] creditTitleRGB, 
			
			// bounus Ship 
					input    logic bounusShipDR, // box of numbers
					input		logic	[7:0] bounusShipRGB, 

					
					
		  ////////////////////////
		  // background 

					input		logic	[7:0] backGroundRGB, 
			  
				   output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		if (alienMatrixDR == 1'b1 )   
			RGBOut <= alienMatrixRGB;  //first priority 
				 
		else if (playerDR == 1'b1 )   
			RGBOut <= playerRGB;  //second priority 
			
		else if (playerShotDR == 1'b1 )   
			RGBOut <= playerShotRGB;  //thirsd priority 
		 
		else if (alienShotDR == 1'b1 )   
			RGBOut <= alienShotRGB;  //forth priority 
			
		else if (scoreDR == 1'b1)
			RGBOut <= scoreRGB;

		else if (scoreTitleDR == 1'b1)
			RGBOut <= scoreTitleRGB;
						
		else if (highScoreDR == 1'b1)
			RGBOut <= highScoreRGB;

		else if (highScoreTitleDR == 1'b1)
			RGBOut <= highScoreTitleRGB;
			
		else if (lifeDR == 1'b1)
			RGBOut <= lifeRGB;
			
		else if (lifeTitleDR == 1'b1)
			RGBOut <= lifeTitleRGB;
			
		else if (creditCoinsDR == 1'b1)
			RGBOut <= creditCoinsRGB;

		else if (creditTitleDR == 1'b1)
			RGBOut <= creditTitleRGB;

		else if (startScreenDR == 1'b1)
			RGBOut <= startScreenRGB;
			
		else if (endScreenDR == 1'b1)
			RGBOut <= endScreenRGB;
		
		else if (bounusShipDR == 1'b1)
			RGBOut <= bounusShipRGB;


		else 
			RGBOut <= backGroundRGB ; // last priority 
			
			
		end ; 
	end

endmodule



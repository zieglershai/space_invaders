// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	playerLifeBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic playGame,
					input logic shotHitPlayer,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
					output   logic gameLose

 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 4;  // 2^4 = 16
localparam  int OBJECT_NUMBER_OF_X_BITS = 6;  // 2^6 = 64


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel 


logic unsigned [0:3] initial_life = { 1'b1, 1'b1, 1'b1, 1'b0 }; //fukcer
logic unsigned [0:3] MazeBiMapMask;



logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] object_colors = {
	64'b0000000000000000000000000000000000000000000000000000000000000000,
	64'b0000000000000000000000000000000000000000000000000000000000000000,
	64'b0000000000000000000000000000000110000000000000000000000000000000,
	64'b0000000000000000000000000000111111110000000000000000000000000000,
	64'b0000000000000000000000000000111111110000000000000000000000000000,
	64'b0000000000000000000000000000111111110000000000000000000000000000,
	64'b0000000000000000001111111111111111111111111111000000000000000000,
	64'b0000000000000000001111111111111111111111111111000000000000000000,
	64'b0000000000000001111111111111111111111111111111110000000000000000,
	64'b0000000000000001111111111111111111111111111111110000000000000000,
	64'b0000000000000001111111111111111111111111111111110000000000000000,
	64'b0000000000000001111111111111111111111111111111110000000000000000,
	64'b0000000000000001111111111111111111111111111111110000000000000000,
	64'b0000000000000001111111111111111111111111111111110000000000000000,
	64'b0000000000000000000000000000000000000000000000000000000000000000,
	64'b0000000000000000000000000000000000000000000000000000000000000000
	};

//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  


 

// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge playGame or negedge resetN)
begin
	if(!resetN || !playGame) begin
		MazeBiMapMask <= initial_life;
		gameLose <= 0;

	end
	


	else begin
	
		if (shotHitPlayer) begin
			if (MazeBiMapMask[3])
				MazeBiMapMask[3] <= 0;
			else if (MazeBiMapMask[2])
				MazeBiMapMask[2] <= 0;
			else if (MazeBiMapMask[1])
				MazeBiMapMask[1] <= 0;
			else if (MazeBiMapMask[0])
				MazeBiMapMask[0] <= 0;
			else
				gameLose <= 1;
		end
		 	
	end
		
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest =MazeBiMapMask[offsetX[8:6]] && object_colors[offsetY][offsetX] && InsideRectangle & playGame;  // in the area and have enough life and ligtehn pixel
assign RGBout = 8'h5c;

endmodule
// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	shieldBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic collision, // if current alien was shot,
					//input logic startOfFrame, for future purpose - if need to disable explotion til new frame
					input logic playGame, // wait for game to begin
					input logic collisionShield_alien,
					
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 


 ) ;



// generating a smiley bitmap


// shield array
logic unsigned [0:3] [0:15] [0:31] shields;
logic [0:3] shieldLive;



logic [0:15] [0:31] initial_shield = {

    32'b00000000000000000000000000000000,
    32'b000000001111111111111111110000000,
    32'b000000111111111111111111111000000,
    32'b00001111111111111111111111110000,
    32'b000111111111111111111111111111000,
    32'b001111111111111111111111111111100,
    32'b001111111111111111111111111111100,
    32'b001111111111111111111111111111100,
    32'b001111111111111111111111111111100,
    32'b001111111111111111111111111111100,
    32'b001111111111111111111111111111100,
    32'b001111111111111111111111111111100,
    32'b0011111111100000000001111111111100,
    32'b001111111100000000000011111111100,
    32'b0011111110000000000000001111111100,
    32'b00000000000000000000000000000000};
	



logic [1:0] shield_number;
logic [4:0] shield_row;
logic [5:0] shield_col;
logic is_shield;

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge playGame or negedge resetN)
begin
	if(!resetN || !playGame) begin
	// begging of new play
		shields [0] <= initial_shield;
		shields [1] <= initial_shield;
		shields [2] <= initial_shield;
		shields [3] <= initial_shield;
		shieldLive <= 4'b1111;

		

	end
	else begin
		if (InsideRectangle) begin
			// the sield are located in the 64 first bit of each 128 pixel
			// player view	 -----shield-----space----shield ----space----.....shield
			// pixels x axis-----0-63-------64-127---128-191----192-255-......128-191
			//-----------------------------------------------
			//we can identify it by looking at offsetX[6]:
			// odd - space
			// even - shield
				
			// we removed offsetX[6] to divide by 2 and ignore the spaces when we decide whice shield to look
			if (collisionShield_alien) begin
				shieldLive [shield_number] <= 1'b0;
			end
			
			else if (collision)begin // if we got hit by fire destroy radius is 4 pixel
			/*
			row
			1:	|||||||||||||||||||*||||||||||||||||||
			2:	||||||||||||||||||***||||||||||||||||
			3:	|||||||||||||||||*****||||||||||||||||
			4:	||||||||||||||||*******|||||||||||||||
			5:	|||||||||||||||****0****|||||||||||||
			6:	||||||||||||||||*******|||||||||||||||
			7;	|||||||||||||||||*****|||||||||||||||||
			8:	||||||||||||||||||***|||||||||||||||||
			9:	|||||||||||||||||||*||||||||||||||||||
			
			0 - location of hit
			* destyored part
		*/
				// explotion center
				shields [shield_number][shield_row][shield_col  ] <= 1'b0;
				//first row
				//shields [shield_number][shield_row - 5'd4][shield_col + 6'd0] <= 1'b0;
				// 2 row
				//shields [shield_number][shield_row - 5'd3][shield_col - 6'd1] <= 1'b0;
				//shields [shield_number][shield_row - 5'd3][shield_col + 6'd0] <= 1'b0;
				//shields [shield_number][shield_row - 5'd3][shield_col + 6'd1] <= 1'b0;
				// 3rd row 
				//shields [shield_number][shield_row - 5'd2][shield_col - 6'd2] <= 1'b0;
				//shields [shield_number][shield_row - 5'd2][shield_col - 6'd1] <= 1'b0;
				shields [shield_number][shield_row - 5'd2][shield_col + 6'd0] <= 1'b0;
				//shields [shield_number][shield_row - 5'd2][shield_col + 6'd1] <= 1'b0;
				//shields [shield_number][shield_row - 5'd2][shield_col + 6'd2] <= 1'b0;
				//4th row
				//shields [shield_number][shield_row - 5'd1][shield_col - 6'd3] <= 1'b0;
				//shields [shield_number][shield_row - 5'd1][shield_col - 6'd2] <= 1'b0;
				shields [shield_number][shield_row - 5'd1][shield_col - 6'd1] <= 1'b0;
				shields [shield_number][shield_row - 5'd1][shield_col + 6'd0] <= 1'b0;
				shields [shield_number][shield_row - 5'd1][shield_col + 6'd1] <= 1'b0;
				//shields [shield_number][shield_row - 5'd1][shield_col + 6'd2] <= 1'b0;
				//shields [shield_number][shield_row - 5'd1][shield_col + 6'd3] <= 1'b0;
				// 5th row
				//shields [shield_number][shield_row + 5'd0][shield_col - 6'd4] <= 1'b0;
				//shields [shield_number][shield_row + 5'd0][shield_col - 6'd3] <= 1'b0;
				shields [shield_number][shield_row + 5'd0][shield_col - 6'd2] <= 1'b0;
				shields [shield_number][shield_row + 5'd0][shield_col - 6'd1] <= 1'b0;
				//shields [shield_number][shield_row + 5'd0][shield_col + 6'd0] <= 1'b0;
				shields [shield_number][shield_row + 5'd0][shield_col + 6'd1] <= 1'b0;
				shields [shield_number][shield_row + 5'd0][shield_col + 6'd2] <= 1'b0;
				//shields [shield_number][shield_row + 5'd0][shield_col + 6'd3] <= 1'b0;
				//shields [shield_number][shield_row + 5'd0][shield_col + 6'd4] <= 1'b0;

				// 6th row
			//	shields [shield_number][shield_row + 5'd1][shield_col - 6'd3] <= 1'b0;
				//shields [shield_number][shield_row + 5'd1][shield_col - 6'd2] <= 1'b0;
				shields [shield_number][shield_row + 5'd1][shield_col - 6'd1] <= 1'b0;
				shields [shield_number][shield_row + 5'd1][shield_col + 6'd0] <= 1'b0;
				shields [shield_number][shield_row + 5'd1][shield_col + 6'd1] <= 1'b0;
				//shields [shield_number][shield_row + 5'd1][shield_col + 6'd2] <= 1'b0;
				//shields [shield_number][shield_row + 5'd1][shield_col + 6'd3] <= 1'b0;
				//7th row
				//shields [shield_number][shield_row + 5'd2][shield_col - 6'd2] <= 1'b0;
				//shields [shield_number][shield_row + 5'd2][shield_col - 6'd1] <= 1'b0;
				shields [shield_number][shield_row + 5'd2][shield_col + 6'd0] <= 1'b0;
				//shields [shield_number][shield_row + 5'd2][shield_col + 6'd1] <= 1'b0;
				//shields [shield_number][shield_row + 5'd2][shield_col + 6'd2] <= 1'b0;

				//8th row
				//shields [shield_number][shield_row + 5'd3][shield_col - 6'd1] <= 1'b0;
				//shields [shield_number][shield_row + 5'd3][shield_col + 6'd0] <= 1'b0;
				//shields [shield_number][shield_row + 5'd3][shield_col + 6'd1] <= 1'b0;

				//9th row
				//shields [shield_number][shield_row + 5'd4][shield_col + 6'd0] <= 1'b0;

			end
		end			
	end	
end

always_comb begin
shield_number = offsetX[8:7];
shield_row = offsetY[4:1];
shield_col = offsetX[5:1];
is_shield = !offsetX[6];

// set drwaing request based on if the pixel alive or dead (it's value)
drawingRequest = InsideRectangle & shields [shield_number][shield_row][shield_col] & is_shield & playGame & shieldLive [shield_number];
RGBout = 8'h5c;
end

//////////--------------------------------------------------------------------------------------------------------------=

endmodule
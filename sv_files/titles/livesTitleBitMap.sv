// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	livesTitleBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic playGame,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;


 
 
localparam logic [7:0] COLOR_ENCODING = 8'hFF ;// RGB value in the bitmap representing the BITMAP coolor
localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel  
logic[0:15][0:63] object_colors = {
	64'b0000001111111000000110000001110000001000000000011111000000000111,
	64'b0000001111111000000110000001110000011000000000011110000000000011,
	64'b0000001111111000000110000001110000011000000000011100000000000001,
	64'b0000001111111000000111000001100000011000000111111100000111000001,
	64'b0000001111111000000111000001100000011000000111111100000111000001,
	64'b0000001111111000000111000001100000011000000111111100000111111111,
	64'b0000001111111000000111000001100000111000000000011100000000011111,
	64'b0000001111111000000111000001100000111000000000011110000000000111,
	64'b0000001111111000000111000001100000111000000000011111000000000001,
	64'b0000001111111000000111100001100000111000000111111111111111000001,
	64'b0000001111111000000111100000100000111000000111111111111111000001,
	64'b0000001111111000000111100000100000111000000111111100000111000001,
	64'b0000001111111000000111100000000001111000000111111100000111000001,
	64'b0000000000011000000111110000000001111000000000001100000000000001,
	64'b0000000000011000000111110000000001111000000000001110000000000011,
	64'b0000000000011000000111110000000001111000000000001111100000001111};

 
 
//////////--------------------------------------------------------------------------------------------------------------= 
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	 
//there is one bit per edge, in the corner two bits are set  

 // pipeline (ff) to get the pixel color from the array 	 
//////////--------------------------------------------------------------------------------------------------------------= 
always_ff@(posedge clk or negedge playGame or negedge resetN) 
begin 
	if(!resetN || !playGame) begin 
		RGBout <=	8'h00; 
	end 
	else begin 
		RGBout <= TRANSPARENT_ENCODING ; // default  
 
		if (InsideRectangle == 1'b1 ) 
		begin // inside an external bracket  
			RGBout <= (object_colors[offsetY][offsetX] ==  0 ) ? COLOR_ENCODING  : TRANSPARENT_ENCODING; 
		end  	 
		 
	end 
end 
 
//////////--------------------------------------------------------------------------------------------------------------= 
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   
 
endmodule 

// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	scoreTitleBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;


 
 
localparam logic [7:0] COLOR_ENCODING = 8'hff ;// RGB value in the bitmap representing the BITMAP coolor
localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel  
logic[0:15][0:63] object_colors = {
	64'b1110000001111111100000111111110000001111110000000011111100000000,
	64'b1100000000111111000000011111100000000111110000000001111100000000,
	64'b1000011000011100000100000111000001000011110000010000111100001111,
	64'b1000011000011100001110000111000011100011110000111000111100011111,
	64'b1000011000011100001110000111000011100011110000111000111100011111,
	64'b1000011111111100001110000111000011100011110000111000111100011111,
	64'b1000011111111100001111111111000011100011110000110000111100001111,
	64'b1000000001111100001111111111000011100011110000000011111100000001,
	64'b1110000000011100001111111111000011100011110000000011111100000001,
	64'b1111111000011100001111111111000011100011110000110000111100011111,
	64'b1111111000011100001110000111000011100011110000111000111100011111,
	64'b1000011000011100001110000111000011100011110000111000111100011111,
	64'b1000011000011100001110000111000011100011110000111000111100011111,
	64'b1000011000011100000100000111000011000011110000111000111100001111,
	64'b1100000000111111000000011111100000000111110000111000111100000000,
	64'b1110000001111111100000111111110000001111110000111000111100000000};

 
 
//////////--------------------------------------------------------------------------------------------------------------= 
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	 
//there is one bit per edge, in the corner two bits are set  

 // pipeline (ff) to get the pixel color from the array 	 
//////////--------------------------------------------------------------------------------------------------------------= 
always_ff@(posedge clk or negedge resetN) 
begin 
	if(!resetN) begin 
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

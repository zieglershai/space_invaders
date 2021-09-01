// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	creditsTitleBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;


 
 
localparam logic [7:0] COLOR_ENCODING = 8'hFF ;// RGB value in the bitmap representing the BITMAP coolor
localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel  
logic[0:15][0:63] object_colors = {
	64'b1100000111100000001110000000110000000111100011000000001110000011,
	64'b1000000011100000000110000000110000000011100011000000001000000001,
	64'b0000000001100000000110000000110000000001100011000000001000000000,
	64'b0000100001100011000110000111110001100001100011110001111000110000,
	64'b0000100001100011000010000111110001100001100011110001111000110000,
	64'b0000100001100011000010000111110001100001100011110001111000111111,
	64'b0000111111100011000110000000110001100001100011110001111000001111,
	64'b0000111111100000001110000000110001100001100011110001111000000011,
	64'b0000111111100000001110000000110001100001100011110001111110000001,
	64'b0000100001100011000110000111110001100001100011110001111111110000,
	64'b0000100001100011000010000111110001100001100011110001111111110000,
	64'b0000100001100011000010000111110001100001100011110001111000110000,
	64'b0000100001100011000010000111110001100001100011110001111000110000,
	64'b0000000001100011000010000000110000000001100011110001111000000000,
	64'b1000000011100011000010000000110000000011100011110001111100000001,
	64'b1110000111100011000010000000110000001111100011110001111110000011};
 
 
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

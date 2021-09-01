// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	highScoreTitleBitMap	(	
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
logic[0:15][0:127] object_colors = {
	128'b10000111000011110000111111000001111111000011100001111111111111110000011111111100000111111111000000111111000000001111111000000001,
	128'b10000111000011110000111110000000011111000011100001111111111111000000001111111000000001111110000000011111000000000011111000000001,
	128'b10000111000011110000111000000000001111000011100001111111111110000000000011100000000000111100000000000111000000000001111000000001,
	128'b10000111000011110000111000011100000111000011100001111111111110000111000011100001110000011000001110000111000001110000111000011111,
	128'b10000111000011110000111000011100000111000011100001111111111110000111000011100001110000011000001110000111000001110000111000011111,
	128'b10000111000011110000111000011110001111000011100001111111111110000111111111100001111000111000001110000111000001110000111000011111,
	128'b10000111000011110000111000011111111111000011100001111111111110000111111111100001111111111000001110000111000001100001111000000001,
	128'b10000000000011110000111000011111111111000000000001111111111111000000001111100001111111111000001110000111000000000111111000000001,
	128'b10000000000011110000111000011000000111000000000001111111111111100000000111100001111111111000001110000111000000000111111000000001,
	128'b10000111000011110000111000011000000111000011100001111111111111111110000011100001111111111000001110000111000001100001111000011111,
	128'b10000111000011110000111000011100000111000011100001111111111111111111000011100001110000011000001110000111000001110000111000011111,
	128'b10000111000011110000111000011100000111000011100001111111111110000111000011100001110000011000001110000111000001110000111000011111,
	128'b10000111000011110000111000011100000111000011100001111111111110000111000011100001110000011000001110000111000001110000111000011111,
	128'b10000111000011110000111000000000001111000011100001111111111110000000000011100000000000111100000000000111000001110000111000000001,
	128'b10000111000011110000111110000000011111000011100001111111111111000000000111111000000001111110000000011111000001110000111000000000,
	128'b10000111000011110000111111000000111111000011100001111111111111110000011111111100000111111111000000111111000001110000111000000000};

 
 

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
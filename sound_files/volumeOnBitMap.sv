// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	volumeOnBitMap	(	
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
logic[0:15][0:31] object_colors = {
	32'b11100000000011111000000111100000,
	32'b10000000000000111000000111100000,
	32'b00000000000000111000000011100000,
	32'b00000011100000111000000011100000,
	32'b00000011100000111000000011100000,
	32'b00000011100000111000000001100000,
	32'b00000011100000111000000000100000,
	32'b00000011100000111000000000000000,
	32'b00000011100000111000000000000000,
	32'b00000011100000111000000100000000,
	32'b00000011100000111000000100000000,
	32'b00000011100000111000000100000000,
	32'b00000011100000111000000110000000,
	32'b00000000000000111000000111000000,
	32'b11000000000001111000000111100000,
	32'b11110000000111111000000111100000};

 
 

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
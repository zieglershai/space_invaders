// bitmap file 
// (c) Technion IIT, Department of Electrical Engineering 2021 
// generated bythe automatic Python tool 
 
 
 module keyCreditBitMap (

					input	logic	clk, 
					input	logic	resetN, 
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY, 
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic standBy,
 
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ; 
 
 
// generating the bitmap 
 

localparam logic [7:0] COLOR_ENCODING = 8'hFF ;// RGB value in the bitmap representing the BITMAP coolor
localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel  
logic[0:127][0:127] object_colors = {
	128'b10000000000000011111111110000000000000001111111111000000000000000011111111100000000001111111111111110000000001111111111111111111,
	128'b10000000000000000111111110000000000000000111111111000000000000000011111111000000000000111111111111100000000000111111111111111111,
	128'b10000000000000000011111110000000000000000011111111000000000000000011111110000000000000011111111111000000000000001111111111111111,
	128'b10000000000000000000111110000000000000000000111111000000000000000011111000000000000000000111111100000000000000000011111111111111,
	128'b10000000000000000000011110000000000000000000011111000000000000000011110000000000000000000011111000000000000000000001111111111111,
	128'b10000000011110000000011110000000011111000000011111000000001111111111110000000011110000000011111000000001111000000001111111111111,
	128'b10000000011110000000011110000000011111000000011111000000001111111111110000000011110000000011111000000011111000000001111111111111,
	128'b10000000011110000000011110000000011111000000011111000000001111111111110000000011110000000011111000000011111000000001111111111111,
	128'b10000000011110000000011110000000011111000000011111000000001111111111110000000011111000000011111000000011111100000001111111111111,
	128'b10000000011110000000011110000000011111000000011111000000001111111111110000000011111111111111111000000011111111111111111111111111,
	128'b10000000011110000000011110000000011111000000011111000000001111111111110000000011111111111111111000000011111111111111111111111111,
	128'b10000000011110000000011110000000011111000000011111000000000000000111110000000011111111111111111000000001111111111111111111111111,
	128'b10000000011110000000011110000000000000000001111111000000000000000111110000000000000001111111111000000000000000111111111111111111,
	128'b10000000011110000000011110000000000000000011111111000000000000000111111000000000000000111111111100000000000000011111111111111111,
	128'b10000000000000000000011110000000000000000111111111000000000000000111111110000000000000001111111111000000000000000111111111111111,
	128'b10000000000000000000111110000000000000000001111111000000000000000111111111000000000000000011111111100000000000000001111111111111,
	128'b10000000000000000011111110000000000000000000111111000000001111111111111111110000000000000011111111111000000000000001111111111111,
	128'b10000000000000000111111110000000011111000000011111000000001111111111111111111111110000000011111111111111111000000001111111111111,
	128'b10000000000000011111111110000000011111000000011111000000001111111111111111111111110000000011111111111111111000000001111111111111,
	128'b10000000011111111111111110000000011111000000011111000000001111111111111111111111110000000011111111111111111000000001111111111111,
	128'b10000000011111111111111110000000011111000000011111000000001111111111110000000011110000000011111000000011111000000001111111111111,
	128'b10000000011111111111111110000000011111000000011111000000001111111111110000000011110000000011111000000011111000000001111111111111,
	128'b10000000011111111111111110000000011111000000011111000000001111111111110000000011110000000011111000000011111000000001111111111111,
	128'b10000000011111111111111110000000011111000000011111000000000111111111110000000011110000000011111000000001111000000001111111111111,
	128'b10000000011111111111111110000000011111000000011111000000000000000011110000000000000000000011111000000000000000000001111111111111,
	128'b10000000011111111111111110000000011111000000011111000000000000000011111000000000000000001111111100000000000000000111111111111111,
	128'b10000000011111111111111110000000011111000000011111000000000000000011111110000000000000011111111111000000000000001111111111111111,
	128'b10000000011111111111111110000000011111000000011111000000000000000011111111100000000001111111111111100000000000111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b10000000011111100000000111110000000000000001100000000111111100000000111111111111111111111110000000000111111111111111111111111111,
	128'b10000000011111100000000111110000000000000001110000000111111100000001111111111111111111111100000000000001111111111111111111111111,
	128'b10000000011111100000001111110000000000000001110000000011111100000001111111111111111111110000000000000000111111111111111111111111,
	128'b10000000011111000000001111110000000000000001110000000011111000000001111111111111111111100000000000000000011111111111111111111111,
	128'b10000000011110000000011111110000000000000001111000000011111000000011111111111111111111000000000000000000001111111111111111111111,
	128'b10000000011110000000111111110000000011111111111100000001110000000111111111111111111111000000001111000000001111111111111111111111,
	128'b10000000011110000000111111110000000011111111111100000001110000000111111111111111111111000000001111000000001111111111111111111111,
	128'b10000000011100000001111111110000000011111111111100000001110000000111111111111111111111000000001111000000001111111111111111111111,
	128'b10000000011000000001111111110000000011111111111110000001110000001111111111111111111111000000011111000000001111111111111111111111,
	128'b10000000011000000011111111110000000011111111111110000000100000001111111111111111111111111111111111000000001111111111111111111111,
	128'b10000000011000000011111111110000000011111111111111000000000000011111111111111111111111111111111111000000001111111111111111111111,
	128'b10000000010000000111111111110000000000000011111111000000000000011111111111111111111111111111111100000000001111111111111111111111,
	128'b10000000000000001111111111110000000000000011111111100000000000111111111111111111111111111111111000000000011111111111111111111111,
	128'b10000000000000000111111111110000000000000011111111100000000000111111111111111111111111111111100000000001111111111111111111111111,
	128'b10000000000000000111111111110000000000000011111111110000000000111111111111111111111111111111000000000011111111111111111111111111,
	128'b10000000000000000111111111110000000000000011111111110000000001111111111111111111111111111100000000001111111111111111111111111111,
	128'b10000000010000000011111111110000000011111111111111111000000011111111111111111111111111111000000000011111111111111111111111111111,
	128'b10000000011000000001111111110000000011111111111111111000000011111111111111111111111111100000000001111111111111111111111111111111,
	128'b10000000011000000001111111110000000011111111111111111000000011111111111111111111111111000000000011111111111111111111111111111111,
	128'b10000000011100000000111111110000000011111111111111111000000011111111111111111111111111000000000111111111111111111111111111111111,
	128'b10000000011100000000111111110000000011111111111111111000000011111111111111111111111111000000001111111111111111111111111111111111,
	128'b10000000011110000000011111110000000011111111111111111000000011111111111111111111111111000000001111111111111111111111111111111111,
	128'b10000000011110000000001111110000000011111111111111111000000011111111111111111111111111000000001111111111111111111111111111111111,
	128'b10000000011111000000001111110000000000000001111111111000000011111111111111111111111111000000000000000000001111111111111111111111,
	128'b10000000011111100000000111110000000000000001111111111000000011111111111111111111111111000000000000000000001111111111111111111111,
	128'b10000000011111100000000111110000000000000001111111111000000011111111111111111111111111000000000000000000001111111111111111111111,
	128'b10000000011111100000000011110000000000000001111111111000000011111111111111111111111111000000000000000000001111111111111111111111,
	128'b10000000011111110000000001110000000000000001111111111000000011111111111111111111111111000000000000000000000111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111,
	128'b11111000000000001111111111000000000000000111111111100000000000000001111000000000000000011111111111000000011110000000000000000001,
	128'b11110000000000000111111111000000000000000001111111100000000000000001111000000000000000001111111111000000011110000000000000000001,
	128'b11000000000000000001111111000000000000000000011111100000000000000001111000000000000000000011111111000000011110000000000000000001,
	128'b10000000000000000000011111000000000000000000001111100000000000000001111000000000000000000000111111000000011110000000000000000001,
	128'b00000000011110000000011111000000000111000000001111100000000011111111111000000000111000000000111111000000011111111100000000011111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111111111111111111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111111111111111111000000000111000000011111100000000000000011111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111111111111111111000000000000000001111111100000000000000011111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111111111111111111000000000000000011111111100000000000000011111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111111111111111111000000000000000001111111100000000000000011111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111111111111111111000000000000000000011111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000001111100000000111111000000011111111100000000111111,
	128'b00000000111110000000011111000000001111000000001111100000000011111111111000000000111100000000111111000000011111111100000000111111,
	128'b00000000000000000000011111000000001111000000001111100000000000000001111000000000000000000000111111000000011111111100000000111111,
	128'b11000000000000000000111111000000001111000000001111100000000000000001111000000000000000000001111111000000011111111100000000111111,
	128'b11100000000000000011111111000000001111000000001111100000000000000001111000000000000000000111111111000000011111111100000000111111,
	128'b11111000000000000111111111000000001111000000001111100000000000000001111000000000000000001111111111000000011111111100000000111111,
	128'b11111100000000011111111111000000001111000000001111100000000000000001111000000000000000011111111111000000011111111100000000111111};

 
 
//////////--------------------------------------------------------------------------------------------------------------= 
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	 
//there is one bit per edge, in the corner two bits are set  
 logic [0:3] [0:3] [3:0] hit_colors = 
		   {16'hC446,     
			16'h8C62,    
			16'h8932, 
			16'h9113}; 
 // pipeline (ff) to get the pixel color from the array 	 
//////////--------------------------------------------------------------------------------------------------------------= 
always_ff@(posedge clk or negedge resetN) 
begin 
	if(!resetN) begin 
		RGBout <=	8'h00; 
	end 
	else begin 
		RGBout <= TRANSPARENT_ENCODING ; // default  
 
		if (InsideRectangle == 1'b1 && standBy) 
		begin // inside an external bracket  
			RGBout <= (object_colors[offsetY][offsetX] ==  0 ) ? COLOR_ENCODING  : TRANSPARENT_ENCODING; 
		end  	 
		 
	end 
end 
 
//////////--------------------------------------------------------------------------------------------------------------= 
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   
 
endmodule 

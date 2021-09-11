//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2021
// generating a number bitmap 



module creditBitMap	(	
					input		logic	clk,
					input		logic	resetN,
					input		logic	startOfFrame,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input		logic	InsideRectangle, //input that the pixel is within a bracket 
					input 	logic addCoin,
					input 	logic gameStart,
					
					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]		RGBout,
					output 	logic [3:0] credits
);
// generating a smily bitmap 

parameter  logic	[7:0] digit_color = 8'hff ; //set the color of the digit 



localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel  

logic[0:15][0:15][7:0] object_colors = {
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'hd9,8'hf9,8'hfd,8'hfd,8'hd0,8'hd9,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h90,8'hfd,8'h90,8'h48,8'hd9,8'h00,8'hfd,8'hfd,8'hd1,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h90,8'h48,8'h00,8'h88,8'h88,8'h48,8'h90,8'hd9,8'hd9,8'hfd,8'h90,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'hfd,8'hfd,8'h88,8'h90,8'h88,8'h90,8'hd0,8'hd9,8'hd9,8'h00,8'hfd,8'hf9,8'h00,8'h00},
	{8'h00,8'hd0,8'hf9,8'hd9,8'h48,8'hd0,8'h90,8'hfd,8'hfd,8'hd9,8'hfd,8'hfd,8'hfd,8'hfd,8'h00,8'h00},
	{8'h00,8'hf9,8'hf9,8'h48,8'h48,8'h88,8'hd8,8'hd0,8'hf9,8'hd9,8'hf9,8'hfd,8'hfd,8'hfd,8'hf9,8'h00},
	{8'h00,8'hfd,8'hf9,8'h00,8'h90,8'hd9,8'hd0,8'hf9,8'hd0,8'hd0,8'hd9,8'hfd,8'hfd,8'hfd,8'hd9,8'h00},
	{8'h00,8'hfd,8'hf9,8'h88,8'h40,8'hd0,8'hd9,8'hd8,8'hfd,8'h90,8'hfe,8'hfd,8'hfd,8'hfd,8'hd9,8'h00},
	{8'h00,8'hf9,8'hf9,8'hf9,8'h90,8'hd9,8'hd8,8'hd8,8'hfd,8'h90,8'hfd,8'hfd,8'hfd,8'hfd,8'hfd,8'h00},
	{8'h00,8'h90,8'hfd,8'hfd,8'hd0,8'hf9,8'hfd,8'hf9,8'hfd,8'h90,8'hfd,8'hfd,8'hfd,8'hf9,8'hda,8'h00},
	{8'h00,8'h00,8'h00,8'h48,8'h88,8'hfd,8'hf9,8'hfd,8'hd9,8'hfd,8'hfd,8'hfd,8'hfd,8'hf9,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'hf9,8'hfd,8'hfd,8'hfd,8'hd9,8'hd9,8'hfd,8'hfe,8'hfd,8'h40,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'hd1,8'hfd,8'hfd,8'hfd,8'hfd,8'hfe,8'hfd,8'hfd,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hf9,8'hd8,8'hd9,8'hf8,8'hda,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}};
																	
	
logic flagadd;
logic flagdec;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	TRANSPARENT_ENCODING;
		credits <= 4'b0;
		flagadd <= 1'b0;
	end
	
	else if(!addCoin && !flagadd && credits < 5) begin
		credits <= credits + 4'b1;
		flagadd <= 1'b1;
	end

	else if(gameStart && !flagdec && credits > 0) begin
		credits <= credits - 4'd1;
		flagdec <= 1'b1;
	end
	
	else begin
		if(addCoin) begin
			flagadd <= 1'b0;
		end
		
		if(!gameStart) begin
			flagdec <= 1'b0;
		end
		
		RGBout <= TRANSPARENT_ENCODING;
	
		if (InsideRectangle == 1'b1 && credits > offsetX[8:4]) begin
			RGBout <= (object_colors[offsetY][offsetX]);	//get value from bitmap
		end

	end 
end




assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ;

endmodule
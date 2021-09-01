//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2021
// generating a number bitmap 



module scoreBitMap	(	
					input		logic	clk,
					input		logic	resetN,
					input		logic	startOfFrame,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input		logic	InsideRectangle, //input that the pixel is within a bracket 
					input 	logic	signed [7:0] scoreUpdate, // points to add
					input 	logic resetScore,
					
					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]		RGBout,
					output 	int score
);
// generating a smily bitmap 

parameter  logic	[7:0] digit_color = 8'hff ; //set the color of the digit 


int unsigned current_digit;
int unsigned  current_digit_value[3:0];

bit [0:9] [0:15] [0:7] number_bitmap  = {


{
// 0

	8'b11000011,
	8'b10000001,
	8'b00000000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00000000,
	8'b10000001,
	8'b11000011},
			
// 1
			
{
	8'b11000000,
	8'b11000000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000,
	8'b11110000},
		
// 2
{
	8'b11000011,
	8'b10000001,
	8'b00000000,
	8'b00011000,
	8'b00011000,
	8'b11111000,
	8'b11110000,
	8'b11100001,
	8'b11000011,
	8'b10000111,
	8'b10001111,
	8'b00011111,
	8'b00011111,
	8'b00000000,
	8'b00000000,
	8'b00000000},
	
// 3
{	
	8'b11000011,
	8'b10000001,
	8'b00000000,
	8'b00011000,
	8'b00011000,
	8'b11111000,
	8'b11110001,
	8'b11100011,
	8'b11100011,
	8'b11111001,
	8'b11111000,
	8'b00011000,
	8'b00011000,
	8'b00000000,
	8'b10000001,
	8'b11000011},
			
// 4
																			
{
	8'b11110011,
	8'b11110011,
	8'b11100011,
	8'b11100011,
	8'b11000011,
	8'b11000011,
	8'b10010011,
	8'b10010011,
	8'b10110011,
	8'b00110011,
	8'b00000000,
	8'b00000000,
	8'b10000001,
	8'b11110011,
	8'b11110011,
	8'b11110011},
			
// 5
																			
{
	8'b00000001,
	8'b00000001,
	8'b00000001,
	8'b00011111,
	8'b00011111,
	8'b00011111,
	8'b00000011,
	8'b10000001,
	8'b11000000,
	8'b11111000,
	8'b11111000,
	8'b00011000,
	8'b00011000,
	8'b00000000,
	8'b10000001,
	8'b11000011},
			
// 6
																			
{
	8'b11000011,
	8'b10000001,
	8'b00000000,
	8'b00011000,
	8'b00011000,
	8'b00011111,
	8'b00011111,
	8'b00000001,
	8'b00000000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00000000,
	8'b10000001,
	8'b11000011},
			
// 7
																			
{
	8'b00000000,
	8'b00000000,
	8'b00000000,
	8'b00011000,
	8'b11111001,
	8'b11110001,
	8'b11110001,
	8'b11100011,
	8'b11100011,
	8'b11100011,
	8'b11000111,
	8'b11000111,
	8'b11000111,
	8'b10001111,
	8'b10001111,
	8'b10001111
},
			
// 8
																			
{
	8'b11000011,
	8'b10000001,
	8'b00000000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b10000001,
	8'b10000011,
	8'b10000001,
	8'b00000000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00000000,
	8'b10000001,
	8'b11000011},
			
// 9
																			
{
	8'b11000011,
	8'b10000001,
	8'b00000000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00011000,
	8'b00000000,
	8'b10000000,
	8'b11111000,
	8'b11111000,
	8'b00011000,
	8'b00011000,
	8'b00000000,
	8'b10000001,
	8'b11000011}

};
																	
	


// pipeline (ff) to get the pixel color from the array 	 
assign current_digit = offsetX[5:3]; // digit place
assign current_digit_value [3] = score % 10; //digit value
assign current_digit_value [2] = (score / (10 ))%10; //digit value
assign current_digit_value [1] = (score / (100 ))%10; //digit value
assign current_digit_value [0] = (score / (1000 ))%10; //digit value

//always_comb begin
//	assign current_digit = offsetX[5:3]; // digit place
//	if (score[3:0] < 10) begin
//		assign current_digit_value [3] = score[3:0];
//	end
//	else begin
//		assign current_digit_value [3] = score[3:0] + 6;
//	end
//	
//	if ((score / 10)[3:0] < 10) begin
//		assign current_digit_value [2] = (score / 10)[3:0];
//	end
//	else begin
//		assign current_digit_value [2] = (score / 10)[3:0] + 6;
//	end
//	
//
//	if ((score / 100)[3:0] < 10) begin
//		assign current_digit_value [1] = (score / 100)[3:0];
//	end
//	else begin
//		assign current_digit_value [1] = (score / 100)[3:0] + 6;
//	end
//	
//	
//		if ((score / 1000)[3:0] < 10) begin
//		assign current_digit_value [0] = (score / 1000)[3:0];
//	end
//	else begin
//		assign current_digit_value [0] = (score / 1000)[3:0] + 6;
//	end
//end

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		drawingRequest <=	1'b0;
		score <= 0;
	end
		
	else begin

		drawingRequest <=	1'b0;
	
		if (InsideRectangle == 1'b1 ) begin
			drawingRequest <= ((number_bitmap[current_digit_value[current_digit]][offsetY][offsetX[2:0]]) == 0);	//get value from bitmap
		
		end
		if (resetScore) begin
			score <= 0;
		end
		else begin
			score <= score + scoreUpdate;
		end
	end 
end

assign RGBout = digit_color ; // this is a fixed color 

endmodule
// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	alienMiddle	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	[10:0] alienMatrixTLX, //input that the pixel is within a bracket 
					input logic [10:0] alienMatrixTLY, // if current alien was shot,
					
					
					//// debuging addition
					output logic [10:0] alienMiddleX,
					output logic [10:0] alienMiddleY



 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^5 = 32 



// decide if to draw the pixel or not 
always_comb begin
alienMiddleX =  alienMatrixTLX + ((offsetX[10:5])<< OBJECT_NUMBER_OF_X_BITS) + 11'd16;
alienMiddleY =  alienMatrixTLY + ((offsetY[10:5])<< OBJECT_NUMBER_OF_Y_BITS) + 11'd16;

		
end


endmodule

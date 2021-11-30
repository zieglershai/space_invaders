

// unnecessry module can be replaced with const in the main block as TOPX and TOPY
module	shield_moveCollision	(	
 
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
	input logic collision,  //collision if smiley hits an object
	input logic playGame, // wait for game to begin

	output logic signed 	[10:0]	topLeftX, // output the top left corner 
	output logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);



parameter int INITIAL_X = 32;
parameter int INITIAL_Y = 400;




const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions



//////////--------------------------------------------------------------------------------------------------------------=
//  calculation X Axis speed using and position calculate regarding X_direction key or  colision

always_ff@(posedge clk or negedge playGame  or negedge resetN)
begin
	if(!resetN || !playGame)
	begin

//		alienReachedBottom <= 0;
	end
	else begin
		
				
			
	end
end

//get a better (64 times) resolution using integer   
//assign 	topLeftX = (topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER) ;   // note it must be 2^n 
//assign 	topLeftY = (topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER) ;    

assign 	topLeftX = topLeftX_FixedPoint [16:6];   //another way to divide by 64
assign 	topLeftY = topLeftY_FixedPoint [16:6];    


endmodule

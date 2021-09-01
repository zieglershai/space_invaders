// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	player_shot_moveCollision	(	
 
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
	input logic fireCollision,  //collision if smiley hits an object
	input logic signed [10:0] playerXPosition ,
	input logic start,
	input logic playGame,





	output logic signed 	[10:0]	topLeftX, // output the top left corner 
	output logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside 
	output logic alive  

					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 0;
parameter int INITIAL_Y = 400;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED =  -320;
parameter int MAX_Y_SPEED = 400;
const int ALIEN_ROW = 4;
const int ALIEN_COLUMN = 8; 
const int  Y_ACCEL = 0;//-1;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation X Axis speed using and position calculate regarding X_direction key or  colision
always_ff@(posedge clk or negedge playGame or negedge resetN)
begin
	if(!resetN || !playGame)
	begin
		Yspeed	<= INITIAL_Y_SPEED;
		Xspeed	<= 0;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		alive <= 0;
	end
	else begin

		if(start && !alive) begin
			topLeftX_FixedPoint <= (playerXPosition + 32) * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint <= INITIAL_Y * FIXED_POINT_MULTIPLIER;
			alive <= 1;
		end 
		if (fireCollision)
			alive <= 0;
		   
		if (startOfFrame == 1'b1 )begin //&& Yspeed != 0) 
	
			topLeftX_FixedPoint <= topLeftX_FixedPoint + Xspeed;
			topLeftY_FixedPoint <= topLeftY_FixedPoint + Yspeed;
						  //Yspeed <= 0;
		end
			
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule

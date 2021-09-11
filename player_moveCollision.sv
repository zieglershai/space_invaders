// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	player_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	leftArrow,  //move left
					input	logic	rightArrow, 	//move right
					input	logic	enter, 	//shoot
					input logic collision,  //collision if player hits an side
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					input logic playGame,
					
					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 240;
parameter int INITIAL_Y = 420;
parameter int INITIAL_X_SPEED = 100;
parameter int INITIAL_Y_SPEED =  0;
parameter int MAX_Y_SPEED = 230;
//const int  Y_ACCEL = 0;//-1; unused const

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
/*const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;*/

// int Xspeed; unused
int XcurrentSpeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;
int rightFlag = 0;
int leftFlag = 0;


assign topLeftY_FixedPoint	= INITIAL_Y * FIXED_POINT_MULTIPLIER; // doesnt changed so was moved to here - can be changed to const
//////////--------------------------------------------------------------------------------------------------------------=
//  calculation X Axis speed using and position calculate regarding X_direction key or  colision

always_ff@(posedge clk or negedge playGame or negedge resetN)
begin
	if(!resetN || !playGame)
	begin
		XcurrentSpeed	<= 0;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		//topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER; was moved to comb part 
		//Xspeed <= INITIAL_X_SPEED;
	end
	else begin
		// unchanged values - can be changed to const or parrameter
		//Xspeed <= INITIAL_X_SPEED;
			
			//  an edge input is tested here as it a very short instance   
		if (rightArrow && !leftArrow && !rightFlag)  
					XcurrentSpeed <= INITIAL_X_SPEED; 
		// check collision with right border while moving right			
		if (HitEdgeCode [1] == 1 && collision || ((topLeftX >= 562) && rightArrow))begin 
			rightFlag <= 1;
			XcurrentSpeed	<= 0;
		end
		
		// moving left	
		if (!rightArrow && leftArrow && !leftFlag)  
					XcurrentSpeed <= -INITIAL_X_SPEED; 
		
		// check collision with left border while moving left			
		if (HitEdgeCode [3] == 1 && collision || ((topLeftX <= 15) && leftArrow )) begin
			leftFlag <= 1;
			XcurrentSpeed	<= 0;
		end
		
		// update location at end of frame	
		if (startOfFrame == 1'b1 ) begin//&& Yspeed != 0) 
			  rightFlag <= 0;
			  leftFlag <= 0;
			  topLeftX_FixedPoint <= topLeftX_FixedPoint + XcurrentSpeed;
			  if (XcurrentSpeed != 0 )
					XcurrentSpeed	<= 0;
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint[16:6] ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint[16:6] ; // player doesnt move y axis   


endmodule

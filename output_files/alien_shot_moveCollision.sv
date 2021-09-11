// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	alien_shot_moveCollision	(	
 
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
	input logic alienFireCollision,  //collision if smiley hits an object
	input logic signed [10:0] alienXPosition ,
	input logic signed [10:0] alienYPosition ,
	input logic signed [10:0] pixelX,
	input logic signed [10:0] pixelY,
	input logic [9:0] bottomAlien,
	input logic playGame,


	output logic signed 	[10:0]	topLeftX, // output the top left corner 
	output logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside 
	output logic  fireAlive  

					
);



// a module used to generate the  ball trajectory.  

logic [0:1] alive;
parameter int INITIAL_X = 32;
parameter int INITIAL_Y = 32;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED =  80;
parameter int MAX_Y_SPEED = 230;

//unused values
/*const int ALIEN_ROW = 4;
const int ALIEN_COLUMN = 8; 
const int  Y_ACCEL = 0;//-1;*/

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions

//unused values
/*const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;*/

logic [31:0] Xspeed; // local parameters 
logic [31:0] Yspeed;
logic [0:1] [31:0] topLeftX_FixedPoint;
logic [0:1] [31:0] topLeftY_FixedPoint;
logic flag;

assign Yspeed	= INITIAL_Y_SPEED;
assign Xspeed	= INITIAL_X_SPEED;


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation X Axis speed using and position calculate regarding X_direction key or  colision
always_ff@(posedge clk or negedge playGame or negedge resetN)
begin
	if(!resetN || !playGame)
	begin
		// for each reset initilazie all vars
		//Yspeed	<= INITIAL_Y_SPEED; doesn't changed was moved to comb part
		//Xspeed	<= 0;
		topLeftX_FixedPoint[0]	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint[0]	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		topLeftX_FixedPoint[1]	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint[1]	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		alive[0] <= 0;
		alive[1] <= 0;
		flag <= 0;
	end
	else begin

		if(bottomAlien <= 5 && !alive[0]) begin
			topLeftX_FixedPoint[0] <= alienXPosition * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint[0] <= alienYPosition * FIXED_POINT_MULTIPLIER;
			alive [0] <= 1;
			flag <= 1;
		end 
		else if(!flag && bottomAlien == 783 && !alive[1]) begin
			topLeftX_FixedPoint[1] <= alienXPosition * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint[1] <= alienYPosition * FIXED_POINT_MULTIPLIER;
			alive [1] <= 1;
		end
	
		if (alienFireCollision)begin
			if ((topLeftY_FixedPoint[1] / FIXED_POINT_MULTIPLIER <= pixelY ) && ((topLeftY_FixedPoint[1] / FIXED_POINT_MULTIPLIER) +16 >= pixelY) &&
						(topLeftX_FixedPoint[1] / FIXED_POINT_MULTIPLIER <= pixelX ) && ((topLeftX_FixedPoint[1] / FIXED_POINT_MULTIPLIER) + 2 >= pixelX))begin
					alive [1] <= 0;
				
			end
			else begin
				alive [0] <= 0;	
			end
		end
		
		if (startOfFrame == 1'b1 )begin // change location by speed  
			flag <= 0;
			topLeftX_FixedPoint[0] <= topLeftX_FixedPoint[0] + Xspeed;
			topLeftY_FixedPoint[0] <= topLeftY_FixedPoint[0] + Yspeed;
			topLeftX_FixedPoint[1] <= topLeftX_FixedPoint[1] + Xspeed;
			topLeftY_FixedPoint[1] <= topLeftY_FixedPoint[1] + Yspeed;
						  //Yspeed <= 0;
		end
			
	end
end

//get a better (64 times) resolution using integer   
always_comb begin
	if ((topLeftY_FixedPoint[1]/ FIXED_POINT_MULTIPLIER <= pixelY) && (topLeftY_FixedPoint[1]/ FIXED_POINT_MULTIPLIER + 16 >= pixelY) 
		&& (topLeftX_FixedPoint[1]/ FIXED_POINT_MULTIPLIER <= pixelX) && (topLeftX_FixedPoint[1]/ FIXED_POINT_MULTIPLIER + 2 >= pixelX) )
		begin	// if we are in fire[0] xone
			topLeftX = topLeftX_FixedPoint[1] [16:6] ;   // note it must be 2^n 
			topLeftY = topLeftY_FixedPoint[1] [16:6] ;	// divide by 64 and match 11 bits of top left
			fireAlive =  alive[1];
	
		
	end
	else begin // if we are in fire[0] zone
	 topLeftX = topLeftX_FixedPoint[0][16:6] ;   // note it must be 2^n 
	 topLeftY = topLeftY_FixedPoint[0][16:6]  ; 
	 fireAlive = alive[0];

	end
end
endmodule
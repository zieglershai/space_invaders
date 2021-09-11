// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	alien_matrix_moveCollision	(	
 
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
	input logic collision,  //collision if smiley hits an object
	input	logic	[3:0] HitEdgeCode, //one bit per edge
	input logic playGame, // wait for game to begin
	input logic matrixDefeated,


	output logic signed 	[10:0]	topLeftX, // output the top left corner 
	output logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
//	output logic alienReachedBottom
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 32;
parameter int INITIAL_Y = 200;//80;
parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_Y_SPEED =  100;//50;
parameter int MAX_Y_SPEED = 230;

// never used const 09/09
/*const int ALIEN_ROW = 4;
const int ALIEN_COLUMN = 8; 
const int  Y_ACCEL = 0;//-1;*/

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions

// never used const 09/09
/*const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;*/

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation X Axis speed using and position calculate regarding X_direction key or  colision

always_ff@(posedge clk or negedge playGame  or negedge resetN)
begin
	if(!resetN || !playGame)
	begin
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		Yspeed	<= 0;
//		alienReachedBottom <= 0;
	end
	else begin
	
		//  an edge input is tested here as it a very short instance   
//	if (toggleX)  
//	
//				Xspeed <= -Xspeed; 
				
				
//		if (collision && HitEdgeCode[0] == 1 && HitEdgeCode [1] == 0 && HitEdgeCode [3] == 0) begin
//			alienReachedBottom <= 1;
//		end
	// collisions with the sides 			
		if (collision && HitEdgeCode[3] == 1) begin
			if (Xspeed < 0 )begin // while moving left
					Xspeed <= -Xspeed ; // positive move right 
					if (Yspeed == 0 )	begin
						Yspeed	<= 300 ;
					end
			end
		end
	
		if (collision && HitEdgeCode [1] == 1 ) begin  // hit right border of brick  
			if (Xspeed > 0 ) begin //  while moving right
					Xspeed <= -Xspeed  ;  // negative move left 
					if (Yspeed == 0 )	begin
						Yspeed	<= 300 ;
					end
				end
		end
				
				
		if (matrixDefeated)begin
			if (Xspeed > 0 ) begin
				Xspeed	<= Xspeed + 50;
			end
			else if (Xspeed < 0 ) begin
				Xspeed	<= Xspeed - 50;
			end
			topLeftX_FixedPoint <= INITIAL_X * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint <= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		end
			
		else if (startOfFrame == 1'b1 ) begin//&& Yspeed != 0) 
	
				        topLeftX_FixedPoint <= topLeftX_FixedPoint + Xspeed;
						  topLeftY_FixedPoint <= topLeftY_FixedPoint + Yspeed;
						  //Yspeed <= 0;
						  if (Yspeed != 0 )
								Yspeed	<= 0 ;
		end
			
	end
end

//get a better (64 times) resolution using integer   
//assign 	topLeftX = (topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER) ;   // note it must be 2^n 
//assign 	topLeftY = (topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER) ;    

assign 	topLeftX = topLeftX_FixedPoint [16:6];   //another way to divide by 64
assign 	topLeftY = topLeftY_FixedPoint [16:6];    


endmodule

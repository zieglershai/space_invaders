


module	bonusShip_moveCollision	#(
	parameter int INITIAL_X = 64,
	parameter int INITIAL_Y = 64,
	parameter int INITIAL_X_SPEED = 40,
	parameter int INITIAL_Y_SPEED =  0,
	parameter int MAX_Y_SPEED = 230
)

(
	
 
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
	input logic bonusFireCollision,  //collision if smiley hits an object
	input logic signed [10:0] alienMatrixYPosition ,
	input logic signed [10:0] pixelX,
	input logic signed [10:0] pixelY,
	input logic [9:0] randX,
	input logic playGame,


	output logic signed 	[10:0]	topLeftX, // output the top left corner 
	output logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside 
	output logic  alive  

					
);



// a module used to generate the  ball trajectory.  



//const int  Y_ACCEL = 0;//-1; unused

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions

//unused
/*const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;*/

int Xspeed; // local parameters 
int Yspeed;
int topLeftX_FixedPoint, topLeftY_FixedPoint;
 logic [9:0] limitX;



one_sec_counter one_sec_counter ( .clk(clk), .resetN(resetN),.turbo(0), .one_sec(t_sec), .duty50() );
logic t_sec ; // wire was created at compilition added on 08/09 
logic [10:0] curr_t_sec;
logic [10:0] nxt_t_sec;
logic secFlag;
logic rightFlag;
logic leftFlag;
logic endTravel;

assign Yspeed	= INITIAL_Y_SPEED; // 09/09 - doesnt changed in this unit

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation X Axis speed using and position calculate regarding X_direction key or  colision
always_ff@(posedge clk or negedge playGame or negedge resetN)
begin
	if(!resetN || !playGame) //resetN
	begin
		//Yspeed	<= INITIAL_Y_SPEED; // moved to combed part as its not changed
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		alive <= 0;
		rightFlag <= 1;
		leftFlag <= 0;
		curr_t_sec <= 3;
		endTravel <= 0;
		secFlag <= 0;
		limitX <= 1;
	end
	else begin
		
		if(!alive && (alienMatrixYPosition > 100) && (randX > 450) && (randX != limitX)) begin // right condition to start
			Xspeed <= INITIAL_X_SPEED;
			alive <= 1;
			topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
			rightFlag <= 1;
			leftFlag <= 0;
			limitX <= randX;

			
		end
		
		if (alive &&  (topLeftX_FixedPoint >= (limitX * FIXED_POINT_MULTIPLIER)) && (Xspeed > 0) && !endTravel) begin // first time got to right edge
			Xspeed <= 0;
			curr_t_sec <= 3;
		end
		else if (alive && (topLeftX_FixedPoint <= (640 - limitX) * FIXED_POINT_MULTIPLIER) && (Xspeed < 0)) begin // first time got to left edge
			Xspeed <= 0;
			curr_t_sec <= 3;
		end
		else if (alive && (Xspeed == 0))begin // wait 3 sec
			if (t_sec && !secFlag)begin
				secFlag <= 1;
				curr_t_sec <= curr_t_sec - 11'b1;
			end
			else if(!t_sec && secFlag) begin
				secFlag <= 0;
			end
		end

		if(curr_t_sec == 0 && rightFlag && !endTravel) begin // stop wait and move left
			Xspeed <= -INITIAL_X_SPEED;
			leftFlag <= 1;
			rightFlag <= 0;
			secFlag <= 0;
			curr_t_sec <= 3;
		end
		else if(curr_t_sec == 0 && leftFlag) begin // stop wait and move right and exit
			Xspeed <= INITIAL_X_SPEED;
			leftFlag <= 0;
			rightFlag <= 1;
			endTravel <= 1;
			secFlag <= 0;
			curr_t_sec <= 3;
		end
		
		if (bonusFireCollision || (topLeftX_FixedPoint >= (640 * FIXED_POINT_MULTIPLIER)))begin // kill space ship when out of screen or hit
			alive <= 0;
		end
	
		if (startOfFrame == 1'b1 && alive)begin 
			topLeftX_FixedPoint <= topLeftX_FixedPoint + Xspeed;
			topLeftY_FixedPoint <= topLeftY_FixedPoint + Yspeed;
		end
			
	end
end

//get a better (64 times) resolution using integer   
assign topLeftX = topLeftX_FixedPoint [16:6];   // note it must be 2^n 
assign topLeftY = topLeftY_FixedPoint [16:6] ; // divide by 64 and match 11 bits of top left
	
		


endmodule
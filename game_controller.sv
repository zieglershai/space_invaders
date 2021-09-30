
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_alienMatrix,
			input	logic	drawing_request_boarders,
			input	logic	drawing_request_playerShot,
			input	logic	drawing_request_alienShot,
       // add the box here 
			input	logic	drawing_request_player,
			input logic gameLose,
			input logic keyStartN,
			input logic [3:0] credits,
			input logic drawing_request_bonusShip,
			input logic [1:0] alienType,
			
			output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic collision_player_boarder,
			output logic collision_alien_boarder,
			output logic collision_playerFire,
			output logic collision_fire_boarder,
			output logic collision_fire_alien,
			output logic collision_alienShot_boarder,
			output logic collision_alienShot_player,
			output logic collision_alienShot_all,

			output logic restart, // new game by reset or gameover
			output logic unsigned [7:0] scoreUpdate, // new game by reset or gameover
			output logic standBy,
			output logic startGame,
			output logic gameEnded,
			output logic collision_fire_bonusShip


			
);
wire collision_alien_player;
logic collision;
assign collision_alien_boarder = ( drawing_request_alienMatrix &&  drawing_request_boarders );
assign collision_alien_player = ( drawing_request_alienMatrix &&  drawing_request_player );

assign collision_player_boarder = (drawing_request_boarders &&  drawing_request_player);
assign collision_fire_boarder = (drawing_request_boarders &&  drawing_request_playerShot);
assign collision_fire_alien = (drawing_request_alienMatrix &&  drawing_request_playerShot);
assign collision_fire_bonusShip = (drawing_request_bonusShip &&  drawing_request_playerShot);
assign collision_playerFire = (collision_fire_boarder || collision_fire_alien || collision_fire_bonusShip);
assign collision_alienShot_boarder = drawing_request_alienShot && drawing_request_boarders;
assign collision_alienShot_player = (drawing_request_alienShot && drawing_request_player);
assign collision_alienShot_all = collision_alienShot_player || collision_alienShot_boarder;

assign collision = (collision_alien_boarder || collision_player_boarder || collision_playerFire
														  || collision_alienShot_all) || collision_fire_bonusShip || collision_alien_player;

														  

logic t_sec;
logic [5:0] cur_endScreenTime;
logic [5:0] nxt_endScreenTime;
one_sec_counter one_sec_counter ( .clk(clk), .resetN(resetN),.turbo(0), .one_sec(t_sec), .duty50() );


logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ;
		restart <=1;
		scoreUpdate <= 0;
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag = 1'b0 ; // reset for next time 
				
//		change the section below  to collision between number and smiley


	if ( collision  && (flag == 1'b0)) begin 
				flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1 ; 
			end 
	if (gameLose == 1) begin
		restart <= 1;
	end
	else begin
	restart <= 0;
	end
	
	
	if (collision_fire_bonusShip == 1 && scoreUpdate == 0 ) begin
					scoreUpdate <= 8'd100;
	end
	if (collision_fire_alien == 1 && scoreUpdate == 0 ) begin
					scoreUpdate <= 8'd10 * alienType;
	end
	if (scoreUpdate != 0)begin
			scoreUpdate <= 0;
	end

	
end
end



enum logic [2:0] {sIdle, sStart, sGame, sOver, sNewGame} pres_st, next_st;

always_ff @(posedge clk or negedge resetN) begin

	if (!resetN) begin
		pres_st <= sIdle;
		cur_endScreenTime <= 15;
	end
	else begin
		pres_st <= next_st;
		cur_endScreenTime <= nxt_endScreenTime;
	end
end

logic secflag;

always_comb begin 
	next_st = pres_st;
	standBy = 1;
	startGame = 0;
	nxt_endScreenTime = cur_endScreenTime;
	secflag = 0;
	gameEnded = 0;
	
	
	
	/*
	game state machine:
	                     ___________________________
								V                          |
	start screen --> game screen --> gameover --> new game
	 ^                                  |
	 L-----------------------------------
	*/
	case (pres_st)
		sIdle: begin
			if (!keyStartN && credits) begin
				next_st = sStart;
			end
		end
		
		sStart: begin
			startGame = 1;
			if (keyStartN) begin
				next_st = sGame;
			end
		end
		
		sGame: begin
			standBy = 0;
			nxt_endScreenTime = 6'd15;
			if (gameLose || collision_alien_player) begin
				next_st = sOver;
			end
		end
		
		sOver: begin
		
		// count second till move to start screen 
			gameEnded = 1'b1;
			standBy = 1'b0;
			if (t_sec && !secflag) begin
				secflag = 1'b1;
				nxt_endScreenTime = cur_endScreenTime - 6'b1;
			end
			else if(!t_sec && secflag) begin
				secflag = 1'b0;
			end
			if (cur_endScreenTime <= 1'b0) begin
				next_st = sIdle;
			end
			
			// if player pushed the button move to new game
			else if (!keyStartN && credits) begin
				next_st = sNewGame;
			end
		end
		
		sNewGame: begin
		
		// new game :
		// raise wires of new game
			startGame = 1'b1; // nerw game
			standBy = 1'b0; // stiil need to wait
			gameEnded = 1'b1; // last game over
			if (keyStartN) begin	// when key is unpressed start
				next_st = sGame;
			end
		end
		
	endcase

end

endmodule

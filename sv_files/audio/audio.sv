module audio(
		input onOff,
		input MCLK,
		input resetN,
		input new_fire,
		input collision_alienShot_player,
		input collision_fire_alien,
		input bonusFireCollision,
		input bonus_ship_alive,
		output LRCLK,
		output SCLK,
		output SD
);


wire new_trackN;
wire [3:0] select;
wire theme_ended;


parameter RATIO = 35;
parameter WIDTH = 16;   
I2S 
#(
    //.RATIO(RATIO),
    .WIDTH(WIDTH)
)I2S_inst
( 
    .onOff(onOff),
     .MCLK(MCLK),
    //.nReset(ARDUINO_IO[3]), //connected  to button 1 - in the future need to be diffrent port
    .nReset(new_trackN), //adjust to new connector
    .select(select),
	 .LRCLK(LRCLK),
    .SCLK(SCLK),
    .SD(SD),
	 .theme_ended(theme_ended)
);



enum logic [2:0] {sIdle, splayer_explode, sfire, sinvader, sufo} pres_st, next_st, prev_st;


always_ff @(posedge MCLK or negedge resetN) begin

	if (!resetN) begin
		pres_st <= sIdle;
		prev_st <= sIdle;
	end
	else begin
		pres_st <= next_st;
		prev_st <= pres_st;

	end
end

always_comb begin 
	select = 4'd0;
	next_st = pres_st;
	//new_trackN = 1'd1;
	new_trackN = prev_st == pres_st; // there is a new track if we switch state
	case (pres_st)
		sIdle: begin
			//new_trackN = 1'd0;
			if (collision_alienShot_player) begin
				select = 4'd1;
				next_st = splayer_explode;
			end
			else if (new_fire) begin
				select = 4'd2;
				next_st = sfire;
			end
			else if (collision_fire_alien) begin
				select = 4'd3;
				next_st = sinvader;
			end
			else if (bonus_ship_alive) begin
				select = 4'd4;
				next_st = sufo;
			end
		end
		
		splayer_explode: begin
			if (theme_ended) begin
				select = 4'd0;
				next_st = sIdle;
			end
			else begin
				select = 4'd1;
			end
		end
		
		sfire: begin
			if (collision_alienShot_player) begin
				select = 4'd1;
				next_st = splayer_explode;
			end
			else if (theme_ended) begin
				select = 4'd0;
				next_st = sIdle;
			end
			else begin
				select = 4'd2;
			end
		end
		sinvader: begin
			if (collision_alienShot_player) begin
				select = 4'd1;
				next_st = splayer_explode;
			end
			else if (theme_ended) begin
				select = 4'd0;
				next_st = sIdle;
			end
			else begin
				select = 4'd3;
			end
		end

		sufo: begin
			if (collision_alienShot_player) begin
				select = 4'd1;
				next_st = splayer_explode;
			end
			else if (new_fire) begin
				select = 4'd2;
				next_st = sfire;
			end
			else if (bonusFireCollision || !bonus_ship_alive) begin // ufo was destroyed
				select = 4'd0;
				next_st = sIdle;
			end
			else begin
				select = 4'd4;
			end
		end
		
	endcase
	
end
endmodule

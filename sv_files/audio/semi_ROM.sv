module semi_ROM (
	
	input clk,				// main clk as the top 
	input resetN,			// resetN
	input [3:0] select, // which event occured
	input [31:0] adress, // which 16 bits to read
	output [15:0] dout,	// data from memeory
	output [17:0] depth,	// how many word (16 bits) there are in the relevant track 
	output [31:0] repeats	// repeats once or loop 

);


logic [15:0] player_dout;
logic [17:0] player_depth;
logic player_repeats;
player_ROM player_ROM_inst(
		.clk(clk),
		.resetN(resetN),
		.adress(adress), // for future purpose
		.dout(player_dout),
		.depth(player_depth),
		.repeats(player_repeats)


);



logic [15:0] shoot_dout;
logic [17:0] shoot_depth;
logic shoot_repeats;
shot_ROM shot_ROM_inst(
		.clk(clk),
		.resetN(resetN),
		.adress(adress), // for future purpose
		.dout(shoot_dout),
		.depth(shoot_depth),
		.repeats(shoot_repeats)


);


logic [15:0] invader_dout;
logic [17:0] invader_depth;
logic invader_repeats;
invader_ROM invader_ROM_inst(
		.clk(clk),
		.resetN(resetN),
		.adress(adress), // for future purpose
		.dout(invader_dout),
		.depth(invader_depth),
		.repeats(invader_repeats)


);





logic [15:0] ROM_dout;
logic [17:0] ROM_depth;
logic [31:0] ROM_repeats;
ROM_mux aud_mux_inst(
	 .clk(clk),
	 .resetN(resetN),
	 .select(select),
	 .adress(adress),
	 .dout(ROM_dout),
	 .depth(ROM_depth),
	 .repeats(ROM_repeats)

);




always_comb begin 
	
	// mux part - depending on select value choose diffrent track to play
	// player hit, shot fired and invader destroyed are stored localy using logic element
	// ufo and soundtrck are stored in ROM
	// sound coming from ROM has noise -- need to be fixed 30/09
	
	if (select == 4'd1) begin // player was hit
		dout[15:0] = player_dout[15:0];//16'h0; // take the adress row
		repeats = player_repeats;
		depth = player_depth;
	end
	else if (select == 4'd2) begin // shot was fired
		dout[15:0] = shoot_dout[15:0];
		repeats = shoot_repeats;
		depth = shoot_depth;
	end
	else if (select == 4'd3) begin // invader was destroyed
		dout[15:0] = invader_dout[15:0];
		repeats = invader_repeats;
		depth = invader_depth;
	end

	// using ROM
	else begin
		dout[15:0]= ROM_dout[15:0];
		depth = ROM_depth;
		repeats = ROM_repeats;
	end
 
 end
endmodule



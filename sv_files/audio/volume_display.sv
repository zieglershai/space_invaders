module volume_display(
					input clk,
					input resetN,
					input vol_btn,
					input [10:0] pixelX,
					input [10:0] pixelY,
					//output [7:0] debug, // for debuging porpurse
					//output debug_dr,
					output sound_en,
					output audioDR,
					output [7:0] audioRGB
					


);

logic display_en; 
logic change_sound;

// use shmidt trigger
shmidth smidth_inst(
	 .clk(clk),
	 .resetN(resetN),
	 .pos_in(vol_btn),
	 .pos_out(change_sound),
	 .neg_in(),
	 .neg_out()
);


/* volume title part*/
wire [10:0] volume_offsetX;
wire [10:0] volume_sq_inst_offsetY;
wire volume_sq_RecDR;
wire volumeDR;
wire [7:0] volumeRGB;

square_object 	#(
			.OBJECT_WIDTH_X(128), //dec
			.OBJECT_HEIGHT_Y(16),//dec
			.OBJECT_COLOR(8'h5b) //hex
)
vol_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd200),
					.topLeftY(11'd11),
					.offsetX(volume_offsetX),
					.offsetY(volume_sq_inst_offsetY),
					.drawingRequest(volume_sq_RecDR),
					.RGBout()
);


volumeTitleBitMap volBitMap_inst	(	
					.clk(clk),
					.resetN(resetN),
					.offsetX(volume_offsetX),// offset from top left  position 
					.offsetY(volume_sq_inst_offsetY),
					.InsideRectangle(volume_sq_RecDR), //input that the pixel is within a bracket 
					.drawingRequest(volumeDR), //output that the pixel should be dispalyed 
					.RGBout(volumeRGB)
);

/* volume title part end*/

/* volume mode part*/
wire [10:0] mode_offsetX;
wire [10:0] mode_sq_inst_offsetY;
wire mode_sq_RecDR;
wire modeDR;
wire [7:0] modeRGB;

square_object 	#(
			.OBJECT_WIDTH_X(32), //dec
			.OBJECT_HEIGHT_Y(16),//dec
			.OBJECT_COLOR(8'h5b) //hex
)
mode_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd340),
					.topLeftY(11'd11),
					.offsetX(mode_offsetX),
					.offsetY(mode_sq_inst_offsetY),
					.drawingRequest(mode_sq_RecDR),
					.RGBout()
);


volumeOnOffBitMap onOffBitMap_inst	(	
					.clk(clk),
					.resetN(resetN),
					.offsetX(mode_offsetX),// offset from top left  position 
					.offsetY(mode_sq_inst_offsetY),
					.InsideRectangle(mode_sq_RecDR), //input that the pixel is within a bracket
					.mode(sound_en), // displlay on or off
					.drawingRequest(modeDR), //output that the pixel should be dispalyed 
					.RGBout(modeRGB)
);

/* volume mode part end*/







one_sec_counter one_sec_counter ( .clk(clk), .resetN(resetN),.turbo(0), .one_sec(t_sec), .duty50() );
logic t_sec; 
logic secflag; 
logic [5:0] pres_sec_counter, nxt_sec_counter; // display counter
logic [31:0] pres_sleep, next_sleep; // lock state counter

enum logic [2:0] {sIdle, sOff} pres_st, next_st;
//logic counter_en;


always_ff @(posedge clk or negedge resetN) begin

	if (!resetN) begin
		pres_st <= sIdle;
		pres_sec_counter <= 5'd5;
		pres_sleep <= 32'b0;
		
	end
	else begin
		pres_st <= next_st;
		pres_sec_counter <= nxt_sec_counter;
		pres_sleep <= next_sleep;
	end
end

always_comb begin
	
	next_st = pres_st;
	next_sleep = pres_sleep;
	display_en = pres_sec_counter != 1'b0; // enable when timer is not zero
	//counter_en = pres_sec_counter != 1'b0; // enable when timer is not zero
	nxt_sec_counter = pres_sec_counter;
	secflag = 1'b0;

	// seceond counter
	if(change_sound) begin
		nxt_sec_counter = 5'd5;
	end
	else if (t_sec && !secflag && pres_sec_counter >= 5'b1) begin
		secflag = 1'b1;
		nxt_sec_counter = pres_sec_counter - 5'b1;
	end
	else if(!t_sec && secflag) begin
		secflag = 1'b0;
	end
	
	if(pres_sleep > 32'b0) begin
		next_sleep = pres_sleep - 32'b1;
	end
	else if (change_sound) begin
		next_sleep = 32'd12_500_000;
	end

	else begin
		next_sleep = pres_sleep;
	end
	
	case (pres_st)
		sIdle : begin
			sound_en = 1'b1;
			if (change_sound && pres_sleep == 17'b0) begin
				next_st = sOff;
			end
			else begin
				next_st = sIdle;	
			end
		end
		
		sOff : begin
			sound_en = 1'b0;
			if (change_sound && pres_sleep == 17'b0) begin
				next_st = sIdle;
			end
			else begin
				next_st = sOff;
			end
		end
		
		default begin
			next_st = sIdle;
			sound_en = 1'b0;
		end
		
	endcase

end

always_comb begin
// mux display part
	if (modeDR && display_en) begin
		audioDR = 1'b1;
		audioRGB = modeRGB;
	end
	else if (volumeDR && display_en) begin
		audioDR = 1'b1;
		audioRGB = volumeRGB;
	end
	else begin
		audioDR = 1'b0;
		audioRGB = modeRGB;
	end
		
end


endmodule 
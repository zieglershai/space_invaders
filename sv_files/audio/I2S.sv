module I2S
	#(	parameter [31:0] RATIO = 32'd19;//ratio between 25 MHz clock to SCLK 
		parameter WIDTH = 16
	)
(
		input onOff,
		input MCLK,
		input nReset,
		input new_shot,
		input player_fire_collision,
		output LRCLK,
		output SCLK,
		output SD
);

typedef enum {State_Reset, State_WaitForReady, State_IncreaseAddress, State_WaitForStart} State_t;
State_t CurrentState;
wire [2 * WIDTH - 1 : 0] Tx;
//wire [WIDTH - 1 : 0] ROM_Data; using dout instead
//wire [6:0] ROM_Address; // using wordcounter instead
wire Ready;
wire Clock_Audio;
    
wire [17:0] depth; // nums of row in the ROM
//wire [31:0] Counter; // counter for creating audio clock - using clock divider instead
//wire [31:0] debug_counter; // debugging wire
wire [31:0] WordCounter ;
wire [15:0] dout; // for output of the semi ROM
wire [31:0] repeatCounter ; // counter for how much repeats for each tone
wire [31:0] repeats; // how many time repeat each tone
wire [3:0] select;


clock_divide_N clock_divide_19( 

	.ref_clk(MCLK), 
   .nReset(nReset), 
	.clk_out(Clock_Audio) );
	
	
I2S_Transmitter #(
    .WIDTH(WIDTH)
)
    I2S_Transmitter_inst
(		
	 .onOff(onOff),
    .Clock(Clock_Audio),
    .nReset(nReset),
    .Ready(Ready),
    .Tx(Tx),
    .LRCLK(LRCLK),
    .SCLK(SCLK),
    .SD(SD)
);
/*ROM : SineROM port map (
    Clock => MCLK,
    Address => ROM_Address,
    DataOut => ROM_Data
);*/

semi_ROM semi_ROM_inst(
		.clk(MCLK),
		.resetN(nReset),
		.select(select)//////////////need to be chosen
		.adress(WordCounter), // for future purpose
		.dout(dout),
		.depth(depth),
		.repeats(repeats)


);

always_ff @(posedge MCLK, negedge nReset) begin
    if(nReset == 1'b0) begin
			WordCounter <= 0;
        CurrentState <= State_Reset;
        Tx <= 0;
		  select <= 4'd0;
        //ROM_Data <= 0; using dout instead
        //ROM_Address  <= 0; // using wordcounter instead
        //Clock_Audio  <= 0;
		  repeatCounter <= 0;
    end
    else begin
        // used to create 44.1 khz clock here and it was moved to clock_divide_19 inst
		  /*if(Counter < ((RATIO / 2) - 1)) begin
            Counter <= Counter + 1;
        end
        else begin
            Counter <= 0;
            Clock_Audio <= ~ Clock_Audio;
        end
		  */
		  select <= 4'd0;
        case (CurrentState)
            State_Reset :begin
                WordCounter <= 0;
                CurrentState <= State_WaitForReady;
            end
            State_WaitForReady : begin
                if(Ready == 1'b1 && repeatCounter < repeats) begin // number of repeats is limited
					 //if(Ready == 1'b1 ) begin // unlimited

                    CurrentState <= State_WaitForStart;
                end
                else begin
                    CurrentState <= State_WaitForReady;
                end
            end
            State_WaitForStart : begin
                // ROM_Address <= STD_LOGIC_VECTOR(to_unsigned(WordCounter, ROM_Address'length)); not sure how to in verylog
                //Tx <= {16'h0000, ROM_Data}; // need to be read from mem
					 
					 //Tx <= 32'h0; //const zero
					 //Tx = {dout[15:0], dout[15:0]}; //full power
					 //Tx = {2'b00,dout[13:0], 2'b00, dout[13:0]}; // 1/4% volume?
					 //Tx = {3'b00,dout[12:0], 3'b000, dout[12:0]}; // 1/16% volume?
					 Tx = {5'b00000,dout[15:5], 5'b00000, dout[15:5]}; // 1/32 volume?
					 //Tx = {5'b00000,dout[10:0], 16'h0000}; // 1/32 volume- only left?

                if(Ready == 1'b0) begin
                    CurrentState <= State_IncreaseAddress;
                end
                else begin
                    CurrentState <= State_WaitForStart;
                end
            end
            State_IncreaseAddress : begin
                if(WordCounter < depth - 1) begin
                    WordCounter <= WordCounter + 1;
                end
                else begin
                    WordCounter <= 0;
						  repeatCounter <= repeatCounter + 1;
                end
                CurrentState <= State_WaitForReady;
				end
        endcase
    end
end

//assign debug_counter = Counter; // for debugging
/*always_comb begin 
	case (CurrentState)
		State_WaitForReady : begin
			if (player_fire_collision) begin
				select = 4'd1;
			end
			else if (new_shot) begin
				select = 4'd2;
			end
			else begin
				select = 4'd0;
			end
		end


	endcase

end*/
endmodule

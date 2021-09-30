module I2S
	#(	parameter [31:0] RATIO = 32'd19;//ratio between 25 MHz clock to SCLK 
		parameter WIDTH = 16
	)
(
		input onOff,
		input MCLK,
		input nReset,
		input [3:0] select,
		output LRCLK,
		output SCLK,
		output SD,
		output theme_ended, // new addition to support multy options
		output [31:0] repeats // used to be internal reassign for debug
);

typedef enum {State_Reset, State_WaitForReady, State_IncreaseAddress, State_WaitForStart} State_t;
State_t CurrentState;
wire [2 * WIDTH - 1 : 0] Tx;

wire Ready;
wire Clock_Audio;
    
wire [17:0] depth; // nums of row in the ROM

wire [31:0] WordCounter ;
wire [15:0] dout; // for output of the semi ROM
wire [31:0] repeatCounter ; // counter for how much repeats for each tone

clock_divide_N clock_divide_19( 

	.ref_clk(MCLK), 
   .nReset(nReset), 
	.clk_out(Clock_Audio) );
	


// pass the current word to the transmitter	
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


// load the current word from the memmory
semi_ROM semi_ROM_inst(
		.clk(MCLK),
		.resetN(nReset),
		.select(select),//////////////need to be chosen
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

		  repeatCounter <= 0;
		  theme_ended <= 1'd0;
    end
    else begin
			
			/* 4 state machine*/
		  theme_ended <= 1'd0 ; // new addition to support multy 11/09
        case (CurrentState)
            /*
				reset - start over from zero
				*/
				State_Reset :begin
                WordCounter <= 0;
                CurrentState <= State_WaitForReady;
            end
				
				/*
				wait till transmitter raise ready and check if loop required or not
				*/
            State_WaitForReady : begin
                if(Ready == 1'b1 && repeatCounter < repeats) begin //should be repeated or not
                    CurrentState <= State_WaitForStart;
                end
                else begin
                    CurrentState <= State_WaitForReady;
                end
            end
				
				/*
					build the relevant word from ROM 
					when transmitter sample the word move to increase word
				*/
            State_WaitForStart : begin
					 if (select == 0) begin // soundtrack amplituse is much stronger and need to be normilize
					 	 Tx = {7'b0000000,dout[15:7], 7'b0000000, dout[15:7]}; // 1/128 volume
					 end
					 else begin
						 Tx = {5'b00000,dout[15:5], 5'b00000, dout[15:5]}; // 1/32 volume
					 end
                if(Ready == 1'b0) begin
                    CurrentState <= State_IncreaseAddress;
                end
                else begin
                    CurrentState <= State_WaitForStart;
                end
            end
				
				/*
					increase address by one and move to wait for ready
					if we loaded all the words than increase counter by one and go to address zero
				*/
            State_IncreaseAddress : begin
                if(WordCounter < depth - 1) begin
                    WordCounter <= WordCounter + 1;
                end
                else begin
                    WordCounter <= 0;
						  theme_ended <= 1'd1 ; // new addition to support multy 11/09
						  
						  if (repeats == 32'd1)begin // repeat nly once
								repeatCounter <= repeatCounter + 1;
						  end
						  else begin // repeat endllessly
								repeatCounter <= repeatCounter;
						  end
						  
                end
                CurrentState <= State_WaitForReady;
				end
        endcase
    end
end


endmodule

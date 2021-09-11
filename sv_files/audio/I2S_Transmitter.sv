module I2S_Transmitter
    #(
        parameter WIDTH = 16
    )
    (		input onOff,
        input Clock, // the Sclk 
        input nReset, // reset
        output Ready, // high after transition of word
        input [2 * WIDTH - 1:0] Tx, 
        output LRCLK,// which speaker
        output SCLK, // each cycle is bit
        output SD, // data for I2S
		  output [4:0] xxx// debug purpose
);

typedef enum {State_Reset, State_LoadWord, State_TransmitWord} State_t; // states for fsm
State_t CurrentState; // currnet state
wire [2 * WIDTH - 1 : 0] Tx_Int;
wire Ready_Int;
wire LRCLK_Int;
wire SD_Int;
wire Enable;
wire [4:0] flag;

wire [31:0] BitCounter;
wire SD_delayed; // check if lrclk need to be delayed


always_ff @(negedge Clock, negedge nReset) begin // SCLK negative edge trigger
	if (nReset == 1'b0) begin
		CurrentState <= State_LoadWord;
		Tx_Int <= 0;
		Ready_Int <= 0;
		LRCLK_Int <= 1;
		SD_Int <= 0;
		Enable <= 1;
		flag <= 4'd0;
	end
	
	/* 3 state machine
	reset - reset all wires to zero and move to load word state/
	load - sample tx into tx_int and move to transtiion state
	transition - transit bit by bit
	*/
	
	
	
	//-first state machine
//	else begin
//		case (CurrentState) 
//			State_Reset : begin
//				flag <= 4'd0;// debug purpose
//				Ready_Int <= 1'b0; // not ready to take new word
//				LRCLK_Int <= 1'b0; // left chanel
//				Enable <= 1'b1; // allways high
//				SD_Int <= 1'b0; 
//				Tx_Int <=  1'b0;
//				CurrentState <= State_LoadWord;
//			end
//			
//			/* load mode
//			sample tx to tx internal
//			and initilize oters wires
//			*/
//			State_LoadWord : begin
//				flag <= 4'd1;// debug purpose
//				BitCounter <= 0; // initilaize bit counter
//				Tx_Int <= Tx; // sample tx input
//				LRCLK_Int <= 1'b0; // left chanel first
//				CurrentState <= State_TransmitWord; // move to transition
//
//			end
//			
//			/* transtion mode:
//			16 bit to the left chanel and than 16 bits to the right
//			after each bit sll tx_int and pad with zero
//			*/
//			State_TransmitWord : begin
//				flag <= 4'd2;// debug purpose
//				BitCounter <= BitCounter + 1;
//				if(BitCounter > (WIDTH - 1)) begin
//					LRCLK_Int <= 1'b1;
//				end
//				if(BitCounter < ((2 * WIDTH) - 1)) begin
//					Ready_Int <= 1'b0;
//					CurrentState <= State_TransmitWord;
//				end
//				else begin
//					Ready_Int <= 1'b1;
//					CurrentState <= State_LoadWord;
//				end
//				Tx_Int <= {Tx_Int[2 * WIDTH - 2:0] , 1'b0};
//				SD_Int <= Tx_Int[2 * WIDTH - 1];
//			end
//		endcase
//	end
	// end first state machine
	
	
	//optional state machine
	else begin
		SD_delayed <= SD_Int;
		case (CurrentState) 
			State_Reset : begin
				flag <= 4'd0;// debug purpose
				Ready_Int <= 1'b0; // not ready to take new word
				LRCLK_Int <= 1'b0; // left chanel
				Enable <= 1'b1; // allways high
				SD_Int <= 1'b0; 
				Tx_Int <=  1'b0;
				CurrentState <= State_LoadWord;
			end
			
			/* load mode
			sample tx to tx internal
			and initilize oters wires
			*/
			State_LoadWord : begin
				flag <= 4'd1;// debug purpose
				BitCounter <= 0; // initilaize bit counter
				Tx_Int <= Tx; // sample tx input
				LRCLK_Int <= 1'b0; // left chanel first
				CurrentState <= State_TransmitWord; // move to transition

			end
			
			/* transtion mode:
			16 bit to the left chanel and than 16 bits to the right
			after each bit sll tx_int and pad with zero
			*/
			State_TransmitWord : begin
				flag <= 4'd2;// debug purpose
				BitCounter <= BitCounter + 1;
				if(BitCounter > (WIDTH - 1)) begin
					LRCLK_Int <= 1'b1;
				end
				else begin
					LRCLK_Int <= 1'b0;
				end
				if(BitCounter < ((2 * WIDTH) - 1)) begin
					Ready_Int <= 1'b0;
					CurrentState <= State_TransmitWord;
					Tx_Int <= {Tx_Int[2 * WIDTH - 2:0] , 1'b0};

				end
				else begin
					Ready_Int <= 1'b1;
					Tx_Int <= Tx; // sample tx input
					CurrentState <= State_TransmitWord;
					BitCounter <=0;
				end
				SD_Int <= Tx_Int[2 * WIDTH - 1];
			end
		endcase
	end
	//optional state machine -end

end
always_comb begin

    Ready = Ready_Int;
    SCLK = Clock & Enable & onOff; 
    LRCLK = LRCLK_Int;// lrclk not dealayed
	 
    //SD = SD_Int;// sd without delay
	 SD = SD_delayed; // sd with delay
	 xxx = flag;// debug purpose
end
endmodule

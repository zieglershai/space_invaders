
module	titles_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // high score title 
					input		logic	highDR, // two set of inputs per unit
					input		logic	[7:0] highRGB,
					
		   // score title  
					input		logic	scoreDR, // two set of inputs per unit
					input		logic	[7:0] scoreRGB,

			// credit invaders 
					input		logic	creditDR, // two set of inputs per unit
					input		logic	[7:0] creditRGB,


			// lives title		
					input		logic	livesDR, // two set of inputs per unit
					input		logic	[7:0] livesRGB,					
	
					output logic [7:0] RGBOut,
					output logic titlesDR
					     

);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			titlesDR <= 0;
			RGBOut	<= 8'b0;
	end
	
	else begin
		if (highDR == 1'b1 )  begin 
			RGBOut <= highRGB;  //first priority 
			titlesDR <= 1;
		end
		
		else if (scoreDR == 1'b1 )  begin 
			RGBOut <= scoreRGB;  //second priority 
			titlesDR <= 1;
		end

		else if (creditDR == 1'b1 )  begin 
			RGBOut <= creditRGB;  //second priority 
			titlesDR <= 1;
		end
		

		else if (livesDR == 1'b1 )  begin 
			RGBOut <= livesRGB;  //second priority 
			titlesDR <= 1;
		end
		
		else begin
			RGBOut <= 8'b0 ; // last priority - nothing
			titlesDR <= 0;
		end
			
		end ; 
	end

endmodule


